import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_with_count.freezed.dart';
part 'category_with_count.g.dart';

/// CategoryWithCount - Represents a category with its usage count
///
/// This model represents a category from the database along with
/// how many memes are associated with it.
@freezed
class CategoryWithCount with _$CategoryWithCount {
  const factory CategoryWithCount({
    required String category,
    required int count,
    String? emoji, // Emoji from database, optional
  }) = _CategoryWithCount;

  factory CategoryWithCount.fromJson(Map<String, dynamic> json) =>
      _$CategoryWithCountFromJson(json);

  /// Create from Supabase RPC response
  factory CategoryWithCount.fromSupabaseResponse(Map<String, dynamic> data) {
    return CategoryWithCount(
      category: data['category'] as String,
      count: data['count'] as int,
      emoji: data['emoji'] as String?,
    );
  }
}
