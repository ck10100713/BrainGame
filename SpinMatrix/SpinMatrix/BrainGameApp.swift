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
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "0f172a"), Color(hex: "1e293b")],
                startPoint: .top,
                endPoint: .bottom
            )
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
        }
    }
}

#Preview {
    RootView()
        .environmentObject(NavigationStore())
}
