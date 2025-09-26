import 'package:flutter/material.dart';

class Responsive {
  static const Size _designSize = Size(390, 844); // iPhone 12 base

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getResponsivePadding(BuildContext context) {
    if (isMobile(context)) {
      return 16.0;
    } else if (isTablet(context)) {
      return 24.0;
    } else {
      return 32.0;
    }
  }

  static double getResponsiveFontSize(
      BuildContext context, double baseFontSize) {
    if (isMobile(context)) {
      return baseFontSize;
    } else if (isTablet(context)) {
      return baseFontSize * 1.1;
    } else {
      return baseFontSize * 1.2;
    }
  }

  static int getCrossAxisCount(BuildContext context) {
    if (isMobile(context)) {
      return 1;
    } else if (isTablet(context)) {
      return 2;
    } else {
      return 3;
    }
  }

  static double getResponsiveWidth(BuildContext context, double percentage) {
    return getScreenWidth(context) * (percentage / 100);
  }

  static double getResponsiveHeight(BuildContext context, double percentage) {
    return getScreenHeight(context) * (percentage / 100);
  }

  // Escala relativa a un tamaño de diseño base
  static double scaleWidth(BuildContext context, double base) {
    final w = getScreenWidth(context);
    return base * (w / _designSize.width);
  }

  static double scaleHeight(BuildContext context, double base) {
    final h = getScreenHeight(context);
    return base * (h / _designSize.height);
  }

  static double scaleFont(BuildContext context, double base) {
    // Usa el menor de los factores para evitar textos excesivos
    final wFactor = getScreenWidth(context) / _designSize.width;
    final hFactor = getScreenHeight(context) / _designSize.height;
    final factor = wFactor < hFactor ? wFactor : hFactor;
    return base * factor.clamp(0.85, 1.3);
  }
}
