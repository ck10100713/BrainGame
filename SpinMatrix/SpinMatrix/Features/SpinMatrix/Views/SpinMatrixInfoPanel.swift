import SwiftUI

struct SpinMatrixInfoPanel: View {
    @ObservedObject var viewModel: SpinMatrixViewModel

    var body: some View {
        VStack(spacing: 20) {
            // Stats
            HStack(spacing: 16) {
                StatCard(icon: "clock", title: "TIME", value: viewModel.formattedTime)
                StatCard(icon: "arrow.up.and.down.and.arrow.left.and.right", title: "MOVES", value: "\(viewModel.moves)")
            }

            // Target Preview
            VStack(spacing: 8) {
                HStack {
                    Text("TARGET PATTERN")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.cyan)
                        .tracking(1.5)

                    Spacer()

                    Image(systemName: "trophy.fill")
                        .font(.caption)
                        .foregroundColor(.cyan)
                }

                SpinMatrixBoardView(
                    grid: viewModel.target,
                    isInteractive: false,
                    showRotators: false,
                    onRotate: { _, _ in }
                )
                .frame(width: 120, height: 120)
                .opacity(0.9)
            }

            Divider()
                .background(Color(hex: "475569").opacity(0.5))

            // Difficulty Selector
            HStack(spacing: 8) {
                ForEach(SpinMatrixDifficulty.allCases, id: \.rawValue) { diff in
                    SpinMatrixDifficultyButton(
                        difficulty: diff,
                        isSelected: viewModel.difficulty == diff,
                        isDisabled: viewModel.isPlaying
                    ) {
                        viewModel.handleDifficultyChange(diff)
                    }
                }
            }
            .padding(4)
            .background(Color(hex: "0f172a"))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            // Action Button
            if !viewModel.isPlaying && !viewModel.isSolved {
                ActionButton(
                    title: "START CHALLENGE",
                    icon: "play.fill",
                    gradient: [Color.green, Color(hex: "059669")]
                ) {
                    viewModel.startGame()
                }
            } else {
                ActionButton(
                    title: viewModel.isSolved ? "PLAY AGAIN" : "RESET / GIVE UP",
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

struct SpinMatrixDifficultyButton: View {
    let difficulty: SpinMatrixDifficulty
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(difficulty.displayName)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(isSelected ? .white : .gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    Group {
                        if isSelected {
                            LinearGradient(
                                colors: difficulty == .easy
                                    ? [.cyan, .blue]
                                    : [.purple, .pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        } else {
                            Color.clear
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1)
    }
}

#Preview {
    SpinMatrixInfoPanel(viewModel: SpinMatrixViewModel())
        .padding()
        .background(Color(hex: "0f172a"))
}
