import Foundation

/// A musical interval described by its number of semitones plus a friendly name.
struct Interval: Identifiable, Hashable {
    var id: String { shortName }
    let semitones: Int
    let name: String
    let shortName: String      // e.g. "P5", "m3", "M7"
    let example: String        // e.g. "C → G"

    static let all: [Interval] = [
        Interval(semitones: 0,  name: "Perfect Unison",  shortName: "P1",  example: "C → C"),
        Interval(semitones: 1,  name: "Minor 2nd",       shortName: "m2",  example: "C → D♭"),
        Interval(semitones: 2,  name: "Major 2nd",       shortName: "M2",  example: "C → D"),
        Interval(semitones: 3,  name: "Minor 3rd",       shortName: "m3",  example: "C → E♭"),
        Interval(semitones: 4,  name: "Major 3rd",       shortName: "M3",  example: "C → E"),
        Interval(semitones: 5,  name: "Perfect 4th",     shortName: "P4",  example: "C → F"),
        Interval(semitones: 6,  name: "Tritone (Aug 4 / dim 5)", shortName: "TT", example: "C → F♯"),
        Interval(semitones: 7,  name: "Perfect 5th",     shortName: "P5",  example: "C → G"),
        Interval(semitones: 8,  name: "Minor 6th",       shortName: "m6",  example: "C → A♭"),
        Interval(semitones: 9,  name: "Major 6th",       shortName: "M6",  example: "C → A"),
        Interval(semitones: 10, name: "Minor 7th",       shortName: "m7",  example: "C → B♭"),
        Interval(semitones: 11, name: "Major 7th",       shortName: "M7",  example: "C → B"),
        Interval(semitones: 12, name: "Perfect Octave",  shortName: "P8",  example: "C → C"),
    ]
}
