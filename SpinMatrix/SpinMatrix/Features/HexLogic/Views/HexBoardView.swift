import SwiftUI

struct HexBoardView: View {
    let grid: HexGridState
    let isInteractive: Bool
    let scale: Double
    let showRotators: Bool
    let onRotate: (Int) -> Void

    private let viewSize: CGFloat = 300

    init(
        grid: HexGridState,
        isInteractive: Bool,
        scale: Double = 1.0,
        showRotators: Bool = true,
        onRotate: @escaping (Int) -> Void
    ) {
        self.grid = grid
        self.isInteractive = isInteractive
        self.scale = scale
        self.showRotators = showRotators
        self.onRotate = onRotate
    }

    var body: some View {
        Canvas { context, size in
            let geometry = HexGeometry.shared

            // Center the drawing
            let centerX = size.width / 2
            let centerY = size.height / 2

            // Draw Triangles as Petals
            for tri in geometry.triangles {
                let color = grid[tri.id].color
                let path = createPetalPath(for: tri, centerX: centerX, centerY: centerY)

                // Fill
                context.fill(path, with: .color(color))

                // Stroke
                context.stroke(
                    path,
                    with: .color(.black.opacity(0.3)),
                    lineWidth: ComponentTokens.borderThin
                )
            }
        }
        .frame(width: viewSize * scale, height: viewSize * scale)
        .overlay {
            // Rotator buttons overlay - 44pt minimum touch target
            if showRotators {
                GeometryReader { geo in
                    let geometry = HexGeometry.shared
                    let centerX = geo.size.width / 2
                    let centerY = geo.size.height / 2

                    ForEach(geometry.rotators) { rot in
                        RotatorHitArea(
                            isInteractive: isInteractive,
                            action: { onRotate(rot.id) }
                        )
                        .position(
                            x: centerX + rot.center.x * scale,
                            y: centerY + rot.center.y * scale
                        )
                    }
                }
            }
        }
    }

    /// Creates a curved petal path for a triangle
    private func createPetalPath(for tri: TriangleDef, centerX: CGFloat, centerY: CGFloat) -> Path {
        let points = tri.points.map { p in
            CGPoint(x: centerX + p.x * scale, y: centerY + p.y * scale)
        }
        let center = CGPoint(x: centerX + tri.center.x * scale, y: centerY + tri.center.y * scale)

        // Helper to get control point for curved edge
        func getControl(p1: CGPoint, p2: CGPoint) -> CGPoint {
            let mid = CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
            let vec = CGPoint(x: mid.x - center.x, y: mid.y - center.y)
            let factor: CGFloat = 0.2
            return CGPoint(x: mid.x + vec.x * factor, y: mid.y + vec.y * factor)
        }

        let c1 = getControl(p1: points[0], p2: points[1])
        let c2 = getControl(p1: points[1], p2: points[2])
        let c3 = getControl(p1: points[2], p2: points[0])

        var path = Path()
        path.move(to: points[0])
        path.addQuadCurve(to: points[1], control: c1)
        path.addQuadCurve(to: points[2], control: c2)
        path.addQuadCurve(to: points[0], control: c3)
        path.closeSubpath()

        return path
    }
}

// MARK: - Rotator Hit Area - 44pt minimum touch target

struct RotatorHitArea: View {
    let isInteractive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Circle()
                .fill(Color.white.opacity(0.01)) // Nearly transparent but tappable
                .frame(width: LayoutMetrics.hexRotatorSize, height: LayoutMetrics.hexRotatorSize)
        }
        .buttonStyle(RotatorButtonStyle())
        .disabled(!isInteractive)
        .opacity(isInteractive ? 1 : 0)
    }
}

// MARK: - Rotator Button Style

struct RotatorButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay {
                if configuration.isPressed {
                    Circle()
                        .fill(BrainGameColors.textPrimary)
                        .frame(width: Spacing.md, height: Spacing.md)
                        .shadow(color: BrainGameColors.textPrimary.opacity(0.5), radius: 4)
                        .overlay {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: Spacing.xs, weight: .bold))
                                .foregroundColor(BrainGameColors.backgroundPrimary)
                        }
                }
            }
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    HexBoardView(
        grid: HexLogic.createTargetGrid(),
        isInteractive: true,
        scale: 1.3,
        onRotate: { _ in }
    )
    .padding(Spacing.xxl)
    .background(
        RoundedRectangle(cornerRadius: ComponentTokens.radius2XL)
            .fill(BrainGameColors.backgroundPrimary.opacity(0.4))
    )
    .padding()
    .background(BrainGameColors.backgroundPrimary)
}
