import 'package:custom_supabase_drift_sync/db/project_dao_mixin.dart';
import 'package:custom_supabase_drift_sync/db/task_dao_mixin.dart';
import 'package:custom_sync_drift_annotations/annotations.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

part 'database.classsync.dart';
part 'database.g.dart';

extension DateTimeExtension on DateTimeColumn {
  Expression<DateTime> get date {
    return FunctionCallExpression<DateTime>('DATE', [this]);
  }
}

@customSync
class Task extends Table {
  static String get serverTableName => "public.task";

  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  @JsonKey('created_at')
  DateTimeColumn get createdAt => dateTime()();
  @JsonKey('updated_at')
  DateTimeColumn get updatedAt => dateTime()();
  @JsonKey('deleted_at')
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get name => text()();

  BoolColumn get isRemote => boolean().withDefault(const Constant(false))();

  @JsonKey('project_id')
  TextColumn get projectId => text()();
  @JsonKey('user_id')
  TextColumn get userId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@customSync
class Project extends Table {
  static String get serverTableName => "public.project";

  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  @JsonKey('created_at')
  DateTimeColumn get createdAt => dateTime()();
  @JsonKey('updated_at')
  DateTimeColumn get updatedAt => dateTime()();
  @JsonKey('deleted_at')
  DateTimeColumn get deletedAt => dateTime().nullable()();

  BoolColumn get isRemote => boolean().withDefault(const Constant(false))();

  TextColumn get name => text()();
  @JsonKey('user_id')
  TextColumn get userId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@customSync
class Docup extends Table {
  static String get serverTableName => "public.doc_updates";

  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  @JsonKey('created_at')
  DateTimeColumn get createdAt => dateTime()();
  @JsonKey('updated_at')
  DateTimeColumn get updatedAt => dateTime()();
  @JsonKey('deleted_at')
  DateTimeColumn get deletedAt => dateTime().nullable()();
  @JsonKey('data_b64')
  TextColumn get dataB64 => text()();

  BoolColumn get isRemote => boolean().withDefault(const Constant(false))();

  @JsonKey('task_id')
  TextColumn get taskId => text()();
  @JsonKey('user_id')
  TextColumn get userId => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  Project,
  Task,
  Docup,
], daos: [
  TaskDao,
  ProjectDao,
])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/getting-started/#open

  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    // `driftDatabase` from `package:drift_flutter` stores the database in
    // `getApplicationDocumentsDirectory()`.
    return driftDatabase(
      name: 'my_database',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
        onResult: (result) {
          if (result.missingFeatures.isNotEmpty) {
            debugPrint(
              'Using ${result.chosenImplementation} due to unsupported '
              'browser features: ${result.missingFeatures}',
            );
          }
        },
      ),
    );
  }
}
