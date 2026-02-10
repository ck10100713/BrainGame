import React, { useState } from 'react';
import MainMenu from './components/MainMenu';
import SpinMatrixGame from './components/SpinMatrixGame';
import SphereGame from './components/SphereGame';
import HexGame from './components/HexGame';
import FlipGame from './components/FlipGame';

type ViewState = 'MENU' | 'SPIN_MATRIX' | 'SPHERE_SHIFT' | 'HEX_LOGIC' | 'FLIP_TILE';

const App: React.FC = () => {
  const [currentView, setCurrentView] = useState<ViewState>('MENU');

  const renderView = () => {
    switch (currentView) {
      case 'SPIN_MATRIX':
        return <SpinMatrixGame onBack={() => setCurrentView('MENU')} />;
      case 'SPHERE_SHIFT':
        return <SphereGame onBack={() => setCurrentView('MENU')} />;
      case 'HEX_LOGIC':
        return <HexGame onBack={() => setCurrentView('MENU')} />;
      case 'FLIP_TILE':
        return <FlipGame onBack={() => setCurrentView('MENU')} />;
      case 'MENU':
      default:
        return <MainMenu onSelectGame={(gameId) => {
          if (gameId === 'SPIN_MATRIX') setCurrentView('SPIN_MATRIX');
          if (gameId === 'SPHERE_SHIFT') setCurrentView('SPHERE_SHIFT');
          if (gameId === 'HEX_LOGIC') setCurrentView('HEX_LOGIC');
          if (gameId === 'FLIP_TILE') setCurrentView('FLIP_TILE');
        }} />;
    }
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