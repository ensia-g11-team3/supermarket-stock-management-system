import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized font configuration for the application
class AppFonts {
  // Font Family
  static String? get fontFamily => GoogleFonts.inter().fontFamily;
  
  // Base Text Style
  static TextStyle get baseTextStyle => GoogleFonts.inter();
  
  // Text Theme
  static TextTheme get textTheme => GoogleFonts.interTextTheme();
  
  // Helper methods for common text styles
  static TextStyle heading1({Color? color, FontWeight? fontWeight}) {
    return GoogleFonts.inter(
      fontSize: 32,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color,
    );
  }
  
  static TextStyle heading2({Color? color, FontWeight? fontWeight}) {
    return GoogleFonts.inter(
      fontSize: 24,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color,
    );
  }
  
  static TextStyle heading3({Color? color, FontWeight? fontWeight}) {
    return GoogleFonts.inter(
      fontSize: 20,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color,
    );
  }
  
  static TextStyle bodyLarge({Color? color, FontWeight? fontWeight}) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
    );
  }
  
  static TextStyle bodyMedium({Color? color, FontWeight? fontWeight}) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
    );
  }
  
  static TextStyle bodySmall({Color? color, FontWeight? fontWeight}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
    );
  }
  
  static TextStyle button({Color? color, FontWeight? fontWeight}) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color,
    );
  }
  
  static TextStyle caption({Color? color, FontWeight? fontWeight}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
    );
  }
}

