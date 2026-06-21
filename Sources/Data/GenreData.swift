import Foundation

enum GenreData {
    static let all: [Genre] = [
        Genre(
            id: "jazz", name: "Jazz", tagline: "Improvisation, swing & extended harmony",
            systemImage: "music.quarternote.3",
            overview: "Born in early-20th-century New Orleans, jazz fuses African-American blues and ragtime with European harmony. It prizes improvisation, swing rhythm, and a sophisticated harmonic language of extended and altered chords.",
            characteristics: [
                "Swing feel — uneven 'long-short' eighth notes",
                "Improvised solos over a repeating form",
                "Syncopation and 'comping' (rhythmic accompaniment)",
                "Walking bass lines"
            ],
            theory: [
                "Extended chords: 7ths, 9ths, 11ths, 13ths and altered tensions",
                "ii–V–I progressions as the central building block",
                "Modal playing (Dorian, Mixolydian, Lydian) over each chord",
                "Tritone substitution and chromatic voice leading"
            ],
            progression: "Dm7 → G7 → Cmaj7",
            progressionName: "ii–V–I in C major",
            artists: ["Louis Armstrong", "Duke Ellington", "Charlie Parker", "Miles Davis", "John Coltrane"]
        ),
        Genre(
            id: "blues", name: "Blues", tagline: "12-bar form & the blue notes",
            systemImage: "guitars.fill",
            overview: "The blues emerged from African-American work songs and spirituals in the Deep South. Its expressive 'blue notes', call-and-response phrasing, and the 12-bar form became the foundation for jazz, R&B and rock 'n' roll.",
            characteristics: [
                "12-bar repeating form built on I, IV and V",
                "Blue notes — bent ♭3, ♭5 and ♭7 for expressive colour",
                "Call-and-response between voice and instrument",
                "Shuffle / swung rhythm"
            ],
            theory: [
                "The blues scale (minor pentatonic + ♭5)",
                "Dominant 7th chords on every degree (I7, IV7, V7)",
                "Mixolydian and minor-pentatonic improvisation",
                "Turnarounds in the final two bars (V–IV–I–V)"
            ],
            progression: "C7 → C7 → C7 → C7 → F7 → F7 → C7 → C7 → G7 → F7 → C7 → G7",
            progressionName: "12-bar blues in C",
            artists: ["Robert Johnson", "B.B. King", "Muddy Waters", "Etta James", "Stevie Ray Vaughan"]
        ),
        Genre(
            id: "rnb", name: "R&B / Soul", tagline: "Groove, gospel harmony & vocal feel",
            systemImage: "waveform",
            overview: "Rhythm & Blues grew out of blues and gospel in the 1940s and evolved through soul, funk and modern neo-soul. It centres on a strong groove, rich gospel-influenced harmony and emotive vocals.",
            characteristics: [
                "Backbeat groove — emphasis on beats 2 and 4",
                "Syncopated, melismatic vocal lines",
                "Tight rhythm section with prominent bass",
                "Gospel-rooted call-and-response and ad-libs"
            ],
            theory: [
                "Extended & added-tone chords (9ths, 11ths, sus, add6)",
                "Smooth chromatic and gospel voice leading",
                "Pentatonic and Dorian melodic vocabulary",
                "Secondary dominants and borrowed chords for colour"
            ],
            progression: "Cmaj9 → Am9 → Dm9 → G13",
            progressionName: "Neo-soul I–vi–ii–V in C",
            artists: ["Ray Charles", "Aretha Franklin", "Stevie Wonder", "Marvin Gaye", "D'Angelo"]
        ),
        Genre(
            id: "classical", name: "Classical", tagline: "Functional harmony & form",
            systemImage: "building.columns.fill",
            overview: "The Western classical tradition spans the Baroque, Classical, Romantic and modern eras. It codified the notation, functional harmony, counterpoint and large-scale forms (sonata, symphony) that underpin most music theory.",
            characteristics: [
                "Functional tonal harmony (tonic–dominant relationships)",
                "Counterpoint — independent interweaving melodic lines",
                "Large structured forms: sonata, rondo, theme & variations",
                "Expressive dynamics and articulation markings"
            ],
            theory: [
                "Diatonic chord functions (I, IV, V, vi…) and cadences",
                "Voice leading and four-part harmony rules",
                "Modulation to closely-related keys",
                "Non-chord tones: passing, neighbour, suspension"
            ],
            progression: "C → F → G7 → C",
            progressionName: "I–IV–V7–I in C major",
            artists: ["J.S. Bach", "Mozart", "Beethoven", "Chopin", "Debussy"]
        )
    ]

    static func genre(id: String) -> Genre? { all.first { $0.id == id } }
}
