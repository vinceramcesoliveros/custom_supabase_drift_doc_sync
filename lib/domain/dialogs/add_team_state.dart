import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_team_state.freezed.dart';

@freezed
class AddTeamState with _$AddTeamState {
  const factory AddTeamState({
    @Default('') String name,
  }) = _AddTeamState;

  const AddTeamState._();

  bool get isValid => name.isNotEmpty;
}
