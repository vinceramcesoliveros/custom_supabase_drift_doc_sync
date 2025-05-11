import 'package:custom_supabase_drift_sync/core/error_handling.dart';
import 'package:custom_supabase_drift_sync/core/navigation/router.dart';
import 'package:custom_supabase_drift_sync/db/database.dart' as db;
import 'package:custom_supabase_drift_sync/sync/sync_builder.dart';
import 'package:custom_supabase_drift_sync/sync/sync_interface.dart';
import 'package:custom_supabase_drift_sync/sync/sync_manager.dart';
import 'package:custom_sync_drift_annotations/annotations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'module.g.dart';

@Riverpod(keepAlive: true)
db.AppDatabase appDatabase(AppDatabaseRef ref) {
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
      E.t.debug('User signed in');
      // Connect to PowerSync when the user is signed in
      //ref.read(supabaseConnectorPProvider.notifier).signIn();
      await Future.delayed(const Duration(milliseconds: 200));

      ref.read(syncMangerPProvider).signIn();
      final currentSession = data.session;
      if (currentSession != null) {
        ref
            .read(sessionPProvider.notifier)
            .setSession(Option.of(currentSession));
      }
    } else if (event == AuthChangeEvent.signedOut) {
      E.t.debug('User signed out');

      await Future.delayed(const Duration(milliseconds: 200));

      // Implicit sign out - disconnect, but don't delete data
      //ref.read(supabaseConnectorPProvider.notifier).signOut();
      ref.read(syncMangerPProvider).signOut();

      ref.read(sessionPProvider.notifier).setSession(const Option.none());
    } else if (event == AuthChangeEvent.tokenRefreshed) {
      E.t.debug('Token refreshed');
      ref.read(syncMangerPProvider).signIn();
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
  SyncInterface build() {
    // final manager = SyncManagerS(
    //   db: ref.watch(appDatabaseProvider),
    //   supabase: ref.watch(supabaseProvider),
    //   basicSharePrefs: ref.watch(sharedPreferencesProvider),
    //   syncClass: const SyncClass(),
    // );
    final dbRef = ref.watch(appDatabaseProvider);
    final manager = SyncManagerBuilder(
      db: dbRef,
      supabase: ref.watch(supabaseProvider),
      basicSharePrefs: ref.watch(sharedPreferencesProvider),
      // syncClass: const SyncClass(),
      syncClass: SyncBuilder(
        tables: [db.Task(), db.Project(), db.Docup()],
      ),
    );
    ref.onDispose(() {
      manager.dispose();
    });
    return manager;
  }
}

@riverpod
SupabaseClient supabase(SupabaseRef ref) {
  throw Exception('SupabaseClient is not provided');
}

@riverpod
SharedPreferences sharedPreferences(Ref ref) {
  throw Exception('SupabaseClient is not provided');
}
