import SwiftUI

struct SpinMatrixBoardView: View {
    let grid: SpinMatrixGridState
    let isInteractive: Bool
    let showRotators: Bool
    let onRotate: (Int, Int) -> Void

    init(
        grid: SpinMatrixGridState,
        isInteractive: Bool,
        showRotators: Bool = true,
        onRotate: @escaping (Int, Int) -> Void
    ) {
        self.grid = grid
        self.isInteractive = isInteractive
        self.showRotators = showRotators
        self.onRotate = onRotate
    }

    var body: some View {
        GeometryReader { geometry in
            let size = grid.count
            let cellSize = geometry.size.width / CGFloat(size)

            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(hex: "1e293b").opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: "475569"), lineWidth: 1)
                    )

                // Grid Container
                VStack(spacing: 4) {
                    ForEach(0..<size, id: \.self) { row in
                        HStack(spacing: 4) {
                            ForEach(0..<size, id: \.self) { col in
                                BlockCell(color: grid[row][col])
                                    .frame(
                                        width: (geometry.size.width - CGFloat(size + 1) * 4 - 16) / CGFloat(size),
                                        height: (geometry.size.width - CGFloat(size + 1) * 4 - 16) / CGFloat(size)
                                    )
                            }
                        }
                    }
                }
                .padding(8)

                // Rotator Buttons
                if showRotators && isInteractive {
                    ForEach(0..<(size - 1), id: \.self) { row in
                        ForEach(0..<(size - 1), id: \.self) { col in
                            RotatorButton {
                                onRotate(row, col)
                            }
                            .position(
                                x: CGFloat(col + 1) * cellSize,
                                y: CGFloat(row + 1) * cellSize
                            )
                        }
                    }
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct BlockCell: View {
    let color: BlockColor

    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(color.color)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.2), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
    }
}

struct RotatorButton: View {
    let action: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color(hex: "0f172a").opacity(0.8))
                    .frame(width: 36, height: 36)

                Circle()
                    .stroke(Color.cyan.opacity(0.5), lineWidth: 1)
                    .frame(width: 36, height: 36)

                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.cyan)
            }
            .shadow(color: .cyan.opacity(0.3), radius: 5)
            .scaleEffect(isPressed ? 0.9 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    SpinMatrixBoardView(
        grid: SpinMatrixLogic.createTargetGrid(size: 4),
        isInteractive: true,
        onRotate: { _, _ in }
    )
    .frame(width: 300, height: 300)
    .padding()
    .background(Color(hex: "0f172a"))
}
