import Foundation

enum Clef: String, CaseIterable, Hashable {
    case treble = "Treble"
    case bass = "Bass"
    case alto = "Alto"

    /// The MIDI note that sits on the bottom line of the staff.
    var bottomLineMIDI: Int {
        switch self {
        case .treble: return 64   // E4
        case .bass:   return 43   // G2
        case .alto:   return 53   // F3 (middle line is C4)
        }
    }
    var symbol: String {
        switch self {
        case .treble: return "𝄞"
        case .bass:   return "𝄢"
        case .alto:   return "𝄡"
        }
    }
}

/// Note duration for both rendering (note-head/flag) and playback length.
enum Duration: String, CaseIterable, Hashable {
    case whole, half, quarter, eighth, sixteenth
    var beats: Double {
        switch self {
        case .whole: return 4
        case .half: return 2
        case .quarter: return 1
        case .eighth: return 0.5
        case .sixteenth: return 0.25
        }
    }
    var isFilled: Bool { self != .whole && self != .half }
    var flags: Int {
        switch self { case .eighth: return 1; case .sixteenth: return 2; default: return 0 }
    }
    var label: String {
        switch self {
        case .whole: return "Whole (semibreve)"
        case .half: return "Half (minim)"
        case .quarter: return "Quarter (crotchet)"
        case .eighth: return "Eighth (quaver)"
        case .sixteenth: return "Sixteenth (semiquaver)"
        }
    }
}

/// A single rendered/playable note: spelled pitch + octave + duration.
struct StaffNote: Hashable {
    var pitch: Pitch
    var octave: Int
    var duration: Duration = .quarter
    var midi: Int { pitch.midi(octave: octave) }

    init(_ spelling: String, octave: Int, duration: Duration = .quarter) {
        self.pitch = Pitch(spelling) ?? Pitch(letter: .c)
        self.octave = octave
        self.duration = duration
    }
    init(pitch: Pitch, octave: Int, duration: Duration = .quarter) {
        self.pitch = pitch; self.octave = octave; self.duration = duration
    }
}

/// A small notation figure that can be drawn on a staff and played back.
struct StaffExample: Hashable {
    var clef: Clef = .treble
    var keySignatureSharps: Int = 0     // +n sharps, -n flats (0 = C major / A minor)
    var timeSignature: String? = nil    // e.g. "4/4"; nil hides it
    var notes: [StaffNote]
    var caption: String? = nil
}
