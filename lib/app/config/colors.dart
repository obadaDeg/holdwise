import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary100 = Color(0xFFE6E2F8);
  static const Color primary200 = Color(0xFFCEC4F6);
  static const Color primary300 = Color(0xFFB2A2F9);
  static const Color primary400 = Color(0xFF9178FA);
  static const Color primary500 = Color(0xFF7152F3); // Base color
  static const Color primary600 = Color(0xFF5D3DE7);
  static const Color primary700 = Color(0xFF4F31D0);
  static const Color primary800 = Color(0xFF3517B4);
  static const Color primary900 = Color(0xFF250C92);
  

  // Secondary Colors
  static const Color secondary100 = Color(0xFFE1F1BC);
  static const Color secondary200 = Color(0xFFCEE993);
  static const Color secondary300 = Color(0xFFBCDE6B);
  static const Color secondary400 = Color(0xFFAFD751);
  static const Color secondary500 = Color(0xFFA3D139); // Base color
  static const Color secondary600 = Color(0xFF97BD33);
  static const Color secondary700 = Color(0xFF88A52A);
  static const Color secondary800 = Color(0xFF798D21);
  static const Color secondary900 = Color(0xFF626615);

  // Tertiary Colors
  static const Color tertiary100 = Color(0xFFF0B0D9);
  static const Color tertiary200 = Color(0xFFE67BC2);
  static const Color tertiary300 = Color(0xFFD846AB);
  static const Color tertiary400 = Color(0xFFCD0D9B);
  static const Color tertiary500 = Color(0xFFB21589); // Base color
  static const Color tertiary600 = Color(0xFFAF0A87);
  static const Color tertiary700 = Color(0xFF9B0982);
  static const Color tertiary800 = Color(0xFF8A087C);
  static const Color tertiary900 = Color(0xFF6C0772);

  // Neutral Colors
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFE0E0E0);
  static const Color gray300 = Color(0xFFBDBDBD);
  static const Color gray400 = Color(0xFF9E9E9E);
  static const Color gray500 = Color(0xFFA2A1A8);
  static const Color gray600 = Color(0xFF7E7D8A);
  static const Color gray700 = Color(0xFF6E6D7A);
  static const Color gray800 = Color(0xFF4F4E5B);
  static const Color gray900 = Color(0xFF2A2A2A);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
  static const Color dark = Color(0xFF16151C);
  static const Color light = Color(0xFFD9E1E1);


  // Feedback Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFFD9E1E1);


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

class Gradients {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7FBE30), Color(0xFF30A5BE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
    tileMode: TileMode.clamp,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF30BEB6), Color(0xFF3069BE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
    tileMode: TileMode.clamp,
  );

  static const LinearGradient tertiaryGradient = LinearGradient(
    colors: [Color(0xFF5D30BE), Color(0xFFB330BE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
    tileMode: TileMode.clamp,
  );
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


class AppIcons {
  static const String home = 'assets/icons/home.svg';
  static const String search = 'assets/icons/search.svg';
  static const String profile = 'assets/icons/profile.svg';
  static const String settings = 'assets/icons/settings.svg';
  static const String logout = 'assets/icons/logout.svg';
  static const String back = 'assets/icons/back.svg';
  static const String close = 'assets/icons/close.svg';
  static const String menu = 'assets/icons/menu.svg';
  static const String notification = 'assets/icons/notification.svg';
  static const String notificationOff = 'assets/icons/notification_off.svg';
  static const String notificationOn = 'assets/icons/notification_on.svg';
  static const String notificationError = 'assets/icons/notification_error.svg';
  static const String notificationWarning = 'assets/icons/notification_warning.svg';
  static const String notificationSuccess = 'assets/icons/notification_success.svg';
  static const String notificationInfo = 'assets/icons/notification_info.svg';
  static const String error = 'assets/icons/error.svg';
  static const String warning = 'assets/icons/warning.svg';
  static const String success = 'assets/icons/success.svg';
  static const String info = 'assets/icons/info.svg';
  static const String empty = 'assets/icons/empty.svg';
  static const String emptySearch = 'assets/icons/empty_search.svg';
  static const String emptyNotification = 'assets/icons/empty_notification.svg';
  static const String emptyProfile = 'assets/icons/empty_profile.svg';
  static const String emptySettings = 'assets/icons/empty_settings.svg';
  static const String emptyError = 'assets/icons/empty_error.svg';
  static const String emptyWarning = 'assets/icons/empty_warning.svg';
  static const String emptySuccess = 'assets/icons/empty_success.svg';
  static const String emptyInfo = 'assets/icons/empty_info.svg';
  static const String emptyData = 'assets/icons/empty_data.svg';
  static const String emptySearchData = 'assets/icons/empty_search_data.svg';
  static const String emptyNotificationData = 'assets/icons/empty_notification_data.svg';
  static const String emptyProfileData = 'assets/icons/empty_profile_data.svg';
  static const String emptySettingsData = 'assets/icons/empty_settings_data.svg';
  static const String emptyErrorData = 'assets/icons/empty_error_data.svg';
  static const String emptyWarningData = 'assets/icons/empty_warning_data.svg';
  static const String emptySuccessData = 'assets/icons/empty_success_data.svg';
  static const String emptyInfoData = 'assets/icons/empty_info_data.svg';

  static const String appLogo = 'assets/icons/app_logo.png';
  static const String defaultImage = 'assets/images/default.png';
  static const String defaultAvatar = 'assets/images/avatar.png';

  static const String google = 'assets/icons/google.svg';
  static const String facebook = 'assets/icons/facebook.svg';


}