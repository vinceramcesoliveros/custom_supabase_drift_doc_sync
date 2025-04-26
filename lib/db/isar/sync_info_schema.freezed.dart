// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_info_schema.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SyncInfo _$SyncInfoFromJson(Map<String, dynamic> json) {
  return _SyncInfo.fromJson(json);
}

/// @nodoc
mixin _$SyncInfo {
  int get id => throw _privateConstructorUsedError;
  DateTime? get lastPulledAt => throw _privateConstructorUsedError;

  /// Serializes this SyncInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SyncInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncInfoCopyWith<SyncInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncInfoCopyWith<$Res> {
  factory $SyncInfoCopyWith(SyncInfo value, $Res Function(SyncInfo) then) =
      _$SyncInfoCopyWithImpl<$Res, SyncInfo>;
  @useResult
  $Res call({int id, DateTime? lastPulledAt});
}

/// @nodoc
class _$SyncInfoCopyWithImpl<$Res, $Val extends SyncInfo>
    implements $SyncInfoCopyWith<$Res> {
  _$SyncInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lastPulledAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      lastPulledAt: freezed == lastPulledAt
          ? _value.lastPulledAt
          : lastPulledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SyncInfoImplCopyWith<$Res>
    implements $SyncInfoCopyWith<$Res> {
  factory _$$SyncInfoImplCopyWith(
          _$SyncInfoImpl value, $Res Function(_$SyncInfoImpl) then) =
      __$$SyncInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, DateTime? lastPulledAt});
}

/// @nodoc
class __$$SyncInfoImplCopyWithImpl<$Res>
    extends _$SyncInfoCopyWithImpl<$Res, _$SyncInfoImpl>
    implements _$$SyncInfoImplCopyWith<$Res> {
  __$$SyncInfoImplCopyWithImpl(
      _$SyncInfoImpl _value, $Res Function(_$SyncInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lastPulledAt = freezed,
  }) {
    return _then(_$SyncInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      lastPulledAt: freezed == lastPulledAt
          ? _value.lastPulledAt
          : lastPulledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SyncInfoImpl implements _SyncInfo {
  const _$SyncInfoImpl({required this.id, this.lastPulledAt});

  factory _$SyncInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncInfoImplFromJson(json);

  @override
  final int id;
  @override
  final DateTime? lastPulledAt;

  @override
  String toString() {
    return 'SyncInfo(id: $id, lastPulledAt: $lastPulledAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lastPulledAt, lastPulledAt) ||
                other.lastPulledAt == lastPulledAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, lastPulledAt);

  /// Create a copy of SyncInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncInfoImplCopyWith<_$SyncInfoImpl> get copyWith =>
      __$$SyncInfoImplCopyWithImpl<_$SyncInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncInfoImplToJson(
      this,
    );
  }
}

abstract class _SyncInfo implements SyncInfo {
  const factory _SyncInfo(
      {required final int id, final DateTime? lastPulledAt}) = _$SyncInfoImpl;

  factory _SyncInfo.fromJson(Map<String, dynamic> json) =
      _$SyncInfoImpl.fromJson;

  @override
  int get id;
  @override
  DateTime? get lastPulledAt;

  /// Create a copy of SyncInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncInfoImplCopyWith<_$SyncInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
