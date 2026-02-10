import { FlipGridState, FlipState } from '../types';

export const GRID_SIZE = 7;

// Create an all-light (white) grid
export const createEmptyFlipGrid = (): FlipGridState => {
  return Array(GRID_SIZE).fill(null).map(() => Array(GRID_SIZE).fill(FlipState.LIGHT));
};

export const copyFlipGrid = (grid: FlipGridState): FlipGridState => {
  return grid.map(row => [...row]);
};

// Toggle a single cell state
const toggleState = (s: FlipState): FlipState => {
  return s === FlipState.LIGHT ? FlipState.DARK : FlipState.LIGHT;
};

// Perform the move: Toggle (r,c) and neighbors (r+/-1, c+/-1)
export const applyFlipMove = (grid: FlipGridState, row: number, col: number): FlipGridState => {
  const newGrid = copyFlipGrid(grid);
  const moves = [
    [0, 0],   // Self
    [0, 1],   // Right
    [0, -1],  // Left
    [1, 0],   // Down
    [-1, 0]   // Up
  ];

  for (const [dr, dc] of moves) {
    const nr = row + dr;
    const nc = col + dc;
    if (nr >= 0 && nr < GRID_SIZE && nc >= 0 && nc < GRID_SIZE) {
      newGrid[nr][nc] = toggleState(newGrid[nr][nc]);
    }
  }
  return newGrid;
};

// Generate a target pattern
// To ensure solvability, we start with an empty grid and apply random moves.
// For Symmetric difficulty, we mirror the moves.
export const generateFlipTarget = (difficulty: 'SYMMETRIC' | 'ASYMMETRIC', seedMoves: number = 15): FlipGridState => {
  let grid = createEmptyFlipGrid();
  
  // We simulate clicks on an empty board to create the pattern.
  // This guarantees the pattern is reachable from an empty board.
  
  for (let i = 0; i < seedMoves; i++) {
    const r = Math.floor(Math.random() * GRID_SIZE);
    const c = Math.floor(Math.random() * GRID_SIZE);
    
    if (difficulty === 'ASYMMETRIC') {
      grid = applyFlipMove(grid, r, c);
    } else {
      // Symmetric: Apply move to 4 quadrants to maintain symmetry
      // This ensures the resulting pattern looks designed/symmetric
      grid = applyFlipMove(grid, r, c);
      grid = applyFlipMove(grid, r, GRID_SIZE - 1 - c); // Horizontal Mirror
      grid = applyFlipMove(grid, GRID_SIZE - 1 - r, c); // Vertical Mirror
      grid = applyFlipMove(grid, GRID_SIZE - 1 - r, GRID_SIZE - 1 - c); // Diagonal Mirror
    }
  }
  
  return grid;
};

export const checkFlipWin = (current: FlipGridState, target: FlipGridState): boolean => {
  for (let r = 0; r < GRID_SIZE; r++) {
    for (let c = 0; c < GRID_SIZE; c++) {
      if (current[r][c] !== target[r][c]) return false;
    }
  }
  return true;
};