import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:memeic/helpers/app_error.dart';
import 'package:memeic/models/tag/tag_with_count.dart';
import 'package:memeic/models/category/category_with_count.dart';
import 'package:memeic/models/hive_models.dart';
import 'package:memeic/services/hive_service.dart';
import 'package:memeic/app/app.locator.dart';

/// TagsService - Manages tags and categories from Supabase with offline support
///
/// This service fetches tags and categories from Supabase RPC functions
/// and caches them in Hive for offline access.
class TagsService {
  final Logger _logger = Logger();
  final SupabaseClient _supabase = Supabase.instance.client;
  HiveService get _hiveService => locator<HiveService>();

  /// Get all tags from Supabase RPC function
  ///
  /// Fetches tags using 'get_all_tags' RPC, caches in Hive, and returns them.
  /// Falls back to cached tags if network fails.
  Future<List<TagWithCount>> getAllTags() async {
    try {
      _logger.d('Fetching tags from Supabase');
      final response = await _supabase.rpc('get_all_tags');

      if (response == null) {
        _logger.w('RPC returned null');
        final cached = getCachedTags();
        if (cached.isNotEmpty) return cached;
        return [];
      }

      if (response is! List) {
        _logger.e('RPC returned unexpected type: ${response.runtimeType}');
        _logger.d('Raw response: $response');
        final cached = getCachedTags();
        if (cached.isNotEmpty) return cached;
        return [];
      }

      final List<dynamic> responseList = response;
      _logger.d('RPC returned ${responseList.length} items');

      if (responseList.isEmpty) {
        _logger.w(
            'RPC returned empty array - check RLS permissions on get_all_tags function');
        final cached = getCachedTags();
        if (cached.isNotEmpty) {
          _logger.d('Using ${cached.length} cached tags');
          return cached;
        }
        return [];
      }

      final tags = responseList
          .where((item) => item != null && item is Map<String, dynamic>)
          .map((item) {
            try {
              return TagWithCount.fromSupabaseResponse(
                  item as Map<String, dynamic>);
            } catch (e) {
              _logger.e('Failed to parse tag item: $item', e);
              return null;
            }
          })
          .whereType<TagWithCount>()
          .toList();

      await _cacheTags(tags);
      _logger.d('Fetched ${tags.length} tags from Supabase');
      return tags;
    } catch (e, stackTrace) {
      _logger.w('Failed to fetch tags, using cached', e, stackTrace);
      final cached = getCachedTags();
      if (cached.isNotEmpty) return cached;
      throw AppError.create(
        message: 'Failed to fetch tags: ${e.toString()}',
        type: ErrorType.network,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Cache tags in Hive for offline access
  Future<void> _cacheTags(List<TagWithCount> tags) async {
    try {
      final box = _hiveService.tagsBox;
      await box.clear();
      for (final tag in tags) {
        await box.put(tag.tag, HiveTagWithCount.fromTagWithCount(tag));
      }
      _logger.d('Cached ${tags.length} tags');
    } catch (e, stackTrace) {
      _logger.e('Failed to cache tags', e, stackTrace);
    }
  }

  /// Get cached tags from Hive
  List<TagWithCount> getCachedTags() {
    try {
      return _hiveService.tagsBox.values
          .map((hiveTag) => hiveTag.toTagWithCount())
          .toList();
    } catch (e, stackTrace) {
      _logger.e('Failed to get cached tags', e, stackTrace);
      return [];
    }
  }

  /// Get top N tags (assumes RPC returns sorted by count)
  Future<List<TagWithCount>> getTopTags({int limit = 20}) async {
    final tags = await getAllTags();
    return tags.take(limit).toList();
  }

  /// Get top N tags from cache
  List<TagWithCount> getTopCachedTags({int limit = 20}) {
    return getCachedTags().take(limit).toList();
  }

  /// Get all categories from Supabase RPC function
  ///
  /// Fetches categories using 'get_all_categories' RPC, caches in Hive, and returns them.
  /// Falls back to cached categories if network fails.
  Future<List<CategoryWithCount>> getAllCategories() async {
    try {
      _logger.d('Fetching categories from Supabase');
      final response = await _supabase.rpc('get_all_categories');

      if (response == null) {
        _logger.w('RPC returned null');
        final cached = getCachedCategories();
        if (cached.isNotEmpty) return cached;
        return [];
      }

      if (response is! List) {
        _logger.e('RPC returned unexpected type: ${response.runtimeType}');
        _logger.d('Raw response: $response');
        final cached = getCachedCategories();
        if (cached.isNotEmpty) return cached;
        return [];
      }

      final List<dynamic> responseList = response;
      _logger.d('RPC returned ${responseList.length} items');

      if (responseList.isEmpty) {
        _logger.w(
            'RPC returned empty array - check RLS permissions on get_all_categories function');
        final cached = getCachedCategories();
        if (cached.isNotEmpty) {
          _logger.d('Using ${cached.length} cached categories');
          return cached;
        }
        return [];
      }

      final categories = responseList
          .where((item) => item != null && item is Map<String, dynamic>)
          .map((item) {
            try {
              return CategoryWithCount.fromSupabaseResponse(
                  item as Map<String, dynamic>);
            } catch (e) {
              _logger.e('Failed to parse category item: $item', e);
              return null;
            }
          })
          .whereType<CategoryWithCount>()
          .toList();

      await _cacheCategories(categories);
      _logger.d('Fetched ${categories.length} categories from Supabase');
      return categories;
    } catch (e, stackTrace) {
      _logger.e('Exception in getAllCategories', e, stackTrace);
      final cached = getCachedCategories();
      if (cached.isNotEmpty) return cached;
      throw AppError.create(
        message: 'Failed to fetch categories: ${e.toString()}',
        type: ErrorType.network,
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Cache categories in Hive for offline access
  Future<void> _cacheCategories(List<CategoryWithCount> categories) async {
    try {
      final box = _hiveService.categoriesBox;
      await box.clear();
      for (final category in categories) {
        await box.put(category.category,
            HiveCategoryWithCount.fromCategoryWithCount(category));
      }
      _logger.d('Cached ${categories.length} categories');
    } catch (e, stackTrace) {
      _logger.e('Failed to cache categories', e, stackTrace);
    }
  }

  /// Get cached categories from Hive
  List<CategoryWithCount> getCachedCategories() {
    try {
      return _hiveService.categoriesBox.values
          .map((hiveCategory) => hiveCategory.toCategoryWithCount())
          .toList();
    } catch (e, stackTrace) {
      _logger.e('Failed to get cached categories', e, stackTrace);
      return [];
    }
  }

  /// Get top N categories (assumes RPC returns sorted by count)
  Future<List<CategoryWithCount>> getTopCategories({int limit = 20}) async {
    final categories = await getAllCategories();
    return categories.take(limit).toList();
  }

  /// Get top N categories from cache
  List<CategoryWithCount> getTopCachedCategories({int limit = 20}) {
    return getCachedCategories().take(limit).toList();
  }

  /// Get random categories for trending (picks from top 20)
  Future<List<CategoryWithCount>> getRandomCategories({int count = 4}) async {
    try {
      final top = await getTopCategories(limit: 20);
      if (top.isEmpty) return [];
      final shuffled = List<CategoryWithCount>.from(top)..shuffle();
      return shuffled.take(count).toList();
    } catch (e, stackTrace) {
      _logger.e('Failed to get random categories, using cached', e, stackTrace);
      final cached = getTopCachedCategories(limit: 20);
      if (cached.isEmpty) return [];
      final shuffled = List<CategoryWithCount>.from(cached)..shuffle();
      return shuffled.take(count).toList();
    }
  }

  /// Get random categories from cache
  List<CategoryWithCount> getRandomCachedCategories({int count = 4}) {
    final top = getTopCachedCategories(limit: 20);
    if (top.isEmpty) return [];
    final shuffled = List<CategoryWithCount>.from(top)..shuffle();
    return shuffled.take(count).toList();
  }
}
