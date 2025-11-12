import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:logger/logger.dart';
import 'package:memeic/app/app.locator.dart';
import 'package:memeic/services/hive_service.dart';

class MemeModel {
  final String id;
  final String imageUrl;
  final String? title;
  final List<String>? tags;
  final bool showPreview;

  MemeModel({
    required this.id,
    required this.imageUrl,
    this.title,
    this.tags,
    this.showPreview = false,
  });
}

class MoodModel {
  final String emoji;
  final String label;
  final int? percentage;

  MoodModel({
    required this.emoji,
    required this.label,
    this.percentage,
  });
}

class SearchViewModel extends BaseViewModel {
  final _logger = Logger();
  final _navigationService = locator<NavigationService>();
  final _hiveService = locator<HiveService>();
  final searchController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<MemeModel> _memes = [];
  List<MemeModel> get memes => _memes;

  // Load favorite IDs from Hive when view initializes
  final Set<String> _favoriteIds = {};

  // Search history for showing recent searches
  List<String> _recentSearches = [];
  List<String> get recentSearches => _recentSearches;

  bool _showTrending = true;
  bool get showTrending => _showTrending;

  final List<MoodModel> trendingMoods = [
    MoodModel(emoji: '😩', label: 'Monday mood', percentage: 25),
    MoodModel(emoji: '💃', label: 'Happy dance', percentage: 18),
    MoodModel(emoji: '🤔', label: 'Confused', percentage: 12),
    MoodModel(emoji: '🎉', label: 'Celebrating', percentage: 30),
  ];

  final List<MoodModel> popularMoods = [
    MoodModel(emoji: '', label: 'Funny'),
    MoodModel(emoji: '', label: 'Relatable'),
    MoodModel(emoji: '', label: 'Confused'),
    MoodModel(emoji: '', label: 'Happy'),
    MoodModel(emoji: '', label: 'Savage'),
    MoodModel(emoji: '', label: 'Wholesome'),
    MoodModel(emoji: '', label: 'Sad'),
    MoodModel(emoji: '', label: 'Surprised'),
    MoodModel(emoji: '', label: 'Thinking'),
    MoodModel(emoji: '', label: 'Celebrating'),
  ];

  SearchViewModel() {
    // Load favorites and search history when view is created
    _loadFavorites();
    _loadSearchHistory();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  /// Load favorite IDs from Hive
  ///
  /// How it works:
  /// 1. Gets all favorites from Hive
  /// 2. Extracts their IDs into a Set for quick lookup
  ///
  /// This is called when the view initializes so we know which memes are favorited
  void _loadFavorites() {
    try {
      final favorites = _hiveService.getAllFavorites();
      _favoriteIds.addAll(favorites.map((f) => f['id'] as String).toSet());
      _logger.d('Loaded ${_favoriteIds.length} favorite IDs from Hive');
    } catch (e, stackTrace) {
      _logger.e('Error loading favorites: $e', e, stackTrace);
    }
  }

  /// Load search history from Hive
  ///
  /// How it works:
  /// 1. Gets all recent searches from Hive
  /// 2. Updates the UI to show recent searches
  ///
  /// This is called when the view initializes to show recent searches
  void _loadSearchHistory() {
    try {
      _recentSearches = _hiveService.getSearchHistory();
      notifyListeners();
      _logger.d('Loaded ${_recentSearches.length} recent searches from Hive');
    } catch (e, stackTrace) {
      _logger.e('Error loading search history: $e', e, stackTrace);
    }
  }

  void onSearchChanged(String query) {
    _logger.d('Search query changed: $query');
    _showTrending = query.isEmpty;

    if (query.isNotEmpty) {
      _performSearch(query);
    } else {
      _memes = [];
    }
    notifyListeners();
  }

  void onVoiceSearch() {
    _logger.d('Voice search initiated');
    // TODO: Implement voice search functionality
  }

  void onMoodSelected(MoodModel mood) {
    _logger.d('Mood selected: ${mood.label}');
    searchController.text = mood.label;
    _performSearch(mood.label);
  }

  Future<void> _performSearch(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call with placeholder meme images
      await Future.delayed(const Duration(seconds: 1));

      _memes = [
        MemeModel(
          id: '1',
          imageUrl: 'https://i.imgflip.com/30b1gx.jpg',
          title: 'Surprised Pikachu',
        ),
        MemeModel(
          id: '2',
          imageUrl: 'https://i.imgflip.com/1g8my4.jpg',
          title: 'Distracted Boyfriend',
        ),
        MemeModel(
          id: '3',
          imageUrl: 'https://i.imgflip.com/26am.jpg',
          title: 'Drake Hotline Bling',
        ),
        MemeModel(
          id: '4',
          imageUrl: 'https://i.imgflip.com/1bij.jpg',
          title: 'One Does Not Simply',
        ),
        MemeModel(
          id: '5',
          imageUrl: 'https://i.imgflip.com/5gimtn.jpg',
          title: 'Bernie Sanders',
        ),
        MemeModel(
          id: '6',
          imageUrl: 'https://i.imgflip.com/261o3j.jpg',
          title: 'Change My Mind',
        ),
        MemeModel(
          id: '7',
          imageUrl: 'https://i.imgflip.com/1ur9b0.jpg',
          title: 'Leonardo Dicaprio Cheers',
        ),
        MemeModel(
          id: '8',
          imageUrl: 'https://i.imgflip.com/3oevdk.jpg',
          title: 'Bernie I Am Once Again Asking',
        ),
      ];

      // Save search to history in Hive
      // This allows users to see their recent searches later
      await _hiveService.addSearchHistory(
        query,
        resultCount: _memes.length,
      );

      // Reload search history to update UI
      _loadSearchHistory();
    } catch (e, stackTrace) {
      _logger.e('Error performing search: $e', e, stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear search history
  ///
  /// How it works:
  /// 1. Clears all search history from Hive
  /// 2. Updates the UI to remove recent searches
  ///
  /// This is called when user wants to clear their search history
  Future<void> clearSearchHistory() async {
    try {
      await _hiveService.clearSearchHistory();
      _recentSearches.clear();
      notifyListeners();
      _logger.d('Cleared search history');
    } catch (e, stackTrace) {
      _logger.e('Error clearing search history: $e', e, stackTrace);
    }
  }

  /// Toggle favorite status of a meme
  ///
  /// How it works:
  /// 1. Checks if meme is already favorited using Hive
  /// 2. If favorited: removes from Hive and updates UI
  /// 3. If not favorited: adds to Hive and updates UI
  ///
  /// This is called when user taps the favorite button on a meme
  Future<void> toggleFavorite(MemeModel meme) async {
    try {
      if (_hiveService.isFavorite(meme.id)) {
        // Remove from favorites
        await _hiveService.removeFavorite(meme.id);
        _favoriteIds.remove(meme.id);
        _logger.d('Removed from favorites: ${meme.id}');
      } else {
        // Add to favorites
        await _hiveService.addFavorite(meme);
        _favoriteIds.add(meme.id);
        _logger.d('Added to favorites: ${meme.id}');
      }
      notifyListeners();
    } catch (e, stackTrace) {
      _logger.e('Error toggling favorite: $e', e, stackTrace);
    }
  }

  /// Check if a meme is favorited
  ///
  /// How it works:
  /// 1. Checks Hive to see if the meme ID exists in favorites
  ///
  /// This is called to show/hide the favorite icon on memes
  bool isFavorite(String memeId) {
    return _hiveService.isFavorite(memeId);
  }

  void onMemePressed(MemeModel meme) {
    _logger.d('Meme pressed: ${meme.title}');
    // TODO: Navigate to meme detail view or show share options
  }

  void onBackPressed() {
    _logger.d('Back button pressed');
    // Since SearchView is part of MainNavigationView,
    // back button navigates to home or does nothing
    // This is mainly for design compliance
    _navigationService.back();
  }

  void onPreviewTap() {
    _logger.d('Preview button tapped');
    // TODO: Implement preview functionality
  }
}
