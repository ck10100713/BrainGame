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
                    lineWidth: 1
                )
            }
        }
        .frame(width: viewSize * scale, height: viewSize * scale)
        .overlay {
            // Rotator buttons overlay
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

// MARK: - Rotator Hit Area

struct RotatorHitArea: View {
    let isInteractive: Bool
    let action: () -> Void

    @State private var isHovered = false
    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            ZStack {
                // Invisible hit area
                Circle()
                    .fill(Color.clear)
                    .frame(width: 30, height: 30)

                // Visible indicator on hover/press
                if isHovered || isPressed {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 16, height: 16)
                        .shadow(color: .white.opacity(0.5), radius: 4)
                        .overlay {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundColor(Color(hex: "0f172a"))
                        }
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isInteractive)
        .opacity(isInteractive ? 1 : 0)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
        .onLongPressGesture(minimumDuration: 0, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    HexBoardView(
        grid: HexLogic.createTargetGrid(),
        isInteractive: true,
        scale: 1.3,
        onRotate: { _ in }
    )
    .padding(40)
    .background(
        RoundedRectangle(cornerRadius: 20)
            .fill(Color(hex: "0f172a").opacity(0.4))
    )
    .padding()
    .background(Color(hex: "0f172a"))
}
