import Foundation

struct Genre: Identifiable, Hashable {
    let id: String
    let name: String
    let tagline: String
    let systemImage: String
    let overview: String
    let characteristics: [String]
    let theory: [String]            // theory features: scales/chords/harmony
    let progression: String         // a representative chord progression
    let progressionName: String
    let artists: [String]
}
