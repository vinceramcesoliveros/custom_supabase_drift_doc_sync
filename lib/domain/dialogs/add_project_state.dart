import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_project_state.freezed.dart';

@freezed
class AddProjectState with _$AddProjectState {
  const factory AddProjectState({
    @Default('') String name,
    @Default(None()) Option<String> teamId,
  }) = _AddProjectState;

  const AddProjectState._();

  bool get isValid => name.isNotEmpty;
}
