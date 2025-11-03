import 'package:memeic/helpers/flavor_config.dart';

class URLProvider {
  static URLProvider? _instance;

  factory URLProvider() {
    _instance ??= URLProvider._internal();
    return _instance!;
  }

  URLProvider._internal();

  String get baseUrl => FlavorConfig.instance.values.baseUrl;

  // API Endpoints
  // String get homeEndpoint => '${AppConfig.apiPath}/home';
  // String get userEndpoint => '${AppConfig.apiPath}';
  // String get authEndpoint => '${AppConfig.apiPath}';

  //Auth
  String get authEndpointGoogle => '/auth/google/token';
  String get authEndpointApple => '/auth/apple/token';
  String get authEndpointRegister => '/auth/register';

  // User URLs
  String get userEndpoint => '/user/profile';
  String get userDelete => '/user/profile';
  String get userUpdateEndpoint => '/user/update';

  String checkUsernameAvailability(String? itemId) =>
      '/user/username/check/$itemId';

  //Push Notifications
  String get pushNotificationsEndpoint => '/push-notifications/register-token';
  String get pushNotificationsUnregisterEndpoint => '/push-notifications/token';

  //App Version
  String get appVersionEndpoint => '/app-version';

  // Helper methods for building URLs
  String addQueryParams(String url, Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) return url;

    final uri = Uri.parse(url);
    final queryParams = Map<String, dynamic>.from(uri.queryParameters)
      ..addAll(params);

    return uri.replace(queryParameters: queryParams).toString();
  }

  String addPathSegments(String url, List<String> segments) {
    final uri = Uri.parse(url);
    final pathSegments = List<String>.from(uri.pathSegments)..addAll(segments);

    return uri.replace(pathSegments: pathSegments).toString();
  }
}
