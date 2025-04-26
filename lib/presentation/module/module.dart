import 'package:custom_supabase_drift_sync/core/navigation/router.dart';
import 'package:custom_supabase_drift_sync/db/database.dart';
import 'package:custom_supabase_drift_sync/sync/sync_manager.dart';
import 'package:fpdart/fpdart.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'module.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) {
  throw UnimplementedError();
}

@Riverpod(keepAlive: true)
class SessionP extends _$SessionP {
  @override
  Option<Session> build() {
    return Option.fromNullable(Supabase.instance.client.auth.currentSession);
  }

  void setSession(Option<Session> session) {
    state = session;
  }

  void signOut() async {
    //final db = ref.read(powerSyncDatabaseProvider);
    ref.read(sessionPProvider.notifier).setSession(const Option.none());

    await Supabase.instance.client.auth.signOut();
    //await db.disconnectAndClear();
  }
}

@Riverpod(keepAlive: true)
Stream<AuthState> authState(AuthStateRef ref) async* {
  await for (final data in Supabase.instance.client.auth.onAuthStateChange) {
    final AuthChangeEvent event = data.event;
    if (event == AuthChangeEvent.signedIn) {
      // Connect to PowerSync when the user is signed in
      //ref.read(supabaseConnectorPProvider.notifier).signIn();
      ref.read(syncMangerPProvider).signIn();
    } else if (event == AuthChangeEvent.signedOut) {
      // Implicit sign out - disconnect, but don't delete data
      //ref.read(supabaseConnectorPProvider.notifier).signOut();
      ref.read(syncMangerPProvider).signOut();
    } else if (event == AuthChangeEvent.tokenRefreshed) {
      // Supabase token refreshed - trigger token refresh for PowerSync.
      //ref.read(supabaseConnectorPProvider.notifier).tokenRefreshed();
    }
    yield data;
  }
}

@riverpod
AppRouter appRouter(AppRouterRef ref) {
  return AppRouter(ref: ref);
}

@riverpod
class SyncMangerP extends _$SyncMangerP {
  @override
  SyncManager build() {
    return SyncManager(
      db: ref.watch(appDatabaseProvider),
      supabase: ref.watch(supabaseProvider),
      isar: ref.watch(isarProvider),
    );
  }
}

@riverpod
SupabaseClient supabase(SupabaseRef ref) {
  throw Exception('SupabaseClient is not provided');
}

@riverpod
Isar isar(IsarRef ref) {
  throw Exception('Isar is not provided');
}
