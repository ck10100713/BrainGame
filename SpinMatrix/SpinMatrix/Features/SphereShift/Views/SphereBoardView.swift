import SwiftUI

struct SphereBoardView: View {
    let grid: SphereGridState
    let isInteractive: Bool
    let isBlind: Bool
    let onShiftRow: (Int, Int) -> Void  // (rowIndex, direction)
    let onShiftCol: (Int, Int) -> Void  // (colIndex, direction)

    private let size = SphereConstants.gridSize
    private let sphereSize: CGFloat = 48
    private let spacing: CGFloat = 8

    var body: some View {
        VStack(spacing: 8) {
            // Top Column Controls (Up arrows)
            HStack(spacing: spacing) {
                Spacer().frame(width: 32)
                ForEach(0..<size, id: \.self) { i in
                    ArrowButton(direction: .up, isDisabled: !isInteractive) {
                        onShiftCol(i, -1)
                    }
                    .frame(width: sphereSize, height: 32)
                }
                Spacer().frame(width: 32)
            }

            HStack(spacing: spacing) {
                // Left Row Controls (Left arrows)
                VStack(spacing: spacing) {
                    ForEach(0..<size, id: \.self) { i in
                        ArrowButton(direction: .left, isDisabled: !isInteractive) {
                            onShiftRow(i, -1)
                        }
                        .frame(width: 32, height: sphereSize)
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
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(hex: "0f172a").opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(hex: "475569"), lineWidth: 1)
                        )
                )

                // Right Row Controls (Right arrows)
                VStack(spacing: spacing) {
                    ForEach(0..<size, id: \.self) { i in
                        ArrowButton(direction: .right, isDisabled: !isInteractive) {
                            onShiftRow(i, 1)
                        }
                        .frame(width: 32, height: sphereSize)
                    }
                }
            }

            // Bottom Column Controls (Down arrows)
            HStack(spacing: spacing) {
                Spacer().frame(width: 32)
                ForEach(0..<size, id: \.self) { i in
                    ArrowButton(direction: .down, isDisabled: !isInteractive) {
                        onShiftCol(i, 1)
                    }
                    .frame(width: sphereSize, height: 32)
                }
                Spacer().frame(width: 32)
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
                color: isBlind ? Color(hex: "94a3b8").opacity(0.2) : color.glowColor,
                radius: 8
            )
            .overlay(
                Circle()
                    .stroke(
                        isBlind ? Color(hex: "475569") : Color.clear,
                        lineWidth: isBlind ? 1 : 0
                    )
            )
            .animation(.easeInOut(duration: 0.3), value: isBlind)
    }

    private var blindGradient: [Color] {
        [Color(hex: "94a3b8"), Color(hex: "475569"), Color(hex: "1e293b")]
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
                .foregroundColor(isDisabled ? Color(hex: "475569") : Color(hex: "94a3b8"))
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
    .background(Color(hex: "0f172a"))
}
