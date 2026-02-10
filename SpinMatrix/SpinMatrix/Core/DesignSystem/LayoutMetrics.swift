import SwiftUI

// MARK: - Layout Metrics for Responsive Design

enum LayoutMetrics {
    // MARK: - Content Width

    /// Maximum width for game content
    static let maxContentWidth: CGFloat = 400

    /// Maximum width for info panels
    static let maxPanelWidth: CGFloat = 400

    /// Maximum width for game boards
    static let maxBoardWidth: CGFloat = 400

    // MARK: - Target Preview Sizes

    /// Small target preview (current)
    static let targetPreviewSmall: CGFloat = 120

    /// Standard target preview (improved)
    static let targetPreviewStandard: CGFloat = 160

    /// Large target preview
    static let targetPreviewLarge: CGFloat = 200

    // MARK: - Game Element Sizes

    /// Rotator button size (44pt minimum touch target)
    static let rotatorButtonSize: CGFloat = 44

    /// Arrow button size for SphereShift
    static let arrowButtonSize: CGFloat = 44

    /// Sphere cell size
    static let sphereCellSize: CGFloat = 48

    /// Hex rotator hit area
    static let hexRotatorSize: CGFloat = 44

    // MARK: - Icon Sizes

    /// Small icon (in labels)
    static let iconSmall: CGFloat = 12

    /// Medium icon (in buttons)
    static let iconMedium: CGFloat = 16

    /// Large icon (headers)
    static let iconLarge: CGFloat = 24

    /// Hero icon (main menu)
    static let iconHero: CGFloat = 40

    /// Rotator icon
    static let rotatorIcon: CGFloat = 16

    // MARK: - Game Card

    /// Game card icon container size
    static let gameCardIconSize: CGFloat = 60

    /// Game card icon symbol size
    static let gameCardIconSymbol: CGFloat = 28

    /// Game card minimum height
    static let gameCardMinHeight: CGFloat = 80

    // MARK: - Header Sizes

    /// Header icon size
    static let headerIcon: CGFloat = 24

    /// Back button minimum width
    static let backButtonMinWidth: CGFloat = 70

    // MARK: - Victory/Modal

    /// Victory emoji size
    static let victoryEmojiSize: CGFloat = 60

    /// Modal icon container size
    static let modalIconSize: CGFloat = 48
}

// MARK: - Responsive Width Modifier

struct MaxWidthModifier: ViewModifier {
    let maxWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: maxWidth)
    }
}

extension View {
    func maxContentWidth(_ width: CGFloat = LayoutMetrics.maxContentWidth) -> some View {
        modifier(MaxWidthModifier(maxWidth: width))
    }

    func maxPanelWidth() -> some View {
        modifier(MaxWidthModifier(maxWidth: LayoutMetrics.maxPanelWidth))
    }

    func maxBoardWidth() -> some View {
        modifier(MaxWidthModifier(maxWidth: LayoutMetrics.maxBoardWidth))
    }
}

// MARK: - Safe Area Helpers

struct SafeAreaPadding: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.top, Spacing.md)
            .padding(.bottom, Spacing.xxl)
    }
}

extension View {
    func safeAreaPadding() -> some View {
        modifier(SafeAreaPadding())
    }
}

// MARK: - Background Circle for HexLogic

struct HexBackgroundCircle: View {
    let size: CGFloat

    init(size: CGFloat = 360) {
        self.size = size
    }

    var body: some View {
        Circle()
            .fill(BrainGameColors.backgroundPrimary.opacity(0.4))
            .frame(width: size, height: size)
            .overlay(
                Circle()
                    .stroke(BrainGameColors.border.opacity(0.5), lineWidth: ComponentTokens.borderThin)
            )
            .shadow(color: .black.opacity(0.3), radius: 20)
    }
}
