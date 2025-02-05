part of 'preferences_cubit.dart';

class PreferencesState {
  final bool darkMode;
  final bool notifNewForYou;
  final bool notifAccountActivity;
  final bool notifOpportunity;
  final bool notifPromotional;
  final bool holdwiseAutoSync;
  final bool developerMode;
  final String selectedLanguage;

  const PreferencesState({
    required this.darkMode,
    required this.notifNewForYou,
    required this.notifAccountActivity,
    required this.notifOpportunity,
    required this.notifPromotional,
    required this.holdwiseAutoSync,
    required this.developerMode,
    required this.selectedLanguage,
  });

  /// Default values for a new user.
  factory PreferencesState.initial() {
    return const PreferencesState(
      darkMode: false,
      notifNewForYou: true,
      notifAccountActivity: true,
      notifOpportunity: false,
      notifPromotional: false,
      holdwiseAutoSync: true,
      developerMode: false,
      selectedLanguage: "English",
    );
  }

  PreferencesState copyWith({
    bool? darkMode,
    bool? notifNewForYou,
    bool? notifAccountActivity,
    bool? notifOpportunity,
    bool? notifPromotional,
    bool? holdwiseAutoSync,
    bool? developerMode,
    String? selectedLanguage,
  }) {
    return PreferencesState(
      darkMode: darkMode ?? this.darkMode,
      notifNewForYou: notifNewForYou ?? this.notifNewForYou,
      notifAccountActivity: notifAccountActivity ?? this.notifAccountActivity,
      notifOpportunity: notifOpportunity ?? this.notifOpportunity,
      notifPromotional: notifPromotional ?? this.notifPromotional,
      holdwiseAutoSync: holdwiseAutoSync ?? this.holdwiseAutoSync,
      developerMode: developerMode ?? this.developerMode,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }
}
