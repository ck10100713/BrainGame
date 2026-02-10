import React from 'react';
import { BrainCircuit, CircleDot, ArrowRight, Hexagon, Grid3x3 } from 'lucide-react';

interface MainMenuProps {
  onSelectGame: (gameId: string) => void;
}

const MainMenu: React.FC<MainMenuProps> = ({ onSelectGame }) => {
  return (
    <div className="w-full max-w-6xl flex flex-col items-center gap-12 animate-in fade-in duration-700 px-4 py-8">
      
      {/* Hero Section */}
      <div className="text-center space-y-4">
        <h1 className="text-5xl md:text-8xl font-display font-bold tracking-tighter text-transparent bg-clip-text bg-gradient-to-b from-white via-slate-200 to-slate-500 drop-shadow-2xl">
          LOGIC LAB
        </h1>
        <p className="text-lg md:text-xl text-slate-400 font-light max-w-2xl mx-auto border-t border-slate-800 pt-4">
          Training grounds for spatial reasoning and cognitive reflexes.
          Select a module to begin simulation.
        </p>
      </div>

      {/* Game Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 w-full">
        
        {/* SpinMatrix Card */}
        <button 
          onClick={() => onSelectGame('SPIN_MATRIX')}
          className="group relative flex flex-col h-[320px] bg-slate-900/50 rounded-2xl border border-slate-700 overflow-hidden hover:border-cyan-500/50 transition-all duration-300 hover:shadow-[0_0_30px_rgba(6,182,212,0.15)] text-left"
        >
          <div className="absolute inset-0 bg-gradient-to-br from-cyan-900/20 to-purple-900/20 opacity-0 group-hover:opacity-100 transition-opacity duration-500" />
          <div className="p-6 flex justify-between items-start z-10">
            <div className="p-3 bg-slate-800 rounded-xl group-hover:bg-cyan-950/50 text-cyan-400 transition-colors">
              <BrainCircuit size={32} />
            </div>
            <div className="px-2 py-1 bg-slate-800 rounded text-[10px] font-bold text-slate-400 uppercase tracking-widest">
              Puzzle
            </div>
          </div>
          <div className="mt-auto p-6 z-10 space-y-2">
            <h3 className="text-xl font-display font-bold text-white group-hover:text-cyan-200 transition-colors">
              SpinMatrix
            </h3>
            <p className="text-slate-400 text-xs leading-relaxed">
              Rotate sub-grids to match the target pattern. Test your spatial manipulation skills.
            </p>
          </div>
          <div className="absolute bottom-6 right-6 opacity-0 transform translate-x-4 group-hover:opacity-100 group-hover:translate-x-0 transition-all duration-300 text-cyan-400">
            <ArrowRight size={24} />
          </div>
        </button>

        {/* SphereShift Card */}
        <button 
          onClick={() => onSelectGame('SPHERE_SHIFT')}
          className="group relative flex flex-col h-[320px] bg-slate-900/50 rounded-2xl border border-slate-700 overflow-hidden hover:border-blue-500/50 transition-all duration-300 hover:shadow-[0_0_30px_rgba(59,130,246,0.15)] text-left"
        >
          <div className="absolute inset-0 bg-gradient-to-br from-blue-900/20 to-emerald-900/20 opacity-0 group-hover:opacity-100 transition-opacity duration-500" />
          <div className="p-6 flex justify-between items-start z-10">
            <div className="p-3 bg-slate-800 rounded-xl group-hover:bg-blue-950/50 text-blue-400 transition-colors">
              <CircleDot size={32} />
            </div>
            <div className="px-2 py-1 bg-slate-800 rounded text-[10px] font-bold text-slate-400 uppercase tracking-widest">
              Logic
            </div>
          </div>
          <div className="mt-auto p-6 z-10 space-y-2">
            <h3 className="text-xl font-display font-bold text-white group-hover:text-blue-200 transition-colors">
              SphereShift
            </h3>
            <p className="text-slate-400 text-xs leading-relaxed">
              Shift rows and columns of spheres to align colors. Features a Blind Mode.
            </p>
          </div>
          <div className="absolute bottom-6 right-6 opacity-0 transform translate-x-4 group-hover:opacity-100 group-hover:translate-x-0 transition-all duration-300 text-blue-400">
            <ArrowRight size={24} />
          </div>
        </button>

         {/* HexLogic Card */}
         <button 
          onClick={() => onSelectGame('HEX_LOGIC')}
          className="group relative flex flex-col h-[320px] bg-slate-900/50 rounded-2xl border border-slate-700 overflow-hidden hover:border-pink-500/50 transition-all duration-300 hover:shadow-[0_0_30px_rgba(236,72,153,0.15)] text-left"
        >
          <div className="absolute inset-0 bg-gradient-to-br from-pink-900/20 to-orange-900/20 opacity-0 group-hover:opacity-100 transition-opacity duration-500" />
          <div className="p-6 flex justify-between items-start z-10">
            <div className="p-3 bg-slate-800 rounded-xl group-hover:bg-pink-950/50 text-pink-400 transition-colors">
              <Hexagon size={32} />
            </div>
            <div className="px-2 py-1 bg-slate-800 rounded text-[10px] font-bold text-slate-400 uppercase tracking-widest">
              Complex
            </div>
          </div>
          <div className="mt-auto p-6 z-10 space-y-2">
            <h3 className="text-xl font-display font-bold text-white group-hover:text-pink-200 transition-colors">
              HexLogic
            </h3>
            <p className="text-slate-400 text-xs leading-relaxed">
              Complex geometry challenge. Click intersections to rotate hexagonal clusters.
            </p>
          </div>
          <div className="absolute bottom-6 right-6 opacity-0 transform translate-x-4 group-hover:opacity-100 group-hover:translate-x-0 transition-all duration-300 text-pink-400">
            <ArrowRight size={24} />
          </div>
        </button>

         {/* FlipTile Card */}
         <button 
          onClick={() => onSelectGame('FLIP_TILE')}
          className="group relative flex flex-col h-[320px] bg-slate-900/50 rounded-2xl border border-slate-700 overflow-hidden hover:border-emerald-500/50 transition-all duration-300 hover:shadow-[0_0_30px_rgba(16,185,129,0.15)] text-left"
        >
          <div className="absolute inset-0 bg-gradient-to-br from-emerald-900/20 to-teal-900/20 opacity-0 group-hover:opacity-100 transition-opacity duration-500" />
          <div className="p-6 flex justify-between items-start z-10">
            <div className="p-3 bg-slate-800 rounded-xl group-hover:bg-emerald-950/50 text-emerald-400 transition-colors">
              <Grid3x3 size={32} />
            </div>
            <div className="px-2 py-1 bg-slate-800 rounded text-[10px] font-bold text-slate-400 uppercase tracking-widest">
              Binary
            </div>
          </div>
          <div className="mt-auto p-6 z-10 space-y-2">
            <h3 className="text-xl font-display font-bold text-white group-hover:text-emerald-200 transition-colors">
              FlipTile
            </h3>
            <p className="text-slate-400 text-xs leading-relaxed">
              Toggle squares to match the target. Clicking a tile flips its color and its neighbors.
            </p>
          </div>
          <div className="absolute bottom-6 right-6 opacity-0 transform translate-x-4 group-hover:opacity-100 group-hover:translate-x-0 transition-all duration-300 text-emerald-400">
            <ArrowRight size={24} />
          </div>
        </button>

      </div>

    </div>
  );
};

export default MainMenu;