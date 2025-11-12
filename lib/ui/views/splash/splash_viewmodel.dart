import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:memeic/app/app.locator.dart';
import 'package:memeic/app/app.router.dart';

class SplashViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  /// Initialize splash screen and navigate after delay.
  void initialize() {
    // Wait 5 seconds then navigate to onboarding
    Future.delayed(const Duration(seconds: 5), () {
      _navigationService.replaceWith(Routes.onboardingauthView);
    });
  }
}
