import Foundation

struct HexLogic {
    private static var geometry: HexGeometry { HexGeometry.shared }

    // MARK: - Grid Creation

    /// Creates target grid with 6 color sectors
    static func createTargetGrid() -> HexGridState {
        // Map sector index to specific colors to match the visual design
        // 0 (0-60): Bot-Right -> GREEN
        // 1 (60-120): Bot -> BLUE
        // 2 (120-180): Bot-Left -> YELLOW
        // 3 (180-240): Top-Left -> CYAN
        // 4 (240-300): Top -> RED
        // 5 (300-360): Top-Right -> PURPLE
        let sectorColors: [HexColor] = [
            .green,
            .blue,
            .yellow,
            .cyan,
            .red,
            .purple
        ]

        // Initialize grid with colors based on sector
        var grid = Array(repeating: HexColor.red, count: geometry.triangles.count)
        for t in geometry.triangles {
            grid[t.id] = sectorColors[t.sector]
        }

        return grid
    }

    // MARK: - Rotation

    /// Rotates 6 triangles clockwise around a rotator point
    static func rotateRegion(_ grid: HexGridState, rotatorId: Int) -> HexGridState {
        var newGrid = grid
        let indices = geometry.rotators[rotatorId].triangleIds

        // Clockwise shift: [0, 1, 2, 3, 4, 5] -> [5, 0, 1, 2, 3, 4]
        let lastVal = newGrid[indices[indices.count - 1]]
        for i in stride(from: indices.count - 1, to: 0, by: -1) {
            newGrid[indices[i]] = newGrid[indices[i - 1]]
        }
        newGrid[indices[0]] = lastVal

        return newGrid
    }

    // MARK: - Scrambling

    /// Scrambles the grid by random rotations
    static func scrambleGrid(moves: Int = HexConstants.scrambleMoves) -> HexGridState {
        var grid = createTargetGrid()
        let numRotators = geometry.rotators.count

        for _ in 0..<moves {
            let r = Int.random(in: 0..<numRotators)
            grid = rotateRegion(grid, rotatorId: r)
        }
        return grid
    }

    // MARK: - Win Check

    /// Checks if current grid matches target
    static func checkWin(grid: HexGridState, target: HexGridState) -> Bool {
        guard grid.count == target.count else { return false }
        return grid.enumerated().allSatisfy { $0.element == target[$0.offset] }
    }
}
