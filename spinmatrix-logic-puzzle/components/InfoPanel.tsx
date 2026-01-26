import React from 'react';
import { Clock, Move, Trophy, RotateCcw, Play, Settings } from 'lucide-react';
import GridBoard from './GridBoard';
import { GridState, Difficulty } from '../types';

interface InfoPanelProps {
  target: GridState;
  moves: number;
  time: number;
  difficulty: Difficulty;
  isSolved: boolean;
  isPlaying: boolean;
  onDifficultyChange: (diff: Difficulty) => void;
  onReset: () => void;
  onStart: () => void;
}

const InfoPanel: React.FC<InfoPanelProps> = ({
  target,
  moves,
  time,
  difficulty,
  isSolved,
  isPlaying,
  onDifficultyChange,
  onReset,
  onStart
}) => {
  
  const formatTime = (seconds: number) => {
    const m = Math.floor(seconds / 60);
    const s = seconds % 60;
    return `${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`;
  };

  return (
    <div className="flex flex-col gap-6 w-full max-w-md bg-slate-800/60 p-6 rounded-2xl border border-slate-700/50 shadow-xl backdrop-blur-md">
      
      {/* Stats Header */}
      <div className="grid grid-cols-2 gap-4">
        <div className="bg-slate-900/80 p-4 rounded-xl border border-slate-700 flex flex-col items-center justify-center relative overflow-hidden group">
          <div className="absolute inset-0 bg-red-500/10 opacity-0 group-hover:opacity-100 transition-opacity" />
          <div className="flex items-center gap-2 text-slate-400 text-sm font-semibold mb-1 uppercase tracking-wider">
            <Clock size={16} /> Time
          </div>
          <div className="text-3xl font-display text-white tabular-nums tracking-widest">
            {formatTime(time)}
          </div>
        </div>

        <div className="bg-slate-900/80 p-4 rounded-xl border border-slate-700 flex flex-col items-center justify-center relative overflow-hidden group">
           <div className="absolute inset-0 bg-yellow-500/10 opacity-0 group-hover:opacity-100 transition-opacity" />
          <div className="flex items-center gap-2 text-slate-400 text-sm font-semibold mb-1 uppercase tracking-wider">
            <Move size={16} /> Moves
          </div>
          <div className="text-3xl font-display text-white tabular-nums">
            {moves}
          </div>
        </div>
      </div>

      {/* Target Preview */}
      <div className="flex flex-col gap-2">
        <div className="flex items-center justify-between text-cyan-400 text-xs font-bold uppercase tracking-widest px-1">
          <span>Target Pattern</span>
          <Trophy size={14} />
        </div>
        <div className="w-1/2 mx-auto pointer-events-none opacity-90">
          <GridBoard grid={target} onRotate={() => {}} isInteractive={false} showRotators={false} />
        </div>
      </div>

      <div className="h-px bg-slate-700/50 w-full" />

      {/* Game Controls */}
      <div className="space-y-4">
        {/* Difficulty Switch */}
        <div className="grid grid-cols-2 gap-2 p-1 bg-slate-900 rounded-lg border border-slate-700">
          <button
            onClick={() => !isPlaying && onDifficultyChange(4)}
            disabled={isPlaying}
            className={`
              py-2 text-sm font-bold rounded-md transition-all
              ${difficulty === 4 
                ? 'bg-gradient-to-br from-cyan-600 to-blue-600 text-white shadow-lg' 
                : 'text-slate-400 hover:text-white hover:bg-slate-800'}
              disabled:opacity-50 disabled:cursor-not-allowed
            `}
          >
            4 x 4
          </button>
          <button
            onClick={() => !isPlaying && onDifficultyChange(6)}
            disabled={isPlaying}
            className={`
              py-2 text-sm font-bold rounded-md transition-all
              ${difficulty === 6 
                ? 'bg-gradient-to-br from-purple-600 to-pink-600 text-white shadow-lg' 
                : 'text-slate-400 hover:text-white hover:bg-slate-800'}
              disabled:opacity-50 disabled:cursor-not-allowed
            `}
          >
            6 x 6
          </button>
        </div>

        {/* Action Buttons */}
        {!isPlaying && !isSolved ? (
          <button
            onClick={onStart}
            className="w-full py-4 bg-gradient-to-r from-emerald-500 to-emerald-700 text-white font-display font-bold text-lg rounded-xl shadow-lg hover:brightness-110 active:scale-95 transition-all flex items-center justify-center gap-2"
          >
            <Play fill="currentColor" /> START CHALLENGE
          </button>
        ) : (
          <button
            onClick={onReset}
            className="w-full py-4 bg-slate-700 text-white font-display font-bold text-lg rounded-xl shadow-lg hover:bg-slate-600 active:scale-95 transition-all flex items-center justify-center gap-2"
          >
            <RotateCcw /> {isSolved ? 'PLAY AGAIN' : 'RESET / GIVE UP'}
          </button>
        )}
      </div>

    </div>
  );
};

export default InfoPanel;