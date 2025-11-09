/// Single-flavor configuration (no multi-flavor support).
///
/// Keep the minimal API surface so existing code can read `FlavorConfig.instance.values`.
enum Flavor { single }

class FlavorValues {
  final String baseUrl;
  final String appTitle;
  final bool enableLogging;
  final Map<String, String> apiKeys;

  const FlavorValues({
    this.baseUrl = '',
    this.appTitle = 'App',
    this.enableLogging = true,
    this.apiKeys = const {},
  });

  /// Get Supabase URL from apiKeys.
  /// Returns empty string if not configured.
  String get supabaseUrl => apiKeys['supabase_url'] ?? '';

  /// Get Supabase anonymous key from apiKeys.
  /// Returns empty string if not configured.
  String get supabaseAnonKey => apiKeys['supabase_anon_key'] ?? '';
}

class FlavorConfig {
  final Flavor flavor;
  final FlavorValues values;
  static FlavorConfig? _instance;

  factory FlavorConfig({FlavorValues? values}) {
    _instance ??= FlavorConfig._internal(
      Flavor.single,
      values ?? const FlavorValues(),
    );
    return _instance!;
  }

  FlavorConfig._internal(this.flavor, this.values);

  static FlavorConfig get instance {
    _instance ??= FlavorConfig();
    return _instance!;
  }
}
