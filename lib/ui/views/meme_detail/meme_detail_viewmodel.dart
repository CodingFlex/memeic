import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:logger/logger.dart';
import 'package:memeic/app/app.locator.dart';
import 'package:memeic/ui/views/search/search_viewmodel.dart';

class MemeDetailViewModel extends BaseViewModel {
  final _logger = Logger();
  final _navigationService = locator<NavigationService>();

  final MemeModel meme;
  final Set<String> _favoriteIds;

  MemeDetailViewModel({
    required this.meme,
    Set<String>? favoriteIds,
  }) : _favoriteIds = favoriteIds ?? {};

  bool get isFavorite => _favoriteIds.contains(meme.id);

  List<MemeModel> _similarMemes = [];
  List<MemeModel> get similarMemes => _similarMemes;

  bool _isLoadingSimilar = false;
  bool get isLoadingSimilar => _isLoadingSimilar;

  MemeDetailViewModel.empty()
      : meme = MemeModel(
          id: '',
          imageUrl: '',
        ),
        _favoriteIds = {} {
    throw Exception('MemeDetailViewModel cannot be empty');
  }

  void onBackPressed() {
    _navigationService.back();
  }

  void toggleFavorite() {
    if (_favoriteIds.contains(meme.id)) {
      _favoriteIds.remove(meme.id);
      _logger.d('Removed from favorites: ${meme.id}');
    } else {
      _favoriteIds.add(meme.id);
      _logger.d('Added to favorites: ${meme.id}');
    }
    notifyListeners();
    // TODO: Persist favorite state
  }

  Future<void> onShare() async {
    _logger.d('Share meme: ${meme.id}');
    // TODO: Implement share functionality
  }

  Future<void> onDownload() async {
    _logger.d('Download meme: ${meme.id}');
    // TODO: Implement download functionality
  }

  Future<void> onSave() async {
    toggleFavorite();
  }

  Future<void> onCopy() async {
    _logger.d('Copy meme: ${meme.id}');
    // TODO: Implement copy to clipboard functionality
  }

  Future<void> loadSimilarMemes() async {
    _isLoadingSimilar = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _similarMemes = [
        MemeModel(
          id: 'similar_1',
          imageUrl: 'https://i.imgflip.com/30b1gx.jpg',
          title: 'Similar vibe',
        ),
        MemeModel(
          id: 'similar_2',
          imageUrl: 'https://i.imgflip.com/1g8my4.jpg',
          title: 'You might like',
        ),
        MemeModel(
          id: 'similar_3',
          imageUrl: 'https://i.imgflip.com/26am.jpg',
          title: 'Related memes',
        ),
      ];
    } catch (e) {
      _logger.e('Error loading similar memes: $e');
    } finally {
      _isLoadingSimilar = false;
      notifyListeners();
    }
  }

  void onSimilarMemePressed(MemeModel similarMeme) {
    _logger.d('Similar meme pressed: ${similarMeme.title}');
    // TODO: Navigate to new detail view with similar meme
  }
}
