import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:logger/logger.dart';
import 'package:memeic/app/app.locator.dart';
import 'package:memeic/ui/views/search/search_viewmodel.dart';
import 'package:memeic/ui/views/meme_detail/meme_detail_view.dart';
import 'package:memeic/ui/views/search/search_view.dart';

class HomeViewModel extends BaseViewModel {
  final _logger = Logger();
  final _navigationService = locator<NavigationService>();
  final searchController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final Set<String> _favoriteIds = {};

  List<MemeModel> _trendingMemes = [];
  List<MemeModel> get trendingMemes => _trendingMemes;

  int _selectedMoodIndex = 0;
  int get selectedMoodIndex => _selectedMoodIndex;

  final List<MoodModel> moodChips = [
    MoodModel(emoji: '😂', label: 'Funny'),
    MoodModel(emoji: '🤔', label: 'Confused'),
    MoodModel(emoji: '😎', label: 'Savage'),
    MoodModel(emoji: '❤️', label: 'Love'),
    MoodModel(emoji: '😡', label: 'Angry'),
    MoodModel(emoji: '😲', label: 'Shocked'),
    MoodModel(emoji: '😊', label: 'Happy'),
    MoodModel(emoji: '😢', label: 'Sad'),
    MoodModel(emoji: '🤣', label: 'LOL'),
    MoodModel(emoji: '😴', label: 'Sleepy'),
  ];

  HomeViewModel() {
    _loadTrendingMemes();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTrendingMemes() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call with placeholder trending memes
      await Future.delayed(const Duration(seconds: 1));

      _trendingMemes = [
        MemeModel(
          id: 'trending_1',
          imageUrl: 'https://i.imgflip.com/30b1gx.jpg',
          title: 'When you finally understand the joke',
          tags: ['Funny', 'Relatable'],
          showPreview: true,
        ),
        MemeModel(
          id: 'trending_2',
          imageUrl: 'https://i.imgflip.com/1g8my4.jpg',
          title: 'Distracted Boyfriend',
          tags: ['Funny'],
          showPreview: true,
        ),
        MemeModel(
          id: 'trending_3',
          imageUrl: 'https://i.imgflip.com/26am.jpg',
          title: 'Drake Hotline Bling',
          tags: ['Savage'],
          showPreview: false,
        ),
        MemeModel(
          id: 'trending_4',
          imageUrl: 'https://i.imgflip.com/1bij.jpg',
          title: 'One Does Not Simply',
          tags: ['Funny', 'Relatable'],
          showPreview: true,
        ),
        MemeModel(
          id: 'trending_5',
          imageUrl: 'https://i.imgflip.com/5gimtn.jpg',
          title: 'Bernie Sanders',
          tags: ['Relatable'],
          showPreview: false,
        ),
        MemeModel(
          id: 'trending_6',
          imageUrl: 'https://i.imgflip.com/261o3j.jpg',
          title: 'Change My Mind',
          tags: ['Savage'],
          showPreview: true,
        ),
      ];
    } catch (e) {
      _logger.e('Error loading trending memes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectMood(int index) {
    _selectedMoodIndex = index;
    _logger.d('Mood selected: ${moodChips[index].label}');
    notifyListeners();
    // TODO: Filter memes by selected mood
  }

  void onSearchChanged(String query) {
    _logger.d('Search query changed: $query');
    // TODO: Implement search functionality for home view
  }

  void onSearchBarTapped() {
    _logger.d('Search bar tapped - navigating to search view');
    _navigationService.navigateToView(const SearchView());
  }

  void onVoiceSearch() {
    _logger.d('Voice search initiated');
    // TODO: Implement voice search functionality
  }

  void toggleFavorite(String memeId) {
    if (_favoriteIds.contains(memeId)) {
      _favoriteIds.remove(memeId);
      _logger.d('Removed from favorites: $memeId');
    } else {
      _favoriteIds.add(memeId);
      _logger.d('Added to favorites: $memeId');
    }
    notifyListeners();
  }

  bool isFavorite(String memeId) {
    return _favoriteIds.contains(memeId);
  }

  void onMemePressed(MemeModel meme) {
    _logger.d('Meme pressed: ${meme.title}');
    Navigator.of(StackedService.navigatorKey!.currentContext!).push(
      MaterialPageRoute(
        builder: (context) => MemeDetailView(
          meme: meme,
          favoriteIds: _favoriteIds,
          heroTag: 'meme_${meme.id}',
        ),
      ),
    );
  }

  // Get height multiplier for masonry layout (varies between 0.6 and 1.4)
  double getMemeHeightMultiplier(int index) {
    // Use index-based pseudo-random to ensure consistent layout
    // This simulates different image aspect ratios
    final variations = [0.7, 1.0, 0.8, 1.2, 0.9, 1.1, 0.85, 1.15, 0.75, 1.25];
    return variations[index % variations.length];
  }
}
