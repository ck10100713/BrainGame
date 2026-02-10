import SwiftUI

struct HexGameView: View {
    @EnvironmentObject var navigationStore: NavigationStore
    @StateObject private var viewModel = HexViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                // Victory Overlay
                if viewModel.isSolved {
                    HexVictoryBanner(moves: viewModel.moves, time: viewModel.elapsedTime)
                }

                // Game Board - Responsive background circle
                ZStack {
                    HexBackgroundCircle(size: 360)

                    HexBoardView(
                        grid: viewModel.grid,
                        isInteractive: viewModel.isPlaying && !viewModel.isSolved,
                        scale: 1.3,
                        onRotate: viewModel.handleRotate
                    )
                }

                Text("Click intersections (gaps) to rotate the surrounding 6 petals clockwise.")
                    .font(BrainGameTypography.caption)
                    .foregroundColor(BrainGameColors.textTertiary)
                    .multilineTextAlignment(.center)

                // Info Panel
                HexInfoPanel(viewModel: viewModel)
                    .maxPanelWidth()
            }
            .padding(Spacing.md)
        }
        .navigationTitle("HexLogic")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    navigationStore.navigateToMenu()
                } label: {
                    HStack(spacing: Spacing.xxs) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(BrainGameColors.textSecondary)
                }
            }
        }
    }
}

// MARK: - Victory Banner

struct HexVictoryBanner: View {
    let moves: Int
    let time: Int

    var body: some View {
        VStack(spacing: Spacing.xs) {
            Text("🎉")
                .font(.system(size: LayoutMetrics.victoryEmojiSize - 10))

            Text("SOLVED!")
                .font(BrainGameTypography.title1)
                .foregroundStyle(
                    LinearGradient(
                        colors: [BrainGameColors.accentHex, Color(hex: "8957E5")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: BrainGameColors.accentHex.opacity(0.5), radius: 10)

            HStack(spacing: Spacing.md) {
                Label("\(moves) Moves", systemImage: "sparkles")
                Label("\(time)s", systemImage: "sparkles")
            }
            .font(BrainGameTypography.headline)
            .foregroundColor(BrainGameColors.accentSpinMatrix)
        }
        .padding(Spacing.md)
    }
}

// MARK: - Hex Info Panel

struct HexInfoPanel: View {
    @ObservedObject var viewModel: HexViewModel

    var body: some View {
        VStack(spacing: Spacing.ml) {
            // Target Preview
            VStack(spacing: Spacing.xs) {
                Text("TARGET PATTERN")
                    .font(BrainGameTypography.captionBold)
                    .foregroundColor(BrainGameColors.accentHex)
                    .tracking(1.5)

                HexBoardView(
                    grid: viewModel.target,
                    isInteractive: false,
                    scale: 0.5,
                    showRotators: false,
                    onRotate: { _ in }
                )
                .opacity(0.9)
            }

            // Stats
            HStack(spacing: Spacing.md) {
                StatCard(icon: "clock", title: "TIME", value: viewModel.formattedTime)
                StatCard(icon: "arrow.up.and.down.and.arrow.left.and.right", title: "MOVES", value: "\(viewModel.moves)")
            }

            // Action Button
            if !viewModel.isPlaying && !viewModel.isSolved {
                ActionButton(
                    title: "START CHALLENGE",
                    icon: "play.fill",
                    gradient: [BrainGameColors.accentHex, Color(hex: "8957E5")]
                ) {
                    viewModel.startGame()
                }
            } else {
                ActionButton(
                    title: viewModel.isSolved ? "PLAY AGAIN" : "RESET",
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

#Preview {
    HexGameView()
        .environmentObject(NavigationStore())
}
