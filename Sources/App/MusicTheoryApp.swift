import SwiftUI

@main
struct MusicTheoryApp: App {
    @StateObject private var progress = ProgressStore()
    init() {
        // Keep the navigation bar legible on our custom background.
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Theme.background)
        appearance.titleTextAttributes = [.foregroundColor: UIColor(Theme.ink)]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Theme.ink)]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(progress)
                .tint(Theme.accent)
        }
    }
}
