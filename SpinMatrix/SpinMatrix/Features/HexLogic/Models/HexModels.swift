import SwiftUI

// MARK: - Hex Color

enum HexColor: String, CaseIterable {
    case red = "RED"
    case purple = "PURPLE"
    case green = "GREEN"
    case blue = "BLUE"
    case yellow = "YELLOW"
    case cyan = "CYAN"

    var color: Color {
        switch self {
        case .red: return Color(hex: "ef4444")
        case .purple: return Color(hex: "a855f7")
        case .green: return Color(hex: "22c55e")
        case .blue: return Color(hex: "3b82f6")
        case .yellow: return Color(hex: "eab308")
        case .cyan: return Color(hex: "06b6d4")
        }
    }
}

// MARK: - Geometry Types

struct HexPoint: Equatable {
    var x: Double
    var y: Double

    static let zero = HexPoint(x: 0, y: 0)

    func toCGPoint() -> CGPoint {
        CGPoint(x: x, y: y)
    }
}

struct TriangleDef: Identifiable {
    let id: Int
    let points: [HexPoint]  // 3 vertices
    let center: HexPoint    // Centroid
    let sector: Int         // 0-5, which large sector it belongs to
}

struct RotatorDef: Identifiable {
    let id: Int
    let center: HexPoint
    let triangleIds: [Int]  // The 6 triangles around this vertex (clockwise)
}

// MARK: - Grid State

typealias HexGridState = [HexColor]  // Flat array of 54 triangles

// MARK: - Constants

enum HexConstants {
    static let sideLength = 3        // Hexagon side length N
    static let triangleCount = 54    // 6 * N^2
    static let scale: Double = 25.0  // Visual scale unit
    static let scrambleMoves = 40
}
