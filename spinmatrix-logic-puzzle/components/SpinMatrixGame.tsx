import React, { useState, useEffect, useCallback, useRef } from 'react';
import { Difficulty } from '../types';
import { createTargetGrid, rotateSubgrid, scrambleGrid, checkWin } from '../utils/gameLogic';
import GridBoard from './GridBoard';
import InfoPanel from './InfoPanel';
import { Sparkles, BrainCircuit, ArrowLeft } from 'lucide-react';

interface SpinMatrixGameProps {
  onBack: () => void;
}

const SpinMatrixGame: React.FC<SpinMatrixGameProps> = ({ onBack }) => {
  const [difficulty, setDifficulty] = useState<Difficulty>(4);
  const [grid, setGrid] = useState(() => createTargetGrid(4));
  const [target, setTarget] = useState(() => createTargetGrid(4));
  const [moves, setMoves] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [isSolved, setIsSolved] = useState(false);
  const [elapsedTime, setElapsedTime] = useState(0);

  const timerRef = useRef<number | null>(null);

  // Initialize or reset game logic
  const initGame = useCallback((diff: Difficulty, startPlaying: boolean = false) => {
    const solvedState = createTargetGrid(diff);
    setTarget(solvedState);
    
    if (startPlaying) {
      const scrambleCount = diff === 4 ? 15 : 40;
      const scrambled = scrambleGrid(solvedState, diff, scrambleCount);
      setGrid(scrambled);
      setIsPlaying(true);
      setIsSolved(false);
      setMoves(0);
      setElapsedTime(0);
      
      if (timerRef.current) clearInterval(timerRef.current);
      timerRef.current = window.setInterval(() => {
        setElapsedTime(prev => prev + 1);
      }, 1000);
    } else {
      setGrid(solvedState);
      setIsPlaying(false);
      setIsSolved(false);
      setMoves(0);
      setElapsedTime(0);
      if (timerRef.current) {
        clearInterval(timerRef.current);
        timerRef.current = null;
      }
    }
  }, []);

  const handleDifficultyChange = (newDiff: Difficulty) => {
    setDifficulty(newDiff);
    initGame(newDiff, false);
  };

  const handleRotate = useCallback((row: number, col: number) => {
    if (!isPlaying || isSolved) return;

    setGrid(prevGrid => {
      const newGrid = rotateSubgrid(prevGrid, row, col);
      if (checkWin(newGrid, target)) {
        setIsSolved(true);
        setIsPlaying(false);
        if (timerRef.current) {
          clearInterval(timerRef.current);
          timerRef.current = null;
        }
      }
      return newGrid;
    });
    setMoves(prev => prev + 1);
  }, [isPlaying, isSolved, target]);

  useEffect(() => {
    return () => {
      if (timerRef.current) clearInterval(timerRef.current);
    };
  }, []);

  return (
    <div className="w-full flex flex-col items-center gap-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
      
      {/* Header with Back Button */}
      <header className="w-full flex items-center justify-between max-w-6xl">
        <button 
          onClick={onBack}
          className="flex items-center gap-2 px-4 py-2 rounded-lg bg-slate-800/50 hover:bg-slate-700 text-slate-300 hover:text-white transition-all border border-slate-700"
        >
          <ArrowLeft size={20} />
          <span className="hidden sm:inline">Back to Menu</span>
        </button>

        <div className="flex items-center gap-3 text-cyan-400">
          <BrainCircuit size={32} />
          <h1 className="text-2xl md:text-4xl font-display font-bold tracking-tighter bg-clip-text text-transparent bg-gradient-to-r from-cyan-400 to-purple-400">
            SpinMatrix
          </h1>
        </div>
        
        <div className="w-[100px]" /> {/* Spacer for centering */}
      </header>

      {/* Main Game Layout */}
      <div className="flex flex-col lg:flex-row items-center lg:items-start justify-center gap-8 lg:gap-16 w-full max-w-6xl">
        
        {/* Left: Game Board */}
        <div className="flex-1 w-full max-w-xl aspect-square flex flex-col items-center justify-center">
          <div className="relative w-full">
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
            
            <GridBoard 
              grid={grid} 
              onRotate={handleRotate} 
              isInteractive={isPlaying && !isSolved} 
            />
          </div>
          
          <div className="mt-4 text-slate-500 text-sm text-center">
            Tap the circular icons to rotate surrounding blocks clockwise.
          </div>
        </div>

        {/* Right: Controls & Stats */}
        <div className="w-full max-w-md">
          <InfoPanel 
            target={target}
            moves={moves}
            time={elapsedTime}
            difficulty={difficulty}
            isSolved={isSolved}
            isPlaying={isPlaying}
            onDifficultyChange={handleDifficultyChange}
            onReset={() => initGame(difficulty, false)}
            onStart={() => initGame(difficulty, true)}
          />
        </div>

      </div>
    </div>
  );
};

export default SpinMatrixGame;