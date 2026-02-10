import SwiftUI

struct FlipTileInfoPanel: View {
    @ObservedObject var viewModel: FlipTileViewModel

    var body: some View {
        VStack(spacing: Spacing.ml) {
            // Stats
            HStack(spacing: Spacing.md) {
                StatCard(icon: "clock", title: "TIME", value: viewModel.formattedTime)
                StatCard(icon: "hand.tap", title: "MOVES", value: "\(viewModel.moves)")
            }

            // Target Preview
            VStack(spacing: Spacing.xs) {
                HStack {
                    Text("TARGET PATTERN")
                        .font(BrainGameTypography.captionBold)
                        .foregroundColor(BrainGameColors.accentFlipTile)
                        .tracking(1.5)

                    Spacer()

                    Image(systemName: "trophy.fill")
                        .font(.system(size: LayoutMetrics.iconSmall))
                        .foregroundColor(BrainGameColors.accentFlipTile)
                }

                FlipTileBoardView(
                    grid: viewModel.targetGrid,
                    isInteractive: false
                )
                .frame(width: LayoutMetrics.targetPreviewStandard, height: LayoutMetrics.targetPreviewStandard)
                .opacity(0.9)
            }

            GameDivider()

            // Difficulty Selector
            HStack(spacing: Spacing.xs) {
                ForEach(FlipDifficulty.allCases, id: \.rawValue) { diff in
                    FlipDifficultyButton(
                        difficulty: diff,
                        isSelected: viewModel.difficulty == diff,
                        isDisabled: viewModel.isPlaying
                    ) {
                        viewModel.handleDifficultyChange(diff)
                    }
                }
            }
            .padding(Spacing.xxs)
            .background(BrainGameColors.backgroundPrimary)
            .clipShape(RoundedRectangle(cornerRadius: ComponentTokens.radiusMedium))

            // Action Button
            if !viewModel.isPlaying && !viewModel.isSolved {
                ActionButton(
                    title: "START CHALLENGE",
                    icon: "play.fill",
                    gradient: [BrainGameColors.accentSphere, Color(hex: "2EA043")]
                ) {
                    viewModel.startGame()
                }
            } else {
                ActionButton(
                    title: viewModel.isSolved ? "PLAY AGAIN" : "RESET / GIVE UP",
                    icon: "arrow.counterclockwise",
                    gradient: [BrainGameColors.backgroundTertiary, BrainGameColors.backgroundSecondary]
                ) {
                    viewModel.resetGame()
                }
            }
        }
        .padding(Spacing.ml)
        .panelBackground()
    }
}

// MARK: - Difficulty Button

struct FlipDifficultyButton: View {
    let difficulty: FlipDifficulty
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(difficulty.displayName)
                .font(BrainGameTypography.subheadline.weight(.bold))
                .foregroundColor(isSelected ? BrainGameColors.textPrimary : BrainGameColors.textTertiary)
                .frame(maxWidth: .infinity)
                .frame(minHeight: TouchTarget.minimum)
                .background(
                    Group {
                        if isSelected {
                            LinearGradient(
                                colors: BrainGameColors.gradientColors(for: .flipTile),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        } else {
                            Color.clear
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: ComponentTokens.radiusMedium - 2))
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1)
    }
}

#Preview {
    FlipTileInfoPanel(viewModel: FlipTileViewModel())
        .padding()
        .background(BrainGameColors.backgroundPrimary)
}
