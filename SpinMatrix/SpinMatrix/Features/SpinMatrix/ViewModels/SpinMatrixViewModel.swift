import SwiftUI
import Combine

class SpinMatrixViewModel: ObservableObject {
    @Published var difficulty: SpinMatrixDifficulty = .easy
    @Published var grid: SpinMatrixGridState = []
    @Published var target: SpinMatrixGridState = []
    @Published var moves: Int = 0
    @Published var isPlaying: Bool = false
    @Published var isSolved: Bool = false
    @Published var elapsedTime: Int = 0

    private var timer: AnyCancellable?

    init() {
        initGame(difficulty: .easy, startPlaying: false)
    }

    func initGame(difficulty: SpinMatrixDifficulty, startPlaying: Bool) {
        self.difficulty = difficulty
        let solvedState = SpinMatrixLogic.createTargetGrid(size: difficulty.rawValue)
        target = solvedState

        if startPlaying {
            // Scramble for gameplay
            let scrambled = SpinMatrixLogic.scrambleGrid(solvedState, size: difficulty.rawValue, moves: difficulty.scrambleCount)
            grid = scrambled
            isPlaying = true
            isSolved = false
            moves = 0
            elapsedTime = 0
            startTimer()
        } else {
            // Show solved state (preview)
            grid = solvedState
            isPlaying = false
            isSolved = false
            moves = 0
            elapsedTime = 0
            stopTimer()
        }
    }

    func handleDifficultyChange(_ newDifficulty: SpinMatrixDifficulty) {
        initGame(difficulty: newDifficulty, startPlaying: false)
    }

    func handleRotate(row: Int, col: Int) {
        guard isPlaying && !isSolved else { return }

        grid = SpinMatrixLogic.rotateSubgrid(grid, row: row, col: col)
        moves += 1

        // Check win condition
        if SpinMatrixLogic.checkWin(gridA: grid, gridB: target) {
            isSolved = true
            isPlaying = false
            stopTimer()
        }
    }

    func startGame() {
        initGame(difficulty: difficulty, startPlaying: true)
    }

    func resetGame() {
        initGame(difficulty: difficulty, startPlaying: false)
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.elapsedTime += 1
            }
    }

    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    var formattedTime: String {
        let minutes = elapsedTime / 60
        let seconds = elapsedTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
