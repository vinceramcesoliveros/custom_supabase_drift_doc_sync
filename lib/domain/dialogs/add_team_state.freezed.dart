// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_team_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AddTeamState {
  String get name => throw _privateConstructorUsedError;

  /// Create a copy of AddTeamState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddTeamStateCopyWith<AddTeamState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddTeamStateCopyWith<$Res> {
  factory $AddTeamStateCopyWith(
          AddTeamState value, $Res Function(AddTeamState) then) =
      _$AddTeamStateCopyWithImpl<$Res, AddTeamState>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$AddTeamStateCopyWithImpl<$Res, $Val extends AddTeamState>
    implements $AddTeamStateCopyWith<$Res> {
  _$AddTeamStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddTeamState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddTeamStateImplCopyWith<$Res>
    implements $AddTeamStateCopyWith<$Res> {
  factory _$$AddTeamStateImplCopyWith(
          _$AddTeamStateImpl value, $Res Function(_$AddTeamStateImpl) then) =
      __$$AddTeamStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$AddTeamStateImplCopyWithImpl<$Res>
    extends _$AddTeamStateCopyWithImpl<$Res, _$AddTeamStateImpl>
    implements _$$AddTeamStateImplCopyWith<$Res> {
  __$$AddTeamStateImplCopyWithImpl(
      _$AddTeamStateImpl _value, $Res Function(_$AddTeamStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddTeamState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_$AddTeamStateImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AddTeamStateImpl extends _AddTeamState {
  const _$AddTeamStateImpl({this.name = ''}) : super._();

  @override
  @JsonKey()
  final String name;

  @override
  String toString() {
    return 'AddTeamState(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddTeamStateImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name);

  /// Create a copy of AddTeamState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddTeamStateImplCopyWith<_$AddTeamStateImpl> get copyWith =>
      __$$AddTeamStateImplCopyWithImpl<_$AddTeamStateImpl>(this, _$identity);
}

abstract class _AddTeamState extends AddTeamState {
  const factory _AddTeamState({final String name}) = _$AddTeamStateImpl;
  const _AddTeamState._() : super._();

  @override
  String get name;

  /// Create a copy of AddTeamState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddTeamStateImplCopyWith<_$AddTeamStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
