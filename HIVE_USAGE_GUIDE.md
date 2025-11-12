# Hive Local Storage - Complete Usage Guide

## 🎯 What is Hive?

**Hive is like a filing cabinet on your phone.** It stores data locally on the device so your app can:
- Work offline (no internet needed)
- Load data instantly (faster than network requests)
- Remember user preferences and favorites
- Cache data for quick access

Think of it like this:
- **Cloud storage (Supabase)**: Like a warehouse far away - stores everything, but takes time to access
- **Local storage (Hive)**: Like a drawer in your desk - stores important stuff, accessed instantly

## 📦 What We're Storing

### 1. **Favorites Box** (`favorites`)
- Stores all memes the user has favorited
- Each meme is saved with its ID as the key
- Persists even after app restart
- **Use case**: Show favorite memes in the Favorites tab

### 2. **Search History Box** (`searchHistory`)
- Stores all past search queries
- Tracks when each search was performed
- Limits to last 50 searches (configurable)
- **Use case**: Show recent searches when user opens search bar

### 3. **Preferences Box** (`preferences`)
- Stores user settings (dark mode, notifications, etc.)
- Only one entry (with key 'default')
- Persists user preferences across app restarts
- **Use case**: Remember user's app settings

### 4. **Meme Cache Box** (`memeCache`)
- Stores memes for offline viewing
- Caches recently viewed memes
- Can be cleared to free up space
- **Use case**: Allow users to view memes without internet

## 🚀 How to Use HiveService

### Step 1: Get HiveService from Dependency Injection

```dart
import 'package:memeic/app/app.locator.dart';
import 'package:memeic/services/hive_service.dart';

class MyViewModel extends BaseViewModel {
  // Get HiveService from the locator (dependency injection)
  final _hiveService = locator<HiveService>();
}
```

### Step 2: Use HiveService Methods

#### **Saving a Favorite Meme**

```dart
// When user taps the favorite button
void toggleFavorite(MemeModel meme) {
  if (_hiveService.isFavorite(meme.id)) {
    // Remove from favorites
    await _hiveService.removeFavorite(meme.id);
  } else {
    // Add to favorites
    await _hiveService.addFavorite(meme);
  }
  notifyListeners(); // Update UI
}
```

#### **Loading Favorites**

```dart
// When the Favorites screen loads
Future<void> loadFavorites() async {
  setBusy(true);
  
  // Get all favorites from Hive
  final favoritesData = _hiveService.getAllFavorites();
  
  // Convert to MemeModel objects
  _favoriteMemes = favoritesData.map((data) => MemeModel(
    id: data['id'],
    imageUrl: data['imageUrl'],
    title: data['title'],
    tags: data['tags'],
    showPreview: data['showPreview'],
  )).toList();
  
  setBusy(false);
  notifyListeners();
}
```

#### **Saving Search History**

```dart
// When user performs a search
Future<void> performSearch(String query) async {
  setBusy(true);
  
  // ... perform search logic ...
  
  // Save to search history
  await _hiveService.addSearchHistory(query, resultCount: results.length);
  
  setBusy(false);
  notifyListeners();
}

// When user opens search bar, show recent searches
void loadSearchHistory() {
  final recentSearches = _hiveService.getSearchHistory();
  // Show recentSearches in UI (e.g., as chips or list)
}
```

#### **Saving User Preferences**

```dart
// When user changes a setting
Future<void> toggleDarkMode(bool enabled) async {
  await _hiveService.updatePreference(darkMode: enabled);
  // UI will update based on preference
}

// When app starts, load preferences
void loadPreferences() {
  final prefs = _hiveService.getPreferences();
  // Apply preferences to app (e.g., set theme)
  _isDarkMode = prefs.darkMode;
}
```

#### **Caching Memes for Offline Viewing**

```dart
// When user views a meme, cache it
void onMemeViewed(MemeModel meme) async {
  // Cache the meme for offline viewing
  await _hiveService.cacheMeme(meme);
}

// When offline, load cached memes
void loadCachedMemes() {
  final cachedMemes = _hiveService.getCachedMemes();
  // Display cached memes in UI
}
```

## 📝 Real-World Examples for Your Meme App

### Example 1: Favorites ViewModel

```dart
class FavoritesViewModel extends BaseViewModel {
  final _hiveService = locator<HiveService>();
  List<MemeModel> _favoriteMemes = [];
  
  List<MemeModel> get favoriteMemes => _favoriteMemes;
  
  @override
  void initialise() {
    _loadFavorites();
  }
  
  Future<void> _loadFavorites() async {
    setBusy(true);
    
    // Load favorites from Hive (local storage)
    final favoritesData = _hiveService.getAllFavorites();
    
    // Convert to MemeModel objects
    _favoriteMemes = favoritesData.map((data) => MemeModel(
      id: data['id'] as String,
      imageUrl: data['imageUrl'] as String,
      title: data['title'] as String?,
      tags: data['tags'] != null 
          ? List<String>.from(data['tags'] as List)
          : null,
      showPreview: data['showPreview'] as bool? ?? false,
    )).toList();
    
    setBusy(false);
    notifyListeners();
  }
  
  Future<void> removeFavorite(String memeId) async {
    await _hiveService.removeFavorite(memeId);
    _favoriteMemes.removeWhere((meme) => meme.id == memeId);
    notifyListeners();
  }
}
```

### Example 2: Search ViewModel with History

```dart
class SearchViewModel extends BaseViewModel {
  final _hiveService = locator<HiveService>();
  List<String> _recentSearches = [];
  
  List<String> get recentSearches => _recentSearches;
  
  @override
  void initialise() {
    _loadSearchHistory();
  }
  
  void _loadSearchHistory() {
    // Load recent searches from Hive
    _recentSearches = _hiveService.getSearchHistory();
    notifyListeners();
  }
  
  Future<void> performSearch(String query) async {
    setBusy(true);
    
    // ... perform search logic ...
    
    // Save to search history
    await _hiveService.addSearchHistory(
      query, 
      resultCount: _memes.length,
    );
    
    // Reload history to update UI
    _loadSearchHistory();
    
    setBusy(false);
    notifyListeners();
  }
  
  void clearSearchHistory() async {
    await _hiveService.clearSearchHistory();
    _recentSearches.clear();
    notifyListeners();
  }
}
```

### Example 3: Home ViewModel with Favorites

```dart
class HomeViewModel extends BaseViewModel {
  final _hiveService = locator<HiveService>();
  final Set<String> _favoriteIds = {};
  
  bool isFavorite(String memeId) {
    return _hiveService.isFavorite(memeId);
  }
  
  Future<void> toggleFavorite(MemeModel meme) async {
    if (_hiveService.isFavorite(meme.id)) {
      await _hiveService.removeFavorite(meme.id);
      _favoriteIds.remove(meme.id);
    } else {
      await _hiveService.addFavorite(meme);
      _favoriteIds.add(meme.id);
    }
    notifyListeners();
  }
  
  @override
  void initialise() {
    // Load favorite IDs when view loads
    final favorites = _hiveService.getAllFavorites();
    _favoriteIds.addAll(favorites.map((f) => f['id'] as String));
    notifyListeners();
  }
}
```

### Example 4: Settings ViewModel

```dart
class SettingsViewModel extends BaseViewModel {
  final _hiveService = locator<HiveService>();
  HiveUserPreferences _preferences = HiveUserPreferences();
  
  bool get darkMode => _preferences.darkMode;
  bool get enableNotifications => _preferences.enableNotifications;
  
  @override
  void initialise() {
    _loadPreferences();
  }
  
  void _loadPreferences() {
    _preferences = _hiveService.getPreferences();
    notifyListeners();
  }
  
  Future<void> toggleDarkMode(bool enabled) async {
    await _hiveService.updatePreference(darkMode: enabled);
    _preferences = _hiveService.getPreferences();
    notifyListeners();
    // Apply theme change to app
  }
  
  Future<void> toggleNotifications(bool enabled) async {
    await _hiveService.updatePreference(enableNotifications: enabled);
    _preferences = _hiveService.getPreferences();
    notifyListeners();
  }
}
```

## 🎓 Key Concepts Explained

### What is a Box?
- A **box** is like a drawer in a filing cabinet
- Each box stores one type of data (favorites, search history, etc.)
- Boxes are persistent (data survives app restarts)
- Boxes are fast (stored in device memory when possible)

### What is an Adapter?
- An **adapter** is like a translator
- It converts between "app language" (MemeModel) and "storage language" (Hive format)
- Hive generates adapters automatically using `build_runner`
- Each model needs an adapter to be stored in Hive

### What is a Key?
- A **key** is like a label on a folder
- We use keys to find specific data in a box
- For favorites, we use the meme's ID as the key
- For preferences, we use 'default' as the key (only one entry)

## 🔄 When to Use Hive vs Supabase

### Use Hive (Local Storage) For:
- ✅ **Favorites** - User's favorite memes (works offline)
- ✅ **Search History** - Recent searches (quick access)
- ✅ **User Preferences** - App settings (instant load)
- ✅ **Cached Memes** - Offline viewing (no internet needed)
- ✅ **Temporary Data** - Data that doesn't need cloud sync

### Use Supabase (Cloud Storage) For:
- ✅ **User Authentication** - Login/signup
- ✅ **User Profile** - User information that syncs across devices
- ✅ **Shared Data** - Data that needs to be shared between users
- ✅ **Backup** - Important data that needs cloud backup
- ✅ **Sync** - Data that needs to sync across multiple devices

## 🛠️ Common Operations

### Check if Data Exists
```dart
bool isFavorite = _hiveService.isFavorite(memeId);
```

### Add Data
```dart
await _hiveService.addFavorite(meme);
await _hiveService.addSearchHistory(query);
await _hiveService.cacheMeme(meme);
```

### Remove Data
```dart
await _hiveService.removeFavorite(memeId);
await _hiveService.clearSearchHistory();
await _hiveService.clearCache();
```

### Get All Data
```dart
List<Map<String, dynamic>> favorites = _hiveService.getAllFavorites();
List<String> searchHistory = _hiveService.getSearchHistory();
List<Map<String, dynamic>> cachedMemes = _hiveService.getCachedMemes();
```

### Update Preferences
```dart
await _hiveService.updatePreference(darkMode: true);
HiveUserPreferences prefs = _hiveService.getPreferences();
```

## ⚠️ Important Notes

1. **Always check if HiveService is initialized** - The service will throw an error if boxes aren't opened
2. **Handle errors** - Wrap Hive operations in try-catch blocks
3. **Update UI after changes** - Call `notifyListeners()` after modifying data
4. **Don't store sensitive data** - Use `flutter_secure_storage` for tokens, passwords, etc.
5. **Clear cache periodically** - Cache can grow large, clear it when needed

## 🎯 Next Steps

1. Update your ViewModels to use HiveService
2. Test favorite functionality - favorites should persist after app restart
3. Test search history - recent searches should appear
4. Test preferences - settings should be remembered
5. Test offline mode - cached memes should be viewable offline

## 📚 Additional Resources

- [Hive Documentation](https://docs.hivedb.dev/)
- [Hive Flutter Package](https://pub.dev/packages/hive_flutter)

Happy coding! 🚀

