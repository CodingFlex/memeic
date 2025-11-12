import 'package:stacked/stacked.dart';
import 'package:logger/logger.dart';
import 'package:memeic/app/app.locator.dart';
import 'package:memeic/services/hive_service.dart';
import 'package:memeic/helpers/meme_converter.dart';
import 'package:memeic/ui/views/search/search_viewmodel.dart';

class FavoritesViewModel extends BaseViewModel {
  final _logger = Logger();
  final _hiveService = locator<HiveService>();

  List<MemeModel> _favoriteMemes = [];
  List<MemeModel> get favoriteMemes => _favoriteMemes;

  FavoritesViewModel() {
    _loadFavorites();
  }

  /// Load favorites from Hive local storage
  ///
  /// How it works:
  /// 1. Gets all favorites from Hive (stored locally on device)
  /// 2. Converts them from Maps to MemeModel objects
  /// 3. Updates the UI with the favorite memes
  ///
  /// This is called when the Favorites screen loads
  Future<void> _loadFavorites() async {
    try {
      setBusy(true);

      // Get all favorites from Hive local storage
      // Hive returns a list of Maps (raw data format)
      final favoritesData = _hiveService.getAllFavorites();

      // Convert Maps to MemeModel objects using our helper
      // Think of this as: "Take the raw data and make it usable MemeModels"
      _favoriteMemes = MemeConverter.fromMapList(favoritesData);

      _logger.d('Loaded ${_favoriteMemes.length} favorites from Hive');
      notifyListeners();
    } catch (e, stackTrace) {
      _logger.e('Error loading favorites: $e', e, stackTrace);
    } finally {
      setBusy(false);
    }
  }

  /// Remove a meme from favorites
  ///
  /// How it works:
  /// 1. Removes the meme from Hive local storage
  /// 2. Removes it from the UI list
  /// 3. Updates the UI
  ///
  /// This is called when user taps the unfavorite button
  Future<void> toggleFavorite(String memeId) async {
    try {
      // Remove from Hive local storage
      await _hiveService.removeFavorite(memeId);

      // Remove from UI list
      _favoriteMemes.removeWhere((meme) => meme.id == memeId);

      _logger.d('Removed from favorites: $memeId');
      notifyListeners();
    } catch (e, stackTrace) {
      _logger.e('Error removing favorite: $e', e, stackTrace);
    }
  }

  void onMemePressed(MemeModel meme) {
    _logger.d('Meme pressed: ${meme.title}');
    // TODO: Navigate to meme detail view or show share options
  }
}
