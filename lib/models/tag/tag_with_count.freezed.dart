// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tag_with_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TagWithCount _$TagWithCountFromJson(Map<String, dynamic> json) {
  return _TagWithCount.fromJson(json);
}

/// @nodoc
mixin _$TagWithCount {
  String get tag => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  String? get emoji => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TagWithCountCopyWith<TagWithCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TagWithCountCopyWith<$Res> {
  factory $TagWithCountCopyWith(
          TagWithCount value, $Res Function(TagWithCount) then) =
      _$TagWithCountCopyWithImpl<$Res, TagWithCount>;
  @useResult
  $Res call({String tag, int count, String? emoji});
}

/// @nodoc
class _$TagWithCountCopyWithImpl<$Res, $Val extends TagWithCount>
    implements $TagWithCountCopyWith<$Res> {
  _$TagWithCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tag = null,
    Object? count = null,
    Object? emoji = freezed,
  }) {
    return _then(_value.copyWith(
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      emoji: freezed == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TagWithCountImplCopyWith<$Res>
    implements $TagWithCountCopyWith<$Res> {
  factory _$$TagWithCountImplCopyWith(
          _$TagWithCountImpl value, $Res Function(_$TagWithCountImpl) then) =
      __$$TagWithCountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String tag, int count, String? emoji});
}

/// @nodoc
class __$$TagWithCountImplCopyWithImpl<$Res>
    extends _$TagWithCountCopyWithImpl<$Res, _$TagWithCountImpl>
    implements _$$TagWithCountImplCopyWith<$Res> {
  __$$TagWithCountImplCopyWithImpl(
      _$TagWithCountImpl _value, $Res Function(_$TagWithCountImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tag = null,
    Object? count = null,
    Object? emoji = freezed,
  }) {
    return _then(_$TagWithCountImpl(
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      emoji: freezed == emoji
          ? _value.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TagWithCountImpl implements _TagWithCount {
  const _$TagWithCountImpl(
      {required this.tag, required this.count, this.emoji});

  factory _$TagWithCountImpl.fromJson(Map<String, dynamic> json) =>
      _$$TagWithCountImplFromJson(json);

  @override
  final String tag;
  @override
  final int count;
  @override
  final String? emoji;

  @override
  String toString() {
    return 'TagWithCount(tag: $tag, count: $count, emoji: $emoji)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TagWithCountImpl &&
            (identical(other.tag, tag) || other.tag == tag) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.emoji, emoji) || other.emoji == emoji));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, tag, count, emoji);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TagWithCountImplCopyWith<_$TagWithCountImpl> get copyWith =>
      __$$TagWithCountImplCopyWithImpl<_$TagWithCountImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TagWithCountImplToJson(
      this,
    );
  }
}

abstract class _TagWithCount implements TagWithCount {
  const factory _TagWithCount(
      {required final String tag,
      required final int count,
      final String? emoji}) = _$TagWithCountImpl;

  factory _TagWithCount.fromJson(Map<String, dynamic> json) =
      _$TagWithCountImpl.fromJson;

  @override
  String get tag;
  @override
  int get count;
  @override
  String? get emoji;
  @override
  @JsonKey(ignore: true)
  _$$TagWithCountImplCopyWith<_$TagWithCountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
