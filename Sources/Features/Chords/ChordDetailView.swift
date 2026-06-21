import SwiftUI

struct ChordDetailView: View {
    let chord: ChordType
    let root: Pitch

    private var pitches: [Pitch] { chord.pitches(root: root) }
    private var staffNotes: [StaffNote] { NoteSequence.ascending(pitches, startOctave: 4) }
    private var pitchClasses: Set<Int> { Set(pitches.map(\.pitchClass)) }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    SectionHeader(title: chord.displaySymbol(root: root),
                                  subtitle: "\(root.name) \(chord.name)",
                                  systemImage: "pianokeys", tint: Theme.chords)

                    Text(chord.blurb).font(.body).foregroundStyle(Theme.ink)
                        .fixedSize(horizontal: false, vertical: true)

                    StaffView(example: StaffExample(clef: .treble, notes: staffNotes,
                                                    caption: "\(chord.displaySymbol(root: root)) — \(pitches.map(\.name).joined(separator: "–"))"))

                    VStack(alignment: .leading, spacing: 8) {
                        Text("CHORD TONES").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                        FlexibleView(data: pitches.map(\.name).enumeratedUnique(), spacing: 8, lineSpacing: 8) { item in
                            Text(item.value).font(.subheadline.weight(.semibold)).foregroundStyle(.white)
                                .padding(.horizontal, 12).padding(.vertical, 8)
                                .background(Theme.chords, in: RoundedRectangle(cornerRadius: 10))
                        }
                        Text("Formula: " + chord.semitones.map { "\($0)" }.joined(separator: " · ") + " semitones from root")
                            .font(.caption).foregroundStyle(Theme.mutedInk)
                    }
                    .appCard()

                    VStack(alignment: .leading, spacing: 8) {
                        Text("ON THE KEYBOARD").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                        PianoKeyboardView(highlighted: pitchClasses)
                    }
                    .appCard()

                    HStack {
                        Button {
                            ToneEngine.shared.playChord(NoteSequence.midis(staffNotes), duration: 1.4)
                        } label: {
                            Label("Play chord", systemImage: "play.circle.fill").frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent).tint(Theme.chords)
                        Button {
                            ToneEngine.shared.playSequence(NoteSequence.midis(staffNotes), noteDuration: 0.4)
                        } label: {
                            Label("Arpeggiate", systemImage: "arrow.up.right").frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered).tint(Theme.chords)
                    }
                }
                .padding(18)
            }
        }
        .navigationTitle(chord.displaySymbol(root: root))
        .navigationBarTitleDisplayMode(.inline)
    }
}
