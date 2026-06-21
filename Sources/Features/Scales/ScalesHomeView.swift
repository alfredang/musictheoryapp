import SwiftUI

struct ScalesHomeView: View {
    @State private var selectedKeyIndex = 0   // index into KeyWheelEntry.all

    private var root: Pitch {
        Pitch(KeyWheelEntry.all[selectedKeyIndex].rootPitch) ?? Pitch(letter: .c)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        SectionHeader(title: "Scales & Keys",
                                      subtitle: "The wheel of scales and every scale type",
                                      systemImage: "circle.hexagongrid.fill", tint: Theme.scales)

                        wheelCard

                        Text("SCALES FROM \(root.name.uppercased())")
                            .font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)

                        ForEach(ScaleType.categories, id: \.self) { category in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(category).font(.subheadline.weight(.semibold)).foregroundStyle(Theme.scales)
                                ForEach(ScaleType.all.filter { $0.category == category }) { scale in
                                    NavigationLink(value: ScaleRoute(scale: scale, rootName: root.name)) {
                                        scaleRow(scale)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    .padding(18)
                }
            }
            .navigationTitle("Scales")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: ScaleRoute.self) { route in
                ScaleDetailView(scale: route.scale, root: Pitch(route.rootName) ?? Pitch(letter: .c))
            }
        }
    }

    private var wheelCard: some View {
        VStack(spacing: 14) {
            Text("Wheel of Scales — Circle of Fifths")
                .font(.headline).foregroundStyle(Theme.ink)
            Text("Tap a key to hear its tonic. Each clockwise step adds a sharp; the inner ring shows the relative minor.")
                .font(.caption).foregroundStyle(Theme.mutedInk)
                .multilineTextAlignment(.center)
            CircleOfFifthsView(selected: $selectedKeyIndex, diameter: 290)
                .frame(maxWidth: .infinity)
            HStack {
                Chip(text: "Major: \(KeyWheelEntry.all[selectedKeyIndex].major)", color: Theme.primary)
                Chip(text: "Relative minor: \(KeyWheelEntry.all[selectedKeyIndex].minor)", color: Theme.secondary)
            }
        }
        .appCard()
    }

    private func scaleRow(_ scale: ScaleType) -> some View {
        let pitches = scale.pitches(root: root)
        return HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(scale.name).font(.subheadline.weight(.semibold)).foregroundStyle(Theme.ink)
                Text(pitches.map(\.name).joined(separator: "  "))
                    .font(.caption.monospaced()).foregroundStyle(Theme.mutedInk)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(Theme.mutedInk)
        }
        .appCard(padding: 14)
    }
}

struct ScaleRoute: Hashable {
    let scale: ScaleType
    let rootName: String
}
