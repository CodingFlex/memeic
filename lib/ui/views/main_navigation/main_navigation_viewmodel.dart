import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:memeic/ui/views/home/home_view.dart';
import 'package:memeic/ui/views/search/search_view.dart';
import 'package:memeic/ui/views/favorites/favorites_view.dart';
import 'package:memeic/ui/views/settings/settings_view.dart';

class MainNavigationViewModel extends BaseViewModel {
  Widget get homeView => const HomeView(key: ValueKey('home'));
  Widget get searchView => const SearchView(key: ValueKey('search'));
  Widget get favoritesView => const FavoritesView(key: ValueKey('favorites'));
  Widget get settingsView => const SettingsView(key: ValueKey('settings'));
}
