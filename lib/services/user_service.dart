import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:memeic/services/auth_service.dart';
import 'package:memeic/app/app.locator.dart';

/// UserService - Manages user state and access tokens
///
/// This service provides access to the current user's authentication state
/// and access tokens for making authenticated API requests.
class UserService {
  final Logger _logger = Logger();
  final AuthService _authService = locator<AuthService>();
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Get the current authenticated user
  User? get currentUser => _authService.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => _authService.isAuthenticated;

  /// Get the current access token
  ///
  /// Returns the access token from the current Supabase session.
  /// Returns null if user is not authenticated.
  String? get accessToken {
    final session = _supabase.auth.currentSession;
    return session?.accessToken;
  }

  /// Get the current refresh token
  ///
  /// Returns the refresh token from the current Supabase session.
  /// Returns null if user is not authenticated.
  String? get refreshToken {
    final session = _supabase.auth.currentSession;
    return session?.refreshToken;
  }

  /// Stream of auth state changes
  Stream<AuthState> get authStateChanges => _authService.authStateChanges;

  /// Get user ID
  ///
  /// Returns the current user's ID, or null if not authenticated.
  String? get userId => currentUser?.id;

  /// Get user email
  ///
  /// Returns the current user's email, or null if not authenticated.
  String? get userEmail => currentUser?.email;

  /// Check if access token is available
  ///
  /// Returns true if user is authenticated and has a valid access token.
  bool get hasAccessToken => accessToken != null;

  /// Refresh the access token if needed
  ///
  /// This will automatically refresh the token if it's expired.
  /// Supabase client handles this automatically, but this method
  /// can be used to explicitly refresh if needed.
  Future<void> refreshTokenIfNeeded() async {
    try {
      final session = _supabase.auth.currentSession;
      if (session != null) {
        // Supabase automatically refreshes tokens, but we can check expiry
        final expiresAt = session.expiresAt;
        if (expiresAt != null) {
          final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
          // Refresh if token expires in less than 5 minutes
          if (expiresAt - now < 300) {
            _logger.d('Token expiring soon, refreshing...');
            await _supabase.auth.refreshSession();
          }
        }
      }
    } catch (e, stackTrace) {
      _logger.e('Failed to refresh token', e, stackTrace);
    }
  }
}
