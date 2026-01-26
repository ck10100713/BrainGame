import SwiftUI

// MARK: - StatCard

struct StatCard: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .tracking(1)
            }
            .foregroundColor(.gray)

            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "0f172a").opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "475569"), lineWidth: 1)
                )
        )
    }
}

// MARK: - ActionButton

struct ActionButton: View {
    let title: String
    let icon: String
    let gradient: [Color]
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.headline)
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: gradient,
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: gradient[0].opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - ScaleButtonStyle

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Previews

#Preview("StatCard") {
    HStack {
        StatCard(icon: "clock", title: "TIME", value: "02:30")
        StatCard(icon: "arrow.up.and.down.and.arrow.left.and.right", title: "MOVES", value: "15")
    }
    .padding()
    .background(Color(hex: "0f172a"))
}

#Preview("ActionButton") {
    VStack {
        ActionButton(
            title: "START CHALLENGE",
            icon: "play.fill",
            gradient: [.green, Color(hex: "059669")]
        ) {}

        ActionButton(
            title: "RESET",
            icon: "arrow.counterclockwise",
            gradient: [Color(hex: "475569"), Color(hex: "334155")]
        ) {}
    }
    .padding()
    .background(Color(hex: "0f172a"))
}
