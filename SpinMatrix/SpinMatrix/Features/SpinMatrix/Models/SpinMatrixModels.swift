import SwiftUI

enum BlockColor: String, CaseIterable {
    case red = "RED"
    case blue = "BLUE"
    case green = "GREEN"
    case yellow = "YELLOW"

    var color: Color {
        switch self {
        case .red: return .red
        case .blue: return .blue
        case .green: return .green
        case .yellow: return .yellow
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
