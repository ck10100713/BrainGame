import React, { useState, useEffect, useRef, useCallback } from 'react';
import { ArrowLeft, BrainCircuit, Play, RotateCcw, Clock, Move, Sparkles } from 'lucide-react';
import HexBoard from './HexBoard';
import { createTargetHexGrid, scrambleHexGrid, rotateHexRegion, checkHexWin } from '../utils/hexLogic';

interface HexGameProps {
  onBack: () => void;
}

const HexGame: React.FC<HexGameProps> = ({ onBack }) => {
  const [grid, setGrid] = useState(() => createTargetHexGrid());
  const [target] = useState(() => createTargetHexGrid()); // Static target
  const [moves, setMoves] = useState(0);
  const [elapsedTime, setElapsedTime] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [isSolved, setIsSolved] = useState(false);
  
  const timerRef = useRef<number | null>(null);

  const initGame = useCallback((startPlaying: boolean) => {
    if (startPlaying) {
      // Scramble
      const scrambled = scrambleHexGrid(40); // More moves for larger grid
      setGrid(scrambled);
      setIsPlaying(true);
      setMoves(0);
      setElapsedTime(0);
      setIsSolved(false);

      if (timerRef.current) clearInterval(timerRef.current);
      timerRef.current = window.setInterval(() => {
        setElapsedTime(prev => prev + 1);
      }, 1000);
    } else {
      // Reset to target (Preview)
      setGrid(createTargetHexGrid());
      setIsPlaying(false);
      setIsSolved(false);
      if (timerRef.current) clearInterval(timerRef.current);
      timerRef.current = null;
    }
  }, []);

  useEffect(() => {
    return () => {
      if (timerRef.current) clearInterval(timerRef.current);
    };
  }, []);

  const handleRotate = (rotatorId: number) => {
    if (!isPlaying || isSolved) return;
    
    setGrid(prev => {
        const next = rotateHexRegion(prev, rotatorId);
        if (checkHexWin(next, target)) {
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
          <h1 className="text-2xl md:text-3xl font-display font-bold tracking-tighter bg-clip-text text-transparent bg-gradient-to-r from-purple-400 to-pink-400">
            HexLogic
          </h1>
        </div>
        
        <div className="w-[80px]" /> 
      </header>

      <div className="flex flex-col md:flex-row gap-8 md:gap-16 items-start w-full max-w-5xl justify-center">
        
        {/* Left: Game Board */}
        <div className="flex-1 flex flex-col items-center">
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

            <div className="relative p-10 bg-slate-900/40 rounded-full border border-slate-800 shadow-2xl">
                <HexBoard 
                    grid={grid}
                    onRotate={handleRotate}
                    isInteractive={isPlaying && !isSolved}
                    scale={1.3}
                />
            </div>

            <div className="mt-6 text-slate-500 text-sm text-center max-w-sm">
                Click intersections (gaps) to rotate the surrounding 6 petals clockwise.
            </div>
        </div>

        {/* Right: Info Panel */}
        <div className="w-full max-w-sm flex flex-col gap-6">
             {/* Target Preview */}
             <div className="bg-slate-800/60 p-4 rounded-2xl border border-slate-700 flex flex-col items-center gap-2">
                <span className="text-xs font-bold text-slate-400 uppercase tracking-widest">Target Pattern</span>
                <div className="pointer-events-none opacity-90">
                    <HexBoard grid={target} onRotate={() => {}} isInteractive={false} scale={0.5} showRotators={false} />
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

             {/* Main Action Buttons */}
             {!isPlaying && !isSolved ? (
                <button
                    onClick={() => initGame(true)}
                    className="w-full py-4 bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-500 hover:to-pink-500 text-white font-display font-bold text-lg rounded-xl shadow-lg transition-all flex items-center justify-center gap-2"
                >
                    <Play fill="currentColor" /> START CHALLENGE
                </button>
             ) : (
                <button
                    onClick={() => initGame(false)}
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

export default HexGame;