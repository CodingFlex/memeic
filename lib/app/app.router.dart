// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i9;
import 'package:flutter/material.dart';
import 'package:memeic/ui/views/favorites/favorites_view.dart' as _i6;
import 'package:memeic/ui/views/home/home_view.dart' as _i4;
import 'package:memeic/ui/views/main_navigation/main_navigation_view.dart'
    as _i3;
import 'package:memeic/ui/views/meme_detail/meme_detail_view.dart' as _i8;
import 'package:memeic/ui/views/onboardingauth/onboardingauth_view.dart' as _i2;
import 'package:memeic/ui/views/search/search_view.dart' as _i5;
import 'package:memeic/ui/views/search/search_viewmodel.dart' as _i10;
import 'package:memeic/ui/views/settings/settings_view.dart' as _i7;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i11;

class Routes {
  static const onboardingauthView = '/';

  static const mainNavigationView = '/main-navigation-view';

  static const homeView = '/home-view';

  static const searchView = '/search-view';

  static const favoritesView = '/favorites-view';

  static const settingsView = '/settings-view';

  static const memeDetailView = '/meme-detail-view';

  static const all = <String>{
    onboardingauthView,
    mainNavigationView,
    homeView,
    searchView,
    favoritesView,
    settingsView,
    memeDetailView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.onboardingauthView,
      page: _i2.OnboardingauthView,
    ),
    _i1.RouteDef(
      Routes.mainNavigationView,
      page: _i3.MainNavigationView,
    ),
    _i1.RouteDef(
      Routes.homeView,
      page: _i4.HomeView,
    ),
    _i1.RouteDef(
      Routes.searchView,
      page: _i5.SearchView,
    ),
    _i1.RouteDef(
      Routes.favoritesView,
      page: _i6.FavoritesView,
    ),
    _i1.RouteDef(
      Routes.settingsView,
      page: _i7.SettingsView,
    ),
    _i1.RouteDef(
      Routes.memeDetailView,
      page: _i8.MemeDetailView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.OnboardingauthView: (data) {
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.OnboardingauthView(),
        settings: data,
      );
    },
    _i3.MainNavigationView: (data) {
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.MainNavigationView(),
        settings: data,
      );
    },
    _i4.HomeView: (data) {
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => const _i4.HomeView(),
        settings: data,
      );
    },
    _i5.SearchView: (data) {
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => const _i5.SearchView(),
        settings: data,
      );
    },
    _i6.FavoritesView: (data) {
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => const _i6.FavoritesView(),
        settings: data,
      );
    },
    _i7.SettingsView: (data) {
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => const _i7.SettingsView(),
        settings: data,
      );
    },
    _i8.MemeDetailView: (data) {
      final args = data.getArgs<MemeDetailViewArguments>(nullOk: false);
      return _i9.MaterialPageRoute<dynamic>(
        builder: (context) => _i8.MemeDetailView(
            key: args.key,
            meme: args.meme,
            favoriteIds: args.favoriteIds,
            heroTag: args.heroTag),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class MemeDetailViewArguments {
  const MemeDetailViewArguments({
    this.key,
    required this.meme,
    this.favoriteIds,
    this.heroTag,
  });

  final _i9.Key? key;

  final _i10.MemeModel meme;

  final Set<String>? favoriteIds;

  final String? heroTag;

  @override
  String toString() {
    return '{"key": "$key", "meme": "$meme", "favoriteIds": "$favoriteIds", "heroTag": "$heroTag"}';
  }

  @override
  bool operator ==(covariant MemeDetailViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key &&
        other.meme == meme &&
        other.favoriteIds == favoriteIds &&
        other.heroTag == heroTag;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        meme.hashCode ^
        favoriteIds.hashCode ^
        heroTag.hashCode;
  }
}

extension NavigatorStateExtension on _i11.NavigationService {
  Future<dynamic> navigateToOnboardingauthView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.onboardingauthView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMainNavigationView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.mainNavigationView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSearchView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.searchView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToFavoritesView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.favoritesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.settingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMemeDetailView({
    _i9.Key? key,
    required _i10.MemeModel meme,
    Set<String>? favoriteIds,
    String? heroTag,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.memeDetailView,
        arguments: MemeDetailViewArguments(
            key: key, meme: meme, favoriteIds: favoriteIds, heroTag: heroTag),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithOnboardingauthView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.onboardingauthView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMainNavigationView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.mainNavigationView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSearchView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.searchView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithFavoritesView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.favoritesView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.settingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithMemeDetailView({
    _i9.Key? key,
    required _i10.MemeModel meme,
    Set<String>? favoriteIds,
    String? heroTag,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.memeDetailView,
        arguments: MemeDetailViewArguments(
            key: key, meme: meme, favoriteIds: favoriteIds, heroTag: heroTag),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
