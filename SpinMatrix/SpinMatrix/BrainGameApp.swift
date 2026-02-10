import SwiftUI

@main
struct BrainGameApp: App {
    @StateObject private var navigationStore = NavigationStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(navigationStore)
        }
    }
}

struct RootView: View {
    @EnvironmentObject var navigationStore: NavigationStore

    var body: some View {
        NavigationStack {
            ZStack {
                // Background - using design system colors
                BrainGameColors.backgroundGradient
                    .ignoresSafeArea()

                // Content
                switch navigationStore.currentView {
                case .menu:
                    MainMenuView()
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))

                case .game(let gameId):
                    gameView(for: gameId)
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
        }
        .tint(BrainGameColors.textPrimary)
    }

    @ViewBuilder
    private func gameView(for gameId: GameId) -> some View {
        switch gameId {
        case .spinMatrix:
            SpinMatrixGameView()
        case .sphereShift:
            SphereGameView()
        case .hexLogic:
            HexGameView()
        case .flipTile:
            FlipTileGameView()
        }
    }
}

#Preview {
    RootView()
        .environmentObject(NavigationStore())
}
