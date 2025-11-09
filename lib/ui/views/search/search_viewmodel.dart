import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:logger/logger.dart';
import 'package:memeic/app/app.locator.dart';

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
  final searchController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<MemeModel> _memes = [];
  List<MemeModel> get memes => _memes;

  final Set<String> _favoriteIds = {};

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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
    } catch (e) {
      _logger.e('Error performing search: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
