import 'package:custom_supabase_drift_sync/db/project_dao_mixin.dart';
import 'package:custom_supabase_drift_sync/db/task_dao_mixin.dart';
import 'package:custom_supabase_drift_sync/sync/sync_builder.dart';
import 'package:custom_sync_drift_annotations/annotations.dart';
import 'package:dartx/dartx.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:uuid/uuid.dart';

part 'database.classsync.dart';
part 'database.g.dart';

extension DateTimeExtension on DateTimeColumn {
  Expression<DateTime> get date {
    return FunctionCallExpression<DateTime>('DATE', [this]);
  }
}

@customSync
class Task extends Table with TableServer {
  static String get serverTableName => "public.task";

  @override
  String get serverTblName => serverTableName;
  TextColumn get name => text()();

  @JsonKey('project_id')
  TextColumn get projectId => text()();
  @JsonKey('user_id')
  TextColumn get userId => text()();

  @override
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  @override
  BoolColumn get isRemote => boolean().withDefault(const Constant(false))();
  @override
  @JsonKey('created_at')
  DateTimeColumn get createdAt => dateTime()();
  @override
  @JsonKey('updated_at')
  DateTimeColumn get updatedAt => dateTime()();
  @override
  @JsonKey('deleted_at')
  DateTimeColumn get deletedAt => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {id};

  @override
  Insertable<DataClass> fromJson(Map<String, dynamic> json) {
    return TaskData.fromJson(json);
  }
}

@customSync
class Project extends Table with TableServer {
  static String get serverTableName => "public.project";

  @override
  String get serverTblName => serverTableName;
  @override
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  @override
  @JsonKey('created_at')
  DateTimeColumn get createdAt => dateTime()();
  @override
  @JsonKey('updated_at')
  DateTimeColumn get updatedAt => dateTime()();
  @override
  @JsonKey('deleted_at')
  DateTimeColumn get deletedAt => dateTime().nullable()();

  TextColumn get name => text()();
  @JsonKey('user_id')
  TextColumn get userId => text()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  Insertable<DataClass> fromJson(Map<String, dynamic> json) {
    return ProjectData.fromJson(json);
  }
}

@customSync
class Docup extends Table with TableServer {
  static String get serverTableName => "public.doc_updates";

  @override
  String get serverTblName => serverTableName;
  @override
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  @override
  @JsonKey('created_at')
  DateTimeColumn get createdAt => dateTime()();
  @override
  @JsonKey('updated_at')
  DateTimeColumn get updatedAt => dateTime()();
  @override
  @JsonKey('deleted_at')
  DateTimeColumn get deletedAt => dateTime().nullable()();
  @JsonKey('data_b64')
  TextColumn get dataB64 => text()();

  @JsonKey('task_id')
  TextColumn get taskId => text()();
  @JsonKey('user_id')
  TextColumn get userId => text()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  Insertable<DataClass> fromJson(Map<String, dynamic> json) {
    return DocupData.fromJson(json);
  }
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

    // Currently having multiple tabs open in the same browser is not supported.
    // So it is important to have unique database names for each tab.
    // https://github.com/simolus3/sqlite3.dart/issues/240
    final dbName = UniversalPlatform.isWeb
        ? 'db_name ${const Uuid().v4()}'
        : 'my_database6';

    return driftDatabase(
      name: dbName,
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
