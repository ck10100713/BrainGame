import SwiftUI

// MARK: - BrainGame Spacing System (8pt Grid)

enum Spacing {
    /// 4pt - Extra extra small, tight spacing
    static let xxs: CGFloat = 4

    /// 8pt - Extra small, small elements
    static let xs: CGFloat = 8

    /// 12pt - Small, related items
    static let sm: CGFloat = 12

    /// 16pt - Medium, default spacing
    static let md: CGFloat = 16

    /// 20pt - Medium-large
    static let ml: CGFloat = 20

    /// 24pt - Large, section spacing
    static let lg: CGFloat = 24

    /// 32pt - Extra large, major sections
    static let xl: CGFloat = 32

    /// 40pt - Extra extra large
    static let xxl: CGFloat = 40

    /// 48pt - Triple extra large
    static let xxxl: CGFloat = 48
}

// MARK: - Padding Helpers

extension View {
    /// Apply horizontal padding using spacing token
    func horizontalPadding(_ spacing: CGFloat = Spacing.md) -> some View {
        self.padding(.horizontal, spacing)
    }

    /// Apply vertical padding using spacing token
    func verticalPadding(_ spacing: CGFloat = Spacing.md) -> some View {
        self.padding(.vertical, spacing)
    }

    /// Apply uniform padding using spacing token
    func uniformPadding(_ spacing: CGFloat = Spacing.md) -> some View {
        self.padding(spacing)
    }

    /// Standard card padding (20pt)
    func cardPadding() -> some View {
        self.padding(Spacing.ml)
    }

    /// Standard section padding (24pt)
    func sectionPadding() -> some View {
        self.padding(Spacing.lg)
    }
}
