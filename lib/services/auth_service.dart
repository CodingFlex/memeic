import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'package:logger/logger.dart';
import 'package:memeic/helpers/app_error.dart';
import 'package:memeic/helpers/flavor_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final Logger _logger = Logger();
  final SupabaseClient _supabase = Supabase.instance.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Get the current authenticated user, if any.
  User? get currentUser => _supabase.auth.currentUser;

  /// Check if a user is currently authenticated.
  bool get isAuthenticated => currentUser != null;

  /// Stream of auth state changes.
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// Sign in with Google using native Google Sign-In.
  ///
  /// This method uses the native Google Sign-In flow to obtain an ID token,
  /// then authenticates with Supabase using the obtained token.
  ///
  /// Returns [User] after successful authentication.
  ///
  /// Throws [AppError] if authentication fails.
  Future<User> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _supabase.auth.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled by user');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Failed to obtain Google ID token');
      }

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      final user = response.user;
      if (user == null) {
        throw Exception('Failed to authenticate with Supabase');
      }

      // Save or update user profile in 'profiles' table
      await _supabase.from('profiles').upsert({
        'id': user.id,
        'username': googleUser.displayName,
        'avatar_url': googleUser.photoUrl,
        'created_at': DateTime.now().toIso8601String(),
      });

      return user;
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
  /// This method uses the native Apple Sign-In flow to obtain an ID token,
  /// then authenticates with Supabase using the obtained token.
  ///
  /// Returns [User] after successful authentication.
  ///
  /// Throws [AppError] if authentication fails.
  Future<User> signInWithApple() async {
    try {
      final rawNonce = _generateNonce();
      final nonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final String? idToken = appleCredential.identityToken;

      if (idToken == null) {
        throw Exception('Failed to obtain Apple ID token');
      }

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
      );

      if (response.user == null) {
        throw Exception('Failed to authenticate with Supabase');
      }

      return response.user!;
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
  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Failed to authenticate with Supabase');
      }

      return response.user!;
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
  Future<User> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Failed to register with Supabase');
      }

      return response.user!;
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
  Future<User> signInAsGuest() async {
    try {
      final response = await _supabase.auth.signInAnonymously();

      if (response.user == null) {
        throw Exception('Failed to authenticate as guest');
      }

      return response.user!;
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
      await _googleSignIn.signOut();
      await _supabase.auth.signOut();
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

  /// Generate a cryptographically secure random nonce.
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }
}
