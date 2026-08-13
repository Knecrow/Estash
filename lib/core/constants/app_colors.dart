import 'package:flutter/material.dart';

abstract class AppColors {
  // ── Canvas / Background (Paynx Dark Body) ──────────────────────
  /// Deep black/charcoal for main screen body below hero
  static const Color canvasBackground = Color(0xFF0D0F12);
  static const Color canvasBackgroundAlt = Color(0xFF14171C);

  /// Top hero card background (Vibrant Neon Lime - Paynx Style)
  static const Color heroBackground = Color(0xFFB5F520);

  /// Inner total balance card background (Soft Bright Lime)
  static const Color heroCardSurface = Color(0xFFD4FD52);

  // ── Card Surfaces (Dark Slate Grey - Darker Tone of #71797E) ───
  /// Card surface on body (Dark Slate Grey #353A40)
  static const Color cardSurface = Color(0xFF353A40);

  /// Elevated card / Tile surface (Deeper Charcoal Slate #26292E)
  static const Color cardSurfaceElevated = Color(0xFF26292E);

  /// Card Divider / Border
  static const Color cardDivider = Color(0xFF4A5057);

  // ── Actions & Buttons ────────────────────────────────────────
  /// Action button background (Dark Pitch Black on Lime)
  static const Color actionDark = Color(0xFF0A1405);

  /// Action button on dark surface
  static const Color actionDarkElevated = Color(0xFF26292E);

  /// High contrast icon color on action buttons
  static const Color actionIconColor = Color(0xFFFFFFFF);

  /// Input background on grey cards
  static const Color inputBackground = Color(0xFF26292E);

  // ── Accent Colors ────────────────────────────────────────────
  /// Safe Accent (<70% Cap / Primary Accent): Electric Neon Lime
  static const Color safeAccent = Color(0xFFB5F520);

  /// Warning Accent (70–90% Cap): Electric Neon Yellow
  static const Color warningAccent = Color(0xFFFFD600);

  /// Danger Accent (>90% Cap / Low Balance): Crisp Electric Crimson Red
  static const Color dangerAccent = Color(0xFFFF3333);

  // ── High Contrast Text Colors (On Dark Grey #353A40) ──────────
  /// Text Primary on Grey Cards: Pure Crisp White
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Text On Dark Alias
  static const Color textOnDark = Color(0xFFFFFFFF);

  /// Text On Dark Muted
  static const Color textOnDarkMuted = Color(0xFFD0D5DD);

  /// Text Secondary on Grey Cards: High Contrast Off-White
  static const Color textSecondary = Color(0xFFD0D5DD);

  /// Text Primary on Lime Header: Pitch Black
  static const Color textOnLimePrimary = Color(0xFF050D02);

  /// Text Secondary on Lime Header: Deep Dark Olive
  static const Color textOnLimeSecondary = Color(0xFF1B300A);

  // ── Positive / Negative ──────────────────────────────────────
  static const Color positiveGreen = Color(0xFFB5F520);

  /// Clean Crisp Crimson Red for Expenses / Negative amounts
  static const Color negativeRed = Color(0xFFFF3333);
}
