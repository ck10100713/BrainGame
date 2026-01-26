import React, { useState, useEffect, useRef, useCallback } from 'react';
import { ArrowLeft, BrainCircuit, Play, RotateCcw, Clock, Move, EyeOff, Eye, AlertTriangle, CheckCircle } from 'lucide-react';
import SphereBoard from './SphereBoard';
import { createSolvedSphereGrid, scrambleSphereGrid, shiftRow, shiftCol, checkSphereWin } from '../utils/sphereLogic';
import { SphereDifficulty } from '../types';

interface SphereGameProps {
  onBack: () => void;
}

const SphereGame: React.FC<SphereGameProps> = ({ onBack }) => {
  const [difficulty, setDifficulty] = useState<SphereDifficulty>('STANDARD');
  const [grid, setGrid] = useState(() => createSolvedSphereGrid());
  const [moves, setMoves] = useState(0);
  const [elapsedTime, setElapsedTime] = useState(0);
  const [isPlaying, setIsPlaying] = useState(false);
  const [isSolved, setIsSolved] = useState(false);
  
  // Blind Mode Specific State
  const [attempts, setAttempts] = useState(3);
  const [showFailModal, setShowFailModal] = useState(false);
  const [isRevealing, setIsRevealing] = useState(false); // True when checking submission

  const timerRef = useRef<number | null>(null);

  const initGame = useCallback((diff: SphereDifficulty, startPlaying: boolean) => {
    if (startPlaying) {
      const scrambled = scrambleSphereGrid(40);
      setGrid(scrambled);
      setIsPlaying(true);
      setMoves(0);
      setElapsedTime(0);
      setIsSolved(false);
      setAttempts(3);
      setShowFailModal(false);
      setIsRevealing(false);

      if (timerRef.current) clearInterval(timerRef.current);
      timerRef.current = window.setInterval(() => {
        setElapsedTime(prev => prev + 1);
      }, 1000);
    } else {
      // Reset to preview/idle state
      setGrid(createSolvedSphereGrid());
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

  const handleDifficultySwitch = (diff: SphereDifficulty) => {
    setDifficulty(diff);
    initGame(diff, false);
  };

  const checkWinCondition = (currentGrid: typeof grid) => {
    if (checkSphereWin(currentGrid)) {
      setIsSolved(true);
      setIsPlaying(false);
      setIsRevealing(true); // Always reveal on win
      if (timerRef.current) clearInterval(timerRef.current);
      timerRef.current = null;
      return true;
    }
    return false;
  };

  const handleShiftRow = (row: number, dir: 1 | -1) => {
    if (!isPlaying || isSolved) return;
    setMoves(p => p + 1);
    setGrid(prev => {
      const next = shiftRow(prev, row, dir);
      if (difficulty === 'STANDARD') {
        checkWinCondition(next);
      }
      return next;
    });
  };

  const handleShiftCol = (col: number, dir: 1 | -1) => {
    if (!isPlaying || isSolved) return;
    setMoves(p => p + 1);
    setGrid(prev => {
      const next = shiftCol(prev, col, dir);
      if (difficulty === 'STANDARD') {
        checkWinCondition(next);
      }
      return next;
    });
  };

  const handleSubmitBlind = () => {
    // 1. Reveal colors
    setIsRevealing(true);

    // 2. Check Win
    const isWin = checkWinCondition(grid);

    // 3. If fail
    if (!isWin) {
      setTimeout(() => {
        setAttempts(prev => prev - 1);
        setShowFailModal(true);
      }, 800); // Slight delay to let user see the mess they made
    }
  };

  const handleContinue = () => {
    setShowFailModal(false);
    setIsRevealing(false); // Go back to blind
    if (attempts <= 0) {
        // Game Over logic if needed, or just reset
        initGame(difficulty, false); 
    }
  };

  const formatTime = (seconds: number) => {
    const m = Math.floor(seconds / 60);
    const s = seconds % 60;
    return `${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`;
  };

  // Determine if we should visually render as blind
  // Blind only if: Difficulty is BLIND, game is Playing, and NOT currently revealing (for check or win)
  const renderBlind = difficulty === 'BLIND' && isPlaying && !isRevealing;

  return (
    <div className="w-full flex flex-col items-center gap-6 animate-in fade-in slide-in-from-bottom-4 duration-500 relative">
      
      {/* Fail Modal */}
      {showFailModal && (
        <div className="absolute inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm rounded-xl">
          <div className="bg-slate-900 border border-red-500/50 p-6 rounded-2xl shadow-2xl max-w-sm w-full text-center space-y-4 animate-in zoom-in duration-300">
            <div className="mx-auto w-12 h-12 bg-red-500/20 rounded-full flex items-center justify-center text-red-500">
              <AlertTriangle size={24} />
            </div>
            <h3 className="text-xl font-display font-bold text-white">Pattern Mismatch</h3>
            <p className="text-slate-400">
              The rows are not perfectly aligned by color.
            </p>
            <div className="text-sm font-bold text-slate-300">
              Attempts remaining: {attempts}
            </div>
            
            {attempts > 0 ? (
               <button 
               onClick={handleContinue}
               className="w-full py-3 bg-slate-700 hover:bg-slate-600 text-white rounded-lg font-bold transition-colors"
             >
               Continue (Hide Colors)
             </button>
            ) : (
                <button 
                onClick={() => initGame('BLIND', false)}
                className="w-full py-3 bg-red-600 hover:bg-red-700 text-white rounded-lg font-bold transition-colors"
              >
                Game Over - Try Again
              </button>
            )}
           
          </div>
        </div>
      )}

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
          <h1 className="text-2xl md:text-3xl font-display font-bold tracking-tighter bg-clip-text text-transparent bg-gradient-to-r from-cyan-400 to-blue-400">
            SphereShift
          </h1>
        </div>
        
        <div className="w-[80px]" /> 
      </header>

      <div className="flex flex-col md:flex-row gap-8 md:gap-16 items-start w-full max-w-5xl justify-center">
        
        {/* Left: Game Board */}
        <div className="flex-1 flex flex-col items-center">
             {/* Solved Overlay */}
             {isSolved && (
              <div className="mb-4 flex flex-col items-center animate-bounce">
                <h2 className="text-3xl font-display font-bold text-green-400 drop-shadow-[0_0_10px_rgba(74,222,128,0.5)]">
                  COMPLETE!
                </h2>
                <p className="text-slate-400 text-sm">Target reached in {formatTime(elapsedTime)}</p>
              </div>
            )}

            <div className="relative">
                <SphereBoard 
                    grid={grid}
                    onShiftRow={handleShiftRow}
                    onShiftCol={handleShiftCol}
                    isInteractive={isPlaying && !isSolved && !showFailModal}
                    isBlind={renderBlind}
                />
            </div>

            <div className="mt-6 text-slate-500 text-sm text-center max-w-sm">
                Use arrows to shift entire rows or columns.
                {difficulty === 'STANDARD' ? ' Align all spheres in a row to the same color.' : ' Memorize the pattern, then align blindly.'}
            </div>
        </div>

        {/* Right: Info Panel */}
        <div className="w-full max-w-sm flex flex-col gap-4">
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

             {/* Mode Selector */}
             <div className="bg-slate-800/40 p-1 rounded-lg flex border border-slate-700/50">
                <button
                    onClick={() => !isPlaying && handleDifficultySwitch('STANDARD')}
                    disabled={isPlaying}
                    className={`flex-1 py-2 text-sm font-bold rounded-md transition-all flex items-center justify-center gap-2
                        ${difficulty === 'STANDARD' ? 'bg-cyan-600 text-white shadow-lg' : 'text-slate-400 hover:text-white'}
                        disabled:opacity-50
                    `}
                >
                    <Eye size={16} /> Standard
                </button>
                <button
                    onClick={() => !isPlaying && handleDifficultySwitch('BLIND')}
                    disabled={isPlaying}
                    className={`flex-1 py-2 text-sm font-bold rounded-md transition-all flex items-center justify-center gap-2
                        ${difficulty === 'BLIND' ? 'bg-purple-600 text-white shadow-lg' : 'text-slate-400 hover:text-white'}
                        disabled:opacity-50
                    `}
                >
                    <EyeOff size={16} /> Blind
                </button>
             </div>

            {/* Blind Mode Attempts Indicator */}
            {difficulty === 'BLIND' && (
                <div className="flex justify-between items-center px-2 py-1">
                    <span className="text-xs text-slate-400 uppercase font-bold">Submissions Left</span>
                    <div className="flex gap-1">
                        {[...Array(3)].map((_, i) => (
                            <div key={i} className={`w-3 h-3 rounded-full ${i < attempts ? 'bg-green-500 shadow-[0_0_5px_rgba(74,222,128,0.5)]' : 'bg-slate-700'}`} />
                        ))}
                    </div>
                </div>
            )}

             {/* Main Action Buttons */}
             {!isPlaying && !isSolved ? (
                <button
                    onClick={() => initGame(difficulty, true)}
                    className="w-full py-4 bg-gradient-to-r from-cyan-600 to-blue-600 hover:from-cyan-500 hover:to-blue-500 text-white font-display font-bold text-lg rounded-xl shadow-lg transition-all flex items-center justify-center gap-2"
                >
                    <Play fill="currentColor" /> START
                </button>
             ) : (
                 <div className="space-y-3">
                    {/* Submit Button for Blind Mode */}
                    {difficulty === 'BLIND' && !isSolved && (
                        <button 
                            onClick={handleSubmitBlind}
                            className="w-full py-4 bg-gradient-to-r from-amber-500 to-orange-600 hover:brightness-110 text-white font-display font-bold text-lg rounded-xl shadow-lg transition-all flex items-center justify-center gap-2"
                        >
                            <CheckCircle /> SUBMIT PATTERN
                        </button>
                    )}

                    <button
                        onClick={() => initGame(difficulty, false)}
                        className="w-full py-3 bg-slate-700 hover:bg-slate-600 text-white font-bold rounded-xl shadow-lg transition-all flex items-center justify-center gap-2"
                    >
                        <RotateCcw size={18} /> {isSolved ? 'PLAY AGAIN' : 'RESET'}
                    </button>
                 </div>
             )}

             {/* Objective Text */}
             <div className="bg-slate-900/50 p-3 rounded-lg border border-slate-700/50 text-xs text-slate-400 leading-relaxed">
                <strong>Objective:</strong> Make every horizontal row consist of a single unique color.
                <br/>
                <span className="text-cyan-400">Row 1: All Cyan</span> • 
                <span className="text-yellow-400"> Row 2: All Yellow</span> ...
             </div>
        </div>

      </div>
    </div>
  );
};

export default SphereGame;