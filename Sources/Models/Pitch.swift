import Foundation

/// A pitch class spelled with a letter + accidental (so we can show E♭ vs D♯ correctly).
struct Pitch: Hashable {
    enum Letter: Int, CaseIterable {
        case c = 0, d, e, f, g, a, b
        var name: String { ["C", "D", "E", "F", "G", "A", "B"][rawValue] }
        /// Semitone of the natural letter, relative to C.
        var naturalSemitone: Int { [0, 2, 4, 5, 7, 9, 11][rawValue] }
    }
    var letter: Letter
    /// Accidental in semitones: -2 (𝄫), -1 (♭), 0, +1 (♯), +2 (𝄪).
    var accidental: Int = 0

    /// Pitch class 0–11 (C = 0).
    var pitchClass: Int { ((letter.naturalSemitone + accidental) % 12 + 12) % 12 }

    var accidentalSymbol: String {
        switch accidental {
        case -2: return "𝄫"
        case -1: return "♭"
        case 0: return ""
        case 1: return "♯"
        case 2: return "𝄪"
        default: return ""
        }
    }

    var name: String { "\(letter.name)\(accidentalSymbol)" }

    /// A MIDI note number given an octave (C4 = 60).
    func midi(octave: Int) -> Int { (octave + 1) * 12 + pitchClass }

    /// Move up by a number of letter steps + an absolute semitone target, keeping a sensible spelling.
    func transposed(letterSteps: Int, semitones: Int) -> Pitch {
        let newLetterRaw = ((letter.rawValue + letterSteps) % 7 + 7) % 7
        let newLetter = Letter(rawValue: newLetterRaw)!
        let targetPC = ((pitchClass + semitones) % 12 + 12) % 12
        var accidental = targetPC - newLetter.naturalSemitone
        // Normalise into the −2…+2 range across the octave boundary.
        if accidental > 6 { accidental -= 12 }
        if accidental < -6 { accidental += 12 }
        return Pitch(letter: newLetter, accidental: accidental)
    }
}

extension Pitch {
    /// Parse a simple spelling like "C", "F#", "Bb", "G♯".
    init?(_ string: String) {
        guard let first = string.first,
              let letter = Letter.allCases.first(where: { $0.name == String(first).uppercased() })
        else { return nil }
        var acc = 0
        for ch in string.dropFirst() {
            switch ch {
            case "#", "♯": acc += 1
            case "b", "♭": acc -= 1
            case "x", "𝄪": acc += 2
            default: break
            }
        }
        self.init(letter: letter, accidental: acc)
    }
}

/// Frequency in Hz for a MIDI note (A4 = 69 = 440 Hz).
func frequency(forMIDI midi: Int) -> Double {
    440.0 * pow(2.0, (Double(midi) - 69.0) / 12.0)
}
