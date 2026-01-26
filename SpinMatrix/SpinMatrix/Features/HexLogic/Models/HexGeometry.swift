import Foundation

/// Singleton class that computes and stores hexagon geometry at app startup
final class HexGeometry {
    static let shared = HexGeometry()

    let triangles: [TriangleDef]
    let rotators: [RotatorDef]

    private init() {
        let N = HexConstants.sideLength
        let SCALE = HexConstants.scale

        // MARK: - Helper Functions

        /// Convert Axial (q, r) to Cartesian (x, y)
        func getPt(q: Int, r: Int) -> HexPoint {
            HexPoint(
                x: SCALE * (Double(q) + Double(r) / 2.0),
                y: SCALE * (Double(r) * sqrt(3.0) / 2.0)
            )
        }

        func getVertexKey(q: Int, r: Int) -> String {
            "\(q),\(r)"
        }

        // MARK: - Generate Vertices

        var verticesMap: [String: HexPoint] = [:]

        for q in -N...N {
            for r in -N...N {
                let s = -q - r
                if abs(s) <= N {
                    verticesMap[getVertexKey(q: q, r: r)] = getPt(q: q, r: r)
                }
            }
        }

        // MARK: - Generate Triangles

        struct TempTriangle {
            let pts: [HexPoint]
            let q: Int
            let r: Int
        }

        var tempTriangles: [TempTriangle] = []

        for (key, pt) in verticesMap {
            let parts = key.split(separator: ",").compactMap { Int($0) }
            guard parts.count == 2 else { continue }
            let q = parts[0]
            let r = parts[1]

            // Type A: (q,r), (q+1,r), (q,r+1)
            let keyA1 = getVertexKey(q: q + 1, r: r)
            let keyA2 = getVertexKey(q: q, r: r + 1)
            if let ptA1 = verticesMap[keyA1], let ptA2 = verticesMap[keyA2] {
                tempTriangles.append(TempTriangle(pts: [pt, ptA1, ptA2], q: q, r: r))
            }

            // Type B: (q,r), (q+1, r-1), (q+1, r)
            let keyB1 = getVertexKey(q: q + 1, r: r - 1)
            let keyB2 = getVertexKey(q: q + 1, r: r)
            if let ptB1 = verticesMap[keyB1], let ptB2 = verticesMap[keyB2] {
                tempTriangles.append(TempTriangle(pts: [pt, ptB1, ptB2], q: q, r: r))
            }
        }

        // MARK: - Calculate Centroids and Assign Sectors

        var trianglesList: [TriangleDef] = []

        for (idx, t) in tempTriangles.enumerated() {
            let center = HexPoint(
                x: (t.pts[0].x + t.pts[1].x + t.pts[2].x) / 3.0,
                y: (t.pts[0].y + t.pts[1].y + t.pts[2].y) / 3.0
            )

            // Determine Sector (0-5) based on angle
            var angle = atan2(center.y, center.x) * (180.0 / Double.pi)
            if angle < 0 { angle += 360.0 }

            // Map 0-360 to 0-5
            // 0 (0-60): Bot-Right (Green)
            // 1 (60-120): Bot (Blue)
            // 2 (120-180): Bot-Left (Yellow)
            // 3 (180-240): Top-Left (Cyan)
            // 4 (240-300): Top (Red)
            // 5 (300-360): Top-Right (Purple)
            let sector = Int(angle / 60.0) % 6

            trianglesList.append(TriangleDef(
                id: idx,
                points: t.pts,
                center: center,
                sector: sector
            ))
        }

        // MARK: - Generate Rotators

        var rotatorsList: [RotatorDef] = []

        for q in -(N - 1)...(N - 1) {
            for r in -(N - 1)...(N - 1) {
                let s = -q - r
                if abs(s) <= (N - 1) {
                    let center = getPt(q: q, r: r)

                    // Find the 6 triangles that share this vertex
                    var touchingTris = trianglesList.filter { t in
                        t.points.contains { p in
                            abs(p.x - center.x) < 0.1 && abs(p.y - center.y) < 0.1
                        }
                    }

                    // Verify we have 6 triangles
                    if touchingTris.count == 6 {
                        // Sort them clockwise around the center
                        touchingTris.sort { a, b in
                            let angA = atan2(a.center.y - center.y, a.center.x - center.x)
                            let angB = atan2(b.center.y - center.y, b.center.x - center.x)
                            return angA < angB
                        }

                        rotatorsList.append(RotatorDef(
                            id: rotatorsList.count,
                            center: center,
                            triangleIds: touchingTris.map { $0.id }
                        ))
                    }
                }
            }
        }

        self.triangles = trianglesList
        self.rotators = rotatorsList
    }
}
