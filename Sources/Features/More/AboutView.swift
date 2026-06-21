import SwiftUI

struct AboutView: View {
    private let developerURL = URL(string: "https://www.tertiaryinfotech.com")!
    private let sourceURL = URL(string: "https://en.wikipedia.org/wiki/Music_theory")!

    private var versionString: String {
        let i = Bundle.main.infoDictionary
        let s = i?["CFBundleShortVersionString"] as? String ?? "1.0"
        let b = i?["CFBundleVersion"] as? String ?? "1"
        return "\(s) (\(b))"
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // App card
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 12) {
                            Image(systemName: "music.note")
                                .font(.title).foregroundStyle(.white)
                                .frame(width: 54, height: 54)
                                .background(Theme.primary.gradient, in: RoundedRectangle(cornerRadius: 14))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Music Theory Maestro").font(.title3.bold()).foregroundStyle(Theme.ink)
                                Text("Learn music theory, the fun way").font(.caption).foregroundStyle(Theme.mutedInk)
                            }
                        }
                        Text("A complete music-theory tutor for iPhone and iPad — from reading the staff and clefs to scales, the circle of fifths, chords and the harmony behind jazz, blues and R&B. Practise with Grade 1–8 mock exams and interactive, audible examples.")
                            .font(.subheadline).foregroundStyle(Theme.ink)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .appCard()

                    // Developer card
                    Text("DEVELOPER").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                    VStack(alignment: .leading, spacing: 0) {
                        Label("Tertiary Infotech Academy Pte Ltd", systemImage: "building.2.fill")
                            .foregroundStyle(Theme.ink)
                            .padding(.vertical, 14)
                        Divider()
                        Link(destination: developerURL) {
                            Label("tertiaryinfotech.com", systemImage: "globe").foregroundStyle(Theme.secondary)
                        }
                        .padding(.vertical, 14)
                    }
                    .padding(.horizontal, 16)
                    .background(Theme.surface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))

                    // Reference / data-source card
                    Text("REFERENCE").font(.caption.weight(.semibold)).foregroundStyle(Theme.mutedInk)
                    VStack(alignment: .leading, spacing: 0) {
                        Link(destination: sourceURL) {
                            Label("Music theory — Wikipedia", systemImage: "book.closed.fill")
                                .foregroundStyle(Theme.secondary)
                        }
                        .padding(.vertical, 14)
                    }
                    .padding(.horizontal, 16)
                    .background(Theme.surface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))

                    // Version row
                    HStack {
                        Text("Version").foregroundStyle(Theme.ink)
                        Spacer()
                        Text(versionString).foregroundStyle(Theme.mutedInk)
                    }
                    .padding(16)
                    .background(Theme.surface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))

                    Text("© 2026 Tertiary Infotech Academy Pte Ltd")
                        .font(.caption2).foregroundStyle(Theme.mutedInk)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(20)
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}
