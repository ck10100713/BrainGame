import SwiftUI

struct InfoPanelView: View {
    @ObservedObject var viewModel: GameViewModel

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

                GridBoardView(
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
                ForEach(Difficulty.allCases, id: \.rawValue) { diff in
                    DifficultyButton(
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

struct StatCard: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .tracking(1)
            }
            .foregroundColor(.gray)

            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "0f172a").opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "475569"), lineWidth: 1)
                )
        )
    }
}

struct DifficultyButton: View {
    let difficulty: Difficulty
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

struct ActionButton: View {
    let title: String
    let icon: String
    let gradient: [Color]
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.headline)
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: gradient,
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: gradient[0].opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    InfoPanelView(viewModel: GameViewModel())
        .padding()
        .background(Color(hex: "0f172a"))
}
