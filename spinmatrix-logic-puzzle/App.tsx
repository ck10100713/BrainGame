import React, { useState, useEffect, useCallback, useRef } from 'react';
import { Difficulty, GameState } from './types';
import { createTargetGrid, rotateSubgrid, scrambleGrid, checkWin, copyGrid } from './utils/gameLogic';
import GridBoard from './components/GridBoard';
import InfoPanel from './components/InfoPanel';
import { Sparkles, BrainCircuit } from 'lucide-react';

const App: React.FC = () => {
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
      // Scramble for gameplay
      // More moves for higher difficulty
      const scrambleCount = diff === 4 ? 15 : 40;
      const scrambled = scrambleGrid(solvedState, diff, scrambleCount);
      setGrid(scrambled);
      setIsPlaying(true);
      setIsSolved(false);
      setMoves(0);
      setElapsedTime(0);
      
      // Start Timer
      if (timerRef.current) clearInterval(timerRef.current);
      timerRef.current = window.setInterval(() => {
        setElapsedTime(prev => prev + 1);
      }, 1000);
    } else {
      // Show solved state (preview)
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

  // Handle Difficulty Change
  const handleDifficultyChange = (newDiff: Difficulty) => {
    setDifficulty(newDiff);
    initGame(newDiff, false);
  };

  // Handle Rotation Input
  const handleRotate = useCallback((row: number, col: number) => {
    if (!isPlaying || isSolved) return;

    setGrid(prevGrid => {
      const newGrid = rotateSubgrid(prevGrid, row, col);
      
      // Check win condition immediately after move
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

  // Cleanup timer
  useEffect(() => {
    return () => {
      if (timerRef.current) clearInterval(timerRef.current);
    };
  }, []);

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 flex flex-col items-center justify-center p-4 lg:p-8 bg-[url('https://images.unsplash.com/photo-1534796636912-3b95b3ab5980?auto=format&fit=crop&q=80')] bg-cover bg-center bg-no-repeat bg-blend-multiply bg-fixed">
      
      {/* Overlay for better text contrast over background image */}
      <div className="absolute inset-0 bg-slate-900/80 pointer-events-none" />

      <div className="relative z-10 w-full max-w-6xl mx-auto flex flex-col items-center gap-8">
        
        {/* Header */}
        <header className="flex flex-col items-center gap-2 mb-4">
          <div className="flex items-center gap-3 text-cyan-400 animate-pulse">
            <BrainCircuit size={40} />
            <h1 className="text-4xl md:text-5xl font-display font-bold tracking-tighter bg-clip-text text-transparent bg-gradient-to-r from-cyan-400 to-purple-400">
              SpinMatrix
            </h1>
          </div>
          <p className="text-slate-400 font-medium">Spatial Logic Challenge</p>
        </header>

        {/* Main Game Layout */}
        <div className="flex flex-col lg:flex-row items-center lg:items-start justify-center gap-8 lg:gap-16 w-full">
          
          {/* Left: Game Board */}
          <div className="flex-1 w-full max-w-xl aspect-square flex flex-col items-center justify-center">
            <div className="relative w-full">
              {/* Victory Overlay */}
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
    </div>
  );
};

export default App;