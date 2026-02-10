import SwiftUI

struct FlipTileGameView: View {
    @EnvironmentObject var navigationStore: NavigationStore
    @StateObject private var viewModel = FlipTileViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.lg) {
                // Game Board
                ZStack {
                    FlipTileBoardView(
                        grid: viewModel.playerGrid,
                        isInteractive: viewModel.isPlaying && !viewModel.isSolved,
                        onTileClick: viewModel.handleTileClick
                    )

                    // Victory Overlay
                    if viewModel.isSolved {
                        FlipTileVictoryOverlay(moves: viewModel.moves, time: viewModel.elapsedTime)
                    }
                }
                .maxBoardWidth()

                Text("Tap tiles to flip them and their neighbors. Match the target pattern!")
                    .font(BrainGameTypography.caption)
                    .foregroundColor(BrainGameColors.textTertiary)
                    .multilineTextAlignment(.center)

                // Info Panel
                FlipTileInfoPanel(viewModel: viewModel)
                    .maxPanelWidth()
            }
            .padding(Spacing.md)
        }
        .navigationTitle("FlipTile")
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

// MARK: - Victory Overlay

struct FlipTileVictoryOverlay: View {
    let moves: Int
    let time: Int

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .clipShape(RoundedRectangle(cornerRadius: ComponentTokens.radiusXL))

            VStack(spacing: Spacing.sm) {
                Text("🎉")
                    .font(.system(size: LayoutMetrics.victoryEmojiSize))

                Text("SOLVED!")
                    .font(BrainGameTypography.title1)
                    .foregroundColor(BrainGameColors.textPrimary)

                HStack(spacing: Spacing.ml) {
                    Label("\(moves) Moves", systemImage: "sparkles")
                    Label("\(time)s", systemImage: "sparkles")
                }
                .font(BrainGameTypography.headline)
                .foregroundColor(BrainGameColors.accentFlipTile)
            }
        }
    }
}

#Preview {
    FlipTileGameView()
        .environmentObject(NavigationStore())
}
