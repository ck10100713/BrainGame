import { HexColor, HexGridState } from '../types';

// ==========================================
// CONFIGURATION: Side 3 Hexagon
// ==========================================
// A hexagon of side N consists of 6 * N^2 equilateral triangles.
// For N=3, Total Triangles = 54.
const N = 3;
const SCALE = 25; // Visual scale unit

// ==========================================
// GEOMETRY GENERATION
// ==========================================

export interface Point { x: number; y: number; }
export interface TriangleDef {
  id: number;
  points: [Point, Point, Point]; // 3 vertices
  center: Point; // Centroid
  sector: number; // 0-5, which large sector it belongs to
}
export interface RotatorDef {
  id: number;
  center: Point;
  triangleIds: number[]; // The 6 triangles around this vertex (clockwise)
}

// 1. Generate Vertices in Axial Coordinates (q, r)
// We need vertices up to distance N (inclusive) to define the grid boundaries.
// Rotators are vertices with distance < N (strictly inside, so triangles can form around them).
const verticesMap = new Map<string, Point>();
const rotatorsList: RotatorDef[] = [];
const trianglesList: TriangleDef[] = [];

// Convert Axial (q, r) to Cartesian (x, y)
// Basis: q along 0 deg, r along 60 deg (standard hex grid)
// x = size * (3/2 * q) -- No, for triangular grid vertices:
// x = scale * (q + r/2)
// y = scale * (r * sqrt(3)/2)
const getPt = (q: number, r: number): Point => ({
  x: SCALE * (q + r/2),
  y: SCALE * (r * Math.sqrt(3)/2)
});

const getVertexKey = (q: number, r: number) => `${q},${r}`;

// Generate all vertices within distance N
for (let q = -N; q <= N; q++) {
  for (let r = -N; r <= N; r++) {
    const s = -q - r;
    if (Math.abs(s) <= N) {
      verticesMap.set(getVertexKey(q, r), getPt(q, r));
    }
  }
}

// 2. Generate Triangles
// A triangle is defined by 3 mutually adjacent vertices.
// In this coordinate system, for a vertex V(q,r), the unit neighbors are:
// (q+1, r), (q, r+1), (q-1, r+1), (q-1, r), (q, r-1), (q+1, r-1)
// We scan all valid "base" vertices and form "up" and "down" triangles?
// Simpler: Scan all vertices V. Check if V + (1,0) and V + (0,1) exist. That forms a triangle.
// Also V + (1,0) and V + (1,-1).
// Basically, we can iterate all triplets of mutual neighbors.

// Let's iterate all vertices V(q,r) and look for two specific types of triangles rooted at V to avoid duplicates:
// Type A (Point Up): V(q,r), V(q+1, r), V(q, r+1) -- wait, (q+1, r) and (q, r+1) distance is 1?
// (q+1, r) - (q, r+1) = (1, -1). Distance is 1. Yes.
// Type B (Point Down): V(q,r), V(q+1, r-1), V(q+1, r).
// V(q+1, r-1) to V(q+1, r) is dist 1. V(q+1, r-1) to V(q,r) is (1, -1) dist 1. Yes.

const tempTriangles: { pts: Point[], q: number, r: number }[] = [];

verticesMap.forEach((pt, key) => {
  const [q, r] = key.split(',').map(Number);
  
  // Check Type A: (q,r), (q+1,r), (q,r+1)
  if (verticesMap.has(getVertexKey(q+1, r)) && verticesMap.has(getVertexKey(q, r+1))) {
    tempTriangles.push({ 
      pts: [pt, verticesMap.get(getVertexKey(q+1, r))!, verticesMap.get(getVertexKey(q, r+1))!],
      q, r 
    });
  }
  
  // Check Type B: (q,r), (q+1, r-1), (q+1, r)
  if (verticesMap.has(getVertexKey(q+1, r-1)) && verticesMap.has(getVertexKey(q+1, r))) {
    tempTriangles.push({
      pts: [pt, verticesMap.get(getVertexKey(q+1, r-1))!, verticesMap.get(getVertexKey(q+1, r))!],
      q, r
    });
  }
});

// Calculate centroids and assign sectors
tempTriangles.forEach((t, idx) => {
  const center = {
    x: (t.pts[0].x + t.pts[1].x + t.pts[2].x) / 3,
    y: (t.pts[0].y + t.pts[1].y + t.pts[2].y) / 3,
  };
  
  // Determine Sector (0-5) based on angle
  // 0 deg is Right. SVG Y is down.
  // Sector 0: Bottom-Right? 
  // Let's align visually with the image.
  // We want 6 wedges.
  let angle = Math.atan2(center.y, center.x) * (180 / Math.PI); // -180 to 180
  if (angle < 0) angle += 360;
  
  // Map 0-360 to 0-5. 
  // Segments: 0-60, 60-120, 120-180, 180-240, 240-300, 300-360
  // Note: Y is down, so +Y is "Down".
  // 0 is Right. 90 is Down. 
  // Image colors:
  // Top (Red): -90 deg -> 270 deg.
  // Top-Right (Purple): -30 deg -> 330 deg.
  // Bot-Right (Green): 30 deg.
  // Bot (Blue): 90 deg.
  // Bot-Left (Yellow): 150 deg.
  // Top-Left (Cyan): 210 deg.
  
  // Shift angle by +30 deg so sector 0 starts at -30 (330)?
  // Let's use simple Math.floor(angle / 60).
  // 0 (0-60): Bot-Right (Green?)
  // 1 (60-120): Bot (Blue)
  // 2 (120-180): Bot-Left (Yellow)
  // 3 (180-240): Top-Left (Cyan)
  // 4 (240-300): Top (Red)
  // 5 (300-360): Top-Right (Purple)
  
  const sector = Math.floor(angle / 60) % 6;

  trianglesList.push({
    id: idx,
    points: t.pts as [Point, Point, Point],
    center,
    sector
  });
});

// 3. Generate Rotators
// Rotators are vertices with distance < N (strictly inside)
// Distance in hex grid: max(|q|, |r|, |s|)
for (let q = -(N-1); q <= (N-1); q++) {
  for (let r = -(N-1); r <= (N-1); r++) {
    const s = -q - r;
    if (Math.abs(s) <= (N-1)) {
      const center = getPt(q, r);
      
      // Find the 6 triangles that share this vertex
      // This is brute-force but safe (54 tris is small)
      // A triangle shares this vertex if one of its points is approx equal
      const touchingTris = trianglesList.filter(t => 
        t.points.some(p => Math.abs(p.x - center.x) < 0.1 && Math.abs(p.y - center.y) < 0.1)
      );

      // Verify we have 6 triangles
      if (touchingTris.length === 6) {
        // Sort them clockwise around the center
        touchingTris.sort((a, b) => {
          const angA = Math.atan2(a.center.y - center.y, a.center.x - center.x);
          const angB = Math.atan2(b.center.y - center.y, b.center.x - center.x);
          return angA - angB;
        });

        rotatorsList.push({
          id: rotatorsList.length,
          center,
          triangleIds: touchingTris.map(t => t.id)
        });
      }
    }
  }
}

// ==========================================
// GAME LOGIC EXPORTS
// ==========================================

export const GEOMETRY = {
  triangles: trianglesList,
  rotators: rotatorsList
};

export const createTargetHexGrid = (): HexGridState => {
  // Map sector index to specific colors to match the image
  // 0 (0-60): Bot-Right -> GREEN
  // 1 (60-120): Bot -> BLUE
  // 2 (120-180): Bot-Left -> YELLOW
  // 3 (180-240): Top-Left -> CYAN
  // 4 (240-300): Top -> RED
  // 5 (300-360): Top-Right -> PURPLE
  
  const sectorColors = [
    HexColor.GREEN,
    HexColor.BLUE,
    HexColor.YELLOW,
    HexColor.CYAN,
    HexColor.RED,
    HexColor.PURPLE,
  ];

  // Initialize grid with target colors
  const grid = new Array(trianglesList.length).fill(HexColor.RED);
  trianglesList.forEach(t => {
    grid[t.id] = sectorColors[t.sector];
  });
  
  return grid;
};

export const rotateHexRegion = (grid: HexGridState, rotatorId: number): HexGridState => {
  const newGrid = [...grid];
  const indices = rotatorsList[rotatorId].triangleIds;
  
  // Clockwise shift
  // [0, 1, 2, 3, 4, 5] -> [5, 0, 1, 2, 3, 4]
  const lastVal = newGrid[indices[indices.length - 1]];
  for (let i = indices.length - 1; i > 0; i--) {
    newGrid[indices[i]] = newGrid[indices[i - 1]];
  }
  newGrid[indices[0]] = lastVal;
  
  return newGrid;
};

export const scrambleHexGrid = (moves = 30): HexGridState => {
  let grid = createTargetHexGrid();
  const numRotators = rotatorsList.length;
  
  for (let i = 0; i < moves; i++) {
    const r = Math.floor(Math.random() * numRotators);
    grid = rotateHexRegion(grid, r);
  }
  return grid;
};

export const checkHexWin = (grid: HexGridState, target: HexGridState): boolean => {
  return grid.every((color, i) => color === target[i]);
};
