import Foundation

enum NoteSequence {
    /// Assign ascending octaves to a list of spelled pitches starting from `startOctave`,
    /// bumping the octave whenever the letter wraps past B→C.
    static func ascending(_ pitches: [Pitch], startOctave: Int = 4) -> [StaffNote] {
        var result: [StaffNote] = []
        var octave = startOctave
        var lastLetter = -1
        for p in pitches {
            if p.letter.rawValue <= lastLetter { octave += 1 }
            lastLetter = p.letter.rawValue
            result.append(StaffNote(pitch: p, octave: octave))
        }
        return result
    }

    /// MIDI values for a sequence, useful for playback.
    static func midis(_ notes: [StaffNote]) -> [Int] { notes.map(\.midi) }
}
