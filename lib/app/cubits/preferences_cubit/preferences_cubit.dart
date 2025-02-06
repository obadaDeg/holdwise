import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'preferences_state.dart';

/// Cubit that loads, holds, and updates the user's preferences.
class PreferencesCubit extends Cubit<PreferencesState> {
  PreferencesCubit() : super(PreferencesState.initial()) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    emit(state.copyWith(
      notifNewForYou: prefs.getBool('notif_new_for_you') ?? state.notifNewForYou,
      notifAccountActivity: prefs.getBool('notif_account_activity') ?? state.notifAccountActivity,
      notifOpportunity: prefs.getBool('notif_opportunity') ?? state.notifOpportunity,
      notifPromotional: prefs.getBool('notif_promotional') ?? state.notifPromotional,
      holdwiseAutoSync: prefs.getBool('holdwise_auto_sync') ?? state.holdwiseAutoSync,
      developerMode: prefs.getBool('developer_mode') ?? state.developerMode,
      selectedLanguage: prefs.getString('selected_language') ?? state.selectedLanguage,
    ));
  }

  Future<void> _savePreferences(PreferencesState newState) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_new_for_you', newState.notifNewForYou);
    await prefs.setBool('notif_account_activity', newState.notifAccountActivity);
    await prefs.setBool('notif_opportunity', newState.notifOpportunity);
    await prefs.setBool('notif_promotional', newState.notifPromotional);
    await prefs.setBool('holdwise_auto_sync', newState.holdwiseAutoSync);
    await prefs.setBool('developer_mode', newState.developerMode);
    await prefs.setString('selected_language', newState.selectedLanguage);
  }

  void updateNotifNewForYou(bool value) {
    final newState = state.copyWith(notifNewForYou: value);
    emit(newState);
    _savePreferences(newState);
  }

  void updateNotifAccountActivity(bool value) {
    final newState = state.copyWith(notifAccountActivity: value);
    emit(newState);
    _savePreferences(newState);
  }

  void updateNotifOpportunity(bool value) {
    final newState = state.copyWith(notifOpportunity: value);
    emit(newState);
    _savePreferences(newState);
  }

  void updateNotifPromotional(bool value) {
    final newState = state.copyWith(notifPromotional: value);
    emit(newState);
    _savePreferences(newState);
  }

  void updateHoldwiseAutoSync(bool value) {
    final newState = state.copyWith(holdwiseAutoSync: value);
    emit(newState);
    _savePreferences(newState);
  }

  void updateDeveloperMode(bool value) {
    final newState = state.copyWith(developerMode: value);
    emit(newState);
    _savePreferences(newState);
  }

  void updateSelectedLanguage(String language) {
    final newState = state.copyWith(selectedLanguage: language);
    emit(newState);
    _savePreferences(newState);
  }
}
