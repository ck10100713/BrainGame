import SwiftUI

struct HexGameView: View {
    @EnvironmentObject var navigationStore: NavigationStore
    @StateObject private var viewModel = HexViewModel()

    var body: some View {
        VStack(spacing: 24) {
            // Header
            GameHeader(
                title: "HexLogic",
                subtitle: "Hexagonal Rotation Puzzle",
                gradientColors: [.purple, .pink]
            )

            ScrollView {
                VStack(spacing: 24) {
                    // Victory Overlay
                    if viewModel.isSolved {
                        HexVictoryBanner(moves: viewModel.moves, time: viewModel.elapsedTime)
                    }

                    // Game Board
                    ZStack {
                        // Background circle
                        Circle()
                            .fill(Color(hex: "0f172a").opacity(0.4))
                            .frame(width: 340, height: 340)
                            .overlay(
                                Circle()
                                    .stroke(Color(hex: "475569").opacity(0.5), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.3), radius: 20)

                        HexBoardView(
                            grid: viewModel.grid,
                            isInteractive: viewModel.isPlaying && !viewModel.isSolved,
                            scale: 1.3,
                            onRotate: viewModel.handleRotate
                        )
                    }

                    Text("Click intersections (gaps) to rotate the surrounding 6 petals clockwise.")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)

                    // Info Panel
                    HexInfoPanel(viewModel: viewModel)
                        .frame(maxWidth: 400)
                }
                .padding()
            }
        }
    }
}

// MARK: - Victory Banner

struct HexVictoryBanner: View {
    let moves: Int
    let time: Int

    var body: some View {
        VStack(spacing: 8) {
            Text("🎉")
                .font(.system(size: 50))

            Text("SOLVED!")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.purple, .pink],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: .purple.opacity(0.5), radius: 10)

            HStack(spacing: 16) {
                Label("\(moves) Moves", systemImage: "sparkles")
                Label("\(time)s", systemImage: "sparkles")
            }
            .font(.headline)
            .foregroundColor(.cyan)
        }
        .padding()
    }
}

// MARK: - Hex Info Panel

struct HexInfoPanel: View {
    @ObservedObject var viewModel: HexViewModel

    var body: some View {
        VStack(spacing: 20) {
            // Target Preview
            VStack(spacing: 8) {
                Text("TARGET PATTERN")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
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
            HStack(spacing: 16) {
                StatCard(icon: "clock", title: "TIME", value: viewModel.formattedTime)
                StatCard(icon: "arrow.up.and.down.and.arrow.left.and.right", title: "MOVES", value: "\(viewModel.moves)")
            }

            // Action Button
            if !viewModel.isPlaying && !viewModel.isSolved {
                ActionButton(
                    title: "START CHALLENGE",
                    icon: "play.fill",
                    gradient: [.purple, .pink]
                ) {
                    viewModel.startGame()
                }
            } else {
                ActionButton(
                    title: viewModel.isSolved ? "PLAY AGAIN" : "RESET",
                    icon: "arrow.counterclockwise",
                    gradient: [Color(hex: "475569"), Color(hex: "334155")]
                ) {
                    viewModel.resetGame()
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "1e293b").opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(hex: "475569").opacity(0.5), lineWidth: 1)
                )
        )
    }
}

#Preview {
    HexGameView()
        .environmentObject(NavigationStore())
}
