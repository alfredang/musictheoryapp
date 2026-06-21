import SwiftUI

struct ScaleDetailView: View {
    let scale: ScaleType
    let root: Pitch

    private var pitches: [Pitch] { scale.pitches(root: root) }
    private var staffNotes: [StaffNote] {
        // Include the octave at the top for a complete-sounding scale.
        var notes = NoteSequence.ascending(pitches, startOctave: 4)
        if let first = notes.first {
            notes.append(StaffNote(pitch: first.pitch, octave: first.octave + 1))
        }
        return notes
    }
    private var pitchClasses: Set<Int> { Set(pitches.map(\.pitchClass)) }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    SectionHeader(title: "\(root.name) \(scale.name)",
                                  subtitle: scale.category, systemImage: "pianokeys", tint: Theme.scales)

                    Text(scale.blurb).font(.body).foregroundStyle(Theme.ink)
                        .fixedSize(horizontal: false, vertical: true)

                    StaffView(example: StaffExample(clef: .treble, notes: staffNotes,
                                                    caption: "\(root.name) \(scale.name) ascending"))

                    VStack(alignment: .leading, spacing: 8) {
                        Text("NOTES").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                        FlexibleView(data: pitches.map(\.name).enumeratedUnique(), spacing: 8, lineSpacing: 8) { item in
                            Text(item.value).font(.subheadline.weight(.semibold)).foregroundStyle(.white)
                                .padding(.horizontal, 12).padding(.vertical, 8)
                                .background(Theme.scales, in: RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .appCard()

                    VStack(alignment: .leading, spacing: 8) {
                        Text("ON THE KEYBOARD").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                        PianoKeyboardView(highlighted: pitchClasses)
                    }
                    .appCard()

                    HStack {
                        Button {
                            ToneEngine.shared.playSequence(NoteSequence.midis(staffNotes), noteDuration: 0.4)
                        } label: {
                            Label("Ascending", systemImage: "arrow.up").frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent).tint(Theme.scales)
                        Button {
                            ToneEngine.shared.playSequence(NoteSequence.midis(staffNotes).reversed(), noteDuration: 0.4)
                        } label: {
                            Label("Descending", systemImage: "arrow.down").frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered).tint(Theme.scales)
                    }
                }
                .padding(18)
            }
        }
        .navigationTitle("\(root.name) \(scale.name)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// Helper to give scale-note chips stable unique ids even if a name repeats.
struct IndexedString: Hashable { let id: Int; let value: String }
extension Array where Element == String {
    func enumeratedUnique() -> [IndexedString] {
        enumerated().map { IndexedString(id: $0.offset, value: $0.element) }
    }
}
