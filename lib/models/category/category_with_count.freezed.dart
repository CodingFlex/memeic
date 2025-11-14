// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_with_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CategoryWithCount _$CategoryWithCountFromJson(Map<String, dynamic> json) {
  return _CategoryWithCount.fromJson(json);
}

/// @nodoc
mixin _$CategoryWithCount {
  String get category => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  String? get emoji => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CategoryWithCountCopyWith<CategoryWithCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryWithCountCopyWith<$Res> {
  factory $CategoryWithCountCopyWith(
          CategoryWithCount value, $Res Function(CategoryWithCount) then) =
      _$CategoryWithCountCopyWithImpl<$Res, CategoryWithCount>;
  @useResult
  $Res call({String category, int count, String? emoji});
}

/// @nodoc
class _$CategoryWithCountCopyWithImpl<$Res, $Val extends CategoryWithCount>
    implements $CategoryWithCountCopyWith<$Res> {
  _$CategoryWithCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? count = null,
    Object? emoji = freezed,
  }) {
    return _then(_value.copyWith(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
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
abstract class _$$CategoryWithCountImplCopyWith<$Res>
    implements $CategoryWithCountCopyWith<$Res> {
  factory _$$CategoryWithCountImplCopyWith(_$CategoryWithCountImpl value,
          $Res Function(_$CategoryWithCountImpl) then) =
      __$$CategoryWithCountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String category, int count, String? emoji});
}

/// @nodoc
class __$$CategoryWithCountImplCopyWithImpl<$Res>
    extends _$CategoryWithCountCopyWithImpl<$Res, _$CategoryWithCountImpl>
    implements _$$CategoryWithCountImplCopyWith<$Res> {
  __$$CategoryWithCountImplCopyWithImpl(_$CategoryWithCountImpl _value,
      $Res Function(_$CategoryWithCountImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? count = null,
    Object? emoji = freezed,
  }) {
    return _then(_$CategoryWithCountImpl(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
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
class _$CategoryWithCountImpl implements _CategoryWithCount {
  const _$CategoryWithCountImpl(
      {required this.category, required this.count, this.emoji});

  factory _$CategoryWithCountImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryWithCountImplFromJson(json);

  @override
  final String category;
  @override
  final int count;
  @override
  final String? emoji;

  @override
  String toString() {
    return 'CategoryWithCount(category: $category, count: $count, emoji: $emoji)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryWithCountImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.emoji, emoji) || other.emoji == emoji));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, category, count, emoji);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryWithCountImplCopyWith<_$CategoryWithCountImpl> get copyWith =>
      __$$CategoryWithCountImplCopyWithImpl<_$CategoryWithCountImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryWithCountImplToJson(
      this,
    );
  }
}

abstract class _CategoryWithCount implements CategoryWithCount {
  const factory _CategoryWithCount(
      {required final String category,
      required final int count,
      final String? emoji}) = _$CategoryWithCountImpl;

  factory _CategoryWithCount.fromJson(Map<String, dynamic> json) =
      _$CategoryWithCountImpl.fromJson;

  @override
  String get category;
  @override
  int get count;
  @override
  String? get emoji;
  @override
  @JsonKey(ignore: true)
  _$$CategoryWithCountImplCopyWith<_$CategoryWithCountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
