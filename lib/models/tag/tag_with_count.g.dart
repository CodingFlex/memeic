// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_with_count.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TagWithCountImpl _$$TagWithCountImplFromJson(Map<String, dynamic> json) =>
    _$TagWithCountImpl(
      tag: json['tag'] as String,
      count: (json['count'] as num).toInt(),
      emoji: json['emoji'] as String?,
    );

Map<String, dynamic> _$$TagWithCountImplToJson(_$TagWithCountImpl instance) =>
    <String, dynamic>{
      'tag': instance.tag,
      'count': instance.count,
      'emoji': instance.emoji,
    };
