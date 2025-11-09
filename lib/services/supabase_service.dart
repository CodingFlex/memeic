import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import 'package:memeic/helpers/flavor_config.dart';

/// Central service for Supabase client access and initialization.
///
/// This service provides access to the Supabase client
/// and handles initialization with configuration from FlavorConfig.
class SupabaseService {
  final Logger _logger = Logger();
  bool _isInitialized = false;

  /// Get the Supabase client instance.
  ///
  /// Throws [StateError] if Supabase has not been initialized.
  SupabaseClient get client {
    if (!_isInitialized) {
      throw StateError(
        'Supabase has not been initialized. '
        'Call initialize() first.',
      );
    }
    return Supabase.instance.client;
  }

  /// Check if Supabase is initialized.
  bool get isInitialized => _isInitialized;

  /// Initialize Supabase with configuration from FlavorConfig.
  ///
  /// This should be called once during app startup, before any
  /// authentication or database operations.
  ///
  /// Throws [StateError] if Supabase URL or anon key is missing.
  Future<void> initialize() async {
    if (_isInitialized) {
      _logger.w('SupabaseService is already initialized');
      return;
    }

    final config = FlavorConfig.instance.values;
    final supabaseUrl = config.supabaseUrl;
    final supabaseAnonKey = config.supabaseAnonKey;

    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw StateError(
        'Supabase URL or anon key is missing in FlavorConfig. '
        'Please configure supabase_url and supabase_anon_key in apiKeys.',
      );
    }

    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        debug: config.enableLogging,
      );

      _isInitialized = true;
      _logger.i('Supabase initialized successfully');
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to initialize Supabase',
        e,
        stackTrace,
      );
      rethrow;
    }
  }
}
