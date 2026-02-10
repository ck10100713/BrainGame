import SwiftUI

// MARK: - BrainGame Typography System

enum BrainGameTypography {
    // MARK: - Font Sizes

    static let displaySize: CGFloat = 40
    static let title1Size: CGFloat = 32
    static let title2Size: CGFloat = 24
    static let title3Size: CGFloat = 20
    static let headlineSize: CGFloat = 17
    static let bodySize: CGFloat = 17
    static let subheadlineSize: CGFloat = 15
    static let captionSize: CGFloat = 12
    static let statValueSize: CGFloat = 32

    // MARK: - Display Fonts

    /// Large display text - 40pt Bold Rounded
    static let display = Font.system(size: displaySize, weight: .bold, design: .rounded)

    /// Title 1 - 32pt Bold Rounded
    static let title1 = Font.system(size: title1Size, weight: .bold, design: .rounded)

    /// Title 2 - 24pt Semibold Rounded
    static let title2 = Font.system(size: title2Size, weight: .semibold, design: .rounded)

    /// Title 3 - 20pt Semibold
    static let title3 = Font.system(size: title3Size, weight: .semibold)

    // MARK: - Body Fonts

    /// Headline - 17pt Semibold
    static let headline = Font.system(size: headlineSize, weight: .semibold)

    /// Body - 17pt Regular
    static let body = Font.system(size: bodySize, weight: .regular)

    /// Subheadline - 15pt Regular
    static let subheadline = Font.system(size: subheadlineSize, weight: .regular)

    // MARK: - Caption & Special

    /// Caption - 12pt Medium
    static let caption = Font.system(size: captionSize, weight: .medium)

    /// Caption Bold - 12pt Bold with tracking
    static let captionBold = Font.system(size: captionSize, weight: .bold)

    /// Stat Value - 32pt Bold Monospaced Rounded
    static let statValue = Font.system(size: statValueSize, weight: .bold, design: .rounded)

    /// Button text - 17pt Bold
    static let button = Font.system(size: headlineSize, weight: .bold)

    /// Game title in header - 28pt Bold Rounded
    static let gameTitle = Font.system(size: 28, weight: .bold, design: .rounded)
}

// MARK: - Text Style Modifiers

struct PrimaryTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(BrainGameColors.textPrimary)
    }
}

struct SecondaryTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(BrainGameColors.textSecondary)
    }
}

struct TertiaryTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(BrainGameColors.textTertiary)
    }
}

struct LabelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(BrainGameTypography.captionBold)
            .foregroundColor(BrainGameColors.textTertiary)
            .textCase(.uppercase)
            .tracking(1.5)
    }
}

// MARK: - View Extensions

extension View {
    func primaryText() -> some View {
        modifier(PrimaryTextStyle())
    }

    func secondaryText() -> some View {
        modifier(SecondaryTextStyle())
    }

    func tertiaryText() -> some View {
        modifier(TertiaryTextStyle())
    }

    func labelStyle() -> some View {
        modifier(LabelStyle())
    }
}
