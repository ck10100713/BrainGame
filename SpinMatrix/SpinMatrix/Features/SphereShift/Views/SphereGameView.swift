import SwiftUI

struct SphereGameView: View {
    @EnvironmentObject var navigationStore: NavigationStore
    @StateObject private var viewModel = SphereViewModel()

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: Spacing.lg) {
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
                        .font(BrainGameTypography.caption)
                        .foregroundColor(BrainGameColors.textTertiary)

                    // Info Panel
                    SphereInfoPanel(viewModel: viewModel)
                        .maxPanelWidth()
                }
                .padding(Spacing.md)
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
        .navigationTitle("SphereShift")
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

// MARK: - Solved Banner

struct SolvedBanner: View {
    let time: String

    var body: some View {
        VStack(spacing: Spacing.xxs) {
            Text("COMPLETE!")
                .font(BrainGameTypography.gameTitle)
                .foregroundStyle(
                    LinearGradient(
                        colors: [BrainGameColors.accentSphere, BrainGameColors.accentSpinMatrix],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: BrainGameColors.accentSphere.opacity(0.5), radius: 10)

            Text("Target reached in \(time)")
                .font(BrainGameTypography.caption)
                .foregroundColor(BrainGameColors.textTertiary)
        }
        .padding(Spacing.md)
    }
}

// MARK: - Sphere Info Panel

struct SphereInfoPanel: View {
    @ObservedObject var viewModel: SphereViewModel

    var body: some View {
        VStack(spacing: Spacing.md) {
            // Stats
            HStack(spacing: Spacing.md) {
                StatCard(icon: "clock", title: "TIME", value: viewModel.formattedTime)
                StatCard(icon: "arrow.up.and.down.and.arrow.left.and.right", title: "MOVES", value: "\(viewModel.moves)")
            }

            // Mode Selector
            HStack(spacing: Spacing.xxs) {
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
            .padding(Spacing.xxs)
            .background(BrainGameColors.backgroundPrimary)
            .clipShape(RoundedRectangle(cornerRadius: ComponentTokens.radiusMedium))

            // Blind Mode Attempts Indicator
            if viewModel.difficulty == .blind {
                HStack {
                    Text("Submissions Left")
                        .font(BrainGameTypography.captionBold)
                        .foregroundColor(BrainGameColors.textTertiary)
                        .textCase(.uppercase)

                    Spacer()

                    HStack(spacing: Spacing.xxs) {
                        ForEach(0..<SphereConstants.maxAttempts, id: \.self) { i in
                            Circle()
                                .fill(i < viewModel.attempts ? BrainGameColors.accentSphere : BrainGameColors.border)
                                .frame(width: Spacing.sm, height: Spacing.sm)
                                .shadow(
                                    color: i < viewModel.attempts ? BrainGameColors.accentSphere.opacity(0.5) : .clear,
                                    radius: 3
                                )
                        }
                    }
                }
                .padding(.horizontal, Spacing.xs)
            }

            // Action Buttons
            if !viewModel.isPlaying && !viewModel.isSolved && !viewModel.isMemorizing {
                ActionButton(
                    title: "START",
                    icon: "play.fill",
                    gradient: [BrainGameColors.accentSpinMatrix, Color(hex: "388BFD")]
                ) {
                    viewModel.startGame()
                }
            } else if viewModel.isMemorizing {
                // Memorization phase for Blind mode
                VStack(spacing: Spacing.sm) {
                    // Memorization info box
                    VStack(spacing: Spacing.xs) {
                        HStack(spacing: Spacing.xxs) {
                            Image(systemName: "eye")
                                .font(.system(size: LayoutMetrics.iconMedium))
                            Text("MEMORIZATION PHASE")
                                .font(BrainGameTypography.captionBold)
                                .textCase(.uppercase)
                        }
                        .foregroundColor(BrainGameColors.accentBlind)

                        Text("Study the pattern carefully. When ready, tap below to hide the colors and begin solving.")
                            .font(BrainGameTypography.caption)
                            .foregroundColor(BrainGameColors.textTertiary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(Spacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: ComponentTokens.radiusMedium)
                            .fill(BrainGameColors.accentBlind.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: ComponentTokens.radiusMedium)
                                    .stroke(BrainGameColors.accentBlind.opacity(0.5), lineWidth: ComponentTokens.borderThin)
                            )
                    )

                    // I'm Ready button
                    ActionButton(
                        title: "I'M READY - HIDE COLORS",
                        icon: "eye.slash",
                        gradient: [BrainGameColors.accentBlind, Color(hex: "6366F1")]
                    ) {
                        viewModel.startBlindPhase()
                    }

                    // Cancel button
                    Button {
                        viewModel.resetGame()
                    } label: {
                        HStack(spacing: Spacing.xxs) {
                            Image(systemName: "arrow.counterclockwise")
                            Text("CANCEL")
                        }
                        .font(BrainGameTypography.subheadline.weight(.bold))
                        .foregroundColor(BrainGameColors.textTertiary)
                        .frame(maxWidth: .infinity)
                        .frame(height: TouchTarget.minimum)
                        .background(BrainGameColors.backgroundTertiary.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: ComponentTokens.radiusMedium))
                    }
                }
            } else {
                VStack(spacing: Spacing.sm) {
                    // Submit Button for Blind Mode
                    if viewModel.difficulty == .blind && !viewModel.isSolved {
                        ActionButton(
                            title: "SUBMIT PATTERN",
                            icon: "checkmark.circle",
                            gradient: [BrainGameColors.warning, Color(hex: "EA580C")]
                        ) {
                            viewModel.handleSubmitBlind()
                        }
                    }

                    ActionButton(
                        title: viewModel.isSolved ? "PLAY AGAIN" : "RESET",
                        icon: "arrow.counterclockwise",
                        gradient: [BrainGameColors.backgroundTertiary, BrainGameColors.backgroundSecondary]
                    ) {
                        viewModel.resetGame()
                    }
                }
            }

            // Objective Text
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("Objective:")
                    .font(BrainGameTypography.captionBold)
                    .foregroundColor(BrainGameColors.textTertiary)

                Text("Make every horizontal row consist of a single unique color.")
                    .font(BrainGameTypography.caption)
                    .foregroundColor(BrainGameColors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: ComponentTokens.radiusMedium)
                    .fill(BrainGameColors.backgroundPrimary.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: ComponentTokens.radiusMedium)
                            .stroke(BrainGameColors.border.opacity(0.5), lineWidth: ComponentTokens.borderThin)
                    )
            )
        }
        .padding(Spacing.ml)
        .panelBackground()
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
            HStack(spacing: Spacing.xxs) {
                Image(systemName: difficulty.icon)
                    .font(.system(size: LayoutMetrics.iconSmall))
                Text(difficulty.displayName)
                    .font(BrainGameTypography.subheadline.weight(.bold))
            }
            .foregroundColor(isSelected ? BrainGameColors.textPrimary : BrainGameColors.textTertiary)
            .frame(maxWidth: .infinity)
            .frame(minHeight: TouchTarget.minimum)
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
            .clipShape(RoundedRectangle(cornerRadius: ComponentTokens.radiusMedium - 2))
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

            VStack(spacing: Spacing.md) {
                // Icon
                ZStack {
                    Circle()
                        .fill(BrainGameColors.error.opacity(0.2))
                        .frame(width: LayoutMetrics.modalIconSize, height: LayoutMetrics.modalIconSize)

                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: LayoutMetrics.headerIcon))
                        .foregroundColor(BrainGameColors.error)
                }

                Text("Pattern Mismatch")
                    .font(BrainGameTypography.title2)
                    .foregroundColor(BrainGameColors.textPrimary)

                Text("The rows are not perfectly aligned by color.")
                    .font(BrainGameTypography.subheadline)
                    .foregroundColor(BrainGameColors.textTertiary)
                    .multilineTextAlignment(.center)

                Text("Attempts remaining: \(attempts)")
                    .font(BrainGameTypography.subheadline.weight(.bold))
                    .foregroundColor(BrainGameColors.textPrimary)

                if attempts > 0 {
                    Button(action: onContinue) {
                        Text("Continue (Hide Colors)")
                            .font(BrainGameTypography.button)
                            .foregroundColor(BrainGameColors.textPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: TouchTarget.large)
                            .background(BrainGameColors.backgroundTertiary)
                            .clipShape(RoundedRectangle(cornerRadius: ComponentTokens.radiusMedium))
                    }
                } else {
                    Button(action: onReset) {
                        Text("Game Over - Try Again")
                            .font(BrainGameTypography.button)
                            .foregroundColor(BrainGameColors.textPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: TouchTarget.large)
                            .background(BrainGameColors.error)
                            .clipShape(RoundedRectangle(cornerRadius: ComponentTokens.radiusMedium))
                    }
                }
            }
            .padding(Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: ComponentTokens.radius2XL)
                    .fill(BrainGameColors.backgroundPrimary)
                    .overlay(
                        RoundedRectangle(cornerRadius: ComponentTokens.radius2XL)
                            .stroke(BrainGameColors.error.opacity(0.5), lineWidth: ComponentTokens.borderThin)
                    )
            )
            .padding(Spacing.xl)
        }
    }
}

#Preview {
    SphereGameView()
        .environmentObject(NavigationStore())
}
