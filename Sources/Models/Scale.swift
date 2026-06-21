import Foundation

/// A scale "shape" defined by semitone offsets from the root and the letter steps used
/// to spell each degree (so a D major scale spells F♯/C♯ rather than G♭/D♭).
struct ScaleType: Identifiable, Hashable {
    var id: String { name }
    let name: String
    let category: String          // "Major / Minor", "Modes", "Pentatonic & Blues", "Other"
    let semitones: [Int]          // ascending offsets from root, excluding the octave
    let letterSteps: [Int]        // letter-step offset for each degree
    let blurb: String

    /// Build the spelled pitches of this scale from a root.
    func pitches(root: Pitch) -> [Pitch] {
        zip(semitones, letterSteps).map { semis, steps in
            root.transposed(letterSteps: steps, semitones: semis)
        }
    }

    static let all: [ScaleType] = [
        // --- Major / minor ---
        ScaleType(name: "Major (Ionian)", category: "Major / Minor",
                  semitones: [0,2,4,5,7,9,11], letterSteps: [0,1,2,3,4,5,6],
                  blurb: "The bright, foundational scale. Step pattern: W–W–H–W–W–W–H."),
        ScaleType(name: "Natural Minor (Aeolian)", category: "Major / Minor",
                  semitones: [0,2,3,5,7,8,10], letterSteps: [0,1,2,3,4,5,6],
                  blurb: "The relative minor sound. Pattern: W–H–W–W–H–W–W."),
        ScaleType(name: "Harmonic Minor", category: "Major / Minor",
                  semitones: [0,2,3,5,7,8,11], letterSteps: [0,1,2,3,4,5,6],
                  blurb: "Natural minor with a raised 7th, creating a leading tone and an exotic aug 2nd."),
        ScaleType(name: "Melodic Minor", category: "Major / Minor",
                  semitones: [0,2,3,5,7,9,11], letterSteps: [0,1,2,3,4,5,6],
                  blurb: "Raised 6th and 7th ascending (shown). Smooths the melodic line toward the tonic."),
        // --- Modes ---
        ScaleType(name: "Dorian", category: "Modes",
                  semitones: [0,2,3,5,7,9,10], letterSteps: [0,1,2,3,4,5,6],
                  blurb: "Minor mode with a bright raised 6th. Common in jazz and folk."),
        ScaleType(name: "Phrygian", category: "Modes",
                  semitones: [0,1,3,5,7,8,10], letterSteps: [0,1,2,3,4,5,6],
                  blurb: "Minor mode with a flat 2nd — a Spanish/flamenco flavour."),
        ScaleType(name: "Lydian", category: "Modes",
                  semitones: [0,2,4,6,7,9,11], letterSteps: [0,1,2,3,4,5,6],
                  blurb: "Major mode with a raised 4th — dreamy and film-score bright."),
        ScaleType(name: "Mixolydian", category: "Modes",
                  semitones: [0,2,4,5,7,9,10], letterSteps: [0,1,2,3,4,5,6],
                  blurb: "Major mode with a flat 7th — the dominant / blues-rock sound."),
        ScaleType(name: "Locrian", category: "Modes",
                  semitones: [0,1,3,5,6,8,10], letterSteps: [0,1,2,3,4,5,6],
                  blurb: "Diminished, unstable mode with a flat 2nd and flat 5th."),
        // --- Pentatonic & blues ---
        ScaleType(name: "Major Pentatonic", category: "Pentatonic & Blues",
                  semitones: [0,2,4,7,9], letterSteps: [0,1,2,4,5],
                  blurb: "Five notes, no half-steps — singable and used everywhere from pop to folk."),
        ScaleType(name: "Minor Pentatonic", category: "Pentatonic & Blues",
                  semitones: [0,3,5,7,10], letterSteps: [0,2,3,4,6],
                  blurb: "The backbone of rock, blues and R&B guitar solos."),
        ScaleType(name: "Blues Scale", category: "Pentatonic & Blues",
                  semitones: [0,3,5,6,7,10], letterSteps: [0,2,3,4,4,6],
                  blurb: "Minor pentatonic plus the ♭5 'blue note' for that gritty blues colour."),
        // --- Other ---
        ScaleType(name: "Chromatic", category: "Other",
                  semitones: [0,1,2,3,4,5,6,7,8,9,10,11], letterSteps: [0,0,1,1,2,3,3,4,4,5,5,6],
                  blurb: "All twelve semitones — used for passing tones and tension."),
        ScaleType(name: "Whole Tone", category: "Other",
                  semitones: [0,2,4,6,8,10], letterSteps: [0,1,2,3,4,5],
                  blurb: "Six notes a whole step apart — ambiguous, dreamlike (Debussy)."),
    ]

    static var categories: [String] {
        var seen: [String] = []
        for s in all where !seen.contains(s.category) { seen.append(s.category) }
        return seen
    }
}
