import React from 'react';
import { FlipGridState, FlipState } from '../types';

interface FlipBoardProps {
  grid: FlipGridState;
  onTileClick: (row: number, col: number) => void;
  isInteractive: boolean;
  isSmall?: boolean;
}

const FlipBoard: React.FC<FlipBoardProps> = ({ 
  grid, 
  onTileClick, 
  isInteractive,
  isSmall = false
}) => {
  const size = grid.length;

  return (
    <div 
      className={`
        grid bg-slate-800 rounded-lg border-2 border-slate-600 shadow-xl mx-auto
        ${isSmall 
          ? 'gap-0.5 p-1 w-full max-w-[260px]' // Increased from 180px fixed to flexible max 260px
          : 'gap-1.5 p-3 w-full max-w-[480px]' // Increased from 400px to 480px, larger gap
        }
      `}
      style={{
        gridTemplateColumns: `repeat(${size}, minmax(0, 1fr))`,
        aspectRatio: '1/1',
      }}
    >
      {grid.map((row, r) => (
        row.map((state, c) => {
          const isDark = state === FlipState.DARK;
          return (
            <button
              key={`${r}-${c}`}
              onClick={() => isInteractive && onTileClick(r, c)}
              disabled={!isInteractive}
              className={`
                relative rounded-sm transition-all duration-300 overflow-hidden
                ${isDark 
                  ? 'bg-slate-900 shadow-[inset_0_0_10px_rgba(0,0,0,0.8)] border border-slate-700' 
                  : 'bg-slate-200 shadow-[inset_0_0_5px_rgba(255,255,255,0.8)] border border-white'
                }
                ${isInteractive ? 'hover:scale-95 active:scale-90 cursor-pointer' : 'cursor-default'}
              `}
            >
              {/* Glossy overlay */}
              <div className={`absolute inset-0 bg-gradient-to-br from-white/20 to-transparent pointer-events-none ${isDark ? 'opacity-10' : 'opacity-40'}`} />
            </button>
          );
        })
      ))}
    </div>
  );
};

export default FlipBoard;