import Foundation

/// A chord "shape" defined by semitone offsets above the root and a symbol suffix.
struct ChordType: Identifiable, Hashable {
    var id: String { name }
    let name: String
    let symbol: String            // suffix, e.g. "", "m", "7", "maj7", "dim"
    let category: String          // "Triads", "Seventh Chords", "Extended & Altered", "Suspended & Added"
    let semitones: [Int]          // offsets from root
    let letterSteps: [Int]        // spelling steps for each chord tone
    let blurb: String

    func pitches(root: Pitch) -> [Pitch] {
        zip(semitones, letterSteps).map { semis, steps in
            root.transposed(letterSteps: steps, semitones: semis)
        }
    }

    func displaySymbol(root: Pitch) -> String { "\(root.name)\(symbol)" }

    static let all: [ChordType] = [
        // --- Triads ---
        ChordType(name: "Major", symbol: "", category: "Triads",
                  semitones: [0,4,7], letterSteps: [0,2,4],
                  blurb: "Root, major 3rd, perfect 5th. Bright and stable."),
        ChordType(name: "Minor", symbol: "m", category: "Triads",
                  semitones: [0,3,7], letterSteps: [0,2,4],
                  blurb: "Root, minor 3rd, perfect 5th. Darker, melancholic."),
        ChordType(name: "Diminished", symbol: "dim", category: "Triads",
                  semitones: [0,3,6], letterSteps: [0,2,4],
                  blurb: "Two stacked minor 3rds — tense and unstable."),
        ChordType(name: "Augmented", symbol: "aug", category: "Triads",
                  semitones: [0,4,8], letterSteps: [0,2,4],
                  blurb: "Two stacked major 3rds — dreamy, suspenseful."),
        // --- Seventh chords ---
        ChordType(name: "Dominant 7th", symbol: "7", category: "Seventh Chords",
                  semitones: [0,4,7,10], letterSteps: [0,2,4,6],
                  blurb: "Major triad + minor 7th. The engine of tension → resolution."),
        ChordType(name: "Major 7th", symbol: "maj7", category: "Seventh Chords",
                  semitones: [0,4,7,11], letterSteps: [0,2,4,6],
                  blurb: "Major triad + major 7th. Lush, jazzy, restful."),
        ChordType(name: "Minor 7th", symbol: "m7", category: "Seventh Chords",
                  semitones: [0,3,7,10], letterSteps: [0,2,4,6],
                  blurb: "Minor triad + minor 7th. Smooth and mellow."),
        ChordType(name: "Minor 7th ♭5 (half-dim)", symbol: "m7♭5", category: "Seventh Chords",
                  semitones: [0,3,6,10], letterSteps: [0,2,4,6],
                  blurb: "Half-diminished — the ii of a minor key turnaround."),
        ChordType(name: "Diminished 7th", symbol: "dim7", category: "Seventh Chords",
                  semitones: [0,3,6,9], letterSteps: [0,2,4,6],
                  blurb: "Stacked minor 3rds — symmetrical and very tense."),
        // --- Extended & altered ---
        ChordType(name: "Dominant 9th", symbol: "9", category: "Extended & Altered",
                  semitones: [0,4,7,10,14], letterSteps: [0,2,4,6,1],
                  blurb: "Dominant 7th plus the 9th — a funk and R&B staple."),
        ChordType(name: "Major 9th", symbol: "maj9", category: "Extended & Altered",
                  semitones: [0,4,7,11,14], letterSteps: [0,2,4,6,1],
                  blurb: "Open, lush extension used widely in neo-soul."),
        ChordType(name: "Dominant 13th", symbol: "13", category: "Extended & Altered",
                  semitones: [0,4,7,10,14,21], letterSteps: [0,2,4,6,1,5],
                  blurb: "A full upper-structure dominant — big-band and jazz colour."),
        // --- Suspended & added ---
        ChordType(name: "Suspended 2nd", symbol: "sus2", category: "Suspended & Added",
                  semitones: [0,2,7], letterSteps: [0,1,4],
                  blurb: "The 3rd is replaced by the 2nd — open, unresolved."),
        ChordType(name: "Suspended 4th", symbol: "sus4", category: "Suspended & Added",
                  semitones: [0,5,7], letterSteps: [0,3,4],
                  blurb: "The 3rd is replaced by the 4th — wants to resolve down to the major."),
        ChordType(name: "Added 6th", symbol: "6", category: "Suspended & Added",
                  semitones: [0,4,7,9], letterSteps: [0,2,4,5],
                  blurb: "Major triad with an added 6th — sweet and vintage."),
    ]

    static var categories: [String] {
        var seen: [String] = []
        for c in all where !seen.contains(c.category) { seen.append(c.category) }
        return seen
    }
}
