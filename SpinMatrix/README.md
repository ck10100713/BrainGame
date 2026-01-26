# SpinMatrix iOS App

A Swift/SwiftUI port of the SpinMatrix Logic Puzzle game.

## Project Setup

### Option 1: Using XcodeGen (Recommended)

1. Install XcodeGen if you haven't:
   ```bash
   brew install xcodegen
   ```

2. Generate the Xcode project:
   ```bash
   cd SpinMatrix
   xcodegen generate
   ```

3. Open the generated project:
   ```bash
   open SpinMatrix.xcodeproj
   ```

### Option 2: Manual Setup in Xcode

1. Open Xcode
2. Create a new project: File → New → Project
3. Select "iOS" → "App"
4. Settings:
   - Product Name: SpinMatrix
   - Interface: SwiftUI
   - Language: Swift
5. Delete the auto-generated ContentView.swift
6. Drag all the Swift files from this folder into your project
7. Make sure to check "Copy items if needed"

## Project Structure

```
SpinMatrix/
├── SpinMatrixApp.swift      # App entry point
├── Models/
│   ├── GameModels.swift     # BlockColor, Difficulty, GridState
│   └── GameLogic.swift      # Game logic functions
├── ViewModels/
│   └── GameViewModel.swift  # Game state management
├── Views/
│   ├── ContentView.swift    # Main view
│   ├── GridBoardView.swift  # Game grid with rotator buttons
│   └── InfoPanelView.swift  # Stats, controls, target preview
└── Assets.xcassets/         # App icons and colors
```

## Game Rules

- Goal: Restore the scrambled color grid to the target pattern
- Target: 4 quadrants (Red top-left, Yellow top-right, Blue bottom-left, Green bottom-right)
- Tap the circular buttons at grid intersections to rotate 4 adjacent blocks clockwise
- Difficulty: 4×4 (easy) or 6×6 (hard)
