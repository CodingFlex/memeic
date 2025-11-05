import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:memeic/ui/views/home/home_view.dart';
import 'package:memeic/ui/views/search/search_view.dart';
import 'package:memeic/ui/views/favorites/favorites_view.dart';
import 'package:memeic/ui/views/settings/settings_view.dart';

class MainNavigationViewModel extends BaseViewModel {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Widget get currentView {
    switch (_currentIndex) {
      case 0:
        return const HomeView(key: ValueKey('home'));
      case 1:
        return const SearchView(key: ValueKey('search'));
      case 2:
        return const FavoritesView(key: ValueKey('favorites'));
      case 3:
        return const SettingsView(key: ValueKey('settings'));
      default:
        return const HomeView(key: ValueKey('home'));
    }
  }
}
