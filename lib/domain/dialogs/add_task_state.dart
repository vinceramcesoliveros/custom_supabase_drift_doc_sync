import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_task_state.freezed.dart';

@freezed
class AddTaskState with _$AddTaskState {
  const factory AddTaskState({
    @Default('') String name,
    @Default(None()) Option<String> projectId,
  }) = _AddTaskState;

  const AddTaskState._();

  bool get isValid => name.isNotEmpty && projectId.isSome();
}
