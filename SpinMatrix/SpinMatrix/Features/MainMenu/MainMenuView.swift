import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var navigationStore: NavigationStore

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.xl) {
                // Hero Header
                VStack(spacing: Spacing.xs) {
                    HStack(spacing: Spacing.sm) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: LayoutMetrics.iconHero))
                            .foregroundStyle(BrainGameColors.heroGradient)

                        Text("BRAIN GAME")
                            .font(BrainGameTypography.title1)
                            .foregroundStyle(BrainGameColors.heroGradient)
                    }

                    Text("Spatial Logic Challenges")
                        .font(BrainGameTypography.subheadline)
                        .foregroundColor(BrainGameColors.textTertiary)
                }
                .padding(.top, Spacing.xxl)

                // Game Cards
                LazyVGrid(columns: [GridItem(.flexible())], spacing: Spacing.md) {
                    ForEach(GameId.allCases) { gameId in
                        GameCard(gameId: gameId) {
                            navigationStore.navigateToGame(gameId)
                        }
                    }
                }
                .padding(.horizontal, Spacing.ml)

                // Footer
                Text("Select a puzzle to begin")
                    .font(BrainGameTypography.caption)
                    .foregroundColor(BrainGameColors.textTertiary)
                    .padding(.bottom, Spacing.xxl)
            }
        }
    }
}

struct GameCard: View {
    let gameId: GameId
    let action: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.md) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: ComponentTokens.radiusLarge)
                        .fill(
                            LinearGradient(
                                colors: BrainGameColors.gradientColors(for: gameId).map { $0.opacity(0.3) },
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: LayoutMetrics.gameCardIconSize, height: LayoutMetrics.gameCardIconSize)

                    Image(systemName: gameId.icon)
                        .font(.system(size: LayoutMetrics.gameCardIconSymbol))
                        .foregroundStyle(
                            LinearGradient(
                                colors: BrainGameColors.gradientColors(for: gameId),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }

                // Text
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(gameId.displayName)
                        .font(BrainGameTypography.title2)
                        .foregroundColor(BrainGameColors.textPrimary)

                    Text(gameId.subtitle)
                        .font(BrainGameTypography.caption)
                        .foregroundColor(BrainGameColors.textTertiary)
                        .lineLimit(2)
                }

                Spacer()

                // Arrow
                Image(systemName: "chevron.right")
                    .font(BrainGameTypography.headline)
                    .foregroundColor(BrainGameColors.textTertiary)
            }
            .padding(Spacing.md)
            .frame(minHeight: LayoutMetrics.gameCardMinHeight)
            .background(
                RoundedRectangle(cornerRadius: ComponentTokens.radiusXL)
                    .fill(BrainGameColors.backgroundSecondary.opacity(0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: ComponentTokens.radiusXL)
                            .stroke(
                                LinearGradient(
                                    colors: BrainGameColors.gradientColors(for: gameId).map { $0.opacity(0.3) },
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: ComponentTokens.borderThin
                            )
                    )
            )
            .gameAccentShadow(BrainGameColors.accentColor(for: gameId), radius: 8)
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    MainMenuView()
        .environmentObject(NavigationStore())
}
