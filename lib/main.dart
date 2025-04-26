// The original content is temporarily commented out to allow generating a self-contained demo - feel free to uncomment later.

import 'package:appflowy_editor_sync_plugin/appflowy_editor_sync_utility_functions.dart';
import 'package:custom_supabase_drift_sync/core/error_handling.dart';
import 'package:custom_supabase_drift_sync/db/database.dart';
import 'package:custom_supabase_drift_sync/db/isar/init_isar.dart';
import 'package:custom_supabase_drift_sync/db/supabase/supabase_helpers.dart';
import 'package:custom_supabase_drift_sync/presentation/app.dart';
import 'package:custom_supabase_drift_sync/presentation/module/module.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final res = await Future.wait([
    SupabaseHelpers.loadSupabase(),
    initializeIsar(),
    AppflowyEditorSyncUtilityFunctions.initAppFlowyEditorSync(),
  ]);

  driftRuntimeOptions.defaultSerializer = const ValueSerializer.defaults(
    serializeDateTimeValuesAsString: true,
  );

  final supabase = res[0] as Supabase;
  final isar = res[1] as Isar;

  runApp(
    ProviderScope(
      overrides: [
        supabaseProvider.overrideWithValue(supabase.client),
        isarProvider.overrideWithValue(isar),
        appDatabaseProvider.overrideWithValue(AppDatabase()),
      ],
      observers: [
        TalkerRiverpodObserver(
          talker: E.t,
        ),
      ],
      child: const App(),
    ),
  );
}
