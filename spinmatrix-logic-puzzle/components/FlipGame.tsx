import React, { useState, useEffect, useRef, useCallback } from 'react';
import { ArrowLeft, BrainCircuit, Play, RotateCcw, Clock, Move, Sparkles, Grid3x3, RefreshCw } from 'lucide-react';
import FlipBoard from './FlipBoard';
import { createEmptyFlipGrid, generateFlipTarget, applyFlipMove, checkFlipWin } from '../utils/flipLogic';
import { FlipDifficulty } from '../types';

interface FlipGameProps {
  onBack: () => void;
}

const FlipGame: React.FC<FlipGameProps> = ({ onBack }) => {
  const [difficulty, setDifficulty] = useState<FlipDifficulty>('SYMMETRIC');
  const [playerGrid, setPlayerGrid] = useState(() => createEmptyFlipGrid());
  const [targetGrid, setTargetGrid] = useState(() => createEmptyFlipGrid()); // Placeholder
  
  const [moves, setMoves] = useState(0);
  const [elapsedTime, setElapsedTime] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [isSolved, setIsSolved] = useState(false);
  
  const timerRef = useRef<number | null>(null);

  // Initialize Logic
  const initGame = useCallback((diff: FlipDifficulty, startPlaying: boolean) => {
    if (startPlaying) {
      // Keep the same target that was shown in preview - don't regenerate!
      // Only reset the player board to empty
      setPlayerGrid(createEmptyFlipGrid());

      setIsPlaying(true);
      setMoves(0);
      setElapsedTime(0);
      setIsSolved(false);

      if (timerRef.current) clearInterval(timerRef.current);
      timerRef.current = window.setInterval(() => {
        setElapsedTime(prev => prev + 1);
      }, 1000);
    } else {
      // Preview Mode - generate new target only in preview mode
      setPlayerGrid(createEmptyFlipGrid());
      // Show a sample target for aesthetic
      setTargetGrid(generateFlipTarget(diff));

      setIsPlaying(false);
      setIsSolved(false);
      if (timerRef.current) clearInterval(timerRef.current);
      timerRef.current = null;
    }
  }, []);

  // Initial load
  useEffect(() => {
    initGame('SYMMETRIC', false);
    return () => {
      if (timerRef.current) clearInterval(timerRef.current);
    };
  }, []);

  const handleDifficultySwitch = (diff: FlipDifficulty) => {
    setDifficulty(diff);
    initGame(diff, false);
  };

  const handleTileClick = (r: number, c: number) => {
    if (!isPlaying || isSolved) return;
    
    setPlayerGrid(prev => {
      const next = applyFlipMove(prev, r, c);
      if (checkFlipWin(next, targetGrid)) {
        setIsSolved(true);
        setIsPlaying(false);
        if (timerRef.current) clearInterval(timerRef.current);
        timerRef.current = null;
      }
      return next;
    });
    setMoves(p => p + 1);
  };

  const formatTime = (seconds: number) => {
    const m = Math.floor(seconds / 60);
    const s = seconds % 60;
    return `${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`;
  };

  return (
    <div className="w-full flex flex-col items-center gap-6 animate-in fade-in slide-in-from-bottom-4 duration-500 relative">
      
      {/* Header */}
      <header className="w-full flex items-center justify-between max-w-5xl px-4">
        <button 
          onClick={onBack}
          className="flex items-center gap-2 px-4 py-2 rounded-lg bg-slate-800/50 hover:bg-slate-700 text-slate-300 hover:text-white transition-all border border-slate-700"
        >
          <ArrowLeft size={20} />
          <span className="hidden sm:inline">Back</span>
        </button>

        <div className="flex items-center gap-3 text-cyan-400">
          <BrainCircuit size={32} />
          <h1 className="text-2xl md:text-3xl font-display font-bold tracking-tighter bg-clip-text text-transparent bg-gradient-to-r from-emerald-400 to-teal-400">
            FlipTile
          </h1>
        </div>
        
        <div className="w-[80px]" /> 
      </header>

      <div className="flex flex-col md:flex-row gap-8 md:gap-16 items-start w-full max-w-5xl justify-center px-4">
        
        {/* Left: Player Board */}
        <div className="flex-1 w-full flex flex-col items-center">
            {isSolved && (
              <div className="absolute inset-0 z-50 flex flex-col items-center justify-center bg-black/60 backdrop-blur-sm rounded-xl animate-in fade-in zoom-in duration-500">
                <div className="text-6xl mb-4 animate-bounce">🎉</div>
                <h2 className="text-4xl font-display font-bold text-white mb-2 drop-shadow-[0_0_10px_rgba(34,211,238,0.8)]">
                  SOLVED!
                </h2>
                <div className="flex gap-4 text-xl text-cyan-300">
                  <span className="flex items-center gap-1"><Sparkles size={20}/> {moves} Moves</span>
                  <span className="flex items-center gap-1"><Sparkles size={20}/> {elapsedTime}s</span>
                </div>
              </div>
            )}

            <div className="relative w-full flex justify-center p-2">
                <FlipBoard 
                    grid={playerGrid}
                    onTileClick={handleTileClick}
                    isInteractive={isPlaying && !isSolved}
                />
            </div>

            <div className="mt-6 text-slate-500 text-sm text-center max-w-md bg-slate-900/50 p-4 rounded-lg border border-slate-700/50">
                Clicking a block toggles itself and its adjacent neighbors. 
                <br/>
                <span className="text-emerald-400 font-bold block mt-1">Match the Target Pattern shown on the right.</span>
            </div>
        </div>

        {/* Right: Info Panel & Target */}
        <div className="w-full max-w-sm flex flex-col gap-6">
             
             {/* Target Preview */}
             <div className="bg-slate-800/60 p-5 rounded-2xl border border-slate-700 flex flex-col items-center gap-4">
                <div className="flex items-center gap-2 text-sm font-bold text-slate-400 uppercase tracking-widest">
                    <Grid3x3 size={18}/> Target Pattern
                </div>
                {/* Target Board Container - ensuring it takes appropriate width */}
                <div className="w-full flex justify-center pointer-events-none opacity-100 shadow-2xl">
                    <FlipBoard grid={targetGrid} onTileClick={() => {}} isInteractive={false} isSmall={true} />
                </div>
             </div>

             {/* Stats */}
             <div className="grid grid-cols-2 gap-3">
                <div className="bg-slate-900/60 border border-slate-700 p-3 rounded-xl flex flex-col items-center">
                    <span className="text-slate-400 text-xs uppercase font-bold flex items-center gap-1 mb-1"><Clock size={12}/> Time</span>
                    <span className="text-2xl font-display text-white">{formatTime(elapsedTime)}</span>
                </div>
                <div className="bg-slate-900/60 border border-slate-700 p-3 rounded-xl flex flex-col items-center">
                    <span className="text-slate-400 text-xs uppercase font-bold flex items-center gap-1 mb-1"><Move size={12}/> Moves</span>
                    <span className="text-2xl font-display text-white">{moves}</span>
                </div>
             </div>

             {/* Difficulty Selector */}
             <div className="bg-slate-800/40 p-1 rounded-lg flex border border-slate-700/50">
                <button
                    onClick={() => !isPlaying && handleDifficultySwitch('SYMMETRIC')}
                    disabled={isPlaying}
                    className={`flex-1 py-2 text-xs md:text-sm font-bold rounded-md transition-all flex items-center justify-center gap-2
                        ${difficulty === 'SYMMETRIC' ? 'bg-emerald-600 text-white shadow-lg' : 'text-slate-400 hover:text-white'}
                        disabled:opacity-50
                    `}
                >
                    Symmetric (Simple)
                </button>
                <button
                    onClick={() => !isPlaying && handleDifficultySwitch('ASYMMETRIC')}
                    disabled={isPlaying}
                    className={`flex-1 py-2 text-xs md:text-sm font-bold rounded-md transition-all flex items-center justify-center gap-2
                        ${difficulty === 'ASYMMETRIC' ? 'bg-teal-600 text-white shadow-lg' : 'text-slate-400 hover:text-white'}
                        disabled:opacity-50
                    `}
                >
                    Asymmetric (Hard)
                </button>
             </div>

             {/* Main Action Buttons */}
             {!isPlaying && !isSolved ? (
                <button
                    onClick={() => initGame(difficulty, true)}
                    className="w-full py-4 bg-gradient-to-r from-emerald-600 to-teal-600 hover:from-emerald-500 hover:to-teal-500 text-white font-display font-bold text-lg rounded-xl shadow-lg transition-all flex items-center justify-center gap-2"
                >
                    <Play fill="currentColor" /> START CHALLENGE
                </button>
             ) : (
                <button
                    onClick={() => initGame(difficulty, false)}
                    className="w-full py-3 bg-slate-700 hover:bg-slate-600 text-white font-bold rounded-xl shadow-lg transition-all flex items-center justify-center gap-2"
                >
                    <RotateCcw size={18} /> {isSolved ? 'PLAY AGAIN' : 'RESET'}
                </button>
             )}
        </div>

      </div>
    </div>
  );
};

export default FlipGame;