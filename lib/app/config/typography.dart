
import 'package:flutter/material.dart';

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

