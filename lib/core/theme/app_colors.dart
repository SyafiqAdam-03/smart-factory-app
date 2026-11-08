import 'package:flutter/material.dart';

/// Clean-industrial palette: slate neutrals, deep navy, ONE accent blue.
/// Status colours carry meaning only: green = passed, orange = quarantined,
/// red = failed / defect.
class AppColors {
  AppColors._();

  // Brand
  static const Color navy = Color(0xFF0F172A);
  static const Color accent = Color(0xFF0284C7);
  static const Color accentSoft = Color(0xFFE0F2FE);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate900 = Color(0xFF0F172A);

  // Status: passed
  static const Color passed = Color(0xFF16A34A);
  static const Color passedText = Color(0xFF15803D);
  static const Color passedSoft = Color(0xFFDCFCE7);

  // Status: quarantined (safety orange)
  static const Color quarantined = Color(0xFFEA580C);
  static const Color quarantinedText = Color(0xFFC2410C);
  static const Color quarantinedSoft = Color(0xFFFFEDD5);

  // Status: failed / defect
  static const Color failed = Color(0xFFDC2626);
  static const Color failedText = Color(0xFFB91C1C);
  static const Color failedSoft = Color(0xFFFEE2E2);
}
