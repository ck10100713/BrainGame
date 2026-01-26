// ============================================
// BrainGame - Shared Type Definitions
// ============================================

// Game Identifiers
export type GameId = 'SPIN_MATRIX' | 'SPHERE_SHIFT' | 'HEX_LOGIC';

// Base Game State Interface
export interface BaseGameState {
  moves: number;
  isSolved: boolean;
  isPlaying: boolean;
  elapsedTime: number;
}

// ============================================
// SpinMatrix Game Types
// ============================================

export enum BlockColor {
  RED = 'RED',
  BLUE = 'BLUE',
  GREEN = 'GREEN',
  YELLOW = 'YELLOW',
}

// ============================================
// SphereShift Game Types
// ============================================

export enum SphereColor {
  CYAN = 'CYAN',
  MAGENTA = 'MAGENTA',
  YELLOW = 'YELLOW',
  BLUE = 'BLUE',
  GREEN = 'GREEN',
}

// ============================================
// HexLogic Game Types
// ============================================

export enum HexColor {
  RED = 'RED',        // Top
  PURPLE = 'PURPLE',  // Top-Right
  GREEN = 'GREEN',    // Bot-Right
  BLUE = 'BLUE',      // Bot
  YELLOW = 'YELLOW',  // Bot-Left
  CYAN = 'CYAN',      // Top-Left
}

// ============================================
// Color Mappings & Styles
// ============================================

// Map logical colors to Tailwind classes
export const COLOR_MAP: Record<BlockColor, string> = {
  [BlockColor.RED]: 'bg-red-500 shadow-[inset_0_0_10px_rgba(0,0,0,0.3)]',
  [BlockColor.BLUE]: 'bg-blue-500 shadow-[inset_0_0_10px_rgba(0,0,0,0.3)]',
  [BlockColor.GREEN]: 'bg-green-500 shadow-[inset_0_0_10px_rgba(0,0,0,0.3)]',
  [BlockColor.YELLOW]: 'bg-yellow-400 shadow-[inset_0_0_10px_rgba(0,0,0,0.3)]',
};

// 3D Sphere Gradients
export const SPHERE_COLOR_MAP: Record<SphereColor, string> = {
  [SphereColor.CYAN]: 'bg-[radial-gradient(circle_at_30%_30%,_#22d3ee,_#0891b2,_#164e63)] shadow-[0_0_15px_rgba(34,211,238,0.4)]',
  [SphereColor.MAGENTA]: 'bg-[radial-gradient(circle_at_30%_30%,_#e879f9,_#c026d3,_#701a75)] shadow-[0_0_15px_rgba(232,121,249,0.4)]',
  [SphereColor.YELLOW]: 'bg-[radial-gradient(circle_at_30%_30%,_#facc15,_#ca8a04,_#713f12)] shadow-[0_0_15px_rgba(250,204,21,0.4)]',
  [SphereColor.BLUE]: 'bg-[radial-gradient(circle_at_30%_30%,_#3b82f6,_#2563eb,_#1e3a8a)] shadow-[0_0_15px_rgba(59,130,246,0.4)]',
  [SphereColor.GREEN]: 'bg-[radial-gradient(circle_at_30%_30%,_#4ade80,_#16a34a,_#14532d)] shadow-[0_0_15px_rgba(74,222,128,0.4)]',
};

export const BLIND_SPHERE_STYLE = 'bg-[radial-gradient(circle_at_30%_30%,_#94a3b8,_#475569,_#1e293b)] shadow-[0_0_10px_rgba(148,163,184,0.2)] border border-slate-600';

export const HEX_COLOR_MAP: Record<HexColor, string> = {
  [HexColor.RED]: '#ef4444',
  [HexColor.PURPLE]: '#a855f7',
  [HexColor.GREEN]: '#22c55e',
  [HexColor.BLUE]: '#3b82f6',
  [HexColor.YELLOW]: '#eab308',
  [HexColor.CYAN]: '#06b6d4',
};

// ============================================
// Grid State Types
// ============================================

export type GridState = BlockColor[][];           // SpinMatrix grid
export type SphereGridState = SphereColor[][];    // SphereShift grid
export type HexGridState = HexColor[];            // HexLogic - flat array of 54 triangles

// ============================================
// Difficulty Settings
// ============================================

export type Difficulty = 4 | 6;                   // SpinMatrix: 4x4 or 6x6
export type SphereDifficulty = 'STANDARD' | 'BLIND';
export type HexDifficulty = 'NORMAL';

// ============================================
// Game State Interfaces
// ============================================

// SpinMatrix specific game state
export interface SpinMatrixGameState extends BaseGameState {
  grid: GridState;
  target: GridState;
  difficulty: Difficulty;
  startTime: number | null;
}

// SphereShift specific game state
export interface SphereShiftGameState extends BaseGameState {
  grid: SphereGridState;
  difficulty: SphereDifficulty;
  attempts: number;
}

// HexLogic specific game state
export interface HexLogicGameState extends BaseGameState {
  grid: HexGridState;
  target: HexGridState;
}

// Legacy GameState (for backward compatibility)
export interface GameState {
  grid: GridState;
  target: GridState;
  difficulty: Difficulty;
  moves: number;
  isSolved: boolean;
  isPlaying: boolean;
  startTime: number | null;
  elapsedTime: number;
}