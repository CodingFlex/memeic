import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:logger/logger.dart';
import 'package:memeic/app/app.locator.dart';
import 'package:memeic/app/app.router.dart';
import 'package:memeic/services/auth_service.dart';
import 'package:memeic/helpers/app_error.dart';
import 'package:memeic/ui/common/toast.dart';

class OnboardingauthViewModel extends BaseViewModel {
  final Logger _logger = Logger();
  final _navigationService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  final _toastService = locator<ToastService>();
  bool get isOAuthBusy => busy('Oauth');

  /// Handle Google sign-in.
  ///
  /// Initiates the Google OAuth flow and navigates to main app on success.
  Future<void> onGoogleTapped() async {
    try {
      _logger.i('Google sign-in tapped');
      setBusyForObject('Oauth', true);

      final user = await _authService.signInWithGoogle();

      _logger.i('Google sign-in successful: ${user.email}');
      _toastService.showSuccess(message: 'Signed in with Google successfully');
      _navigateToMainApp();
    } on AppError catch (e) {
      _logger.e('Google sign-in error: ${e.message}', e.originalError);
      _toastService.showError(message: e.message);
      setError(e.message);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error during Google sign-in', e, stackTrace);
      const errorMessage = 'An unexpected error occurred. Please try again.';
      _toastService.showError(message: errorMessage);
      setError(errorMessage);
    } finally {
      setBusyForObject('Oauth', false);
    }
  }

  /// Handle Apple sign-in.
  ///
  /// Initiates the Apple OAuth flow and navigates to main app on success.
  Future<void> onAppleTapped() async {
    try {
      _logger.i('Apple sign-in tapped');
      setBusyForObject('Oauth', true);

      final user = await _authService.signInWithApple();

      _logger.i('Apple sign-in successful: ${user.email}');
      _toastService.showSuccess(message: 'Signed in with Apple successfully');
      _navigateToMainApp();
    } on AppError catch (e) {
      _logger.e('Apple sign-in error: ${e.message}', e.originalError);
      _toastService.showError(message: e.message);
      setError(e.message);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error during Apple sign-in', e, stackTrace);
      const errorMessage = 'An unexpected error occurred. Please try again.';
      _toastService.showError(message: errorMessage);
      setError(errorMessage);
    } finally {
      setBusyForObject('Oauth', false);
    }
  }

  /// Check if OAuth authentication is busy (Google or Apple).

  /// Handle email sign-in.
  ///
  /// For now, this navigates to main app. Email authentication
  /// should be implemented with a proper email/password flow.
  void onEmailTapped() {
    _logger.i('Email sign-in tapped');
    // TODO: Implement email sign-in flow
    // For now, navigate to main app
    _navigateToMainApp();
  }

  /// Handle guest mode.
  ///
  /// Creates an anonymous session and navigates to main app.
  Future<void> onGuestTapped() async {
    try {
      _logger.i('Guest continue tapped');
      setBusy(true);

      await _authService.signInAsGuest();

      _logger.i('Guest sign-in successful');
      _toastService.showSuccess(message: 'Signed in as guest');
      _navigateToMainApp();
    } on AppError catch (e) {
      _logger.e('Guest sign-in error: ${e.message}', e.originalError);
      _toastService.showError(message: e.message);
      setError(e.message);
    } catch (e, stackTrace) {
      _logger.e('Unexpected error during guest sign-in', e, stackTrace);
      const errorMessage = 'An unexpected error occurred. Please try again.';
      _toastService.showError(message: errorMessage);
      setError(errorMessage);
    } finally {
      setBusy(false);
    }
  }

  void _navigateToMainApp() {
    _navigationService.replaceWith(Routes.mainNavigationView);
  }
}
