import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'package:logger/logger.dart';
import 'package:memeic/helpers/app_error.dart';
import 'package:memeic/services/supabase_service.dart';

/// Service for handling authentication operations.
///
/// This service provides methods for user authentication including
/// Google and Apple sign-in, email authentication, and guest mode.
class AuthService {
  final Logger _logger = Logger();
  final SupabaseService _supabaseService;

  AuthService(this._supabaseService);

  /// Get the current Supabase client.
  SupabaseClient get _client => _supabaseService.client;

  /// Get the current authenticated user, if any.
  User? get currentUser => _client.auth.currentUser;

  /// Check if a user is currently authenticated.
  bool get isAuthenticated => currentUser != null;

  /// Get the current session, if any.
  Session? get currentSession => _client.auth.currentSession;

  /// Stream of auth state changes.
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Sign in with Google using native Google Sign-In.
  ///
  /// This method uses the native Google Sign-In flow and then authenticates
  /// with Supabase using the obtained ID token.
  ///
  /// Returns [AuthResponse] containing the session and user.
  ///
  /// Throws [AppError] if authentication fails.
  Future<AuthResponse> signInWithGoogle() async {
    try {
      _logger.i('Initiating native Google sign-in');

      // Initialize Google Sign-In
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      // Sign out any existing Google session
      await googleSignIn.signOut();

      // Trigger the sign-in flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled by user');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      if (idToken == null) {
        throw Exception('Failed to obtain Google ID token');
      }

      _logger.i('Google ID token obtained, authenticating with Supabase');

      // Authenticate with Supabase using the ID token
      final response = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      _logger.i('Google sign-in successful');
      return response;
    } catch (e, stackTrace) {
      _logger.e('Google sign-in failed', e, stackTrace);
      throw AppError.create(
        message: 'Failed to sign in with Google: ${e.toString()}',
        type: ErrorType.authentication,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Sign in with Apple using native Apple Sign-In.
  ///
  /// This method uses the native Apple Sign-In flow and then authenticates
  /// with Supabase using the obtained ID token.
  ///
  /// Returns [AuthResponse] containing the session and user.
  ///
  /// Throws [AppError] if authentication fails.
  Future<AuthResponse> signInWithApple() async {
    try {
      _logger.i('Initiating native Apple sign-in');

      // Generate a random nonce using Supabase's method
      final rawNonce = _client.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      // Request credential for the currently signed in Apple account
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final String? idToken = appleCredential.identityToken;

      if (idToken == null) {
        throw Exception('Failed to obtain Apple ID token');
      }

      _logger.i('Apple ID token obtained, authenticating with Supabase');

      // Authenticate with Supabase using the ID token
      final response = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );

      _logger.i('Apple sign-in successful');
      return response;
    } catch (e, stackTrace) {
      _logger.e('Apple sign-in failed', e, stackTrace);
      throw AppError.create(
        message: 'Failed to sign in with Apple: ${e.toString()}',
        type: ErrorType.authentication,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Sign in with email and password.
  ///
  /// Throws [AppError] if authentication fails.
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _logger.i('Signing in with email: $email');

      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      _logger.i('Email sign-in successful');
      return response;
    } catch (e, stackTrace) {
      _logger.e('Email sign-in failed', e, stackTrace);
      throw AppError.create(
        message: 'Failed to sign in with email: ${e.toString()}',
        type: ErrorType.authentication,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Sign up with email and password.
  ///
  /// Throws [AppError] if registration fails.
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _logger.i('Signing up with email: $email');

      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      _logger.i('Email sign-up successful');
      return response;
    } catch (e, stackTrace) {
      _logger.e('Email sign-up failed', e, stackTrace);
      throw AppError.create(
        message: 'Failed to sign up with email: ${e.toString()}',
        type: ErrorType.authentication,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Continue as guest (anonymous user).
  ///
  /// This creates an anonymous session that allows the user to use
  /// the app without signing in. The session can be upgraded later.
  ///
  /// Throws [AppError] if guest authentication fails.
  Future<AuthResponse> signInAsGuest() async {
    try {
      _logger.i('Signing in as guest');

      final response = await _client.auth.signInAnonymously();

      _logger.i('Guest sign-in successful');
      return response;
    } catch (e, stackTrace) {
      _logger.e('Guest sign-in failed', e, stackTrace);
      throw AppError.create(
        message: 'Failed to sign in as guest: ${e.toString()}',
        type: ErrorType.authentication,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Sign out the current user.
  ///
  /// Throws [AppError] if sign out fails.
  Future<void> signOut() async {
    try {
      _logger.i('Signing out user');

      await _client.auth.signOut();

      _logger.i('Sign out successful');
    } catch (e, stackTrace) {
      _logger.e('Sign out failed', e, stackTrace);
      throw AppError.create(
        message: 'Failed to sign out: ${e.toString()}',
        type: ErrorType.authentication,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
