import React, { useState, useCallback } from 'react';
import MainMenu from './components/MainMenu';
import SpinMatrixGame from './components/SpinMatrixGame';
import SphereGame from './components/SphereGame';
import HexGame from './components/HexGame';

// Game identifiers for routing
export type GameId = 'SPIN_MATRIX' | 'SPHERE_SHIFT' | 'HEX_LOGIC';
export type ViewState = 'MENU' | GameId;

// Game registry for easy extension
export interface GameConfig {
  id: GameId;
  name: string;
  component: React.FC<{ onBack: () => void }>;
}

const GAMES: GameConfig[] = [
  { id: 'SPIN_MATRIX', name: 'SpinMatrix', component: SpinMatrixGame },
  { id: 'SPHERE_SHIFT', name: 'SphereShift', component: SphereGame },
  { id: 'HEX_LOGIC', name: 'HexLogic', component: HexGame },
];

const App: React.FC = () => {
  const [currentView, setCurrentView] = useState<ViewState>('MENU');

  const navigateToMenu = useCallback(() => {
    setCurrentView('MENU');
  }, []);

  const navigateToGame = useCallback((gameId: GameId) => {
    setCurrentView(gameId);
  }, []);

  const renderView = () => {
    if (currentView === 'MENU') {
      return <MainMenu onSelectGame={(gameId) => navigateToGame(gameId as GameId)} />;
    }

    const game = GAMES.find(g => g.id === currentView);
    if (game) {
      const GameComponent = game.component;
      return <GameComponent onBack={navigateToMenu} />;
    }

    return <MainMenu onSelectGame={(gameId) => navigateToGame(gameId as GameId)} />;
  };

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 flex flex-col items-center justify-center p-4 lg:p-8 bg-[url('https://images.unsplash.com/photo-1534796636912-3b95b3ab5980?auto=format&fit=crop&q=80')] bg-cover bg-center bg-no-repeat bg-blend-multiply bg-fixed">

      {/* Global Overlay for consistency */}
      <div className="absolute inset-0 bg-slate-950/85 pointer-events-none" />

      {/* Content Container */}
      <div className="relative z-10 w-full flex flex-col items-center">
        {renderView()}
      </div>

    </div>
  );
};

export default App;