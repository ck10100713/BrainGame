import SwiftUI

// MARK: - Sphere Color

enum SphereColor: String, CaseIterable {
    case cyan = "CYAN"
    case magenta = "MAGENTA"
    case yellow = "YELLOW"
    case blue = "BLUE"
    case green = "GREEN"

    /// 3D gradient colors for sphere rendering (highlight, mid, shadow)
    var gradientColors: [Color] {
        switch self {
        case .cyan:
            return [Color(hex: "22d3ee"), Color(hex: "0891b2"), Color(hex: "164e63")]
        case .magenta:
            return [Color(hex: "e879f9"), Color(hex: "c026d3"), Color(hex: "701a75")]
        case .yellow:
            return [Color(hex: "facc15"), Color(hex: "ca8a04"), Color(hex: "713f12")]
        case .blue:
            return [Color(hex: "3b82f6"), Color(hex: "2563eb"), Color(hex: "1e3a8a")]
        case .green:
            return [Color(hex: "4ade80"), Color(hex: "16a34a"), Color(hex: "14532d")]
        }
    }

    /// Shadow color for glow effect
    var glowColor: Color {
        switch self {
        case .cyan: return Color(hex: "22d3ee").opacity(0.4)
        case .magenta: return Color(hex: "e879f9").opacity(0.4)
        case .yellow: return Color(hex: "facc15").opacity(0.4)
        case .blue: return Color(hex: "3b82f6").opacity(0.4)
        case .green: return Color(hex: "4ade80").opacity(0.4)
        }
    }
}

// MARK: - Sphere Difficulty

enum SphereDifficulty: String, CaseIterable {
    case standard = "STANDARD"
    case blind = "BLIND"

    var displayName: String {
        switch self {
        case .standard: return "Standard"
        case .blind: return "Blind"
        }
    }

    var icon: String {
        switch self {
        case .standard: return "eye"
        case .blind: return "eye.slash"
        }
    }

    var gradientColors: [Color] {
        switch self {
        case .standard: return [.cyan, .blue]
        case .blind: return [.purple, .pink]
        }
    }
}

// MARK: - Grid State

typealias SphereGridState = [[SphereColor]]

// MARK: - Constants

enum SphereConstants {
    static let gridSize = 5
    static let scrambleMoves = 40
    static let maxAttempts = 3
}
