import SwiftUI

enum BlockColor: String, CaseIterable {
    case red = "RED"
    case blue = "BLUE"
    case green = "GREEN"
    case yellow = "YELLOW"

    var color: Color {
        switch self {
        case .red: return BrainGameColors.blockRed
        case .blue: return BrainGameColors.blockBlue
        case .green: return BrainGameColors.blockGreen
        case .yellow: return BrainGameColors.blockYellow
        }
    }
}

enum SpinMatrixDifficulty: Int, CaseIterable {
    case easy = 4
    case hard = 6

    var scrambleCount: Int {
        switch self {
        case .easy: return 15
        case .hard: return 40
        }
    }

    var displayName: String {
        "\(rawValue) x \(rawValue)"
    }
}

typealias SpinMatrixGridState = [[BlockColor]]
