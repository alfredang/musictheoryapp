import Foundation

enum LessonData {
    static let units: [LearningUnit] = [
        foundations, rhythm, pitchScalesKeys, harmony, advanced
    ]

    static func lesson(id: String) -> Lesson? {
        units.flatMap(\.lessons).first { $0.id == id }
    }

    // MARK: - Unit 1 — Foundations of Notation

    static let foundations = LearningUnit(
        id: "u1", title: "Foundations of Notation",
        subtitle: "The staff, clefs, and note names", systemImage: "music.note.list",
        lessons: [
            Lesson(id: "l1-1", title: "The Staff & Ledger Lines",
                   summary: "How pitch is written on five lines and four spaces.",
                   level: .basic, systemImage: "lines.measurement.horizontal",
                   blocks: [
                    .paragraph("Western music is written on a **staff** — five horizontal lines and the four spaces between them. The higher a note sits on the staff, the higher it sounds."),
                    .heading("Lines and spaces"),
                    .paragraph("Each line and space represents a letter note. Notes can also sit above or below the staff on short **ledger lines**, which extend the staff for very high or low pitches."),
                    .staff(StaffExample(clef: .treble, notes: [
                        StaffNote("C", octave: 4), StaffNote("E", octave: 4), StaffNote("G", octave: 4),
                        StaffNote("B", octave: 4), StaffNote("D", octave: 5), StaffNote("A", octave: 5)
                    ], caption: "Middle C sits on a ledger line below the treble staff.")),
                    .tip("Middle C (C4) is the note roughly in the centre of the piano and is shared between the treble and bass staves.")
                   ]),
            Lesson(id: "l1-2", title: "Music Alphabet & Note Names",
                   summary: "Only seven letters, A–G, repeat across the keyboard.",
                   level: .basic, systemImage: "textformat.abc",
                   blocks: [
                    .paragraph("Music uses just seven letter names — **A, B, C, D, E, F, G** — that repeat in cycles called **octaves**. After G we return to A."),
                    .keyboard(["C", "D", "E", "F", "G", "A", "B"]),
                    .paragraph("On a piano, the white keys spell this alphabet. The pattern of two-then-three black keys helps you find any note instantly: **C** is always immediately left of the group of two black keys."),
                    .tip("Tap any key above to hear it. The highlighted keys are the natural notes C through B.")
                   ]),
            Lesson(id: "l1-3", title: "The Treble Clef",
                   summary: "The G-clef used for higher instruments and the right hand.",
                   level: .basic, systemImage: "music.note",
                   blocks: [
                    .paragraph("The **treble clef** (G-clef) curls around the second line from the bottom, marking it as **G4**. It is used by flutes, violins, trumpets, voices and the pianist's right hand."),
                    .heading("Reading the lines & spaces"),
                    .bullets([
                        "Lines (bottom→top): **E – G – B – D – F** ('Every Good Boy Deserves Fruit').",
                        "Spaces (bottom→top): **F – A – C – E** (spells 'FACE')."
                    ]),
                    .staff(StaffExample(clef: .treble, notes: [
                        StaffNote("E", octave: 4), StaffNote("G", octave: 4), StaffNote("B", octave: 4),
                        StaffNote("D", octave: 5), StaffNote("F", octave: 5)
                    ], caption: "The five treble-clef lines: E G B D F."))
                   ]),
            Lesson(id: "l1-4", title: "The Bass Clef",
                   summary: "The F-clef used for lower instruments and the left hand.",
                   level: .basic, systemImage: "music.note",
                   blocks: [
                    .paragraph("The **bass clef** (F-clef) places its two dots around the fourth line, marking it as **F3**. It is used by cellos, basses, trombones, tubas and the pianist's left hand."),
                    .heading("Reading the lines & spaces"),
                    .bullets([
                        "Lines (bottom→top): **G – B – D – F – A** ('Good Boys Deserve Fruit Always').",
                        "Spaces (bottom→top): **A – C – E – G** ('All Cows Eat Grass')."
                    ]),
                    .staff(StaffExample(clef: .bass, notes: [
                        StaffNote("G", octave: 2), StaffNote("B", octave: 2), StaffNote("D", octave: 3),
                        StaffNote("F", octave: 3), StaffNote("A", octave: 3)
                    ], caption: "The five bass-clef lines: G B D F A."))
                   ]),
            Lesson(id: "l1-5", title: "Sharps, Flats & Naturals",
                   summary: "Accidentals raise or lower a pitch by a semitone.",
                   level: .basic, systemImage: "number",
                   blocks: [
                    .paragraph("An **accidental** changes a note's pitch:"),
                    .bullets([
                        "**Sharp (♯)** — raises the note by one semitone (half step).",
                        "**Flat (♭)** — lowers the note by one semitone.",
                        "**Natural (♮)** — cancels a previous sharp or flat.",
                        "**Double sharp (𝄪)** / **double flat (𝄫)** — raise/lower by two semitones."
                    ]),
                    .paragraph("Two spellings can sound the same pitch — for example **F♯ and G♭**. These are called **enharmonic equivalents**."),
                    .staff(StaffExample(clef: .treble, notes: [
                        StaffNote("F", octave: 4), StaffNote("F#", octave: 4),
                        StaffNote("G", octave: 4), StaffNote("Gb", octave: 4)
                    ], caption: "F, F♯, G, G♭ — F♯ and G♭ sound identical."))
                   ])
        ])

    // MARK: - Unit 2 — Rhythm & Meter

    static let rhythm = LearningUnit(
        id: "u2", title: "Rhythm & Meter",
        subtitle: "Note values, rests, bars and time signatures", systemImage: "metronome.fill",
        lessons: [
            Lesson(id: "l2-1", title: "Note Values & Rests",
                   summary: "How long each note and silence lasts.",
                   level: .basic, systemImage: "timer",
                   blocks: [
                    .paragraph("A note's **value** tells you how long to hold it. In 4/4 time, the standard durations are:"),
                    .table(headers: ["Note", "British name", "Beats"], rows: [
                        ["Whole", "Semibreve", "4"],
                        ["Half", "Minim", "2"],
                        ["Quarter", "Crotchet", "1"],
                        ["Eighth", "Quaver", "½"],
                        ["Sixteenth", "Semiquaver", "¼"]
                    ]),
                    .staff(StaffExample(clef: .treble, notes: [
                        StaffNote("C", octave: 5, duration: .whole),
                        StaffNote("C", octave: 5, duration: .half),
                        StaffNote("C", octave: 5, duration: .quarter),
                        StaffNote("C", octave: 5, duration: .eighth),
                        StaffNote("C", octave: 5, duration: .sixteenth)
                    ], caption: "Whole, half, quarter, eighth and sixteenth notes.")),
                    .paragraph("Each note value has a matching **rest** — a symbol of equal length that tells you to be silent.")
                   ]),
            Lesson(id: "l2-2", title: "Dots & Ties",
                   summary: "Extending durations beyond the basic values.",
                   level: .intermediate, systemImage: "ellipsis",
                   blocks: [
                    .paragraph("A **dot** after a note adds half of that note's value. A dotted half note = 2 + 1 = **3 beats**."),
                    .paragraph("A **tie** joins two notes of the same pitch into one continuous sound, adding their values together — useful across a bar line."),
                    .tip("A dot always adds half the value of the note it follows: a dotted quarter = 1 + ½ = 1½ beats.")
                   ]),
            Lesson(id: "l2-3", title: "Bars & Bar Lines",
                   summary: "How music is grouped into measures.",
                   level: .basic, systemImage: "rectangle.split.3x1",
                   blocks: [
                    .paragraph("Music is divided into **bars** (also called **measures**) by vertical **bar lines**. Each bar holds a fixed number of beats set by the time signature."),
                    .bullets([
                        "**Single bar line** — separates one measure from the next.",
                        "**Double bar line** — marks the end of a section.",
                        "**Final bar line** — a thin + thick line ending the piece.",
                        "**Repeat signs** ( 𝄆 𝄇 ) — play the enclosed bars again."
                    ]),
                    .paragraph("Grouping music into bars makes rhythm easier to read and gives the music a regular pulse.")
                   ]),
            Lesson(id: "l2-4", title: "Time Signatures",
                   summary: "The two numbers that define the meter.",
                   level: .intermediate, systemImage: "4.square",
                   blocks: [
                    .paragraph("A **time signature** has two numbers. The **top** number is how many beats are in each bar; the **bottom** number is which note value gets one beat (4 = quarter note, 8 = eighth note)."),
                    .table(headers: ["Signature", "Feel", "Counts as"], rows: [
                        ["4/4", "Common time", "4 quarter-note beats"],
                        ["3/4", "Waltz", "3 quarter-note beats"],
                        ["2/4", "March", "2 quarter-note beats"],
                        ["6/8", "Compound duple", "2 dotted-quarter beats"]
                    ]),
                    .staff(StaffExample(clef: .treble, timeSignature: "3/4", notes: [
                        StaffNote("G", octave: 4), StaffNote("A", octave: 4), StaffNote("B", octave: 4)
                    ], caption: "Three quarter-note beats in 3/4 (waltz) time.")),
                    .tip("In **simple** time (4/4, 3/4) the beat divides into 2. In **compound** time (6/8, 9/8) the beat divides into 3.")
                   ])
        ])

    // MARK: - Unit 3 — Pitch, Scales & Keys

    static let pitchScalesKeys = LearningUnit(
        id: "u3", title: "Pitch, Scales & Keys",
        subtitle: "Intervals, scales, keys and the circle of fifths", systemImage: "key.fill",
        lessons: [
            Lesson(id: "l3-1", title: "Tones, Semitones & Intervals",
                   summary: "The distance between two notes.",
                   level: .basic, systemImage: "ruler",
                   blocks: [
                    .paragraph("A **semitone** (half step) is the smallest distance in Western music — the gap between any key and its nearest neighbour. Two semitones make a **tone** (whole step)."),
                    .paragraph("An **interval** is the distance between two pitches, named by quantity (2nd, 3rd…) and quality (major, minor, perfect)."),
                    .keyboard(["C", "G"]),
                    .tip("From C up to G is a **perfect 5th** (7 semitones). Tap the keys to hear it.")
                   ]),
            Lesson(id: "l3-2", title: "The Major Scale",
                   summary: "The W-W-H-W-W-W-H pattern behind major keys.",
                   level: .basic, systemImage: "arrow.up.right",
                   blocks: [
                    .paragraph("A **major scale** is built from a fixed pattern of tones (W) and semitones (H): **W–W–H–W–W–W–H**. Starting on C uses only the white keys."),
                    .staff(StaffExample(clef: .treble, notes: [
                        StaffNote("C", octave: 4), StaffNote("D", octave: 4), StaffNote("E", octave: 4),
                        StaffNote("F", octave: 4), StaffNote("G", octave: 4), StaffNote("A", octave: 4),
                        StaffNote("B", octave: 4), StaffNote("C", octave: 5)
                    ], caption: "The C major scale.")),
                    .keyboard(["C", "D", "E", "F", "G", "A", "B"]),
                    .tip("The same W–W–H–W–W–W–H pattern transposed to any starting note gives that note's major scale.")
                   ]),
            Lesson(id: "l3-3", title: "Minor Scales",
                   summary: "Natural, harmonic and melodic minor.",
                   level: .intermediate, systemImage: "arrow.down.right",
                   blocks: [
                    .paragraph("Minor scales sound darker than major. There are three forms:"),
                    .bullets([
                        "**Natural minor** — W–H–W–W–H–W–W (the relative minor of a major key).",
                        "**Harmonic minor** — raises the 7th degree, creating a strong leading tone.",
                        "**Melodic minor** — raises the 6th and 7th ascending, reverting when descending."
                    ]),
                    .staff(StaffExample(clef: .treble, notes: [
                        StaffNote("A", octave: 4), StaffNote("B", octave: 4), StaffNote("C", octave: 5),
                        StaffNote("D", octave: 5), StaffNote("E", octave: 5), StaffNote("F", octave: 5),
                        StaffNote("G", octave: 5), StaffNote("A", octave: 5)
                    ], caption: "A natural minor — the relative minor of C major."))
                   ]),
            Lesson(id: "l3-4", title: "Key Signatures",
                   summary: "Sharps and flats declared at the start of a line.",
                   level: .intermediate, systemImage: "number.square",
                   blocks: [
                    .paragraph("A **key signature** lists the sharps or flats used throughout a piece, written right after the clef, so you don't mark every accidental individually."),
                    .staff(StaffExample(clef: .treble, keySignatureSharps: 2, notes: [
                        StaffNote("D", octave: 4), StaffNote("E", octave: 4), StaffNote("F#", octave: 4),
                        StaffNote("G", octave: 4), StaffNote("A", octave: 4)
                    ], caption: "D major has two sharps (F♯ and C♯).")),
                    .bullets([
                        "Sharps are added in the order **F C G D A E B**.",
                        "Flats are added in the reverse order **B E A D G C F**.",
                        "**Last sharp + a semitone = the major key.** Last flat = the key; the second-to-last flat names it."
                    ])
                   ]),
            Lesson(id: "l3-5", title: "The Circle of Fifths",
                   summary: "A map of all keys and how they relate.",
                   level: .intermediate, systemImage: "circle.hexagongrid",
                   blocks: [
                    .paragraph("The **circle of fifths** arranges the 12 keys so each step clockwise adds a sharp (and moves up a perfect 5th); each step anticlockwise adds a flat."),
                    .paragraph("Neighbouring keys share almost all their notes, which is why progressions and modulations often move around the circle. The inner ring shows each major key's **relative minor**."),
                    .tip("Open the **Scales** tab to explore the interactive wheel of scales and hear each key.")
                   ])
        ])

    // MARK: - Unit 4 — Harmony & Chords

    static let harmony = LearningUnit(
        id: "u4", title: "Harmony & Chords",
        subtitle: "Triads, inversions, sevenths and cadences", systemImage: "pianokeys.inverse",
        lessons: [
            Lesson(id: "l4-1", title: "Triads",
                   summary: "Three-note chords built in thirds.",
                   level: .basic, systemImage: "triangle",
                   blocks: [
                    .paragraph("A **triad** stacks two thirds: a **root**, a **third**, and a **fifth**. The qualities of those thirds give four triad types:"),
                    .bullets([
                        "**Major** — major 3rd + minor 3rd (bright).",
                        "**Minor** — minor 3rd + major 3rd (dark).",
                        "**Diminished** — two minor 3rds (tense).",
                        "**Augmented** — two major 3rds (suspended)."
                    ]),
                    .keyboard(["C", "E", "G"]),
                    .staff(StaffExample(clef: .treble, notes: [
                        StaffNote("C", octave: 4), StaffNote("E", octave: 4), StaffNote("G", octave: 4)
                    ], caption: "A C major triad: C–E–G."))
                   ]),
            Lesson(id: "l4-2", title: "Inversions",
                   summary: "Rearranging chord tones changes the bass.",
                   level: .intermediate, systemImage: "arrow.up.arrow.down",
                   blocks: [
                    .paragraph("When a chord's lowest note is not the root, the chord is **inverted**."),
                    .bullets([
                        "**Root position** — root in the bass (C–E–G).",
                        "**First inversion** — third in the bass (E–G–C).",
                        "**Second inversion** — fifth in the bass (G–C–E)."
                    ]),
                    .paragraph("Inversions let chords connect smoothly with minimal movement between voices — the heart of good **voice leading**.")
                   ]),
            Lesson(id: "l4-3", title: "Seventh Chords",
                   summary: "Adding a fourth note a seventh above the root.",
                   level: .intermediate, systemImage: "7.circle",
                   blocks: [
                    .paragraph("Stacking one more third on a triad adds a **7th**, giving richer four-note chords central to jazz, blues and pop."),
                    .bullets([
                        "**Major 7th (maj7)** — lush and restful.",
                        "**Dominant 7th (7)** — tense, wants to resolve.",
                        "**Minor 7th (m7)** — smooth and mellow.",
                        "**Half-diminished (m7♭5)** — used in minor-key turnarounds."
                    ]),
                    .keyboard(["C", "E", "G", "B"]),
                    .staff(StaffExample(clef: .treble, notes: [
                        StaffNote("C", octave: 4), StaffNote("E", octave: 4),
                        StaffNote("G", octave: 4), StaffNote("B", octave: 4)
                    ], caption: "A C major 7th chord: C–E–G–B."))
                   ]),
            Lesson(id: "l4-4", title: "Cadences",
                   summary: "How phrases come to rest.",
                   level: .advanced, systemImage: "flag.checkered",
                   blocks: [
                    .paragraph("A **cadence** is a chord progression that ends a phrase, like punctuation in a sentence."),
                    .table(headers: ["Cadence", "Chords", "Effect"], rows: [
                        ["Perfect (authentic)", "V → I", "Strong, conclusive"],
                        ["Plagal", "IV → I", "'Amen', gentle close"],
                        ["Imperfect (half)", "→ V", "Unfinished, suspended"],
                        ["Interrupted (deceptive)", "V → vi", "Surprise, delays the ending"]
                    ]),
                    .tip("The pull of **V → I** (dominant to tonic) is the strongest gravity in tonal harmony.")
                   ])
        ])

    // MARK: - Unit 5 — Advanced Topics

    static let advanced = LearningUnit(
        id: "u5", title: "Advanced Topics",
        subtitle: "Modes, transposition, ornaments and modulation", systemImage: "graduationcap.fill",
        lessons: [
            Lesson(id: "l5-1", title: "The Modes",
                   summary: "Seven scales from the major-scale family.",
                   level: .advanced, systemImage: "infinity",
                   blocks: [
                    .paragraph("Starting the major scale on each of its seven degrees produces the **modes**, each with a distinct colour:"),
                    .table(headers: ["Mode", "Start on", "Flavour"], rows: [
                        ["Ionian", "1st (major)", "Bright, standard major"],
                        ["Dorian", "2nd", "Minor with a raised 6th"],
                        ["Phrygian", "3rd", "Spanish, flat 2nd"],
                        ["Lydian", "4th", "Dreamy, raised 4th"],
                        ["Mixolydian", "5th", "Bluesy, flat 7th"],
                        ["Aeolian", "6th", "Natural minor"],
                        ["Locrian", "7th", "Unstable, diminished"]
                    ]),
                    .tip("Explore each mode with audio in the **Scales** tab.")
                   ]),
            Lesson(id: "l5-2", title: "Transposition",
                   summary: "Moving music to a different key.",
                   level: .advanced, systemImage: "arrow.left.arrow.right",
                   blocks: [
                    .paragraph("**Transposing** shifts every note by the same interval, preserving the tune in a new key — to suit a singer's range or a transposing instrument (e.g. a B♭ trumpet)."),
                    .paragraph("Keep the intervals identical and respell notes to fit the new key signature. The **circle of fifths** shows how far you've moved.")
                   ]),
            Lesson(id: "l5-3", title: "Ornaments",
                   summary: "Decorations that embellish a melody.",
                   level: .advanced, systemImage: "sparkles",
                   blocks: [
                    .paragraph("**Ornaments** add flourish to notes:"),
                    .bullets([
                        "**Trill** — rapid alternation with the note above.",
                        "**Mordent** — a quick flick to an adjacent note and back.",
                        "**Turn** — a four-note figure circling the main note.",
                        "**Grace note** — a tiny note 'crushed' before the main note.",
                        "**Appoggiatura** — a leaning note that resolves stepwise."
                    ])
                   ]),
            Lesson(id: "l5-4", title: "Modulation",
                   summary: "Changing key within a piece.",
                   level: .advanced, systemImage: "shuffle",
                   blocks: [
                    .paragraph("**Modulation** moves the music from one key to another, usually via a **pivot chord** shared by both keys, refreshing the harmonic colour."),
                    .paragraph("Common modulations go to closely-related keys — the dominant, subdominant, or relative major/minor — all neighbours on the circle of fifths.")
                   ])
        ])
}
