import 'package:flutter/material.dart';

class AppColors {
  // Colores principales - Esquema moderno con gradientes
  static const Color primary = Color(0xFF6366F1); // Indigo moderno
  static const Color primaryDark = Color(0xFF4F46E5); // Indigo más oscuro
  static const Color primaryLight = Color(0xFF818CF8); // Indigo más claro
  static const Color primaryGradientStart = Color(0xFF6366F1);
  static const Color primaryGradientEnd = Color(0xFF8B5CF6);

  // Colores secundarios - Complementarios modernos
  static const Color secondary = Color(0xFF10B981); // Emerald verde
  static const Color secondaryDark = Color(0xFF059669);
  static const Color secondaryLight = Color(0xFF34D399);
  static const Color secondaryGradientStart = Color(0xFF10B981);
  static const Color secondaryGradientEnd = Color(0xFF06B6D4);

  // Colores de estado mejorados
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // Colores neutros mejorados
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF111827);
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // Colores de fondo modernos
  static const Color background = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBackgroundDark = Color(0xFF334155);

  // Colores de texto mejorados
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textHint = Color(0xFFD1D5DB);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFF9FAFB);

  // Colores de borde mejorados
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderFocus = Color(0xFF6366F1);
  static const Color borderError = Color(0xFFEF4444);
  static const Color borderSuccess = Color(0xFF10B981);

  // Colores de sombra
  static const Color shadowLight = Color(0x0A000000);
  static const Color shadowMedium = Color(0x14000000);
  static const Color shadowDark = Color(0x1A000000);

  // Gradientes predefinidos
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGradientStart, primaryGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryGradientStart, secondaryGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, grey50],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Colores de overlay
  static const Color overlayLight = Color(0x80000000);
  static const Color overlayDark = Color(0xCC000000);
}
