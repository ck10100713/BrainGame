import React from 'react';
import { ChevronUp, ChevronDown, ChevronLeft, ChevronRight } from 'lucide-react';
import { SphereGridState, SPHERE_COLOR_MAP, BLIND_SPHERE_STYLE } from '../types';

interface SphereBoardProps {
  grid: SphereGridState;
  onShiftRow: (rowIndex: number, dir: 1 | -1) => void;
  onShiftCol: (colIndex: number, dir: 1 | -1) => void;
  isInteractive: boolean;
  isBlind: boolean; // If true, hide colors
}

const SphereBoard: React.FC<SphereBoardProps> = ({ 
  grid, 
  onShiftRow, 
  onShiftCol, 
  isInteractive,
  isBlind
}) => {
  const size = 5;

  return (
    <div className="flex flex-col items-center gap-2">
      
      {/* Top Column Controls */}
      <div className="flex gap-2 mb-1 pl-10 pr-10">
        {Array.from({ length: size }).map((_, i) => (
          <button
            key={`col-up-${i}`}
            onClick={() => onShiftCol(i, -1)}
            disabled={!isInteractive}
            className="w-12 h-8 flex items-center justify-center text-slate-500 hover:text-cyan-400 disabled:opacity-30 disabled:hover:text-slate-500 transition-colors"
          >
            <ChevronUp size={24} />
          </button>
        ))}
      </div>

      <div className="flex gap-2">
        {/* Left Row Controls */}
        <div className="flex flex-col gap-2 justify-center mr-1">
          {Array.from({ length: size }).map((_, i) => (
            <button
              key={`row-left-${i}`}
              onClick={() => onShiftRow(i, -1)}
              disabled={!isInteractive}
              className="w-8 h-12 flex items-center justify-center text-slate-500 hover:text-cyan-400 disabled:opacity-30 disabled:hover:text-slate-500 transition-colors"
            >
              <ChevronLeft size={24} />
            </button>
          ))}
        </div>

        {/* The Grid */}
        <div className="grid grid-cols-5 gap-2 bg-slate-900/50 p-3 rounded-2xl border border-slate-700 shadow-2xl">
          {grid.map((row, r) => (
            row.map((color, c) => (
              <div
                key={`${r}-${c}`}
                className={`
                  w-12 h-12 rounded-full transition-all duration-300
                  ${isBlind ? BLIND_SPHERE_STYLE : SPHERE_COLOR_MAP[color]}
                `}
              />
            ))
          ))}
        </div>

        {/* Right Row Controls */}
        <div className="flex flex-col gap-2 justify-center ml-1">
          {Array.from({ length: size }).map((_, i) => (
            <button
              key={`row-right-${i}`}
              onClick={() => onShiftRow(i, 1)}
              disabled={!isInteractive}
              className="w-8 h-12 flex items-center justify-center text-slate-500 hover:text-cyan-400 disabled:opacity-30 disabled:hover:text-slate-500 transition-colors"
            >
              <ChevronRight size={24} />
            </button>
          ))}
        </div>
      </div>

      {/* Bottom Column Controls */}
      <div className="flex gap-2 mt-1 pl-10 pr-10">
        {Array.from({ length: size }).map((_, i) => (
          <button
            key={`col-down-${i}`}
            onClick={() => onShiftCol(i, 1)}
            disabled={!isInteractive}
            className="w-12 h-8 flex items-center justify-center text-slate-500 hover:text-cyan-400 disabled:opacity-30 disabled:hover:text-slate-500 transition-colors"
          >
            <ChevronDown size={24} />
          </button>
        ))}
      </div>

    </div>
  );
};

export default SphereBoard;