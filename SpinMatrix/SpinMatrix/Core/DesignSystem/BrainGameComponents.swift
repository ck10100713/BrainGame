import SwiftUI

// MARK: - BrainGame Component Tokens

enum ComponentTokens {
    // MARK: - Corner Radius

    /// Small radius - 4pt (chips, small elements)
    static let radiusSmall: CGFloat = 4

    /// Medium radius - 8pt (buttons, inputs)
    static let radiusMedium: CGFloat = 8

    /// Large radius - 12pt (cards)
    static let radiusLarge: CGFloat = 12

    /// Extra large radius - 16pt (board, panels)
    static let radiusXL: CGFloat = 16

    /// 2XL radius - 20pt (modals, major cards)
    static let radius2XL: CGFloat = 20

    // MARK: - Border Width

    static let borderThin: CGFloat = 1
    static let borderMedium: CGFloat = 2

    // MARK: - Shadow

    static let shadowRadius: CGFloat = 8
    static let shadowY: CGFloat = 4
    static let shadowOpacity: Double = 0.3
}

// MARK: - Card Background Modifier

struct CardBackground: ViewModifier {
    var cornerRadius: CGFloat = ComponentTokens.radiusLarge
    var showBorder: Bool = true

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(BrainGameColors.backgroundSecondary.opacity(0.8))
                    .overlay(
                        Group {
                            if showBorder {
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .stroke(BrainGameColors.border, lineWidth: ComponentTokens.borderThin)
                            }
                        }
                    )
            )
    }
}

struct PanelBackground: ViewModifier {
    var cornerRadius: CGFloat = ComponentTokens.radius2XL

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(BrainGameColors.backgroundSecondary.opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(BrainGameColors.border.opacity(0.5), lineWidth: ComponentTokens.borderThin)
                    )
            )
    }
}

struct BoardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: ComponentTokens.radiusXL)
                    .fill(BrainGameColors.backgroundSecondary.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: ComponentTokens.radiusXL)
                            .stroke(BrainGameColors.border, lineWidth: ComponentTokens.borderThin)
                    )
            )
    }
}

// MARK: - View Extensions

extension View {
    func cardBackground(cornerRadius: CGFloat = ComponentTokens.radiusLarge, showBorder: Bool = true) -> some View {
        modifier(CardBackground(cornerRadius: cornerRadius, showBorder: showBorder))
    }

    func panelBackground(cornerRadius: CGFloat = ComponentTokens.radius2XL) -> some View {
        modifier(PanelBackground(cornerRadius: cornerRadius))
    }

    func boardBackground() -> some View {
        modifier(BoardBackground())
    }

    func gameAccentShadow(_ color: Color, radius: CGFloat = ComponentTokens.shadowRadius) -> some View {
        self.shadow(color: color.opacity(ComponentTokens.shadowOpacity), radius: radius, x: 0, y: ComponentTokens.shadowY)
    }
}

// MARK: - Divider Style

struct GameDivider: View {
    var body: some View {
        Divider()
            .background(BrainGameColors.border.opacity(0.5))
    }
}
