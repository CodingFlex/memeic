/// Hive Models for Local Storage
///
/// Hive is like a filing cabinet on your phone - it stores data locally
/// so your app can work even when you're offline. Think of it like saving
/// files to your computer's hard drive instead of the cloud.
///
/// This file defines the "shapes" of data we want to store in Hive.
/// Each model tells Hive: "This is what a Meme looks like" or
/// "This is what a Search History entry looks like".

import 'package:hive/hive.dart';

/// Part files are used by Hive's code generator to create the adapter
/// Think of it like a template that Hive uses to know how to save/load data
part 'hive_models.g.dart';

/// Box Names - These are like drawer labels in a filing cabinet
/// Each box stores a different type of data
class HiveBoxes {
  // Box for storing favorite memes
  // Think of this as a drawer labeled "My Favorite Memes"
  static const String favorites = 'favorites';

  // Box for storing search history
  // Think of this as a drawer labeled "Search History"
  static const String searchHistory = 'searchHistory';

  // Box for storing user preferences/settings
  // Think of this as a drawer labeled "My Settings"
  static const String preferences = 'preferences';

  // Box for caching memes for offline viewing
  // Think of this as a drawer labeled "Offline Memes Cache"
  static const String memeCache = 'memeCache';
}

/// HiveType annotation tells Hive: "This is a type I want to store"
/// The number (0, 1, 2, etc.) is like an ID - each stored type needs a unique number
/// Think of it like a barcode - Hive uses this number to identify what type of data it is
@HiveType(typeId: 0)
class HiveMemeModel extends HiveObject {
  /// HiveField tells Hive which properties of this class to save
  /// The number (0, 1, 2, etc.) is like a field ID - each property needs a unique number
  /// Think of it like columns in a spreadsheet - each column has a number

  @HiveField(0)
  final String id; // The unique identifier for this meme (like a barcode)

  @HiveField(1)
  final String imageUrl; // The web address where the meme image is stored

  @HiveField(2)
  final String? title; // The name/title of the meme (optional, can be null)

  @HiveField(3)
  final List<String>? tags; // Keywords associated with this meme (optional)

  @HiveField(4)
  final bool showPreview; // Whether to show a preview or full image

  @HiveField(5)
  final DateTime? savedAt; // When this meme was saved (for sorting/filtering)

  /// Constructor - This is how we create a new HiveMemeModel
  /// Think of it like a recipe - you provide ingredients (parameters) and get a finished dish (object)
  HiveMemeModel({
    required this.id,
    required this.imageUrl,
    this.title,
    this.tags,
    this.showPreview = false,
    this.savedAt,
  });

  /// Convert from the regular MemeModel (used in the app) to HiveMemeModel (for storage)
  /// Think of this as translating from one language to another
  ///
  /// This accepts a MemeModel-like object (with id, imageUrl, title, tags, showPreview)
  factory HiveMemeModel.fromMemeModel(
    dynamic meme, {
    DateTime? savedAt,
  }) {
    // Handle both Map and MemeModel objects
    if (meme is Map<String, dynamic>) {
      return HiveMemeModel(
        id: meme['id'] as String,
        imageUrl: meme['imageUrl'] as String,
        title: meme['title'] as String?,
        tags: meme['tags'] != null
            ? List<String>.from(meme['tags'] as List)
            : null,
        showPreview: meme['showPreview'] as bool? ?? false,
        savedAt: savedAt ?? DateTime.now(),
      );
    } else {
      // Handle MemeModel objects using reflection/dynamic access
      // This works because Dart allows dynamic property access
      return HiveMemeModel(
        id: meme.id as String,
        imageUrl: meme.imageUrl as String,
        title: meme.title as String?,
        tags: meme.tags != null ? List<String>.from(meme.tags as List) : null,
        showPreview: (meme.showPreview as bool?) ?? false,
        savedAt: savedAt ?? DateTime.now(),
      );
    }
  }

  /// Convert back to a simple map (for easy use in the app)
  /// Think of this as unpacking a box - you get all the items inside
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'title': title,
      'tags': tags,
      'showPreview': showPreview,
    };
  }
}

/// HiveType for storing search history entries
/// Think of this as a notebook where we write down every search query
@HiveType(typeId: 1)
class HiveSearchHistory extends HiveObject {
  @HiveField(0)
  final String query; // The search term the user typed

  @HiveField(1)
  final DateTime searchedAt; // When the search was performed

  @HiveField(2)
  final int
      resultCount; // How many results were found (optional, for analytics)

  HiveSearchHistory({
    required this.query,
    required this.searchedAt,
    this.resultCount = 0,
  });
}

/// HiveType for storing user preferences
/// Think of this as a settings menu that remembers your choices
@HiveType(typeId: 2)
class HiveUserPreferences extends HiveObject {
  @HiveField(0)
  final bool darkMode; // Whether dark mode is enabled

  @HiveField(1)
  final bool autoPlayVideos; // Whether videos should auto-play

  @HiveField(2)
  final String? defaultSearchFilter; // Default filter for searches

  @HiveField(3)
  final int maxSearchHistoryItems; // How many search history items to keep

  @HiveField(4)
  final bool enableNotifications; // Whether to show notifications

  HiveUserPreferences({
    this.darkMode = true,
    this.autoPlayVideos = false,
    this.defaultSearchFilter,
    this.maxSearchHistoryItems = 50,
    this.enableNotifications = true,
  });

  /// Create a copy with some values changed
  /// Think of this as making a photocopy and changing some details
  HiveUserPreferences copyWith({
    bool? darkMode,
    bool? autoPlayVideos,
    String? defaultSearchFilter,
    int? maxSearchHistoryItems,
    bool? enableNotifications,
  }) {
    return HiveUserPreferences(
      darkMode: darkMode ?? this.darkMode,
      autoPlayVideos: autoPlayVideos ?? this.autoPlayVideos,
      defaultSearchFilter: defaultSearchFilter ?? this.defaultSearchFilter,
      maxSearchHistoryItems:
          maxSearchHistoryItems ?? this.maxSearchHistoryItems,
      enableNotifications: enableNotifications ?? this.enableNotifications,
    );
  }
}
