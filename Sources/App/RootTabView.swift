import SwiftUI

/// Root bottom-tab navigation. iOS 17 deployment target → use the classic
/// `.tabItem { Label(...) }` API (the `Tab(_:systemImage:)` initializer is iOS 18+).
struct RootTabView: View {
    /// Allows screenshot automation to open a specific tab via `-startTab N` launch argument.
    @State private var selection: Int = {
        let args = ProcessInfo.processInfo.arguments
        if let i = args.firstIndex(of: "-startTab"), i + 1 < args.count, let n = Int(args[i + 1]) {
            return n
        }
        return 0
    }()

    var body: some View {
        TabView(selection: $selection) {
            LearnHomeView()
                .tabItem { Label("Learn", systemImage: "book.fill") }.tag(0)
            ScalesHomeView()
                .tabItem { Label("Scales", systemImage: "circle.hexagongrid.fill") }.tag(1)
            ChordsHomeView()
                .tabItem { Label("Chords", systemImage: "pianokeys") }.tag(2)
            ExamsHomeView()
                .tabItem { Label("Exams", systemImage: "checkmark.seal.fill") }.tag(3)
            MoreView()
                .tabItem { Label("More", systemImage: "ellipsis.circle.fill") }.tag(4)
        }
        .tint(Theme.accent)
    }
}

/// "More" hosts the secondary destinations (Feedback + About) so the five primary
/// learning sections each get a first-class tab.
struct MoreView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    Section {
                        NavigationLink {
                            FeedbackView()
                        } label: {
                            Label("Feedback", systemImage: "bubble.left.and.bubble.right.fill")
                        }
                        NavigationLink {
                            AboutView()
                        } label: {
                            Label("About", systemImage: "info.circle.fill")
                        }
                    }
                    Section("Reference") {
                        NavigationLink {
                            GlossaryView()
                        } label: {
                            Label("Glossary of Terms", systemImage: "character.book.closed.fill")
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("More")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
