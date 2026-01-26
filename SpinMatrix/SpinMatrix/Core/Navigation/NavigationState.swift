import SwiftUI

// MARK: - Game Identifiers

enum GameId: String, CaseIterable, Identifiable {
    case spinMatrix = "SPIN_MATRIX"
    case sphereShift = "SPHERE_SHIFT"
    case hexLogic = "HEX_LOGIC"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .spinMatrix: return "SpinMatrix"
        case .sphereShift: return "SphereShift"
        case .hexLogic: return "HexLogic"
        }
    }

    var subtitle: String {
        switch self {
        case .spinMatrix: return "Rotate 2x2 blocks to match the target pattern"
        case .sphereShift: return "Shift rows and columns to align sphere colors"
        case .hexLogic: return "Rotate triangular petals in a hexagonal puzzle"
        }
    }

    var icon: String {
        switch self {
        case .spinMatrix: return "arrow.clockwise.circle.fill"
        case .sphereShift: return "circle.grid.3x3.fill"
        case .hexLogic: return "hexagon.fill"
        }
    }

    var gradientColors: [Color] {
        switch self {
        case .spinMatrix: return [.cyan, .blue]
        case .sphereShift: return [.cyan, .teal]
        case .hexLogic: return [.purple, .pink]
        }
    }
}

// MARK: - View State

enum ViewState: Equatable {
    case menu
    case game(GameId)
}

// MARK: - Navigation Store

@MainActor
class NavigationStore: ObservableObject {
    @Published var currentView: ViewState = .menu

    func navigateToMenu() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentView = .menu
        }
    }

    func navigateToGame(_ gameId: GameId) {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentView = .game(gameId)
        }
    }
}
