import { SphereColor, SphereGridState } from '../types';

const SIZE = 5;

// Create a solved grid: Row 0 = Color A, Row 1 = Color B, etc.
export const createSolvedSphereGrid = (): SphereGridState => {
  const colors = [
    SphereColor.CYAN,
    SphereColor.MAGENTA,
    SphereColor.YELLOW,
    SphereColor.BLUE,
    SphereColor.GREEN,
  ];
  
  const grid: SphereGridState = [];
  for (let r = 0; r < SIZE; r++) {
    const row: SphereColor[] = [];
    for (let c = 0; c < SIZE; c++) {
      row.push(colors[r]);
    }
    grid.push(row);
  }
  return grid;
};

export const copySphereGrid = (grid: SphereGridState): SphereGridState => {
  return grid.map(row => [...row]);
};

// Shift Row: direction 1 = Right, -1 = Left
export const shiftRow = (grid: SphereGridState, rowIndex: number, direction: 1 | -1): SphereGridState => {
  const newGrid = copySphereGrid(grid);
  const row = newGrid[rowIndex];
  
  if (direction === 1) {
    // Right: Last becomes first
    const last = row.pop()!;
    row.unshift(last);
  } else {
    // Left: First becomes last
    const first = row.shift()!;
    row.push(first);
  }
  return newGrid;
};

// Shift Col: direction 1 = Down, -1 = Up
export const shiftCol = (grid: SphereGridState, colIndex: number, direction: 1 | -1): SphereGridState => {
  const newGrid = copySphereGrid(grid);
  
  if (direction === 1) {
    // Down
    const lastVal = newGrid[SIZE - 1][colIndex];
    for (let r = SIZE - 1; r > 0; r--) {
      newGrid[r][colIndex] = newGrid[r - 1][colIndex];
    }
    newGrid[0][colIndex] = lastVal;
  } else {
    // Up
    const firstVal = newGrid[0][colIndex];
    for (let r = 0; r < SIZE - 1; r++) {
      newGrid[r][colIndex] = newGrid[r + 1][colIndex];
    }
    newGrid[SIZE - 1][colIndex] = firstVal;
  }
  
  return newGrid;
};

export const scrambleSphereGrid = (moves: number = 30): SphereGridState => {
  let grid = createSolvedSphereGrid();
  
  for (let i = 0; i < moves; i++) {
    const isRow = Math.random() > 0.5;
    const index = Math.floor(Math.random() * SIZE);
    const dir = Math.random() > 0.5 ? 1 : -1;
    
    if (isRow) {
      grid = shiftRow(grid, index, dir);
    } else {
      grid = shiftCol(grid, index, dir);
    }
  }
  return grid;
};

// Check if every row consists of a single unique color (and 5 distinct rows)
export const checkSphereWin = (grid: SphereGridState): boolean => {
  for (let r = 0; r < SIZE; r++) {
    const firstColor = grid[r][0];
    for (let c = 1; c < SIZE; c++) {
      if (grid[r][c] !== firstColor) return false;
    }
  }
  return true;
};