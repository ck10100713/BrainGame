import SwiftUI

// MARK: - Flip State

enum FlipState: Int, CaseIterable {
    case light = 0
    case dark = 1

    var color: Color {
        switch self {
        case .light: return BrainGameColors.textPrimary.opacity(0.9)
        case .dark: return BrainGameColors.backgroundPrimary
        }
    }

    var toggled: FlipState {
        self == .light ? .dark : .light
    }
}

// MARK: - Difficulty

enum FlipDifficulty: String, CaseIterable {
    case symmetric = "SYMMETRIC"
    case asymmetric = "ASYMMETRIC"

    var displayName: String {
        switch self {
        case .symmetric: return "Symmetric"
        case .asymmetric: return "Asymmetric"
        }
    }
}

// MARK: - Type Aliases & Constants

typealias FlipGridState = [[FlipState]]

enum FlipConstants {
    static let gridSize = 7
    static let seedMoves = 15
}
