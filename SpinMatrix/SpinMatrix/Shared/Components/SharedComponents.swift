import SwiftUI

// MARK: - StatCard

struct StatCard: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: Spacing.xs) {
            HStack(spacing: Spacing.xxs) {
                Image(systemName: icon)
                    .font(.system(size: LayoutMetrics.iconSmall))
                Text(title)
                    .font(BrainGameTypography.captionBold)
                    .tracking(1)
            }
            .foregroundColor(BrainGameColors.textTertiary)

            Text(value)
                .font(BrainGameTypography.statValue)
                .foregroundColor(BrainGameColors.textPrimary)
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: ComponentTokens.radiusLarge)
                .fill(BrainGameColors.backgroundPrimary.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: ComponentTokens.radiusLarge)
                        .stroke(BrainGameColors.border, lineWidth: ComponentTokens.borderThin)
                )
        )
    }
}

// MARK: - ActionButton

struct ActionButton: View {
    let title: String
    let icon: String
    let gradient: [Color]
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xs) {
                Image(systemName: icon)
                    .font(BrainGameTypography.headline)
                Text(title)
                    .font(BrainGameTypography.button)
            }
            .foregroundColor(BrainGameColors.textPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: TouchTarget.large)
            .background(
                LinearGradient(
                    colors: gradient,
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: ComponentTokens.radiusLarge))
            .gameAccentShadow(gradient[0])
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - ScaleButtonStyle

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Previews

#Preview("StatCard") {
    HStack(spacing: Spacing.md) {
        StatCard(icon: "clock", title: "TIME", value: "02:30")
        StatCard(icon: "arrow.up.and.down.and.arrow.left.and.right", title: "MOVES", value: "15")
    }
    .padding()
    .background(BrainGameColors.backgroundPrimary)
}

#Preview("ActionButton") {
    VStack(spacing: Spacing.md) {
        ActionButton(
            title: "START CHALLENGE",
            icon: "play.fill",
            gradient: [BrainGameColors.accentSphere, Color(hex: "2EA043")]
        ) {}

        ActionButton(
            title: "RESET",
            icon: "arrow.counterclockwise",
            gradient: [BrainGameColors.backgroundTertiary, BrainGameColors.backgroundSecondary]
        ) {}
    }
    .padding()
    .background(BrainGameColors.backgroundPrimary)
}
