import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:logger/logger.dart';
import 'package:memeic/app/app.locator.dart';
import 'package:memeic/services/hive_service.dart';
import 'package:memeic/services/tags_service.dart';

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
  final _tagsService = locator<TagsService>();
  final searchController = TextEditingController();

  // Loading state getters using setBusyForObject
  bool get isLoading => busy('search');
  bool get isLoadingTags => busy('tags');
  bool get isLoadingCategories => busy('categories');

  // Combined loading state for when any operation is in progress
  bool get isAnyLoading => isLoading || isLoadingTags || isLoadingCategories;

  List<MemeModel> _memes = [];
  List<MemeModel> get memes => _memes;

  // Load favorite IDs from Hive when view initializes
  final Set<String> _favoriteIds = {};

  // Search history for showing recent searches
  List<String> _recentSearches = [];
  List<String> get recentSearches => _recentSearches;

  bool _showTrending = true;
  bool get showTrending => _showTrending;

  List<MoodModel> _trendingMoods = [];
  List<MoodModel> get trendingMoods => _trendingMoods;

  List<MoodModel> _popularMoods = [];
  List<MoodModel> get popularMoods => _popularMoods;

  SearchViewModel() {
    // Load favorites and search history when view is created
    _loadFavorites();
    _loadSearchHistory();
    _loadTags();
    _loadTrendingCategories();
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

  /// Load tags from TagsService
  ///
  /// How it works:
  /// 1. Fetches top 15 tags from Supabase via TagsService (sorted by count)
  /// 2. Converts tags to MoodModel objects with emojis and counts
  /// 3. Updates the UI to show tags as mood chips
  ///
  /// This is called when the view initializes to populate mood chips
  Future<void> _loadTags() async {
    try {
      setBusyForObject('tags', true);
      _logger.d('Loading top tags from TagsService');
      // Get top 15 tags (most popular by count)
      final tags = await _tagsService.getTopTags(limit: 15);

      // Convert tags to MoodModel objects with emojis from database
      _popularMoods = tags.map((tag) {
        return MoodModel(
          emoji: tag.emoji ??
              '', // Use emoji from database, empty if not available
          label: tag.tag,
          percentage: tag.count, // Store count in percentage field
        );
      }).toList();

      notifyListeners();
      _logger.d('Loaded ${_popularMoods.length} top tags as mood chips');
    } catch (e, stackTrace) {
      _logger.e('Error loading tags: $e', e, stackTrace);
      // Fall back to cached tags if available
      try {
        final cachedTags = _tagsService.getTopCachedTags(limit: 15);
        if (cachedTags.isNotEmpty) {
          _popularMoods = cachedTags.map((tag) {
            return MoodModel(
              emoji: tag.emoji ??
                  '', // Use emoji from database, empty if not available
              label: tag.tag,
              percentage: tag.count, // Store count in percentage field
            );
          }).toList();
          notifyListeners();
          _logger.d('Using ${_popularMoods.length} cached top tags');
        }
      } catch (cacheError) {
        _logger.e('Error loading cached tags: $cacheError');
      }
    } finally {
      setBusyForObject('tags', false);
    }
  }

  /// Load trending categories from TagsService
  ///
  /// How it works:
  /// 1. Fetches 4 random categories from Supabase via TagsService
  /// 2. Converts categories to MoodModel objects with emojis and counts
  /// 3. Updates the UI to show trending categories
  ///
  /// This is called when the view initializes to populate trending section
  Future<void> _loadTrendingCategories() async {
    try {
      setBusyForObject('categories', true);
      _logger.d('Loading trending categories from TagsService');
      // Get 4 random categories from top 20
      final categories = await _tagsService.getRandomCategories(count: 4);

      // Convert categories to MoodModel objects with emojis from database
      _trendingMoods = categories.map((category) {
        return MoodModel(
          emoji: category.emoji ??
              '', // Use emoji from database, empty if not available
          label: category.category,
          percentage: category.count, // Store count in percentage field
        );
      }).toList();

      notifyListeners();
      _logger.d('Loaded ${_trendingMoods.length} trending categories');
    } catch (e, stackTrace) {
      _logger.e('Error loading trending categories: $e', e, stackTrace);
      // Fall back to cached categories if available
      try {
        final cachedCategories =
            _tagsService.getRandomCachedCategories(count: 4);
        if (cachedCategories.isNotEmpty) {
          _trendingMoods = cachedCategories.map((category) {
            return MoodModel(
              emoji: category.emoji ??
                  '', // Use emoji from database, empty if not available
              label: category.category,
              percentage: category.count, // Store count in percentage field
            );
          }).toList();
          notifyListeners();
          _logger
              .d('Using ${_trendingMoods.length} cached trending categories');
        }
      } catch (cacheError) {
        _logger.e('Error loading cached trending categories: $cacheError');
      }
    } finally {
      setBusyForObject('categories', false);
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
    try {
      setBusyForObject('search', true);
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
      notifyListeners();
    } catch (e, stackTrace) {
      _logger.e('Error performing search: $e', e, stackTrace);
    } finally {
      setBusyForObject('search', false);
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
