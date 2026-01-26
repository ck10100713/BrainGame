import Foundation

struct GameLogic {
    /// Creates a solved grid pattern (Quadrants)
    /// Top-Left: Red, Top-Right: Yellow
    /// Bottom-Left: Blue, Bottom-Right: Green
    static func createTargetGrid(size: Int) -> GridState {
        var grid: GridState = []
        let mid = size / 2

        for r in 0..<size {
            var row: [BlockColor] = []
            for c in 0..<size {
                if r < mid && c < mid {
                    row.append(.red)
                } else if r < mid && c >= mid {
                    row.append(.yellow)
                } else if r >= mid && c < mid {
                    row.append(.blue)
                } else {
                    row.append(.green)
                }
            }
            grid.append(row)
        }
        return grid
    }

    /// Creates a deep copy of the grid
    static func copyGrid(_ grid: GridState) -> GridState {
        return grid.map { $0 }
    }

    /// Rotates the 2x2 block at the intersection (row, col) clockwise.
    /// The intersection (row, col) affects cells:
    /// (row, col), (row, col+1)
    /// (row+1, col), (row+1, col+1)
    static func rotateSubgrid(_ grid: GridState, row: Int, col: Int) -> GridState {
        var newGrid = copyGrid(grid)

        // Coordinates of the 4 cells
        let tl = newGrid[row][col]         // Top-Left
        let tr = newGrid[row][col + 1]     // Top-Right
        let br = newGrid[row + 1][col + 1] // Bottom-Right
        let bl = newGrid[row + 1][col]     // Bottom-Left

        // Clockwise rotation
        newGrid[row][col + 1] = tl     // TL -> TR
        newGrid[row + 1][col + 1] = tr // TR -> BR
        newGrid[row + 1][col] = br     // BR -> BL
        newGrid[row][col] = bl         // BL -> TL

        return newGrid
    }

    /// Scrambles the grid by performing random valid rotations.
    /// This ensures the puzzle is always solvable.
    static func scrambleGrid(_ grid: GridState, size: Int, moves: Int = 20) -> GridState {
        var currentGrid = copyGrid(grid)
        let maxIdx = size - 1

        for _ in 0..<moves {
            let r = Int.random(in: 0..<maxIdx)
            let c = Int.random(in: 0..<maxIdx)
            currentGrid = rotateSubgrid(currentGrid, row: r, col: c)
        }

        return currentGrid
    }

    /// Checks if two grids are identical
    static func checkWin(gridA: GridState, gridB: GridState) -> Bool {
        guard gridA.count == gridB.count else { return false }

        for i in 0..<gridA.count {
            for j in 0..<gridA[i].count {
                if gridA[i][j] != gridB[i][j] {
                    return false
                }
            }
        }
        return true
    }
}
