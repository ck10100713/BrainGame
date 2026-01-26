import Foundation

struct SphereLogic {
    private static let SIZE = SphereConstants.gridSize

    // MARK: - Grid Creation

    /// Create a solved grid: Row 0 = Cyan, Row 1 = Magenta, etc.
    static func createSolvedGrid() -> SphereGridState {
        let colors: [SphereColor] = [.cyan, .magenta, .yellow, .blue, .green]

        var grid: SphereGridState = []
        for r in 0..<SIZE {
            var row: [SphereColor] = []
            for _ in 0..<SIZE {
                row.append(colors[r])
            }
            grid.append(row)
        }
        return grid
    }

    /// Creates a deep copy of the grid
    static func copyGrid(_ grid: SphereGridState) -> SphereGridState {
        return grid.map { $0 }
    }

    // MARK: - Row/Column Shifting

    /// Shift Row: direction 1 = Right, -1 = Left
    static func shiftRow(_ grid: SphereGridState, rowIndex: Int, direction: Int) -> SphereGridState {
        var newGrid = copyGrid(grid)
        var row = newGrid[rowIndex]

        if direction == 1 {
            // Right: Last becomes first
            let last = row.removeLast()
            row.insert(last, at: 0)
        } else {
            // Left: First becomes last
            let first = row.removeFirst()
            row.append(first)
        }

        newGrid[rowIndex] = row
        return newGrid
    }

    /// Shift Col: direction 1 = Down, -1 = Up
    static func shiftCol(_ grid: SphereGridState, colIndex: Int, direction: Int) -> SphereGridState {
        var newGrid = copyGrid(grid)

        if direction == 1 {
            // Down
            let lastVal = newGrid[SIZE - 1][colIndex]
            for r in stride(from: SIZE - 1, to: 0, by: -1) {
                newGrid[r][colIndex] = newGrid[r - 1][colIndex]
            }
            newGrid[0][colIndex] = lastVal
        } else {
            // Up
            let firstVal = newGrid[0][colIndex]
            for r in 0..<(SIZE - 1) {
                newGrid[r][colIndex] = newGrid[r + 1][colIndex]
            }
            newGrid[SIZE - 1][colIndex] = firstVal
        }

        return newGrid
    }

    // MARK: - Scrambling

    /// Scrambles the grid by random shifts
    static func scrambleGrid(moves: Int = SphereConstants.scrambleMoves) -> SphereGridState {
        var grid = createSolvedGrid()

        for _ in 0..<moves {
            let isRow = Bool.random()
            let index = Int.random(in: 0..<SIZE)
            let dir = Bool.random() ? 1 : -1

            if isRow {
                grid = shiftRow(grid, rowIndex: index, direction: dir)
            } else {
                grid = shiftCol(grid, colIndex: index, direction: dir)
            }
        }
        return grid
    }

    // MARK: - Win Check

    /// Check if every row consists of a single unique color
    static func checkWin(_ grid: SphereGridState) -> Bool {
        for r in 0..<SIZE {
            let firstColor = grid[r][0]
            for c in 1..<SIZE {
                if grid[r][c] != firstColor {
                    return false
                }
            }
        }
        return true
    }
}
