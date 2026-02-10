import Foundation

struct FlipTileLogic {
    // MARK: - Grid Creation

    /// Create an all-light (white) grid
    static func createEmptyGrid() -> FlipGridState {
        Array(repeating: Array(repeating: FlipState.light, count: FlipConstants.gridSize), count: FlipConstants.gridSize)
    }

    /// Deep copy a grid
    static func copyGrid(_ grid: FlipGridState) -> FlipGridState {
        grid.map { $0 }
    }

    // MARK: - Move Logic

    /// Apply a flip move at (row, col) - toggles the cell and its 4 neighbors
    static func applyFlipMove(_ grid: FlipGridState, row: Int, col: Int) -> FlipGridState {
        var newGrid = copyGrid(grid)
        let size = FlipConstants.gridSize

        // Directions: self, right, left, down, up
        let offsets = [
            (0, 0),   // Self
            (0, 1),   // Right
            (0, -1),  // Left
            (1, 0),   // Down
            (-1, 0)   // Up
        ]

        for (dr, dc) in offsets {
            let nr = row + dr
            let nc = col + dc
            if nr >= 0 && nr < size && nc >= 0 && nc < size {
                newGrid[nr][nc] = newGrid[nr][nc].toggled
            }
        }

        return newGrid
    }

    // MARK: - Target Generation

    /// Generate a target pattern by simulating random moves from an empty grid
    /// This guarantees the pattern is reachable (solvable)
    static func generateTarget(difficulty: FlipDifficulty, seedMoves: Int = FlipConstants.seedMoves) -> FlipGridState {
        var grid = createEmptyGrid()
        let size = FlipConstants.gridSize

        for _ in 0..<seedMoves {
            let r = Int.random(in: 0..<size)
            let c = Int.random(in: 0..<size)

            switch difficulty {
            case .asymmetric:
                grid = applyFlipMove(grid, row: r, col: c)

            case .symmetric:
                // Apply move to 4 quadrants to maintain symmetry
                grid = applyFlipMove(grid, row: r, col: c)
                grid = applyFlipMove(grid, row: r, col: size - 1 - c) // Horizontal mirror
                grid = applyFlipMove(grid, row: size - 1 - r, col: c) // Vertical mirror
                grid = applyFlipMove(grid, row: size - 1 - r, col: size - 1 - c) // Diagonal mirror
            }
        }

        return grid
    }

    // MARK: - Win Check

    /// Check if current grid matches the target
    static func checkWin(current: FlipGridState, target: FlipGridState) -> Bool {
        let size = FlipConstants.gridSize
        for r in 0..<size {
            for c in 0..<size {
                if current[r][c] != target[r][c] {
                    return false
                }
            }
        }
        return true
    }
}
