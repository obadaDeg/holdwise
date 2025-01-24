import 'package:flutter/material.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/config/typography.dart';

class AppTheme {
  static const double borderRadius = 8.0;

  /// Light Theme Configuration
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _colorSchemeLight(),
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: _appBarTheme(context, AppColors.primary500, AppColors.white),
      textTheme: _textTheme(context),
      elevatedButtonTheme: _elevatedButtonTheme(context, AppColors.primary500),
      textButtonTheme: _textButtonTheme(context, AppColors.primary500),
      outlinedButtonTheme: _outlinedButtonTheme(context, AppColors.primary500),
      inputDecorationTheme: _inputDecorationTheme(context, AppColors.primary500, AppColors.light, AppColors.gray500),
      floatingActionButtonTheme: _floatingActionButtonTheme(AppColors.primary500),
      snackBarTheme: _snackBarTheme(context, AppColors.primary500, AppColors.secondary500),
      cardTheme: _cardTheme(AppColors.light, AppColors.gray500),
      dialogTheme: _dialogTheme(context, AppColors.white, AppColors.black),
      tabBarTheme: _tabBarTheme(context, AppColors.primary500, AppColors.gray500),
      progressIndicatorTheme: _progressIndicatorTheme(AppColors.primary500, AppColors.primary200),
      iconTheme: const IconThemeData(color: AppColors.gray500),
    );
  }

  /// Dark Theme Configuration
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _colorSchemeDark(),
      scaffoldBackgroundColor: AppColors.dark,
      appBarTheme: _appBarTheme(context, AppColors.primary700, AppColors.white),
      textTheme: _textTheme(context).apply(bodyColor: AppColors.white, displayColor: AppColors.white),
      elevatedButtonTheme: _elevatedButtonTheme(context, AppColors.primary700),
      textButtonTheme: _textButtonTheme(context, AppColors.primary700),
      outlinedButtonTheme: _outlinedButtonTheme(context, AppColors.primary700),
      inputDecorationTheme: _inputDecorationTheme(context, AppColors.primary700, AppColors.dark, AppColors.gray500),
      floatingActionButtonTheme: _floatingActionButtonTheme(AppColors.primary700),
      snackBarTheme: _snackBarTheme(context, AppColors.primary700, AppColors.secondary700),
      cardTheme: _cardTheme(AppColors.dark, AppColors.gray500),
      dialogTheme: _dialogTheme(context, AppColors.dark, AppColors.white),
    );
  }

  /// Common Color Schemes
  static ColorScheme _colorSchemeLight() => ColorScheme.fromSeed(
        seedColor: AppColors.primary500,
        primary: AppColors.primary500,
        secondary: AppColors.secondary500,
        surface: AppColors.light,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.black,
        onError: AppColors.white,
      );

  static ColorScheme _colorSchemeDark() => ColorScheme.fromSeed(
        seedColor: AppColors.primary700,
        primary: AppColors.primary700,
        secondary: AppColors.secondary700,
        surface: AppColors.dark,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.white,
        onError: AppColors.black,
      );

  /// Shared Themes and Configurations
  static AppBarTheme _appBarTheme(BuildContext context, Color backgroundColor, Color foregroundColor) {
    return AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      titleTextStyle: AppTypography.header6(context).copyWith(color: foregroundColor),
      iconTheme: IconThemeData(color: foregroundColor),
    );
  }

  static TextTheme _textTheme(BuildContext context) {
    return TextTheme(
      displayLarge: AppTypography.header1(context),
      displayMedium: AppTypography.header2(context),
      displaySmall: AppTypography.header3(context),
      headlineLarge: AppTypography.header4(context),
      headlineMedium: AppTypography.header5(context),
      headlineSmall: AppTypography.header6(context),
      titleLarge: AppTypography.subtitle1(context),
      titleMedium: AppTypography.subtitle2(context),
      bodyLarge: AppTypography.body1(context),
      bodyMedium: AppTypography.body2(context),
      labelLarge: AppTypography.label(context),
      labelMedium: AppTypography.button(context),
      bodySmall: AppTypography.caption(context),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(BuildContext context, Color color) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppColors.white,
        textStyle: AppTypography.button(context),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(BuildContext context, Color color) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: color,
        textStyle: AppTypography.button(context),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(BuildContext context, Color color) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        textStyle: AppTypography.button(context),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(BuildContext context, Color primaryColor, Color fillColor, Color hintColor) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor.withOpacity(0.7)),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 2),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      labelStyle: AppTypography.body1(context).copyWith(color: primaryColor),
      hintStyle: AppTypography.body2(context).copyWith(color: hintColor),
    );
  }

  static FloatingActionButtonThemeData _floatingActionButtonTheme(Color color) {
    return FloatingActionButtonThemeData(
      backgroundColor: color,
      foregroundColor: AppColors.white,
    );
  }

  static SnackBarThemeData _snackBarTheme(BuildContext context, Color backgroundColor, Color actionColor) {
    return SnackBarThemeData(
      backgroundColor: backgroundColor,
      contentTextStyle: AppTypography.body1(context).copyWith(color: AppColors.white),
      actionTextColor: actionColor,
    );
  }

  static CardTheme _cardTheme(Color backgroundColor, Color shadowColor) {
    return CardTheme(
      color: backgroundColor,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  static DialogTheme _dialogTheme(BuildContext context, Color backgroundColor, Color titleColor) {
    return DialogTheme(
      backgroundColor: backgroundColor,
      titleTextStyle: AppTypography.header5(context).copyWith(color: titleColor),
      contentTextStyle: AppTypography.body1(context).copyWith(color: titleColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  static TabBarTheme _tabBarTheme(BuildContext context, Color selectedColor, Color unselectedColor) {
    return TabBarTheme(
      labelColor: selectedColor,
      unselectedLabelColor: unselectedColor,
      labelStyle: AppTypography.body1(context),
      unselectedLabelStyle: AppTypography.body2(context),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: selectedColor, width: 2),
      ),
    );
  }

  static ProgressIndicatorThemeData _progressIndicatorTheme(Color color, Color trackColor) {
    return ProgressIndicatorThemeData(
      color: color,
      linearTrackColor: trackColor,
    );
  }
}
