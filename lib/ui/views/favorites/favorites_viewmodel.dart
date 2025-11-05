import 'package:stacked/stacked.dart';
import 'package:logger/logger.dart';
import 'package:memeic/ui/views/search/search_viewmodel.dart';

class FavoritesViewModel extends BaseViewModel {
  final _logger = Logger();

  List<MemeModel> _favoriteMemes = [];
  List<MemeModel> get favoriteMemes => _favoriteMemes;

  FavoritesViewModel() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      // Simulate loading favorites from storage
      await Future.delayed(const Duration(milliseconds: 500));

      // For demo purposes, pre-populate with some memes
      _favoriteMemes = [
        MemeModel(
          id: 'fav_1',
          imageUrl: 'https://i.imgflip.com/30b1gx.jpg',
          title: 'Surprised Pikachu',
        ),
        MemeModel(
          id: 'fav_2',
          imageUrl: 'https://i.imgflip.com/26am.jpg',
          title: 'Drake Hotline Bling',
        ),
        MemeModel(
          id: 'fav_3',
          imageUrl: 'https://i.imgflip.com/5gimtn.jpg',
          title: 'Bernie Sanders',
        ),
        MemeModel(
          id: 'fav_4',
          imageUrl: 'https://i.imgflip.com/1ur9b0.jpg',
          title: 'Leonardo Dicaprio Cheers',
        ),
        MemeModel(
          id: 'fav_5',
          imageUrl: 'https://i.imgflip.com/1g8my4.jpg',
          title: 'Distracted Boyfriend',
        ),
      ];
      notifyListeners();
    } catch (e) {
      _logger.e('Error loading favorites: $e');
    }
  }

  void toggleFavorite(String memeId) {
    _favoriteMemes.removeWhere((meme) => meme.id == memeId);
    _logger.d('Removed from favorites: $memeId');
    notifyListeners();
  }

  void onMemePressed(MemeModel meme) {
    _logger.d('Meme pressed: ${meme.title}');
    // TODO: Navigate to meme detail view or show share options
  }
}
