import SwiftUI

struct ChordsHomeView: View {
    @State private var rootName = "C"
    private let roots = ["C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"]

    private var root: Pitch { Pitch(rootName) ?? Pitch(letter: .c) }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        SectionHeader(title: "Chords",
                                      subtitle: "Triads, sevenths and extended chords",
                                      systemImage: "pianokeys", tint: Theme.chords)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("ROOT NOTE").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(roots, id: \.self) { name in
                                        Button {
                                            rootName = name
                                            if let p = Pitch(name) { ToneEngine.shared.play(midi: p.midi(octave: 4), duration: 0.4) }
                                        } label: {
                                            Text(Pitch(name)?.name ?? name)
                                                .font(.subheadline.weight(.bold))
                                                .foregroundStyle(rootName == name ? .white : Theme.ink)
                                                .frame(width: 46, height: 40)
                                                .background(rootName == name ? Theme.chords : Theme.surface,
                                                            in: RoundedRectangle(cornerRadius: 10))
                                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.chords.opacity(0.3), lineWidth: rootName == name ? 0 : 1))
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                        .appCard()

                        ForEach(ChordType.categories, id: \.self) { category in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(category).font(.subheadline.weight(.semibold)).foregroundStyle(Theme.chords)
                                ForEach(ChordType.all.filter { $0.category == category }) { chord in
                                    NavigationLink(value: ChordRoute(chord: chord, rootName: rootName)) {
                                        chordRow(chord)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .padding(18)
                }
            }
            .navigationTitle("Chords")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: ChordRoute.self) { route in
                ChordDetailView(chord: route.chord, root: Pitch(route.rootName) ?? Pitch(letter: .c))
            }
        }
    }

    private func chordRow(_ chord: ChordType) -> some View {
        let pitches = chord.pitches(root: root)
        return HStack(spacing: 12) {
            Text(chord.displaySymbol(root: root))
                .font(.headline).foregroundStyle(.white)
                .frame(minWidth: 64, minHeight: 40)
                .padding(.horizontal, 8)
                .background(Theme.chords.gradient, in: RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 3) {
                Text(chord.name).font(.subheadline.weight(.semibold)).foregroundStyle(Theme.ink)
                Text(pitches.map(\.name).joined(separator: "  "))
                    .font(.caption.monospaced()).foregroundStyle(Theme.mutedInk)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(Theme.mutedInk)
        }
        .appCard(padding: 14)
    }
}

struct ChordRoute: Hashable {
    let chord: ChordType
    let rootName: String
}
