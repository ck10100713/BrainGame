import SwiftUI

// MARK: - BrainGame Color System (WCAG AA Compliant)

enum BrainGameColors {
    // MARK: - Background Colors

    /// Primary background - #0D1117
    static let backgroundPrimary = Color(hex: "0D1117")

    /// Secondary background for cards/panels - #161B22
    static let backgroundSecondary = Color(hex: "161B22")

    /// Tertiary background for highlighted elements - #21262D
    static let backgroundTertiary = Color(hex: "21262D")

    // MARK: - Text Colors (WCAG AA Compliant)

    /// Primary text - #F0F6FC (15.8:1 contrast ratio)
    static let textPrimary = Color(hex: "F0F6FC")

    /// Secondary text - #C9D1D9 (11.5:1 contrast ratio)
    static let textSecondary = Color(hex: "C9D1D9")

    /// Tertiary/hint text - #8B949E (5.3:1 contrast ratio)
    static let textTertiary = Color(hex: "8B949E")

    // MARK: - Game Theme Colors (Accent)

    /// SpinMatrix accent - Blue #58A6FF
    static let accentSpinMatrix = Color(hex: "58A6FF")

    /// SphereShift accent - Green #39D353
    static let accentSphere = Color(hex: "39D353")

    /// HexLogic accent - Purple #A371F7
    static let accentHex = Color(hex: "A371F7")

    /// FlipTile accent - Orange #F97316
    static let accentFlipTile = Color(hex: "F97316")

    /// Blind mode accent - Purple #9333EA
    static let accentBlind = Color(hex: "9333EA")

    // MARK: - Block/Game Piece Colors (Enhanced Visibility)

    /// Block Red - #FF6B6B
    static let blockRed = Color(hex: "FF6B6B")

    /// Block Blue - #4DABF7
    static let blockBlue = Color(hex: "4DABF7")

    /// Block Green - #51CF66
    static let blockGreen = Color(hex: "51CF66")

    /// Block Yellow - #FFE066
    static let blockYellow = Color(hex: "FFE066")

    // MARK: - UI Element Colors

    /// Border color for cards and panels
    static let border = Color(hex: "30363D")

    /// Subtle border
    static let borderSubtle = Color(hex: "21262D")

    /// Success state
    static let success = Color(hex: "39D353")

    /// Warning state
    static let warning = Color(hex: "F59E0B")

    /// Error state
    static let error = Color(hex: "F85149")

    // MARK: - Gradients

    static let backgroundGradient = LinearGradient(
        colors: [backgroundPrimary, backgroundSecondary],
        startPoint: .top,
        endPoint: .bottom
    )

    static let spinMatrixGradient = LinearGradient(
        colors: [accentSpinMatrix, Color(hex: "388BFD")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let sphereGradient = LinearGradient(
        colors: [accentSphere, Color(hex: "2EA043")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let hexGradient = LinearGradient(
        colors: [accentHex, Color(hex: "8957E5")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let flipTileGradient = LinearGradient(
        colors: [accentFlipTile, Color(hex: "EA580C")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let heroGradient = LinearGradient(
        colors: [Color(hex: "58A6FF"), accentHex],
        startPoint: .leading,
        endPoint: .trailing
    )
}

// MARK: - Game-Specific Color Helpers

extension BrainGameColors {
    static func gradientColors(for gameId: GameId) -> [Color] {
        switch gameId {
        case .spinMatrix:
            return [accentSpinMatrix, Color(hex: "388BFD")]
        case .sphereShift:
            return [accentSphere, Color(hex: "2EA043")]
        case .hexLogic:
            return [accentHex, Color(hex: "8957E5")]
        case .flipTile:
            return [accentFlipTile, Color(hex: "EA580C")]
        }
    }

    static func accentColor(for gameId: GameId) -> Color {
        switch gameId {
        case .spinMatrix: return accentSpinMatrix
        case .sphereShift: return accentSphere
        case .hexLogic: return accentHex
        case .flipTile: return accentFlipTile
        }
    }
}
