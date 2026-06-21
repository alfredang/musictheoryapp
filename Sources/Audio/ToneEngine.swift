import Foundation
import AVFoundation

/// A small sine-wave synth for auditioning notes, scales and chords.
/// Uses an AVAudioSourceNode that mixes any number of currently-sounding voices.
final class ToneEngine {
    static let shared = ToneEngine()

    private let engine = AVAudioEngine()
    private var sourceNode: AVAudioSourceNode?
    private let sampleRate: Double = 44_100
    private let lock = NSLock()

    /// Active voices: frequency -> (phase, remaining samples, amplitude envelope).
    private struct Voice { var phase: Double; var freq: Double; var remaining: Int; var total: Int }
    private var voices: [Voice] = []
    private var started = false

    private init() {}

    private func startIfNeeded() {
        guard !started else { return }
        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        let node = AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self else { return noErr }
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            self.lock.lock()
            for frame in 0..<Int(frameCount) {
                var sample: Double = 0
                for i in voices.indices {
                    guard voices[i].remaining > 0 else { continue }
                    // Simple attack/decay envelope to avoid clicks.
                    let progress = 1.0 - Double(voices[i].remaining) / Double(voices[i].total)
                    let env = min(1, progress * 12) * min(1, (1 - progress) * 12 + 0.0001)
                    sample += sin(voices[i].phase) * 0.22 * env
                    voices[i].phase += 2 * .pi * voices[i].freq / sampleRate
                    if voices[i].phase > 2 * .pi { voices[i].phase -= 2 * .pi }
                    voices[i].remaining -= 1
                }
                voices.removeAll { $0.remaining <= 0 }
                let clipped = Float(max(-1, min(1, sample)))
                for buffer in ablPointer {
                    let buf = buffer.mData!.assumingMemoryBound(to: Float.self)
                    buf[frame] = clipped
                }
            }
            self.lock.unlock()
            return noErr
        }
        sourceNode = node
        engine.attach(node)
        engine.connect(node, to: engine.mainMixerNode, format: format)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            try engine.start()
            started = true
        } catch {
            started = false
        }
    }

    /// Play a single MIDI note for `duration` seconds.
    func play(midi: Int, duration: Double = 0.6) {
        startIfNeeded()
        addVoice(freq: frequency(forMIDI: midi), duration: duration)
    }

    /// Play several MIDI notes at once (a chord) for `duration` seconds.
    func playChord(_ midis: [Int], duration: Double = 1.1) {
        startIfNeeded()
        for m in midis { addVoice(freq: frequency(forMIDI: m), duration: duration) }
    }

    /// Play a sequence of MIDI notes melodically with a gap between each.
    func playSequence(_ midis: [Int], noteDuration: Double = 0.45) {
        startIfNeeded()
        for (i, m) in midis.enumerated() {
            let delay = Double(i) * noteDuration
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.addVoice(freq: frequency(forMIDI: m), duration: noteDuration * 0.95)
            }
        }
    }

    private func addVoice(freq: Double, duration: Double) {
        let total = Int(duration * sampleRate)
        lock.lock()
        voices.append(Voice(phase: 0, freq: freq, remaining: total, total: total))
        lock.unlock()
    }
}
