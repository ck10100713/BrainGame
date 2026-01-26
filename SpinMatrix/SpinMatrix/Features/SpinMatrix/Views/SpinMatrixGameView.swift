import SwiftUI

struct SpinMatrixGameView: View {
    @EnvironmentObject var navigationStore: NavigationStore
    @StateObject private var viewModel = SpinMatrixViewModel()

    var body: some View {
        VStack(spacing: 24) {
            // Header with Back Button
            GameHeader(
                title: "SpinMatrix",
                subtitle: "Spatial Logic Challenge",
                gradientColors: [.cyan, .purple]
            )

            // Main Content
            ScrollView {
                VStack(spacing: 24) {
                    // Game Board
                    ZStack {
                        SpinMatrixBoardView(
                            grid: viewModel.grid,
                            isInteractive: viewModel.isPlaying && !viewModel.isSolved,
                            onRotate: viewModel.handleRotate
                        )

                        // Victory Overlay
                        if viewModel.isSolved {
                            VictoryOverlay(moves: viewModel.moves, time: viewModel.elapsedTime)
                        }
                    }
                    .frame(maxWidth: 400)

                    Text("Tap the circular icons to rotate surrounding blocks clockwise.")
                        .font(.caption)
                        .foregroundColor(.gray)

                    // Info Panel
                    SpinMatrixInfoPanel(viewModel: viewModel)
                        .frame(maxWidth: 400)
                }
                .padding()
            }
        }
    }
}

struct GameHeader: View {
    @EnvironmentObject var navigationStore: NavigationStore
    let title: String
    let subtitle: String
    let gradientColors: [Color]

    var body: some View {
        HStack {
            // Back Button
            Button {
                navigationStore.navigateToMenu()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(hex: "1e293b").opacity(0.8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "475569"), lineWidth: 1)
                        )
                )
            }

            Spacer()

            // Title
            VStack(spacing: 4) {
                HStack(spacing: 8) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 24))
                        .foregroundStyle(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    Text(title)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }

                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            // Spacer to balance the back button
            Color.clear
                .frame(width: 70)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
}

struct VictoryOverlay: View {
    let moves: Int
    let time: Int

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            VStack(spacing: 12) {
                Text("🎉")
                    .font(.system(size: 60))

                Text("SOLVED!")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                HStack(spacing: 20) {
                    Label("\(moves) Moves", systemImage: "sparkles")
                    Label("\(time)s", systemImage: "sparkles")
                }
                .font(.headline)
                .foregroundColor(.cyan)
            }
        }
    }
}

#Preview {
    SpinMatrixGameView()
        .environmentObject(NavigationStore())
}
