// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editor_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EditorStateCustom {
  EditorState get editorState => throw _privateConstructorUsedError;

  /// Create a copy of EditorStateCustom
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EditorStateCustomCopyWith<EditorStateCustom> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditorStateCustomCopyWith<$Res> {
  factory $EditorStateCustomCopyWith(
          EditorStateCustom value, $Res Function(EditorStateCustom) then) =
      _$EditorStateCustomCopyWithImpl<$Res, EditorStateCustom>;
  @useResult
  $Res call({EditorState editorState});
}

/// @nodoc
class _$EditorStateCustomCopyWithImpl<$Res, $Val extends EditorStateCustom>
    implements $EditorStateCustomCopyWith<$Res> {
  _$EditorStateCustomCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EditorStateCustom
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? editorState = null,
  }) {
    return _then(_value.copyWith(
      editorState: null == editorState
          ? _value.editorState
          : editorState // ignore: cast_nullable_to_non_nullable
              as EditorState,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EditorStateCustomImplCopyWith<$Res>
    implements $EditorStateCustomCopyWith<$Res> {
  factory _$$EditorStateCustomImplCopyWith(_$EditorStateCustomImpl value,
          $Res Function(_$EditorStateCustomImpl) then) =
      __$$EditorStateCustomImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({EditorState editorState});
}

/// @nodoc
class __$$EditorStateCustomImplCopyWithImpl<$Res>
    extends _$EditorStateCustomCopyWithImpl<$Res, _$EditorStateCustomImpl>
    implements _$$EditorStateCustomImplCopyWith<$Res> {
  __$$EditorStateCustomImplCopyWithImpl(_$EditorStateCustomImpl _value,
      $Res Function(_$EditorStateCustomImpl) _then)
      : super(_value, _then);

  /// Create a copy of EditorStateCustom
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? editorState = null,
  }) {
    return _then(_$EditorStateCustomImpl(
      editorState: null == editorState
          ? _value.editorState
          : editorState // ignore: cast_nullable_to_non_nullable
              as EditorState,
    ));
  }
}

/// @nodoc

class _$EditorStateCustomImpl extends _EditorStateCustom {
  const _$EditorStateCustomImpl({required this.editorState}) : super._();

  @override
  final EditorState editorState;

  @override
  String toString() {
    return 'EditorStateCustom(editorState: $editorState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EditorStateCustomImpl &&
            (identical(other.editorState, editorState) ||
                other.editorState == editorState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, editorState);

  /// Create a copy of EditorStateCustom
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EditorStateCustomImplCopyWith<_$EditorStateCustomImpl> get copyWith =>
      __$$EditorStateCustomImplCopyWithImpl<_$EditorStateCustomImpl>(
          this, _$identity);
}

abstract class _EditorStateCustom extends EditorStateCustom {
  const factory _EditorStateCustom({required final EditorState editorState}) =
      _$EditorStateCustomImpl;
  const _EditorStateCustom._() : super._();

  @override
  EditorState get editorState;

  /// Create a copy of EditorStateCustom
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EditorStateCustomImplCopyWith<_$EditorStateCustomImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
