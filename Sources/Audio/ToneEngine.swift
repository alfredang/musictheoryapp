import Foundation
import AVFoundation

/// A small additive synth that auditions notes, scales and chords with a piano-like timbre.
/// Uses an AVAudioSourceNode that mixes any number of currently-sounding voices, summing a
/// handful of harmonics per voice under a fast-attack / exponential-decay envelope so it reads
/// as a struck piano string rather than a flat sine.
final class ToneEngine {
    static let shared = ToneEngine()

    private let engine = AVAudioEngine()
    private var sourceNode: AVAudioSourceNode?
    /// Resolved from the real output hardware on start (48 kHz on most devices, not always 44.1).
    private var sampleRate: Double = 44_100
    private let lock = NSLock()

    /// Relative amplitudes of harmonics 1…6 — a bright-ish piano spectrum.
    private let harmonics: [Double] = [1.0, 0.55, 0.33, 0.20, 0.12, 0.07]

    private struct Voice { var phase: Double; var freq: Double; var pos: Int; var total: Int }
    private var voices: [Voice] = []
    private var started = false

    private init() {}

    private func startIfNeeded() {
        guard !started else { return }
        // Configure and activate the session FIRST so the output runs at its true hardware rate.
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, options: [.mixWithOthers])
        try? session.setActive(true)

        // Use the output hardware's actual sample rate to avoid silent/mismatched rendering on device.
        let hwRate = engine.outputNode.outputFormat(forBus: 0).sampleRate
        sampleRate = hwRate > 0 ? hwRate : session.sampleRate > 0 ? session.sampleRate : 44_100

        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        let node = AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self else { return noErr }
            let abl = UnsafeMutableAudioBufferListPointer(audioBufferList)
            let sr = self.sampleRate
            self.lock.lock()
            for frame in 0..<Int(frameCount) {
                var sample = 0.0
                for i in voices.indices {
                    guard voices[i].pos < voices[i].total else { continue }
                    let t = Double(voices[i].pos) / Double(voices[i].total)   // 0…1 over the note
                    // Fast attack (first 1.5%), then exponential decay like a struck string,
                    // with a short fade in the last 4% to prevent an end-of-note click.
                    let attack = min(1.0, t / 0.015)
                    let decay = exp(-t * 4.2)
                    let release = t > 0.96 ? (1.0 - t) / 0.04 : 1.0
                    let env = attack * decay * release
                    // Additive harmonics.
                    let base = 2.0 * Double.pi * voices[i].freq / sr
                    var s = 0.0
                    for (h, amp) in harmonics.enumerated() {
                        s += amp * sin(voices[i].phase * Double(h + 1))
                    }
                    sample += s * env * 0.085
                    voices[i].phase += base
                    if voices[i].phase > 2 * .pi { voices[i].phase -= 2 * .pi }
                    voices[i].pos += 1
                }
                voices.removeAll { $0.pos >= $0.total }
                let clipped = Float(max(-1.0, min(1.0, sample)))
                for buffer in abl {
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
        engine.prepare()
        do {
            try engine.start()
            started = true
        } catch {
            started = false
        }
    }

    /// Play a single MIDI note for `duration` seconds.
    func play(midi: Int, duration: Double = 0.9) {
        startIfNeeded()
        addVoice(freq: frequency(forMIDI: midi), duration: duration)
    }

    /// Play several MIDI notes at once (a chord).
    func playChord(_ midis: [Int], duration: Double = 1.6) {
        startIfNeeded()
        for m in midis { addVoice(freq: frequency(forMIDI: m), duration: duration) }
    }

    /// Play a sequence of MIDI notes melodically with a gap between each.
    func playSequence(_ midis: [Int], noteDuration: Double = 0.5) {
        startIfNeeded()
        for (i, m) in midis.enumerated() {
            let delay = Double(i) * noteDuration
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.addVoice(freq: frequency(forMIDI: m), duration: noteDuration * 1.6)
            }
        }
    }

    private func addVoice(freq: Double, duration: Double) {
        // Ensure the engine is running (it can stop on interruptions/route changes).
        if !engine.isRunning { try? engine.start() }
        let total = max(1, Int(duration * sampleRate))
        lock.lock()
        voices.append(Voice(phase: 0, freq: freq, pos: 0, total: total))
        lock.unlock()
    }
}
