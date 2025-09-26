import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // Tamaños de fuente
  static const double fontSizeSmall = 12.0;
  static const double fontSizeBody = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeXLarge = 20.0;
  static const double fontSizeXXLarge = 24.0;
  static const double fontSizeTitle = 28.0;
  static const double fontSizeHeadline = 32.0;

  // Estilos de texto con Google Fonts Roboto
  static TextStyle get headline1 => GoogleFonts.roboto(
        fontSize: fontSizeHeadline,
        fontWeight: FontWeight.bold,
        height: 1.2,
      );

  static TextStyle get headline2 => GoogleFonts.roboto(
        fontSize: fontSizeTitle,
        fontWeight: FontWeight.bold,
        height: 1.3,
      );

  static TextStyle get headline3 => GoogleFonts.roboto(
        fontSize: fontSizeXXLarge,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle get headline4 => GoogleFonts.roboto(
        fontSize: fontSizeXLarge,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get headline5 => GoogleFonts.roboto(
        fontSize: fontSizeLarge,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get headline6 => GoogleFonts.roboto(
        fontSize: fontSizeMedium,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  static TextStyle get bodyText1 => GoogleFonts.roboto(
        fontSize: fontSizeBody,
        fontWeight: FontWeight.normal,
        height: 1.5,
      );

  static TextStyle get bodyText2 => GoogleFonts.roboto(
        fontSize: fontSizeSmall,
        fontWeight: FontWeight.normal,
        height: 1.5,
      );

  static TextStyle get button => GoogleFonts.roboto(
        fontSize: fontSizeMedium,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  static TextStyle get caption => GoogleFonts.roboto(
        fontSize: fontSizeSmall,
        fontWeight: FontWeight.normal,
        height: 1.4,
      );

  static TextStyle get overline => GoogleFonts.roboto(
        fontSize: fontSizeSmall,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 1.5,
      );
}
