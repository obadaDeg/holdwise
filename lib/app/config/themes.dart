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
      appBarTheme: _appBarTheme(
        context,
        backgroundColor: AppColors.primary500,
        foregroundColor: AppColors.white,
      ),
      textTheme: _textTheme(context),
      elevatedButtonTheme: _elevatedButtonTheme(
        context,
        color: AppColors.primary500,
      ),
      textButtonTheme: _textButtonTheme(
        context,
        color: AppColors.primary500,
      ),
      outlinedButtonTheme: _outlinedButtonTheme(
        context,
        color: AppColors.primary500,
        fillColor: AppColors.white,
      ),

      // --- Input Decoration ---
      inputDecorationTheme: _inputDecorationTheme(
        context,
        fillColor: AppColors.light,
        filled: true,
        enabledBorderColor: AppColors.primary500,
        focusedBorderColor: AppColors.primary500,
        errorBorderColor: AppColors.error,
        disabledBorderColor: AppColors.gray300,
        hintColor: AppColors.black,
        labelStyle: AppTypography.body1(context).copyWith(
          color: AppColors.primary500,
        ),
        hintStyle: AppTypography.body2(context).copyWith(
          color: AppColors.black.withOpacity(0.5),
        ),
      ),

      floatingActionButtonTheme: _floatingActionButtonTheme(
        color: AppColors.primary500,
      ),
      snackBarTheme: _snackBarTheme(
        context,
        backgroundColor: AppColors.primary500,
        actionColor: AppColors.secondary500,
      ),
      cardTheme: _cardTheme(
        backgroundColor: AppColors.light,
        shadowColor: AppColors.black,
      ),
      dialogTheme: _dialogTheme(
        context,
        backgroundColor: AppColors.white,
        contentColor: AppColors.gray900,
        titleColor: AppColors.black,
      ),
      tabBarTheme: _tabBarTheme(
        context,
        selectedColor: AppColors.primary500,
        unselectedColor: AppColors.gray200,
      ),
      progressIndicatorTheme: _progressIndicatorTheme(
        color: AppColors.primary500,
        trackColor: AppColors.primary200,
      ),
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
      appBarTheme: _appBarTheme(
        context,
        backgroundColor: AppColors.primary700,
        foregroundColor: AppColors.white,
      ),
      textTheme: _textTheme(context)
          .apply(bodyColor: AppColors.white, displayColor: AppColors.white, fontFamily: 'Lexend'),
      elevatedButtonTheme: _elevatedButtonTheme(
        context,
        color: AppColors.primary700,
      ),
      textButtonTheme: _textButtonTheme(
        context,
        color: AppColors.white,
      ),
      outlinedButtonTheme: _outlinedButtonTheme(
        context,
        color: AppColors.primary500,
        fillColor: AppColors.gray200,
      ),
      inputDecorationTheme: _inputDecorationTheme(
        context,
        fillColor: AppColors.gray200,
        filled: true,
        enabledBorderColor: AppColors.primary500,
        focusedBorderColor: AppColors.primary500,
        errorBorderColor: AppColors.error,
        disabledBorderColor: AppColors.gray500,
        hintColor: AppColors.gray500,
        labelStyle: AppTypography.body1(context).copyWith(
          color: AppColors.primary500,
        ),
        hintStyle: AppTypography.body2(context).copyWith(
          color: AppColors.gray500,
        ),
      ),
      floatingActionButtonTheme: _floatingActionButtonTheme(
        color: AppColors.primary700,
      ),
      snackBarTheme: _snackBarTheme(
        context,
        backgroundColor: AppColors.primary700,
        actionColor: AppColors.secondary700,
      ),
      cardTheme: _cardTheme(
        backgroundColor: AppColors.gray800,
        shadowColor: AppColors.gray500,
      ),
      dialogTheme: _dialogTheme(
        context,
        backgroundColor: AppColors.dark,
        contentColor: AppColors.gray200,
        titleColor: AppColors.white,
      ),
      tabBarTheme: _tabBarTheme(
        context,
        selectedColor: AppColors.primary700,
        unselectedColor: AppColors.gray200,
      ),
      progressIndicatorTheme: _progressIndicatorTheme(
        color: AppColors.primary700,
        trackColor: AppColors.primary300,
      ),
      iconTheme: const IconThemeData(color: AppColors.gray300),
    );
  }

  /// Common Color Schemes
  static ColorScheme _colorSchemeLight() => ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary500,
        onPrimary: AppColors.white,
        secondary: AppColors.secondary500,
        onSecondary: AppColors.white,
        surface: AppColors.gray100,
        onSurface: AppColors.gray900,
        error: AppColors.error,
        onError: AppColors.white,
      );

  static ColorScheme _colorSchemeDark() => ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primary700,
        onPrimary: AppColors.gray100,
        secondary: AppColors.secondary700,
        onSecondary: AppColors.gray200,
        surface: AppColors.gray800,
        onSurface: AppColors.gray100,
        error: AppColors.error,
        onError: AppColors.gray100,
      );

  /// Shared Themes and Configurations
  static AppBarTheme _appBarTheme(
    BuildContext context, {
    required Color backgroundColor,
    required Color foregroundColor,
  }) {
    return AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      titleTextStyle:
          AppTypography.header6(context).copyWith(color: foregroundColor),
      iconTheme: IconThemeData(color: foregroundColor),
    );
  }

  static TextTheme _textTheme(BuildContext context) {
    return TextTheme(
      displayLarge:
          AppTypography.header1(context).copyWith(color: AppColors.gray900),
      displayMedium:
          AppTypography.header2(context).copyWith(color: AppColors.gray900),
      displaySmall:
          AppTypography.header3(context).copyWith(color: AppColors.gray900),
      headlineLarge:
          AppTypography.header4(context).copyWith(color: AppColors.gray900),
      headlineMedium:
          AppTypography.header5(context).copyWith(color: AppColors.gray900),
      headlineSmall:
          AppTypography.header6(context).copyWith(color: AppColors.gray900),
      titleLarge:
          AppTypography.subtitle1(context).copyWith(color: AppColors.gray900),
      titleMedium:
          AppTypography.subtitle2(context).copyWith(color: AppColors.gray900),
      bodyLarge:
          AppTypography.body1(context).copyWith(color: AppColors.gray900),
      bodyMedium:
          AppTypography.body2(context).copyWith(color: AppColors.gray900),
      labelLarge:
          AppTypography.label(context).copyWith(color: AppColors.gray900),
      labelMedium:
          AppTypography.button(context).copyWith(color: AppColors.gray900),
      bodySmall:
          AppTypography.caption(context).copyWith(color: AppColors.gray900),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(
    BuildContext context, {
    required Color color,
  }) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppColors.white,
        textStyle: AppTypography.button(context),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(
    BuildContext context, {
    required Color color,
  }) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: color,
        textStyle: AppTypography.button(context),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(
    BuildContext context, {
    required Color color,
    required Color fillColor,
  }) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        backgroundColor: fillColor,
        side: BorderSide(color: color),
        textStyle: AppTypography.button(context),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(
    BuildContext context, {
    // Basic colors
    required Color fillColor,
    bool filled = true,

    // Border radius & widths
    double borderRadius = 8.0,
    double enabledBorderWidth = 1.0,
    double focusedBorderWidth = 2.0,
    double errorBorderWidth = 1.0,
    double disabledBorderWidth = 1.0,

    // Border colors
    required Color enabledBorderColor,
    required Color focusedBorderColor,
    required Color hintColor,
    Color? errorBorderColor,
    Color? disabledBorderColor,

    // Label, hint, helper, error texts
    TextStyle? labelStyle,
    TextStyle? floatingLabelStyle,
    TextStyle? helperStyle,
    int? helperMaxLines,
    TextStyle? hintStyle,
    Duration? hintFadeDuration,
    TextStyle? errorStyle,
    int? errorMaxLines,

    // Label & hint behaviors
    FloatingLabelBehavior floatingLabelBehavior = FloatingLabelBehavior.auto,
    FloatingLabelAlignment floatingLabelAlignment =
        FloatingLabelAlignment.start,
    bool alignLabelWithHint = false,

    // Content layout
    bool isDense = false,
    bool isCollapsed = false,
    EdgeInsetsGeometry? contentPadding,
    BoxConstraints? constraints,

    // Icon or prefix/suffix customizations
    Color? iconColor,
    TextStyle? prefixStyle,
    Color? prefixIconColor,
    BoxConstraints? prefixIconConstraints,
    TextStyle? suffixStyle,
    Color? suffixIconColor,
    BoxConstraints? suffixIconConstraints,
    TextStyle? counterStyle,

    // Focus & hover colors
    Color? focusColor,
    Color? hoverColor,

    // If you want to pass fully custom borders
    InputBorder? enabledBorderOverride,
    InputBorder? focusedBorderOverride,
    InputBorder? errorBorderOverride,
    InputBorder? focusedErrorBorderOverride,
    InputBorder? disabledBorderOverride,
    InputBorder? globalBorderOverride,
  }) {
    // Helper method to build OutlineInputBorder with standard defaults.
    OutlineInputBorder _outline({
      required Color color,
      required double width,
    }) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecorationTheme(
      filled: filled,
      fillColor: fillColor,

      // Overall border (if you don't specify any state border)
      border: globalBorderOverride ??
          _outline(
            color: AppColors.gray300, // e.g. default fallback color
            width: enabledBorderWidth,
          ),

      // Enabled / focused / error / disabled borders
      enabledBorder: enabledBorderOverride ??
          _outline(
            color: enabledBorderColor,
            width: enabledBorderWidth,
          ),
      focusedBorder: focusedBorderOverride ??
          _outline(
            color: focusedBorderColor,
            width: focusedBorderWidth,
          ),
      errorBorder: errorBorderOverride ??
          _outline(
            color: errorBorderColor ?? Colors.red,
            width: errorBorderWidth,
          ),
      focusedErrorBorder: focusedErrorBorderOverride ??
          _outline(
            color: errorBorderColor ?? Colors.red,
            width: focusedBorderWidth,
          ),
      disabledBorder: disabledBorderOverride ??
          _outline(
            color: disabledBorderColor ?? AppColors.gray300,
            width: disabledBorderWidth,
          ),

      // Text styles
      labelStyle: labelStyle,
      floatingLabelStyle: floatingLabelStyle,
      helperStyle: helperStyle,
      helperMaxLines: helperMaxLines,
      hintStyle: hintStyle,
      hintFadeDuration: hintFadeDuration,
      errorStyle: errorStyle,
      errorMaxLines: errorMaxLines,

      // Label & hint behaviors
      floatingLabelBehavior: floatingLabelBehavior,
      floatingLabelAlignment: floatingLabelAlignment,
      alignLabelWithHint: alignLabelWithHint,

      // Layout & padding
      isDense: isDense,
      isCollapsed: isCollapsed,
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
      constraints: constraints,

      // Icons & prefix/suffix
      iconColor: iconColor,
      prefixStyle: prefixStyle,
      prefixIconColor: prefixIconColor,
      prefixIconConstraints: prefixIconConstraints,
      suffixStyle: suffixStyle,
      suffixIconColor: suffixIconColor,
      suffixIconConstraints: suffixIconConstraints,
      counterStyle: counterStyle,

      // Hover & focus colors
      focusColor: focusColor,
      hoverColor: hoverColor,
    );
  }

  static FloatingActionButtonThemeData _floatingActionButtonTheme({
    required Color color,
  }) {
    return FloatingActionButtonThemeData(
      backgroundColor: color,
      foregroundColor: AppColors.white,
    );
  }

  static SnackBarThemeData _snackBarTheme(
    BuildContext context, {
    required Color backgroundColor,
    required Color actionColor,
  }) {
    return SnackBarThemeData(
      backgroundColor: backgroundColor,
      contentTextStyle:
          AppTypography.body1(context).copyWith(color: AppColors.white),
      actionTextColor: actionColor,
    );
  }

  static CardTheme _cardTheme({
    required Color backgroundColor,
    required Color shadowColor,
  }) {
    return CardTheme(
      color: backgroundColor,
      shadowColor: AppColors.gray300,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: 2,
    );
  }

  static DialogTheme _dialogTheme(
    BuildContext context, {
    required Color backgroundColor,
    required Color titleColor,
    required Color contentColor,
  }) {
    return DialogTheme(
      backgroundColor: backgroundColor,
      titleTextStyle:
          AppTypography.header5(context).copyWith(color: titleColor),
      contentTextStyle:
          AppTypography.body1(context).copyWith(color: contentColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  static TabBarTheme _tabBarTheme(
    BuildContext context, {
    required Color selectedColor,
    required Color unselectedColor,
  }) {
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

  static ProgressIndicatorThemeData _progressIndicatorTheme({
    required Color color,
    required Color trackColor,
  }) {
    return ProgressIndicatorThemeData(
      color: color,
      linearTrackColor: trackColor,
    );
  }
}
