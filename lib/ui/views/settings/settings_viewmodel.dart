import 'package:stacked/stacked.dart';
import 'package:logger/logger.dart';

class SettingsViewModel extends BaseViewModel {
  final _logger = Logger();

  String get userName => 'Guest User';

  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  bool _notificationsEnabled = true;
  bool get notificationsEnabled => _notificationsEnabled;

  bool _aiSuggestionsEnabled = true;
  bool get aiSuggestionsEnabled => _aiSuggestionsEnabled;

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    _logger.d('Dark mode toggled: $value');
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    _logger.d('Notifications toggled: $value');
    notifyListeners();
  }

  void toggleAiSuggestions(bool value) {
    _aiSuggestionsEnabled = value;
    _logger.d('AI suggestions toggled: $value');
    notifyListeners();
  }

  void onLanguagePressed() {
    _logger.d('Language settings pressed');
    // TODO: Navigate to language selection
  }

  void onPrivacyPressed() {
    _logger.d('Privacy settings pressed');
    // TODO: Navigate to privacy settings
  }

  void onAboutPressed() {
    _logger.d('About pressed');
    // TODO: Show about dialog
  }

  void onFeedbackPressed() {
    _logger.d('Feedback pressed');
    // TODO: Open feedback form
  }

  void onSignOut() {
    _logger.d('Sign out pressed');
    // TODO: Implement sign out and navigate to onboarding
  }

  void onResetOnboarding() {
    _logger.d('Reset onboarding pressed');
    // TODO: Reset onboarding flag and navigate to onboarding
  }

  void onProfilePressed() {
    _logger.d('Profile pressed');
    // TODO: Navigate to profile creation/editing
  }
}
