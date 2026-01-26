import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: "0f172a"), Color(hex: "1e293b")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                // Header
                HeaderView()

                // Main Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Game Board
                        ZStack {
                            GridBoardView(
                                grid: viewModel.grid,
                                isInteractive: viewModel.isPlaying && !viewModel.isSolved,
                                onRotate: viewModel.handleRotate
                            )

                            // Victory Overlay
                            if viewModel.isSolved {
                                VictoryOverlay(moves: viewModel.moves, time: viewModel.elapsedTime)
                            }
                        }
                        .frame(maxWidth: 400)

                        Text("Tap the circular icons to rotate surrounding blocks clockwise.")
                            .font(.caption)
                            .foregroundColor(.gray)

                        // Info Panel
                        InfoPanelView(viewModel: viewModel)
                            .frame(maxWidth: 400)
                    }
                    .padding()
                }
            }
        }
    }
}

struct HeaderView: View {
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 8) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 32))
                    .foregroundColor(.cyan)

                Text("SpinMatrix")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.cyan, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }

            Text("Spatial Logic Challenge")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.top, 16)
    }
}

struct VictoryOverlay: View {
    let moves: Int
    let time: Int

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            VStack(spacing: 12) {
                Text("🎉")
                    .font(.system(size: 60))

                Text("SOLVED!")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                HStack(spacing: 20) {
                    Label("\(moves) Moves", systemImage: "sparkles")
                    Label("\(time)s", systemImage: "sparkles")
                }
                .font(.headline)
                .foregroundColor(.cyan)
            }
        }
    }
}

// Color hex extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    ContentView()
}
