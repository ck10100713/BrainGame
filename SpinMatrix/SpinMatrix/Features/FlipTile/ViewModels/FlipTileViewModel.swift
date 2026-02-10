import SwiftUI
import Combine

class FlipTileViewModel: ObservableObject {
    @Published var difficulty: FlipDifficulty = .symmetric
    @Published var playerGrid: FlipGridState = []
    @Published var targetGrid: FlipGridState = []
    @Published var moves: Int = 0
    @Published var isPlaying: Bool = false
    @Published var isSolved: Bool = false
    @Published var elapsedTime: Int = 0

    private var timer: AnyCancellable?

    init() {
        initGame(difficulty: .symmetric, startPlaying: false)
    }

    func initGame(difficulty: FlipDifficulty, startPlaying: Bool) {
        self.difficulty = difficulty

        if startPlaying {
            // Keep the same target that was shown in preview - don't regenerate!
            // Player starts with an empty (all light) grid
            playerGrid = FlipTileLogic.createEmptyGrid()
            isPlaying = true
            isSolved = false
            moves = 0
            elapsedTime = 0
            startTimer()
        } else {
            // Preview mode: generate new target only in preview mode
            targetGrid = FlipTileLogic.generateTarget(difficulty: difficulty)
            playerGrid = FlipTileLogic.createEmptyGrid()
            isPlaying = false
            isSolved = false
            moves = 0
            elapsedTime = 0
            stopTimer()
        }
    }

    func handleDifficultyChange(_ newDifficulty: FlipDifficulty) {
        initGame(difficulty: newDifficulty, startPlaying: false)
    }

    func handleTileClick(row: Int, col: Int) {
        guard isPlaying && !isSolved else { return }

        playerGrid = FlipTileLogic.applyFlipMove(playerGrid, row: row, col: col)
        moves += 1

        // Check win condition
        if FlipTileLogic.checkWin(current: playerGrid, target: targetGrid) {
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
