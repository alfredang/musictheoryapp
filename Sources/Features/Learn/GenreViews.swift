import SwiftUI

struct GenresListView: View {
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Every style applies the same theory in its own way. Explore how jazz, blues, R&B and classical each shape harmony, rhythm and melody.")
                        .font(.subheadline).foregroundStyle(Theme.mutedInk)
                    ForEach(GenreData.all) { genre in
                        NavigationLink(value: Route.genre(genre)) {
                            HStack(spacing: 14) {
                                Image(systemName: genre.systemImage).font(.title2).foregroundStyle(.white)
                                    .frame(width: 48, height: 48)
                                    .background(Theme.genres.gradient, in: RoundedRectangle(cornerRadius: 12))
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(genre.name).font(.headline).foregroundStyle(Theme.ink)
                                    Text(genre.tagline).font(.caption).foregroundStyle(Theme.mutedInk)
                                }
                                Spacer()
                                Image(systemName: "chevron.right").foregroundStyle(Theme.mutedInk)
                            }
                            .appCard()
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(18)
            }
        }
        .navigationTitle("Musical Styles")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct GenreDetailView: View {
    let genre: Genre

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    SectionHeader(title: genre.name, subtitle: genre.tagline,
                                  systemImage: genre.systemImage, tint: Theme.genres)

                    Text(genre.overview).font(.body).foregroundStyle(Theme.ink)
                        .fixedSize(horizontal: false, vertical: true)

                    group("Characteristics", genre.characteristics, "waveform.path")
                    group("Theory & harmony", genre.theory, "function")

                    VStack(alignment: .leading, spacing: 8) {
                        Text("SIGNATURE PROGRESSION").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                        Text(genre.progressionName).font(.subheadline.weight(.semibold)).foregroundStyle(Theme.ink)
                        Text(genre.progression).font(.callout.monospaced()).foregroundStyle(Theme.genres)
                            .fixedSize(horizontal: false, vertical: true)
                        Button {
                            playProgression()
                        } label: {
                            Label("Hear the progression", systemImage: "play.circle.fill")
                                .font(.subheadline.weight(.semibold))
                        }
                        .buttonStyle(.borderedProminent).tint(Theme.genres)
                        .padding(.top, 2)
                    }
                    .appCard()

                    VStack(alignment: .leading, spacing: 8) {
                        Text("KEY ARTISTS").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                        FlowChips(items: genre.artists)
                    }
                    .appCard()
                }
                .padding(18)
            }
        }
        .navigationTitle(genre.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func group(_ title: String, _ items: [String], _ image: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: image).font(.headline).foregroundStyle(Theme.ink)
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 10) {
                    Circle().fill(Theme.genres).frame(width: 6, height: 6).padding(.top, 7)
                    Text(item).font(.subheadline).foregroundStyle(Theme.ink)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .appCard()
    }

    /// Audition a few representative chords for this genre's tonic area.
    private func playProgression() {
        // A simple, genre-flavoured set of chords rooted around C.
        let chords: [[Int]]
        switch genre.id {
        case "jazz": chords = [[62,65,69,72], [55,59,65,69], [60,64,67,71]]      // Dm7 G7 Cmaj7
        case "blues": chords = [[60,64,67,70], [65,69,72,75], [67,71,74,77]]     // C7 F7 G7
        case "rnb": chords = [[60,64,67,71,74], [57,60,64,67], [62,65,69,72]]    // Cmaj9 Am Dm9
        default: chords = [[60,64,67], [65,69,72], [67,71,74,77], [60,64,67]]    // C F G7 C
        }
        for (i, c) in chords.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.9) {
                ToneEngine.shared.playChord(c, duration: 0.85)
            }
        }
    }
}

/// A simple wrapping chip layout.
struct FlowChips: View {
    let items: [String]
    var body: some View {
        FlexibleView(data: items, spacing: 8, lineSpacing: 8) { item in
            Text(item).font(.caption.weight(.semibold)).foregroundStyle(Theme.genres)
                .padding(.horizontal, 10).padding(.vertical, 6)
                .background(Theme.genres.opacity(0.14), in: Capsule())
        }
    }
}
