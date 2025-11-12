import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';

/// Central service for Firebase initialization.
///
/// This service handles Firebase initialization.
class FirebaseService {
  final Logger _logger = Logger();
  bool _isInitialized = false;

  /// Check if Firebase is initialized.
  bool get isInitialized => _isInitialized;

  /// Initialize Firebase.
  ///
  /// This should be called once during app startup, before any
  /// authentication or database operations.
  Future<void> initialize() async {
    if (_isInitialized) {
      _logger.w('FirebaseService is already initialized');
      return;
    }

    try {
      await Firebase.initializeApp();
      _isInitialized = true;
      _logger.i('Firebase initialized successfully');
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to initialize Firebase',
        e,
        stackTrace,
      );
      rethrow;
    }
  }
}
