import SwiftUI

struct SphereBoardView: View {
    let grid: SphereGridState
    let isInteractive: Bool
    let isBlind: Bool
    let onShiftRow: (Int, Int) -> Void  // (rowIndex, direction)
    let onShiftCol: (Int, Int) -> Void  // (colIndex, direction)

    private let size = SphereConstants.gridSize
    private let sphereSize: CGFloat = LayoutMetrics.sphereCellSize
    private let spacing: CGFloat = Spacing.xs

    var body: some View {
        VStack(spacing: Spacing.xs) {
            // Top Column Controls (Up arrows) - 44pt touch targets
            HStack(spacing: spacing) {
                Spacer().frame(width: LayoutMetrics.arrowButtonSize)
                ForEach(0..<size, id: \.self) { i in
                    ArrowButton(direction: .up, isDisabled: !isInteractive) {
                        onShiftCol(i, -1)
                    }
                    .frame(width: sphereSize, height: LayoutMetrics.arrowButtonSize)
                }
                Spacer().frame(width: LayoutMetrics.arrowButtonSize)
            }

            HStack(spacing: spacing) {
                // Left Row Controls (Left arrows)
                VStack(spacing: spacing) {
                    ForEach(0..<size, id: \.self) { i in
                        ArrowButton(direction: .left, isDisabled: !isInteractive) {
                            onShiftRow(i, -1)
                        }
                        .frame(width: LayoutMetrics.arrowButtonSize, height: sphereSize)
                    }
                }

                // The Grid
                VStack(spacing: spacing) {
                    ForEach(0..<size, id: \.self) { row in
                        HStack(spacing: spacing) {
                            ForEach(0..<size, id: \.self) { col in
                                SphereCell(
                                    color: grid[row][col],
                                    isBlind: isBlind
                                )
                                .frame(width: sphereSize, height: sphereSize)
                            }
                        }
                    }
                }
                .padding(Spacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: ComponentTokens.radiusXL)
                        .fill(BrainGameColors.backgroundPrimary.opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: ComponentTokens.radiusXL)
                                .stroke(BrainGameColors.border, lineWidth: ComponentTokens.borderThin)
                        )
                )

                // Right Row Controls (Right arrows)
                VStack(spacing: spacing) {
                    ForEach(0..<size, id: \.self) { i in
                        ArrowButton(direction: .right, isDisabled: !isInteractive) {
                            onShiftRow(i, 1)
                        }
                        .frame(width: LayoutMetrics.arrowButtonSize, height: sphereSize)
                    }
                }
            }

            // Bottom Column Controls (Down arrows)
            HStack(spacing: spacing) {
                Spacer().frame(width: LayoutMetrics.arrowButtonSize)
                ForEach(0..<size, id: \.self) { i in
                    ArrowButton(direction: .down, isDisabled: !isInteractive) {
                        onShiftCol(i, 1)
                    }
                    .frame(width: sphereSize, height: LayoutMetrics.arrowButtonSize)
                }
                Spacer().frame(width: LayoutMetrics.arrowButtonSize)
            }
        }
    }
}

// MARK: - Sphere Cell

struct SphereCell: View {
    let color: SphereColor
    let isBlind: Bool

    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: isBlind ? blindGradient : color.gradientColors,
                    center: .init(x: 0.3, y: 0.3),
                    startRadius: 0,
                    endRadius: 30
                )
            )
            .shadow(
                color: isBlind ? BrainGameColors.textSecondary.opacity(0.2) : color.glowColor,
                radius: 8
            )
            .overlay(
                Circle()
                    .stroke(
                        isBlind ? BrainGameColors.border : Color.clear,
                        lineWidth: isBlind ? ComponentTokens.borderThin : 0
                    )
            )
            .animation(.easeInOut(duration: 0.3), value: isBlind)
    }

    private var blindGradient: [Color] {
        [BrainGameColors.textSecondary, BrainGameColors.border, BrainGameColors.backgroundSecondary]
    }
}

// MARK: - Arrow Button

enum ArrowDirection {
    case up, down, left, right

    var systemImage: String {
        switch self {
        case .up: return "chevron.up"
        case .down: return "chevron.down"
        case .left: return "chevron.left"
        case .right: return "chevron.right"
        }
    }
}

struct ArrowButton: View {
    let direction: ArrowDirection
    let isDisabled: Bool
    let action: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            Image(systemName: direction.systemImage)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(isDisabled ? BrainGameColors.border : BrainGameColors.textSecondary)
                .frame(width: LayoutMetrics.arrowButtonSize, height: LayoutMetrics.arrowButtonSize)
                .scaleEffect(isPressed ? 0.8 : 1.0)
        }
        .disabled(isDisabled)
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    SphereBoardView(
        grid: SphereLogic.createSolvedGrid(),
        isInteractive: true,
        isBlind: false,
        onShiftRow: { _, _ in },
        onShiftCol: { _, _ in }
    )
    .padding()
    .background(BrainGameColors.backgroundPrimary)
}
