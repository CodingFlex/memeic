import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'package:logger/logger.dart';
import 'package:memeic/helpers/app_error.dart';

class AuthService {
  final Logger _logger = Logger();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Get the current authenticated user, if any.
  User? get currentUser => _auth.currentUser;

  /// Check if a user is currently authenticated.
  bool get isAuthenticated => currentUser != null;

  /// Stream of auth state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with Google using native Google Sign-In.
  ///
  /// This method uses the native Google Sign-In flow and then authenticates
  /// with Firebase using the obtained credential.
  ///
  /// Returns [User] after successful authentication.
  ///
  /// Throws [AppError] if authentication fails.
  Future<User> signInWithGoogle() async {
    try {
      _logger.i('Initiating native Google sign-in');

      // Sign out any existing Google session
      await _googleSignIn.signOut();
      await _auth.signOut();

      // Trigger the sign-in flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

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

      _logger.i('Google ID token obtained, authenticating with Firebase');

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);

      _logger.i('Google sign-in successful: ${userCredential.user?.email}');
      return userCredential.user!;
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
  /// with Firebase using the obtained credential.
  ///
  /// Returns [User] after successful authentication.
  ///
  /// Throws [AppError] if authentication fails.
  Future<User> signInWithApple() async {
    try {
      _logger.i('Initiating native Apple sign-in');

      // Generate a random nonce for Apple Sign-In
      final rawNonce = _generateNonce();
      final nonce = sha256.convert(utf8.encode(rawNonce)).toString();

      // Request credential for the currently signed in Apple account
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

      _logger.i('Apple ID token obtained, authenticating with Firebase');

      // Create an `OAuthCredential` from the credential returned by Apple
      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: idToken,
        rawNonce: rawNonce,
      );

      // Sign in to Firebase with the Apple credential
      final userCredential = await _auth.signInWithCredential(oauthCredential);

      _logger.i('Apple sign-in successful: ${userCredential.user?.email}');
      return userCredential.user!;
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
      _logger.i('Signing in with email: $email');

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _logger.i('Email sign-in successful');
      return userCredential.user!;
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
      _logger.i('Signing up with email: $email');

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _logger.i('Email sign-up successful');
      return userCredential.user!;
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
      _logger.i('Signing in as guest');

      final userCredential = await _auth.signInAnonymously();

      _logger.i('Guest sign-in successful');
      return userCredential.user!;
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

      await _googleSignIn.signOut();
      await _auth.signOut();

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
