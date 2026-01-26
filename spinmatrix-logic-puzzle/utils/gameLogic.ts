import { BlockColor, Difficulty, GridState } from '../types';

/**
 * Creates a solved grid pattern (Quadrants)
 * Top-Left: Red, Top-Right: Yellow
 * Bottom-Left: Blue, Bottom-Right: Green
 */
export const createTargetGrid = (size: Difficulty): GridState => {
  const grid: GridState = [];
  const mid = size / 2;

  for (let r = 0; r < size; r++) {
    const row: BlockColor[] = [];
    for (let c = 0; c < size; c++) {
      if (r < mid && c < mid) row.push(BlockColor.RED);
      else if (r < mid && c >= mid) row.push(BlockColor.YELLOW);
      else if (r >= mid && c < mid) row.push(BlockColor.BLUE);
      else row.push(BlockColor.GREEN);
    }
    grid.push(row);
  }
  return grid;
};

/**
 * Creates a deep copy of the grid
 */
export const copyGrid = (grid: GridState): GridState => {
  return grid.map(row => [...row]);
};

/**
 * Rotates the 2x2 block at the intersection (row, col) clockwise.
 * The intersection (row, col) affects cells:
 * (row, col), (row, col+1)
 * (row+1, col), (row+1, col+1)
 */
export const rotateSubgrid = (grid: GridState, row: number, col: number): GridState => {
  const newGrid = copyGrid(grid);
  
  // Coordinates of the 4 cells
  const tl = newGrid[row][col];         // Top-Left
  const tr = newGrid[row][col + 1];     // Top-Right
  const br = newGrid[row + 1][col + 1]; // Bottom-Right
  const bl = newGrid[row + 1][col];     // Bottom-Left

  // Clockwise rotation
  newGrid[row][col + 1] = tl;     // TL -> TR
  newGrid[row + 1][col + 1] = tr; // TR -> BR
  newGrid[row + 1][col] = br;     // BR -> BL
  newGrid[row][col] = bl;         // BL -> TL

  return newGrid;
};

/**
 * Scrambles the grid by performing random valid rotations.
 * This ensures the puzzle is always solvable.
 */
export const scrambleGrid = (grid: GridState, size: Difficulty, moves: number = 20): GridState => {
  let currentGrid = copyGrid(grid);
  const maxIdx = size - 1; 

  for (let i = 0; i < moves; i++) {
    const r = Math.floor(Math.random() * maxIdx);
    const c = Math.floor(Math.random() * maxIdx);
    currentGrid = rotateSubgrid(currentGrid, r, c);
  }
  
  return currentGrid;
};

/**
 * Checks if two grids are identical
 */
export const checkWin = (gridA: GridState, gridB: GridState): boolean => {
  if (gridA.length !== gridB.length) return false;
  for (let i = 0; i < gridA.length; i++) {
    for (let j = 0; j < gridA[i].length; j++) {
      if (gridA[i][j] !== gridB[i][j]) return false;
    }
  }
  return true;
};