/// HiveService - The Manager of Your Local Storage
///
/// Think of HiveService as the librarian of your app's local storage.
/// Just like a librarian:
/// - Opens the library (initializes Hive)
/// - Knows where every book (data) is stored
/// - Helps you save new books (save data)
/// - Helps you find books (read data)
/// - Helps you remove books (delete data)
///
/// This service manages all the "boxes" (think: filing cabinet drawers)
/// where we store different types of data.

import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:memeic/models/hive_models.dart';

class HiveService {
  final Logger _logger = Logger();

  /// Box references - These are like handles to open specific drawers
  /// We store them here so we can easily access them later
  Box<HiveMemeModel>? _favoritesBox;
  Box<HiveSearchHistory>? _searchHistoryBox;
  Box<HiveUserPreferences>? _preferencesBox;
  Box<HiveMemeModel>? _memeCacheBox;
  Box<HiveTagWithCount>? _tagsBox;
  Box<HiveCategoryWithCount>? _categoriesBox;

  /// Getters - These let other parts of the app access the boxes
  /// Think of them as asking: "Can I see the favorites drawer?"
  Box<HiveMemeModel> get favoritesBox {
    if (_favoritesBox == null) {
      throw Exception('HiveService not initialized. Call initialize() first.');
    }
    return _favoritesBox!;
  }

  Box<HiveSearchHistory> get searchHistoryBox {
    if (_searchHistoryBox == null) {
      throw Exception('HiveService not initialized. Call initialize() first.');
    }
    return _searchHistoryBox!;
  }

  Box<HiveUserPreferences> get preferencesBox {
    if (_preferencesBox == null) {
      throw Exception('HiveService not initialized. Call initialize() first.');
    }
    return _preferencesBox!;
  }

  Box<HiveMemeModel> get memeCacheBox {
    if (_memeCacheBox == null) {
      throw Exception('HiveService not initialized. Call initialize() first.');
    }
    return _memeCacheBox!;
  }

  Box<HiveTagWithCount> get tagsBox {
    if (_tagsBox == null) {
      throw Exception('HiveService not initialized. Call initialize() first.');
    }
    return _tagsBox!;
  }

  Box<HiveCategoryWithCount> get categoriesBox {
    if (_categoriesBox == null) {
      throw Exception('HiveService not initialized. Call initialize() first.');
    }
    return _categoriesBox!;
  }

  /// Static initialization - Sets up Hive framework (must be called once, before any HiveService instance)
  ///
  /// What happens here:
  /// 1. HiveFlutter.init() - Sets up Hive to work with Flutter (gets permission to use storage)
  /// 2. registerAdapters() - Tells Hive how to save/load our custom models
  ///
  /// Think of this as setting up the library building itself (the framework)
  /// This is separate from opening boxes (which happens in initialize())
  ///
  /// This MUST be called once in main() before creating any HiveService instances!
  static Future<void> initHive() async {
    try {
      // Initialize Hive for Flutter
      // Think of this as turning on the library's electricity
      // This gives Hive permission to read/write files on the device
      await Hive.initFlutter();

      // Register adapters - These tell Hive how to convert our models to/from storage format
      // Think of adapters as translators - they convert between "app language" and "storage language"
      // The generated adapters (from .g.dart files) know how to do this conversion
      // We check if they're already registered to avoid errors if initHive() is called multiple times
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(HiveMemeModelAdapter());
      }
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(HiveSearchHistoryAdapter());
      }
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(HiveUserPreferencesAdapter());
      }
      if (!Hive.isAdapterRegistered(3)) {
        Hive.registerAdapter(HiveTagWithCountAdapter());
      }
      if (!Hive.isAdapterRegistered(4)) {
        Hive.registerAdapter(HiveCategoryWithCountAdapter());
      }
    } catch (e, stackTrace) {
      Logger().e('Failed to initialize Hive framework', e, stackTrace);
      rethrow;
    }
  }

  /// Initialize HiveService - Opens all boxes (drawers) we need
  ///
  /// What happens here:
  /// 1. Opens all the boxes we need (favorites, search history, preferences, cache)
  /// 2. Initializes default preferences if they don't exist
  ///
  /// Think of this as unlocking all the drawers in the filing cabinet
  ///
  /// This MUST be called after initHive() and before using any box methods!
  Future<void> initialize() async {
    try {
      // Open all the boxes we need
      // Think of this as unlocking all the drawers in the filing cabinet
      await _openBoxes();

      _logger.i('HiveService initialized successfully');
    } catch (e, stackTrace) {
      _logger.e('Failed to initialize HiveService', e, stackTrace);
      rethrow;
    }
  }

  /// Open all boxes - This opens each drawer in the filing cabinet
  ///
  /// What's a box? A box is like a drawer in a filing cabinet.
  /// - Each box stores one type of data (favorites, search history, etc.)
  /// - Boxes are persistent (data survives app restarts)
  /// - Boxes are fast (stored in device memory when possible)
  ///
  /// Hive.openBox() opens a box if it exists, or creates it if it doesn't.
  /// Think of it as: "Open the 'favorites' drawer, and create it if it doesn't exist yet"
  Future<void> _openBoxes() async {
    // Open favorites box - stores all favorite memes
    _favoritesBox = await Hive.openBox<HiveMemeModel>(HiveBoxes.favorites);

    // Open search history box - stores all past search queries
    _searchHistoryBox =
        await Hive.openBox<HiveSearchHistory>(HiveBoxes.searchHistory);

    // Open preferences box - stores user settings (only one entry, with key 'default')
    _preferencesBox =
        await Hive.openBox<HiveUserPreferences>(HiveBoxes.preferences);

    // Open meme cache box - stores memes for offline viewing
    _memeCacheBox = await Hive.openBox<HiveMemeModel>(HiveBoxes.memeCache);

    // Open tags box - stores tags for offline access
    _tagsBox = await Hive.openBox<HiveTagWithCount>(HiveBoxes.tags);

    // Open categories box - stores categories for offline access
    _categoriesBox =
        await Hive.openBox<HiveCategoryWithCount>(HiveBoxes.categories);

    // Initialize default preferences if they don't exist
    // Think of this as creating a default settings file if one doesn't exist
    if (_preferencesBox!.isEmpty) {
      await _preferencesBox!.put('default', HiveUserPreferences());
    }
  }

  /// ========================================
  /// FAVORITES METHODS
  /// ========================================
  /// These methods manage favorite memes - like bookmarks for memes you love

  /// Add a meme to favorites
  ///
  /// How it works:
  /// 1. Convert the meme data to HiveMemeModel (storage format)
  /// 2. Save it to the favorites box using the meme's ID as the key
  ///
  /// The key is like a label on a folder - we use the meme's ID so we can find it later
  ///
  /// [meme] can be either a MemeModel object or a Map<String, dynamic>
  Future<void> addFavorite(dynamic meme) async {
    try {
      final hiveMeme = HiveMemeModel.fromMemeModel(meme);
      await favoritesBox.put(hiveMeme.id, hiveMeme);
      _logger.d('Added favorite: ${hiveMeme.id}');
    } catch (e, stackTrace) {
      _logger.e('Failed to add favorite', e, stackTrace);
      rethrow;
    }
  }

  /// Remove a meme from favorites
  ///
  /// How it works:
  /// 1. Find the meme in the favorites box using its ID
  /// 2. Delete it from the box
  ///
  /// Think of this as throwing away a bookmark
  Future<void> removeFavorite(String memeId) async {
    try {
      await favoritesBox.delete(memeId);
      _logger.d('Removed favorite: $memeId');
    } catch (e, stackTrace) {
      _logger.e('Failed to remove favorite', e, stackTrace);
      rethrow;
    }
  }

  /// Check if a meme is favorited
  ///
  /// How it works:
  /// 1. Check if the favorites box contains a meme with this ID
  ///
  /// Think of this as checking: "Do I have a bookmark for this meme?"
  bool isFavorite(String memeId) {
    return favoritesBox.containsKey(memeId);
  }

  /// Get all favorite memes
  ///
  /// How it works:
  /// 1. Get all values from the favorites box
  /// 2. Convert them to a list
  /// 3. Sort by when they were saved (newest first)
  ///
  /// Think of this as: "Show me all my bookmarks, newest first"
  List<Map<String, dynamic>> getAllFavorites() {
    try {
      final favorites = favoritesBox.values.toList();
      // Sort by savedAt date (newest first)
      favorites.sort((a, b) {
        final aDate = a.savedAt ?? DateTime(1970);
        final bDate = b.savedAt ?? DateTime(1970);
        return bDate.compareTo(aDate);
      });
      return favorites.map((meme) => meme.toMap()).toList();
    } catch (e, stackTrace) {
      _logger.e('Failed to get favorites', e, stackTrace);
      return [];
    }
  }

  /// Clear all favorites
  ///
  /// How it works:
  /// 1. Delete all entries from the favorites box
  ///
  /// Think of this as: "Throw away all my bookmarks"
  Future<void> clearFavorites() async {
    try {
      await favoritesBox.clear();
      _logger.d('Cleared all favorites');
    } catch (e, stackTrace) {
      _logger.e('Failed to clear favorites', e, stackTrace);
      rethrow;
    }
  }

  /// ========================================
  /// SEARCH HISTORY METHODS
  /// ========================================
  /// These methods manage search history - like a log of all your searches

  /// Add a search to history
  ///
  /// How it works:
  /// 1. Create a HiveSearchHistory entry with the query and timestamp
  /// 2. Save it to the search history box
  /// 3. Limit the history to prevent it from growing too large
  ///
  /// We use the query as the key, so duplicate searches update the timestamp
  /// Think of this as: "Write down what I searched for, and when"
  Future<void> addSearchHistory(String query, {int resultCount = 0}) async {
    try {
      // Remove old entry if it exists (so we update the timestamp)
      if (searchHistoryBox.containsKey(query)) {
        await searchHistoryBox.delete(query);
      }

      // Add new entry with current timestamp
      final historyEntry = HiveSearchHistory(
        query: query,
        searchedAt: DateTime.now(),
        resultCount: resultCount,
      );
      await searchHistoryBox.put(query, historyEntry);

      // Limit history size - keep only the most recent searches
      // Think of this as: "Only keep the last 50 searches, delete the rest"
      final preferences = getPreferences();
      await _limitSearchHistory(preferences.maxSearchHistoryItems);

      _logger.d('Added search history: $query');
    } catch (e, stackTrace) {
      _logger.e('Failed to add search history', e, stackTrace);
      rethrow;
    }
  }

  /// Get all search history
  ///
  /// How it works:
  /// 1. Get all values from the search history box
  /// 2. Sort by when they were searched (newest first)
  /// 3. Return just the query strings
  ///
  /// Think of this as: "Show me all my past searches, newest first"
  List<String> getSearchHistory() {
    try {
      final history = searchHistoryBox.values.toList();
      // Sort by searchedAt date (newest first)
      history.sort((a, b) => b.searchedAt.compareTo(a.searchedAt));
      return history.map((entry) => entry.query).toList();
    } catch (e, stackTrace) {
      _logger.e('Failed to get search history', e, stackTrace);
      return [];
    }
  }

  /// Clear search history
  ///
  /// How it works:
  /// 1. Delete all entries from the search history box
  ///
  /// Think of this as: "Clear my search log"
  Future<void> clearSearchHistory() async {
    try {
      await searchHistoryBox.clear();
      _logger.d('Cleared search history');
    } catch (e, stackTrace) {
      _logger.e('Failed to clear search history', e, stackTrace);
      rethrow;
    }
  }

  /// Limit search history to a maximum number of items
  ///
  /// How it works:
  /// 1. Get all search history entries
  /// 2. Sort by date (newest first)
  /// 3. Keep only the most recent ones
  /// 4. Delete the rest
  ///
  /// Think of this as: "Keep only the last 50 searches, delete older ones"
  Future<void> _limitSearchHistory(int maxItems) async {
    if (maxItems <= 0) return;

    final history = searchHistoryBox.values.toList();
    if (history.length <= maxItems) return;

    // Sort by date (newest first)
    history.sort((a, b) => b.searchedAt.compareTo(a.searchedAt));

    // Delete entries beyond the limit (oldest ones)
    final toDelete = history.sublist(maxItems);
    for (final entry in toDelete) {
      await searchHistoryBox.delete(entry.query);
    }
  }

  /// ========================================
  /// PREFERENCES METHODS
  /// ========================================
  /// These methods manage user preferences/settings

  /// Get user preferences
  ///
  /// How it works:
  /// 1. Get the preferences from the box (stored with key 'default')
  /// 2. Return it, or return default preferences if none exist
  ///
  /// Think of this as: "Show me my settings"
  HiveUserPreferences getPreferences() {
    try {
      return preferencesBox.get('default') ?? HiveUserPreferences();
    } catch (e, stackTrace) {
      _logger.e('Failed to get preferences', e, stackTrace);
      return HiveUserPreferences();
    }
  }

  /// Save user preferences
  ///
  /// How it works:
  /// 1. Save the preferences to the box with key 'default'
  ///
  /// Think of this as: "Save my settings"
  Future<void> savePreferences(HiveUserPreferences preferences) async {
    try {
      await preferencesBox.put('default', preferences);
      _logger.d('Saved preferences');
    } catch (e, stackTrace) {
      _logger.e('Failed to save preferences', e, stackTrace);
      rethrow;
    }
  }

  /// Update a specific preference
  ///
  /// How it works:
  /// 1. Get current preferences
  /// 2. Create a new preferences object with the updated value
  /// 3. Save it back
  ///
  /// Think of this as: "Change just one setting, keep the rest the same"
  Future<void> updatePreference({
    bool? darkMode,
    bool? autoPlayVideos,
    String? defaultSearchFilter,
    int? maxSearchHistoryItems,
    bool? enableNotifications,
  }) async {
    try {
      final current = getPreferences();
      final updated = current.copyWith(
        darkMode: darkMode,
        autoPlayVideos: autoPlayVideos,
        defaultSearchFilter: defaultSearchFilter,
        maxSearchHistoryItems: maxSearchHistoryItems,
        enableNotifications: enableNotifications,
      );
      await savePreferences(updated);
    } catch (e, stackTrace) {
      _logger.e('Failed to update preference', e, stackTrace);
      rethrow;
    }
  }

  /// ========================================
  /// MEME CACHE METHODS
  /// ========================================
  /// These methods manage cached memes for offline viewing

  /// Cache a meme for offline viewing
  ///
  /// How it works:
  /// 1. Convert the meme to HiveMemeModel
  /// 2. Save it to the cache box
  ///
  /// Think of this as: "Save this meme so I can view it offline"
  ///
  /// [meme] can be either a MemeModel object or a Map<String, dynamic>
  Future<void> cacheMeme(dynamic meme) async {
    try {
      final hiveMeme = HiveMemeModel.fromMemeModel(meme);
      await memeCacheBox.put(hiveMeme.id, hiveMeme);
      _logger.d('Cached meme: ${hiveMeme.id}');
    } catch (e, stackTrace) {
      _logger.e('Failed to cache meme', e, stackTrace);
      rethrow;
    }
  }

  /// Get cached memes
  ///
  /// How it works:
  /// 1. Get all values from the cache box
  /// 2. Convert them to a list of maps
  ///
  /// Think of this as: "Show me all memes I can view offline"
  List<Map<String, dynamic>> getCachedMemes() {
    try {
      return memeCacheBox.values.map((meme) => meme.toMap()).toList();
    } catch (e, stackTrace) {
      _logger.e('Failed to get cached memes', e, stackTrace);
      return [];
    }
  }

  /// Clear cached memes
  ///
  /// How it works:
  /// 1. Delete all entries from the cache box
  ///
  /// Think of this as: "Delete all offline memes to free up space"
  Future<void> clearCache() async {
    try {
      await memeCacheBox.clear();
      _logger.d('Cleared meme cache');
    } catch (e, stackTrace) {
      _logger.e('Failed to clear cache', e, stackTrace);
      rethrow;
    }
  }

  /// ========================================
  /// CLEANUP METHODS
  /// ========================================

  /// Close all boxes - This closes all drawers
  ///
  /// How it works:
  /// 1. Close each box
  ///
  /// Think of this as: "Lock all the drawers"
  /// Usually called when the app is closing
  Future<void> closeBoxes() async {
    try {
      await _favoritesBox?.close();
      await _searchHistoryBox?.close();
      await _preferencesBox?.close();
      await _memeCacheBox?.close();
      await _tagsBox?.close();
      await _categoriesBox?.close();
      _logger.d('Closed all Hive boxes');
    } catch (e, stackTrace) {
      _logger.e('Failed to close boxes', e, stackTrace);
      rethrow;
    }
  }

  /// Delete all data - Nuclear option!
  ///
  /// How it works:
  /// 1. Delete all boxes
  /// 2. This removes ALL stored data
  ///
  /// Think of this as: "Burn down the entire library"
  /// Use with caution! This cannot be undone.
  Future<void> deleteAllData() async {
    try {
      await Hive.deleteBoxFromDisk(HiveBoxes.favorites);
      await Hive.deleteBoxFromDisk(HiveBoxes.searchHistory);
      await Hive.deleteBoxFromDisk(HiveBoxes.preferences);
      await Hive.deleteBoxFromDisk(HiveBoxes.memeCache);
      await Hive.deleteBoxFromDisk(HiveBoxes.tags);
      await Hive.deleteBoxFromDisk(HiveBoxes.categories);
      _logger.d('Deleted all Hive data');
    } catch (e, stackTrace) {
      _logger.e('Failed to delete all data', e, stackTrace);
      rethrow;
    }
  }
}
