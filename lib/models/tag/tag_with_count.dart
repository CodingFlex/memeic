import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag_with_count.freezed.dart';
part 'tag_with_count.g.dart';

/// TagWithCount - Represents a tag with its usage count
///
/// This model represents a tag from the database along with
/// how many memes are associated with it.
@freezed
class TagWithCount with _$TagWithCount {
  const factory TagWithCount({
    required String tag,
    required int count,
    String? emoji, // Emoji from database, optional
  }) = _TagWithCount;

  factory TagWithCount.fromJson(Map<String, dynamic> json) =>
      _$TagWithCountFromJson(json);

  /// Create from Supabase RPC response
  factory TagWithCount.fromSupabaseResponse(Map<String, dynamic> data) {
    return TagWithCount(
      tag: data['tag'] as String,
      count: data['count'] as int,
      emoji: data['emoji'] as String?,
    );
  }
}
