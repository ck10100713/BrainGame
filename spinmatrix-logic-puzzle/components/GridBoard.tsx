import React from 'react';
import { RotateCw } from 'lucide-react';
import { BlockColor, COLOR_MAP, GridState } from '../types';

interface GridBoardProps {
  grid: GridState;
  onRotate: (row: number, col: number) => void;
  isInteractive: boolean;
  showRotators?: boolean;
}

const GridBoard: React.FC<GridBoardProps> = ({ 
  grid, 
  onRotate, 
  isInteractive, 
  showRotators = true 
}) => {
  const size = grid.length;
  
  // Calculate percentage positions for rotators
  // The grid has 'size' cells. Rotators are between cells.
  // There are size-1 rotators in each direction.
  const rotatorIndices = Array.from({ length: size - 1 }, (_, i) => i);

  return (
    <div className="relative p-2 bg-slate-800/50 rounded-xl border border-slate-700 shadow-2xl backdrop-blur-sm">
      {/* The Color Grid */}
      <div 
        className="grid gap-1 bg-slate-900 p-1 rounded-lg border-2 border-slate-600"
        style={{
          gridTemplateColumns: `repeat(${size}, minmax(0, 1fr))`,
          aspectRatio: '1/1',
        }}
      >
        {grid.map((row, rIndex) => (
          row.map((color, cIndex) => (
            <div
              key={`${rIndex}-${cIndex}`}
              className={`
                w-full h-full rounded-sm transition-colors duration-300
                ${COLOR_MAP[color]}
                border border-white/10
              `}
            />
          ))
        ))}
      </div>

      {/* The Rotator Layer (Overlay) */}
      {showRotators && rotatorIndices.map((r) => (
        rotatorIndices.map((c) => {
          // Calculate position as percentage
          // Each cell is roughly (100 / size)%
          // The intersection is at (index + 1) * cell_size
          const top = ((r + 1) / size) * 100;
          const left = ((c + 1) / size) * 100;

          return (
            <button
              key={`rot-${r}-${c}`}
              onClick={() => isInteractive && onRotate(r, c)}
              disabled={!isInteractive}
              className={`
                absolute w-8 h-8 -ml-4 -mt-4 
                flex items-center justify-center
                rounded-full 
                bg-slate-900/80 border border-cyan-500/50
                text-cyan-400 hover:text-white hover:bg-cyan-600
                transition-all duration-200 
                hover:scale-110 active:scale-95
                disabled:opacity-0 disabled:cursor-default
                z-10 shadow-[0_0_10px_rgba(34,211,238,0.3)]
              `}
              style={{ top: `${top}%`, left: `${left}%` }}
              aria-label={`Rotate at row ${r} col ${c}`}
            >
              <RotateCw size={16} strokeWidth={3} />
            </button>
          );
        })
      ))}
    </div>
  );
};

export default GridBoard;