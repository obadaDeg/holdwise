import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Class for general app information
class AppInfo {
  static const String appName = 'HoldWise';
  static const String appVersion = '1.0.0';
}

class AppRoles {
  static const String admin = 'Admin';
  static const String patient = 'patient';
  static const String specialist = 'Specialist';
}

// Class for asset file paths
class Assets {
  static const String appIconPath = 'assets/icons/app_icon.png';
  static const String appLogoPath = 'assets/icons/app_logo.png';
  static const String defaultImagePath = 'assets/images/default.png';
  static const String defaultAvatarPath = 'assets/images/avatar.png';
}

// Class for error messages
class ErrorMessages {
  static const String noInternetError = 'No Internet Connection';
  static const String genericError = 'Something went wrong';
  static const String serverError = 'Server Error';
  static const String invalidDataError = 'Invalid Data';
  static const String invalidEmailError = 'Invalid Email';
  static const String invalidPasswordError = 'Invalid Password';
  static const String invalidPhoneNumberError = 'Invalid Phone Number';
  static const String invalidVerificationCodeError = 'Invalid Verification Code';
  static const String invalidOtpError = 'Invalid OTP';
  static const String invalidNameError = 'Invalid Name';
  static const String invalidAddressError = 'Invalid Address';
  static const String invalidPincodeError = 'Invalid Pincode';
  static const String invalidAmountError = 'Invalid Amount';
  static const String invalidDateError = 'Invalid Date';
  static const String invalidTimeError = 'Invalid Time';
  static const String invalidImageError = 'Invalid Image';
  static const String invalidFileError = 'Invalid File';
  static const String invalidVideoError = 'Invalid Video';
  static const String invalidAudioError = 'Invalid Audio';
  static const String invalidDocumentError = 'Invalid Document';
}

class WarningMessages {
  static const String wrongPosetureWarning = 'Wrong Posture Detected';
}

// Class for API keys (Move to environment variables or config files)
class APIKeys {
  // Avoid hardcoding API keys in production. Consider using a secure storage or environment variable.
  static String OPENAI_API_KEY = dotenv.env['OPENAI_API_KEY'] ?? 'No API Key Found';
}

class APIs {
  static const String openaiApiUrl = 'https://api.openai.com/v1/engines/davinci/completions';
  static String baseServerUrl = dotenv.env['BASE_SERVER_URL'] ?? 'http://localhost:5000';
}

class Constants {
  static const double borderRadius = 8.0;
  static const double backgroundWhiteAlpha = 0.95;
  
  // Padding constants (general)
  static double getPadding(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.05; // 5% of screen width
  }

  static double getSmallPadding(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.03; // 3% of screen width
  }

  static double getMediumPadding(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.07; // 7% of screen width
  }

  static double getLargePadding(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.1; // 10% of screen width
  }

  // Radius constants (for rounded corners)
  static double getSmallRadius(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.03; // 3% of screen width
  }

  static double getMediumRadius(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.05; // 5% of screen width
  }

  static double getLargeRadius(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.08; // 8% of screen width
  }

  // Icon size constants
  static double getSmallIconSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.06; // 6% of screen width
  }

  static double getMediumIconSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.08; // 8% of screen width
  }

  static double getLargeIconSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.1; // 10% of screen width
  }

  // Font size constants
  static double getSmallFontSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.04; // 4% of screen width
  }

  static double getMediumFontSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.05; // 5% of screen width
  }

  static double getLargeFontSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.07; // 7% of screen width
  }

  // Button size constants
  static double getButtonHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.07; // 7% of screen height
  }

  static double getButtonWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.8; // 80% of screen width
  }

  static double getButtonFontSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.05; // 5% of screen width
  }

  // Form Field size constants
  static double getFormFieldHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.06; // 6% of screen height
  }

  static double getFormFieldIconSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.05; // 5% of screen width
  }

  static double getFormFieldFontSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.045; // 4.5% of screen width
  }

  // Miscellaneous constants
  static double getDividerHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.02; // 2% of screen height
  }

  static double getCardMargin(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.04; // 4% of screen width
  }

  static double getBorderRadius(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.05; // 5% of screen width
  }
}
