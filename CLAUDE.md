# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 專案概述

BrainGame 是一個益智遊戲集合，**主要開發目標是 iOS Swift/SwiftUI 原生應用程式**。

**Web 版 (React/TypeScript)**: `spinmatrix-logic-puzzle/` - 僅作為基礎範例參考，不是主要開發目標
**iOS 版 (Swift/SwiftUI)**: `SpinMatrix/` - **主要開發項目**

> ⚠️ **重要**：Web 版本僅供快速原型驗證和邏輯參考，所有正式功能開發都應在 iOS app 上進行。

## 常用指令

### Web 開發 (spinmatrix-logic-puzzle/)
```bash
cd spinmatrix-logic-puzzle
npm install        # 安裝依賴
npm run dev        # 啟動開發伺服器 (port 3000)
npm run build      # 建置生產版本
npx tsc --noEmit   # 檢查 TypeScript 編譯
```

### iOS 開發 (SpinMatrix/)
```bash
cd SpinMatrix
brew install xcodegen      # 安裝 XcodeGen (僅需一次)
xcodegen generate          # 從 project.yml 產生 .xcodeproj
open SpinMatrix.xcodeproj  # 開啟 Xcode
```

## 架構

### 遊戲列表

| 遊戲 | ID | Web | iOS | 說明 |
|------|-----|-----|-----|------|
| SpinMatrix | `SPIN_MATRIX` | ✅ | ✅ | 旋轉 2x2 子格陣匹配目標圖案 |
| SphereShift | `SPHERE_SHIFT` | ✅ | ❌ | 移動行/列對齊球體顏色，含盲模式 |
| HexLogic | `HEX_LOGIC` | ✅ | ❌ | 六邊形三角形旋轉謎題 |

### Web 架構 (React)

```
spinmatrix-logic-puzzle/
├── App.tsx                    # 主路由，GAMES 陣列管理遊戲註冊
├── types.ts                   # 共用類型定義 (GameId, 顏色 enum, GridState)
├── components/
│   ├── MainMenu.tsx           # 遊戲選單
│   ├── SpinMatrixGame.tsx     # SpinMatrix 完整遊戲組件
│   ├── SphereGame.tsx         # SphereShift 完整遊戲組件
│   └── HexGame.tsx            # HexLogic 完整遊戲組件
└── utils/
    ├── gameLogic.ts           # SpinMatrix 遊戲邏輯
    ├── sphereLogic.ts         # SphereShift 遊戲邏輯
    └── hexLogic.ts            # HexLogic 遊戲邏輯 (含幾何計算)
```

### iOS 架構 (SwiftUI MVVM)

```
SpinMatrix/SpinMatrix/
├── SpinMatrixApp.swift        # App 進入點
├── Models/
│   ├── GameModels.swift       # BlockColor enum, Difficulty, GridState
│   └── GameLogic.swift        # 純函數：createTargetGrid, rotateSubgrid, scrambleGrid, checkWin
├── ViewModels/
│   └── GameViewModel.swift    # ObservableObject，管理遊戲狀態和計時器
└── Views/
    ├── ContentView.swift      # 主畫面，含 HeaderView, VictoryOverlay
    ├── GridBoardView.swift    # 遊戲網格，含 BlockCell, RotatorButton
    └── InfoPanelView.swift    # 資訊面板：難度選擇、統計、目標預覽
```

### 遊戲邏輯對應 (Web → iOS 移植參考)

| Web (TypeScript) | iOS (Swift) | 功能 |
|------------------|-------------|------|
| `createTargetGrid()` | `GameLogic.createTargetGrid(size:)` | 建立目標網格 |
| `rotateSubgrid()` | `GameLogic.rotateSubgrid(_:row:col:)` | 順時針旋轉 2x2 區塊 |
| `scrambleGrid()` | `GameLogic.scrambleGrid(_:size:moves:)` | 打亂網格 |
| `checkWin()` | `GameLogic.checkWin(gridA:gridB:)` | 檢查是否完成 |

## 新增遊戲到 iOS 的步驟

1. 在 `Models/` 新增對應的 Models 和 Logic 檔案
2. 在 `ViewModels/` 新增對應的 ViewModel
3. 在 `Views/` 新增遊戲畫面和棋盤組件
4. 建立主選單導航系統 (目前 iOS 版沒有)

## iOS 專案配置

- Bundle ID: `com.braingame.spinmatrix`
- Deployment Target: iOS 16.0
- 使用 XcodeGen (`project.yml`) 管理專案設定
- 無外部依賴，純 SwiftUI

## 注意事項

- Web 使用 Tailwind CSS CDN，iOS 需手動實作對應的顏色和樣式
- `hexLogic.ts` 包含複雜的幾何計算 (三角形網格、旋轉點)，移植時需仔細對應座標系統
- iOS 的 `Color(hex:)` extension 已在 `ContentView.swift` 定義
