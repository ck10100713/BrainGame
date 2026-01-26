import SwiftUI

struct SphereGameView: View {
    @EnvironmentObject var navigationStore: NavigationStore
    @StateObject private var viewModel = SphereViewModel()

    var body: some View {
        ZStack {
            // Main Content
            VStack(spacing: 24) {
                // Header
                GameHeader(
                    title: "SphereShift",
                    subtitle: "Color Alignment Challenge",
                    gradientColors: [.cyan, .teal]
                )

                ScrollView {
                    VStack(spacing: 24) {
                        // Victory Banner
                        if viewModel.isSolved {
                            SolvedBanner(time: viewModel.formattedTime)
                        }

                        // Game Board
                        SphereBoardView(
                            grid: viewModel.grid,
                            isInteractive: viewModel.isPlaying && !viewModel.isSolved && !viewModel.showFailModal,
                            isBlind: viewModel.renderBlind,
                            onShiftRow: viewModel.handleShiftRow,
                            onShiftCol: viewModel.handleShiftCol
                        )

                        Text("Use arrows to shift entire rows or columns.")
                            .font(.caption)
                            .foregroundColor(.gray)

                        // Info Panel
                        SphereInfoPanel(viewModel: viewModel)
                            .frame(maxWidth: 400)
                    }
                    .padding()
                }
            }

            // Fail Modal Overlay
            if viewModel.showFailModal {
                FailModalOverlay(
                    attempts: viewModel.attempts,
                    onContinue: viewModel.handleContinue,
                    onReset: { viewModel.initGame(difficulty: .blind, startPlaying: false) }
                )
            }
        }
    }
}

// MARK: - Solved Banner

struct SolvedBanner: View {
    let time: String

    var body: some View {
        VStack(spacing: 4) {
            Text("COMPLETE!")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.green, .cyan],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: .green.opacity(0.5), radius: 10)

            Text("Target reached in \(time)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

// MARK: - Sphere Info Panel

struct SphereInfoPanel: View {
    @ObservedObject var viewModel: SphereViewModel

    var body: some View {
        VStack(spacing: 16) {
            // Stats
            HStack(spacing: 16) {
                StatCard(icon: "clock", title: "TIME", value: viewModel.formattedTime)
                StatCard(icon: "arrow.up.and.down.and.arrow.left.and.right", title: "MOVES", value: "\(viewModel.moves)")
            }

            // Mode Selector
            HStack(spacing: 4) {
                ForEach(SphereDifficulty.allCases, id: \.rawValue) { diff in
                    SphereModeButton(
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

            // Blind Mode Attempts Indicator
            if viewModel.difficulty == .blind {
                HStack {
                    Text("Submissions Left")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .textCase(.uppercase)

                    Spacer()

                    HStack(spacing: 4) {
                        ForEach(0..<SphereConstants.maxAttempts, id: \.self) { i in
                            Circle()
                                .fill(i < viewModel.attempts ? Color.green : Color(hex: "475569"))
                                .frame(width: 12, height: 12)
                                .shadow(
                                    color: i < viewModel.attempts ? Color.green.opacity(0.5) : .clear,
                                    radius: 3
                                )
                        }
                    }
                }
                .padding(.horizontal, 8)
            }

            // Action Buttons
            if !viewModel.isPlaying && !viewModel.isSolved {
                ActionButton(
                    title: "START",
                    icon: "play.fill",
                    gradient: [.cyan, .blue]
                ) {
                    viewModel.startGame()
                }
            } else {
                VStack(spacing: 12) {
                    // Submit Button for Blind Mode
                    if viewModel.difficulty == .blind && !viewModel.isSolved {
                        ActionButton(
                            title: "SUBMIT PATTERN",
                            icon: "checkmark.circle",
                            gradient: [Color(hex: "f59e0b"), Color(hex: "ea580c")]
                        ) {
                            viewModel.handleSubmitBlind()
                        }
                    }

                    ActionButton(
                        title: viewModel.isSolved ? "PLAY AGAIN" : "RESET",
                        icon: "arrow.counterclockwise",
                        gradient: [Color(hex: "475569"), Color(hex: "334155")]
                    ) {
                        viewModel.resetGame()
                    }
                }
            }

            // Objective Text
            VStack(alignment: .leading, spacing: 4) {
                Text("Objective:")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)

                Text("Make every horizontal row consist of a single unique color.")
                    .font(.caption)
                    .foregroundColor(Color(hex: "94a3b8"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: "0f172a").opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "475569").opacity(0.5), lineWidth: 1)
                    )
            )
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

// MARK: - Sphere Mode Button

struct SphereModeButton: View {
    let difficulty: SphereDifficulty
    let isSelected: Bool
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: difficulty.icon)
                    .font(.caption)
                Text(difficulty.displayName)
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
            .foregroundColor(isSelected ? .white : .gray)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                Group {
                    if isSelected {
                        LinearGradient(
                            colors: difficulty.gradientColors,
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

// MARK: - Fail Modal Overlay

struct FailModalOverlay: View {
    let attempts: Int
    let onContinue: () -> Void
    let onReset: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture { }  // Block taps

            VStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.2))
                        .frame(width: 48, height: 48)

                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 24))
                        .foregroundColor(.red)
                }

                Text("Pattern Mismatch")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("The rows are not perfectly aligned by color.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                Text("Attempts remaining: \(attempts)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                if attempts > 0 {
                    Button(action: onContinue) {
                        Text("Continue (Hide Colors)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(hex: "475569"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                } else {
                    Button(action: onReset) {
                        Text("Game Over - Try Again")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "0f172a"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.red.opacity(0.5), lineWidth: 1)
                    )
            )
            .padding(32)
        }
    }
}

#Preview {
    SphereGameView()
        .environmentObject(NavigationStore())
}
