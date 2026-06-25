import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography scale extracted from the Vaultly design.
abstract final class AppTextStyles {
  // ── Headings ─────────────────────────────────────────────────────────
  /// "Unlock to continue" – large heading on the lock screen.
  static TextStyle heading1 = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// Section headings / screen titles.
  static TextStyle heading2 = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // ── Body ─────────────────────────────────────────────────────────────
  /// Subtitle / description text (lock screen subtitle).
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  /// Regular body.
  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  /// Small / caption.
  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.4,
  );

  // ── Buttons ──────────────────────────────────────────────────────────
  /// Primary CTA button text ("Use PIN").
  static TextStyle buttonPrimary = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.0,
  );

  // ── Labels ───────────────────────────────────────────────────────────
  /// Brand name "Vaultly" in the header.
  static TextStyle brandLabel = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.brandText,
    height: 1.0,
  );

  /// Status text ("Authenticated. Access granted.").
  static TextStyle statusSuccess = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.success,
    height: 1.4,
  );

  /// Link-style text ("Forgot authentication?").
  static TextStyle linkText = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  /// Footer text ("Vaultly v4.2.0 • Secured by …").
  static TextStyle footer = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.4,
  );
}
