import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary100 = Color(0xFFF3E5F5);
  static const Color primary200 = Color(0xFFE1BEE7);
  static const Color primary300 = Color(0xFFCE93D8);
  static const Color primary400 = Color(0xFFBA68C8);
  static const Color primary500 = Color(0xFF7152F3); // Base color
  static const Color primary600 = Color(0xFF9C27B0);
  static const Color primary700 = Color(0xFF8E24AA);
  static const Color primary800 = Color(0xFF7B1FA2);
  static const Color primary900 = Color(0xFF6A1B9A);

  // Secondary Colors
  static const Color secondary100 = Color(0xFFF8BBD0);
  static const Color secondary200 = Color(0xFFF48FB1);
  static const Color secondary300 = Color(0xFFF06292);
  static const Color secondary400 = Color(0xFFEC407A);
  static const Color secondary500 = Color(0xFFE91E63); // Base color
  static const Color secondary600 = Color(0xFFD81B60);
  static const Color secondary700 = Color(0xFFC2185B);
  static const Color secondary800 = Color(0xFFAD1457);
  static const Color secondary900 = Color(0xFF880E4F);

  // Tertiary Colors
  static const Color tertiary100 = Color(0xFFC8E6C9);
  static const Color tertiary200 = Color(0xFFA5D6A7);
  static const Color tertiary300 = Color(0xFF81C784);
  static const Color tertiary400 = Color(0xFF66BB6A);
  static const Color tertiary500 = Color(0xFF4CAF50); // Base color
  static const Color tertiary600 = Color(0xFF43A047);
  static const Color tertiary700 = Color(0xFF388E3C);
  static const Color tertiary800 = Color(0xFF2E7D32);
  static const Color tertiary900 = Color(0xFF1B5E20);

  // Neutral Colors
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Feedback Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Opacity Utility (Dynamically)
  static Color withOpacity(Color color, double opacity) {
    if (opacity < 0.0 || opacity > 1.0) {
      throw Exception('Opacity must be between 0.0 and 1.0');
    }

    return color.withValues(
      alpha: opacity,
      red: color.r.toDouble(),
      green: color.g.toDouble(),
      blue: color.b.toDouble(),
    );
  }
}

class AppTypography {
  static TextStyle baseStyle(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).size.width /
        375; // Assume 375 as base width for scaling
    return TextStyle(
      fontFamily: 'Lexend',
      color: Colors.black,
      fontSize: 16 * scaleFactor,
    );
  }

  static TextStyle header1(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).size.width / 375;
    return baseStyle(context).copyWith(
      fontSize: 80 * scaleFactor,
      fontWeight: FontWeight.bold,
      letterSpacing: -1.5,
    );
  }

  static TextStyle header2(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).size.width / 375;
    return baseStyle(context).copyWith(
      fontSize: 60 * scaleFactor,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    );
  }

  static TextStyle header3(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).size.width / 375;
    return baseStyle(context).copyWith(
      fontSize: 48 * scaleFactor,
      fontWeight: FontWeight.bold,
      letterSpacing: 0,
    );
  }

  static TextStyle header4(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).size.width / 375;
    return baseStyle(context).copyWith(
      fontSize: 34 * scaleFactor,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.25,
    );
  }

  static TextStyle header5(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).size.width / 375;
    return baseStyle(context).copyWith(
      fontSize: 24 * scaleFactor,
      fontWeight: FontWeight.bold,
      letterSpacing: 0,
    );
  }

  static TextStyle header6(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).size.width / 375;
    return baseStyle(context).copyWith(
      fontSize: 20 * scaleFactor,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.15,
    );
  }

  static TextStyle subtitle1(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).size.width / 375;
    return baseStyle(context).copyWith(
      fontSize: 18 * scaleFactor,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.15,
    );
  }

  static TextStyle subtitle2(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).size.width / 375;
    return baseStyle(context).copyWith(
      fontSize: 16 * scaleFactor,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.1,
    );
  }

  static TextStyle body1(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).size.width / 375;
    return baseStyle(context).copyWith(
      fontSize: 16 * scaleFactor,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.5,
    );
  }

  static TextStyle body2(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).size.width / 375;
    return baseStyle(context).copyWith(
      fontSize: 14 * scaleFactor,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.25,
    );
  }

  static TextStyle button(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).size.width / 375;
    return baseStyle(context).copyWith(
      fontSize: 14 * scaleFactor,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.25,
    );
  }

  static TextStyle caption(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).size.width / 375;
    return baseStyle(context).copyWith(
      fontSize: 12 * scaleFactor,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.4,
    );
  }

  static TextStyle overline(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).size.width / 375;
    return baseStyle(context).copyWith(
      fontSize: 10 * scaleFactor,
      fontWeight: FontWeight.normal,
      letterSpacing: 1.5,
    );
  }

  static TextStyle label(BuildContext context) {
    double scaleFactor = MediaQuery.of(context).size.width / 375;
    return baseStyle(context).copyWith(
      fontSize: 16 * scaleFactor,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.75,
    );
  }

  static TextStyle applyColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }
}


/**
 * 
class LightColors {
  static const Color lightPrimaryColor = Color(0xFFE0E0E0); // Light Grey
  static const Color lightSecondaryColor = Color(0xFFFFFFFF); // White
  static const Color lightTertiaryColor = Color(0xFFE0E0E0); // Light Grey
  static const Color lightAccentColor = Color(0xFF9E9E9E); // Grey
  static const Color lightTextColor = Color(0xFF212121); // Dark Grey
  static const Color lightIconColor = Color(0xFF757575); // Grey
  static const Color lightButtonColor = Color(0xFFE0E0E0); // Light Grey
  static const Color lightButtonTextColor = Color(0xFF212121); // Dark Grey
  static const Color lightErrorColor = Color(0xFFB00020); // Red
  static const Color lightWarningColor = Color(0xFFFFAB00); // Orange
  static const Color lightSuccessColor = Color(0xFF00C853); // Green
  static const Color lightInfoColor = Color(0xFF2979FF); // Blue
  static const Color lightBackgroundColor = Color(0xFFFAFAFA); // Light Grey
  static const Color lightCardColor = Color(0xFFFFFFFF); // White
  static const Color lightCardShadowColor = Color(0xFF000000); // Black
  static const Color lightCardBorderColor = Color(0xFFE0E0E0); // Light Grey
  static const Color lightCardTextColor = Color(0xFF212121); // Dark Grey
  static const Color lightCardIconColor = Color(0xFF757575); // Grey
  static const Color lightCardButtonColor = Color(0xFFE0E0E0); // Light Grey
  static const Color lightCardButtonTextColor = Color(0xFF212121); // Dark Grey
  static const Color lightCardErrorColor = Color(0xFFB00020); // Red
  static const Color lightCardWarningColor = Color(0xFFFFAB00); // Orange
  static const Color lightCardSuccessColor = Color(0xFF00C853); // Green
  static const Color lightCardInfoColor = Color(0xFF2979FF); // Blue
  static const Color lightCardBackgroundColor = Color(0xFFFAFAFA); // Light Grey
}

class DarkColors {
  static const Color darkPrimaryColor = Color(0xFF212121); // Dark Grey
  static const Color darkSecondaryColor = Color(0xFF000000); // Black
  static const Color darkTertiaryColor = Color(0xFF424242); // Grey
  static const Color darkAccentColor = Color(0xFF616161); // Grey
  static const Color darkTextColor = Color(0xFFFFFFFF); // White
  static const Color darkIconColor = Color(0xFF9E9E9E); // Grey
  static const Color darkButtonColor = Color(0xFF212121); // Dark Grey
  static const Color darkButtonTextColor = Color(0xFFFFFFFF); // White
  static const Color darkErrorColor = Color(0xFFCF6679); // Red
  static const Color darkWarningColor = Color(0xFFFFAB00); // Orange
  static const Color darkSuccessColor = Color(0xFF00C853); // Green
  static const Color darkInfoColor = Color(0xFF2979FF); // Blue
  static const Color darkBackgroundColor = Color(0xFF121212); // Dark Grey
  static const Color darkCardColor = Color(0xFF333333); // Dark Grey
  static const Color darkCardShadowColor = Color(0xFF000000); // Black
  static const Color darkCardBorderColor = Color(0xFF424242); // Grey
  static const Color darkCardTextColor = Color(0xFFFFFFFF); // White
  static const Color darkCardIconColor = Color(0xFF9E9E9E); // Grey
  static const Color darkCardButtonColor = Color(0xFF212121); // Dark Grey
  static const Color darkCardButtonTextColor = Color(0xFFFFFFFF); // White
  static const Color darkCardErrorColor = Color(0xFFCF6679); // Red
  static const Color darkCardWarningColor = Color(0xFFFFAB00); // Orange
  static const Color darkCardSuccessColor = Color(0xFF00C853); // Green
  static const Color darkCardInfoColor = Color(0xFF2979FF); // Blue
  static const Color darkCardBackgroundColor = Color(0xFF121212); // Dark Grey
}

 */