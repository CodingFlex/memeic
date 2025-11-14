// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_with_count.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryWithCountImpl _$$CategoryWithCountImplFromJson(
        Map<String, dynamic> json) =>
    _$CategoryWithCountImpl(
      category: json['category'] as String,
      count: (json['count'] as num).toInt(),
      emoji: json['emoji'] as String?,
    );

Map<String, dynamic> _$$CategoryWithCountImplToJson(
        _$CategoryWithCountImpl instance) =>
    <String, dynamic>{
      'category': instance.category,
      'count': instance.count,
      'emoji': instance.emoji,
    };
