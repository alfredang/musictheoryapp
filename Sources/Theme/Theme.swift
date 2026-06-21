import SwiftUI

/// Brand design tokens. Reference these everywhere — never raw `Color` literals.
/// A re-theme is then a one-file change. (see mobile-ios-design skill)
enum Theme {
    /// Primary accent — key buttons, active states. A warm violet.
    static let primary = Color(red: 0.42, green: 0.27, blue: 0.86)
    /// Secondary accent — links, selected tabs. A teal.
    static let secondary = Color(red: 0.0, green: 0.62, blue: 0.65)
    /// Highlight — ratings, badges, correct answers. Amber.
    static let highlight = Color(red: 0.98, green: 0.71, blue: 0.20)
    /// Accent used by tab tint / launch screen (mirrors `primary`).
    static let accent = primary

    /// App background — a soft, near-white with a hint of violet.
    static let background = Color(red: 0.97, green: 0.97, blue: 0.99)
    /// Elevated card / surface color.
    static let surface = Color.white
    /// Subtle fills / chips.
    static let chip = Color(red: 0.93, green: 0.93, blue: 0.97)

    /// Primary text — explicit dark ink (not `.primary`) so it passes AA on our custom bg.
    static let ink = Color(red: 0.10, green: 0.10, blue: 0.16)
    /// Secondary text.
    static let mutedInk = Color(red: 0.40, green: 0.40, blue: 0.48)

    /// Semantic feedback colors.
    static let correct = Color(red: 0.20, green: 0.66, blue: 0.33)
    static let wrong = Color(red: 0.85, green: 0.24, blue: 0.24)

    /// Per-section accent colors, used for cards and headers.
    static let learn = Color(red: 0.42, green: 0.27, blue: 0.86)
    static let scales = Color(red: 0.0, green: 0.62, blue: 0.65)
    static let chords = Color(red: 0.90, green: 0.40, blue: 0.30)
    static let exams = Color(red: 0.20, green: 0.50, blue: 0.85)
    static let genres = Color(red: 0.78, green: 0.30, blue: 0.55)
}

// MARK: - Reusable card surface

struct AppCardModifier: ViewModifier {
    var padding: CGFloat = 16
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(Theme.surface, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: .black.opacity(0.06), radius: 8, y: 3)
    }
}

extension View {
    /// Single, reusable elevated card surface (white, 18pt continuous radius, soft shadow).
    func appCard(padding: CGFloat = 16) -> some View {
        modifier(AppCardModifier(padding: padding))
    }
}

/// A small rounded label chip.
struct Chip: View {
    let text: String
    var color: Color = Theme.primary
    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.14), in: Capsule())
    }
}

/// A header used at the top of section home screens.
struct SectionHeader: View {
    let title: String
    let subtitle: String
    let systemImage: String
    var tint: Color = Theme.primary
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: systemImage)
                .font(.title)
                .foregroundStyle(.white)
                .frame(width: 54, height: 54)
                .background(tint.gradient, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.title2.bold()).foregroundStyle(Theme.ink)
                Text(subtitle).font(.subheadline).foregroundStyle(Theme.mutedInk)
            }
            Spacer()
        }
    }
}
