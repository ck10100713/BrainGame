import SwiftUI

struct FlipTileBoardView: View {
    let grid: FlipGridState
    let isInteractive: Bool
    let onTileClick: (Int, Int) -> Void

    init(
        grid: FlipGridState,
        isInteractive: Bool,
        onTileClick: @escaping (Int, Int) -> Void = { _, _ in }
    ) {
        self.grid = grid
        self.isInteractive = isInteractive
        self.onTileClick = onTileClick
    }

    var body: some View {
        GeometryReader { geometry in
            let size = FlipConstants.gridSize
            let spacing: CGFloat = Spacing.xxs
            let totalSpacing = spacing * CGFloat(size - 1)
            let padding: CGFloat = Spacing.xs
            let availableWidth = geometry.size.width - (padding * 2)
            let cellSize = (availableWidth - totalSpacing) / CGFloat(size)

            ZStack {
                // Background
                RoundedRectangle(cornerRadius: ComponentTokens.radiusXL)
                    .fill(BrainGameColors.backgroundSecondary.opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: ComponentTokens.radiusXL)
                            .stroke(BrainGameColors.border, lineWidth: ComponentTokens.borderThin)
                    )

                // Grid
                VStack(spacing: spacing) {
                    ForEach(0..<size, id: \.self) { row in
                        HStack(spacing: spacing) {
                            ForEach(0..<size, id: \.self) { col in
                                TileCell(
                                    state: grid[row][col],
                                    isInteractive: isInteractive
                                ) {
                                    onTileClick(row, col)
                                }
                                .frame(width: cellSize, height: cellSize)
                            }
                        }
                    }
                }
                .padding(padding)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Tile Cell

struct TileCell: View {
    let state: FlipState
    let isInteractive: Bool
    let onTap: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: {
            if isInteractive {
                onTap()
            }
        }) {
            RoundedRectangle(cornerRadius: ComponentTokens.radiusSmall)
                .fill(state.color)
                .overlay(
                    RoundedRectangle(cornerRadius: ComponentTokens.radiusSmall)
                        .fill(
                            LinearGradient(
                                colors: state == .light
                                    ? [.white.opacity(0.3), .clear]
                                    : [.white.opacity(0.05), .clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: ComponentTokens.radiusSmall)
                        .stroke(
                            state == .light
                                ? BrainGameColors.border
                                : BrainGameColors.border.opacity(0.5),
                            lineWidth: ComponentTokens.borderThin
                        )
                )
                .shadow(
                    color: state == .light ? .black.opacity(0.15) : .black.opacity(0.4),
                    radius: 2,
                    x: 0,
                    y: 2
                )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.92 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .disabled(!isInteractive)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if isInteractive && !isPressed {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
}

#Preview {
    FlipTileBoardView(
        grid: FlipTileLogic.createEmptyGrid(),
        isInteractive: true
    ) { row, col in
        print("Tapped: \(row), \(col)")
    }
    .frame(width: 300, height: 300)
    .padding()
    .background(BrainGameColors.backgroundPrimary)
}
