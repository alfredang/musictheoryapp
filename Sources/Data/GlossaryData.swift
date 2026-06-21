import Foundation

struct GlossaryTerm: Identifiable, Hashable {
    var id: String { term }
    let term: String
    let definition: String
}

enum GlossaryData {
    static let terms: [GlossaryTerm] = [
        GlossaryTerm(term: "Accidental", definition: "A sharp, flat or natural that alters a note's pitch."),
        GlossaryTerm(term: "Arpeggio", definition: "The notes of a chord played one after another rather than together."),
        GlossaryTerm(term: "Bar (Measure)", definition: "A segment of music containing a fixed number of beats, marked off by bar lines."),
        GlossaryTerm(term: "Cadence", definition: "A chord progression that brings a phrase to a close."),
        GlossaryTerm(term: "Chord", definition: "Three or more notes sounded together."),
        GlossaryTerm(term: "Clef", definition: "A symbol fixing the pitch of the staff lines (treble, bass, alto)."),
        GlossaryTerm(term: "Dynamics", definition: "The volume of music, e.g. piano (soft) and forte (loud)."),
        GlossaryTerm(term: "Enharmonic", definition: "Two note names for the same pitch, e.g. F♯ and G♭."),
        GlossaryTerm(term: "Interval", definition: "The distance in pitch between two notes."),
        GlossaryTerm(term: "Key signature", definition: "The sharps or flats shown after the clef that apply throughout a piece."),
        GlossaryTerm(term: "Legato", definition: "Played smoothly and connected."),
        GlossaryTerm(term: "Modulation", definition: "Changing from one key to another within a piece."),
        GlossaryTerm(term: "Octave", definition: "The interval between a note and the next note of the same name (12 semitones)."),
        GlossaryTerm(term: "Ornament", definition: "A decoration such as a trill, mordent or turn."),
        GlossaryTerm(term: "Pitch", definition: "How high or low a note sounds."),
        GlossaryTerm(term: "Scale", definition: "An ordered sequence of notes ascending or descending by step."),
        GlossaryTerm(term: "Semitone", definition: "The smallest interval in Western music (a half step)."),
        GlossaryTerm(term: "Staccato", definition: "Played short and detached."),
        GlossaryTerm(term: "Syncopation", definition: "Accenting off-beats or weak beats against the pulse."),
        GlossaryTerm(term: "Tempo", definition: "The speed of the music."),
        GlossaryTerm(term: "Tie", definition: "A curved line joining two notes of the same pitch into one duration."),
        GlossaryTerm(term: "Time signature", definition: "Two numbers showing beats per bar and which note is one beat."),
        GlossaryTerm(term: "Tone", definition: "A whole step — two semitones."),
        GlossaryTerm(term: "Transposition", definition: "Moving music up or down into a different key."),
        GlossaryTerm(term: "Triad", definition: "A three-note chord built in thirds (root, third, fifth).")
    ]
}
