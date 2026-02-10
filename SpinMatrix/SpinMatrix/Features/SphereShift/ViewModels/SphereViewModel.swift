import SwiftUI
import Combine

class SphereViewModel: ObservableObject {
    // MARK: - Published State

    @Published var difficulty: SphereDifficulty = .standard
    @Published var grid: SphereGridState = []
    @Published var moves: Int = 0
    @Published var elapsedTime: Int = 0
    @Published var isPlaying: Bool = false
    @Published var isSolved: Bool = false

    // Blind Mode State
    @Published var attempts: Int = SphereConstants.maxAttempts
    @Published var showFailModal: Bool = false
    @Published var isRevealing: Bool = false
    @Published var isMemorizing: Bool = false  // Blind mode: show puzzle before hiding

    // MARK: - Private

    private var timer: AnyCancellable?

    // MARK: - Initialization

    init() {
        grid = SphereLogic.createSolvedGrid()
    }

    // MARK: - Game Control

    func initGame(difficulty: SphereDifficulty, startPlaying: Bool) {
        self.difficulty = difficulty

        if startPlaying {
            grid = SphereLogic.scrambleGrid()
            isSolved = false
            moves = 0
            elapsedTime = 0
            attempts = SphereConstants.maxAttempts
            showFailModal = false
            isRevealing = false

            if difficulty == .blind {
                // Blind mode: show puzzle first for memorization
                isMemorizing = true
                isPlaying = false  // Not playing yet, just memorizing
            } else {
                // Standard mode: start immediately
                isPlaying = true
                isMemorizing = false
                startTimer()
            }
        } else {
            grid = SphereLogic.createSolvedGrid()
            isPlaying = false
            isSolved = false
            isMemorizing = false
            stopTimer()
        }
    }

    /// Blind mode: start playing after memorization phase
    func startBlindPhase() {
        isMemorizing = false
        isPlaying = true
        startTimer()
    }

    func handleDifficultyChange(_ newDifficulty: SphereDifficulty) {
        initGame(difficulty: newDifficulty, startPlaying: false)
    }

    func startGame() {
        initGame(difficulty: difficulty, startPlaying: true)
    }

    func resetGame() {
        initGame(difficulty: difficulty, startPlaying: false)
    }

    // MARK: - Shift Actions

    func handleShiftRow(_ row: Int, direction: Int) {
        guard isPlaying && !isSolved else { return }

        grid = SphereLogic.shiftRow(grid, rowIndex: row, direction: direction)
        moves += 1

        if difficulty == .standard {
            checkWinCondition()
        }
    }

    func handleShiftCol(_ col: Int, direction: Int) {
        guard isPlaying && !isSolved else { return }

        grid = SphereLogic.shiftCol(grid, colIndex: col, direction: direction)
        moves += 1

        if difficulty == .standard {
            checkWinCondition()
        }
    }

    // MARK: - Blind Mode

    func handleSubmitBlind() {
        // 1. Reveal colors
        isRevealing = true

        // 2. Check Win
        let isWin = checkWinCondition()

        // 3. If fail
        if !isWin {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                self?.attempts -= 1
                self?.showFailModal = true
            }
        }
    }

    func handleContinue() {
        showFailModal = false
        isRevealing = false

        if attempts <= 0 {
            initGame(difficulty: difficulty, startPlaying: false)
        }
    }

    // MARK: - Win Condition

    @discardableResult
    private func checkWinCondition() -> Bool {
        if SphereLogic.checkWin(grid) {
            isSolved = true
            isPlaying = false
            isRevealing = true
            stopTimer()
            return true
        }
        return false
    }

    // MARK: - Timer

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

    // MARK: - Computed Properties

    var formattedTime: String {
        let minutes = elapsedTime / 60
        let seconds = elapsedTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    /// Determine if we should visually render as blind
    var renderBlind: Bool {
        difficulty == .blind && isPlaying && !isRevealing
    }
}
