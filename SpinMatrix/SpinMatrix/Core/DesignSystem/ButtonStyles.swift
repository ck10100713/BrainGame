import SwiftUI

// MARK: - Touch Target Sizes

enum TouchTarget {
    /// Minimum touch target - 44pt (Apple HIG)
    static let minimum: CGFloat = 44

    /// Comfortable touch target - 48pt (recommended for games)
    static let comfortable: CGFloat = 48

    /// Large touch target - 56pt (primary actions)
    static let large: CGFloat = 56
}

// MARK: - Primary Action Button Style

struct PrimaryButtonStyle: ButtonStyle {
    let gradient: LinearGradient
    let height: CGFloat

    init(gradient: LinearGradient, height: CGFloat = TouchTarget.large) {
        self.gradient = gradient
        self.height = height
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BrainGameTypography.button)
            .foregroundColor(BrainGameColors.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(gradient)
            .clipShape(RoundedRectangle(cornerRadius: ComponentTokens.radiusLarge))
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Secondary Button Style

struct SecondaryButtonStyle: ButtonStyle {
    let height: CGFloat

    init(height: CGFloat = TouchTarget.large) {
        self.height = height
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BrainGameTypography.button)
            .foregroundColor(BrainGameColors.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(
                LinearGradient(
                    colors: [BrainGameColors.backgroundTertiary, BrainGameColors.backgroundSecondary],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: ComponentTokens.radiusLarge))
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Circular Button Style (for rotators)

struct CircularButtonStyle: ButtonStyle {
    let size: CGFloat
    let accentColor: Color

    init(size: CGFloat = TouchTarget.minimum, accentColor: Color = BrainGameColors.accentSpinMatrix) {
        self.size = size
        self.accentColor = accentColor
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: size, height: size)
            .background(
                Circle()
                    .fill(BrainGameColors.backgroundPrimary.opacity(0.9))
            )
            .overlay(
                Circle()
                    .stroke(accentColor.opacity(0.6), lineWidth: ComponentTokens.borderThin)
            )
            .shadow(color: accentColor.opacity(0.3), radius: 5)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Back Button Style

struct BackButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BrainGameTypography.subheadline)
            .foregroundColor(BrainGameColors.textSecondary)
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xs)
            .frame(minHeight: TouchTarget.minimum)
            .background(
                RoundedRectangle(cornerRadius: ComponentTokens.radiusMedium)
                    .fill(BrainGameColors.backgroundSecondary.opacity(0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: ComponentTokens.radiusMedium)
                            .stroke(BrainGameColors.border, lineWidth: ComponentTokens.borderThin)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Difficulty/Mode Selector Button Style

struct SelectorButtonStyle: ButtonStyle {
    let isSelected: Bool
    let gradient: LinearGradient

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BrainGameTypography.subheadline.weight(.bold))
            .foregroundColor(isSelected ? BrainGameColors.textPrimary : BrainGameColors.textTertiary)
            .frame(maxWidth: .infinity)
            .frame(minHeight: TouchTarget.minimum)
            .background(
                Group {
                    if isSelected {
                        gradient
                    } else {
                        Color.clear
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: ComponentTokens.radiusMedium - 2))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Arrow Button Style (for SphereShift)

struct ArrowButtonStyle: ButtonStyle {
    let isDisabled: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: TouchTarget.minimum, height: TouchTarget.minimum)
            .foregroundColor(isDisabled ? BrainGameColors.border : BrainGameColors.textSecondary)
            .scaleEffect(configuration.isPressed && !isDisabled ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Button Extension Helpers

extension Button {
    func primaryStyle(gradient: LinearGradient, height: CGFloat = TouchTarget.large) -> some View {
        self.buttonStyle(PrimaryButtonStyle(gradient: gradient, height: height))
    }

    func secondaryStyle(height: CGFloat = TouchTarget.large) -> some View {
        self.buttonStyle(SecondaryButtonStyle(height: height))
    }

    func circularStyle(size: CGFloat = TouchTarget.minimum, accentColor: Color = BrainGameColors.accentSpinMatrix) -> some View {
        self.buttonStyle(CircularButtonStyle(size: size, accentColor: accentColor))
    }

    func backButtonStyle() -> some View {
        self.buttonStyle(BackButtonStyle())
    }
}
