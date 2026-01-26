import SwiftUI
import Combine

class HexViewModel: ObservableObject {
    // MARK: - Published State

    @Published var grid: HexGridState = []
    @Published var target: HexGridState = []
    @Published var moves: Int = 0
    @Published var elapsedTime: Int = 0
    @Published var isPlaying: Bool = false
    @Published var isSolved: Bool = false

    // MARK: - Private

    private var timer: AnyCancellable?

    // MARK: - Initialization

    init() {
        let targetGrid = HexLogic.createTargetGrid()
        grid = targetGrid
        target = targetGrid
    }

    // MARK: - Game Control

    func initGame(startPlaying: Bool) {
        target = HexLogic.createTargetGrid()

        if startPlaying {
            grid = HexLogic.scrambleGrid()
            isPlaying = true
            isSolved = false
            moves = 0
            elapsedTime = 0
            startTimer()
        } else {
            grid = target
            isPlaying = false
            isSolved = false
            stopTimer()
        }
    }

    func startGame() {
        initGame(startPlaying: true)
    }

    func resetGame() {
        initGame(startPlaying: false)
    }

    // MARK: - Rotation

    func handleRotate(rotatorId: Int) {
        guard isPlaying && !isSolved else { return }

        grid = HexLogic.rotateRegion(grid, rotatorId: rotatorId)
        moves += 1

        // Check win condition
        if HexLogic.checkWin(grid: grid, target: target) {
            isSolved = true
            isPlaying = false
            stopTimer()
        }
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
}
