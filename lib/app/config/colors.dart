import 'package:flutter/material.dart';


// class AppColors {
//   static const Color gradientStart = Color(0xFF9C27B0); // Purple gradient start
//   static const Color gradientEnd = Color(0xFF673AB7);   // Deep Purple gradient end
//   static const Color primaryText = Color(0xFFFFFFFF);   // White for text
//   static const Color backgroundForm = Color(0x80000000); // Semi-transparent dark background
//   static const Color buttonBackground = Color(0xFF00BFA5); // Teal for buttons
//   static const Color iconColor = Color(0xFF000000); // White icons
//   static const Color inputFieldFill = Color(0xFFFFFFFF); // Clean white for input fields
//   static const Color secondaryText = Color(0xFF000000); // Black for secondary text
//   static const Color textColor = Colors.white;
//   static const Color black = Colors.black;
//   static const Color lightBackground = Color(0xFFF3E5F5);
// }


class LightColors {
  static const Color lightPrimaryColor = Color(0xFF00796B); // Teal
  static const Color lightSecondaryColor = Color(0xFF004D40); // Dark Teal
  static const Color lightAccentColor = Color(0xFFFFA726); // Vibrant Orange
  static const Color lightBackgroundColor = Color(0xFFFFFFFF); // White
  static const Color lightSurfaceColor = Color(0xFFF5F5F5); // Light Gray
  static const Color lightSuccessColor = Color(0xFF81C784); // Light Green
  static const Color lightErrorColor = Color(0xFFE57373); // Light Red
  static const Color lightWarningColor = Color(0xFFFFD54F); // Light Yellow
  static const Color lightInfoColor = Color(0xFF64B5F6); // Light Blue
  static const Color lightTextColor = Colors.black;
}

class DarkColors {
  static const Color darkPrimaryColor = Color(0xFF004D40); // Deep Teal
  static const Color darkSecondaryColor = Color(0xFF00251A); // Very Dark Teal
  static const Color darkAccentColor = Color(0xFFFF7043); // Coral
  static const Color darkBackgroundColor = Color(0xFF121212); // Charcoal
  static const Color darkSurfaceColor = Color(0xFF1E1E1E); // Dark Gray
  static const Color darkSuccessColor = Color(0xFF388E3C); // Dark Green
  static const Color darkErrorColor = Color(0xFFD32F2F); // Dark Red
  static const Color darkWarningColor = Color(0xFFFFA000); // Dark Yellow
  static const Color darkInfoColor = Color(0xFF1976D2); // Dark Blue
  static const Color darkTextColor = Colors.white;
}

class FeedbackColors {
  static const Color goodPostureColor = Color(0xFF4CAF50); // Green
  static const Color badPostureColor = Color(0xFFFF5252); // Red
  static const Color warningPostureColor = Color(0xFFFFC107); // Warm Orange
}

class Gradients {
  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      LightColors.lightPrimaryColor,
      LightColors.lightSecondaryColor,
    ],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      DarkColors.darkPrimaryColor,
      DarkColors.darkSecondaryColor,
    ],
  );
}
