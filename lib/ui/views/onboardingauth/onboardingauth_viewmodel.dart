import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:logger/logger.dart';
import 'package:memeic/app/app.locator.dart';
import 'package:memeic/app/app.router.dart';

class OnboardingauthViewModel extends BaseViewModel {
  final Logger _logger = Logger();
  final _navigationService = locator<NavigationService>();

  void onGoogleTapped() {
    _logger.i('Google sign-in tapped');
    _navigateToMainApp();
  }

  void onAppleTapped() {
    _logger.i('Apple sign-in tapped');
    _navigateToMainApp();
  }

  void onEmailTapped() {
    _logger.i('Email sign-in tapped');
    _navigateToMainApp();
  }

  void onGuestTapped() {
    _logger.i('Guest continue tapped');
    _navigateToMainApp();
  }

  void _navigateToMainApp() {
    _navigationService.replaceWith(Routes.mainNavigationView);
  }
}
