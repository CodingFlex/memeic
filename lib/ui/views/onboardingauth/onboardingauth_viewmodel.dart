import 'package:stacked/stacked.dart';
import 'package:logger/logger.dart';

class OnboardingauthViewModel extends BaseViewModel {
  final Logger _logger = Logger();

  void onGoogleTapped() {
    _logger.i('Google sign-in tapped');
  }

  void onAppleTapped() {
    _logger.i('Apple sign-in tapped');
  }

  void onEmailTapped() {
    _logger.i('Email sign-in tapped');
  }

  void onGuestTapped() {
    _logger.i('Guest continue tapped');
  }
}
