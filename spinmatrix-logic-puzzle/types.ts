export enum BlockColor {
  RED = 'RED',
  BLUE = 'BLUE',
  GREEN = 'GREEN',
  YELLOW = 'YELLOW',
}

// Map logical colors to Tailwind classes
export const COLOR_MAP: Record<BlockColor, string> = {
  [BlockColor.RED]: 'bg-red-500 shadow-[inset_0_0_10px_rgba(0,0,0,0.3)]',
  [BlockColor.BLUE]: 'bg-blue-500 shadow-[inset_0_0_10px_rgba(0,0,0,0.3)]',
  [BlockColor.GREEN]: 'bg-green-500 shadow-[inset_0_0_10px_rgba(0,0,0,0.3)]',
  [BlockColor.YELLOW]: 'bg-yellow-400 shadow-[inset_0_0_10px_rgba(0,0,0,0.3)]',
};

export type GridState = BlockColor[][];

export type Difficulty = 4 | 6;

export interface GameState {
  grid: GridState;
  target: GridState;
  difficulty: Difficulty;
  moves: number;
  isSolved: boolean;
  isPlaying: boolean;
  startTime: number | null;
  elapsedTime: number; // in seconds
}