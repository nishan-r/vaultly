import 'package:flutter/material.dart';

/// Color palette extracted from the Vaultly design screens.
abstract final class AppColors {
  // ── Primary ──────────────────────────────────────────────────────────
  /// Deep indigo used for the main CTA button and brand accent.
  static const Color primary = Color(0xFF4338CA);

  /// Slightly lighter variant for hover / pressed states.
  static const Color primaryLight = Color(0xFF5B52E0);

  /// Very dark shade for text on light backgrounds.
  static const Color primaryDark = Color(0xFF312E81);

  // ── Brand ────────────────────────────────────────────────────────────
  /// Vaultly logo text color (deep purple-blue).
  static const Color brandText = Color(0xFF4338CA);

  // ── Surfaces ─────────────────────────────────────────────────────────
  /// Card / screen background.
  static const Color surface = Color(0xFFFFFFFF);

  /// Outer scaffold background (dark, visible behind the card).
  static const Color scaffoldDark = Color(0xFF1A1A2E);

  /// Soft lavender tint used in the fingerprint circle background.
  static const Color lavenderLight = Color(0xFFEDE9FE);

  /// Mid-lavender ring around the fingerprint icon.
  static const Color lavenderMid = Color(0xFFDDD6FE);

  /// Outer subtle ring.
  static const Color lavenderOuter = Color(0xFFF0EDFF);

  // ── Text ─────────────────────────────────────────────────────────────
  /// Main heading text.
  static const Color textPrimary = Color(0xFF1E1B2E);

  /// Subtitle / body text.
  static const Color textSecondary = Color(0xFF6B7280);

  /// Tertiary / hint text (footer, etc.)
  static const Color textTertiary = Color(0xFF9CA3AF);

  // ── Semantic ─────────────────────────────────────────────────────────
  /// Success / authenticated status (warm orange).
  static const Color success = Color(0xFFC2410C);

  /// Error red.
  static const Color error = Color(0xFFDC2626);

  // ── Misc ─────────────────────────────────────────────────────────────
  /// Divider / border color.
  static const Color border = Color(0xFFE5E7EB);

  /// Icon default tint.
  static const Color iconDefault = Color(0xFF6B7280);

  /// Fingerprint icon stroke color.
  static const Color fingerprintStroke = Color(0xFF3F3D56);
}
