import 'package:custom_supabase_drift_sync/domain/dialogs/add_team_state.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'module.g.dart';

@riverpod
class AddTeamP extends _$AddTeamP {
  @override
  AddTeamState build() {
    return const AddTeamState();
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  Future<Option<int>> createTeam() async {
    if (!state.isValid) {
      return const None();
    }
    //    const {data, error} = await Supabase.rpc('create_account', {

    final map = {
      'name': state.name,
      "slug": state.name.toLowerCase().replaceAll(' ', '_'),
    };
    try {
      final res =
          await Supabase.instance.client.rpc('create_account', params: map);
      return const Some(1);
    } catch (e) {
      Logger.root.severe('Error creating team: $e');
      print(e);
    }
    return const None();
  }
}
