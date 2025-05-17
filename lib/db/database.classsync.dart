// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'database.dart';

// **************************************************************************
// ClassSyncCodeGenerator
// **************************************************************************

extension TaskSyncExtension on Task {
// Task sync code
  static Future<void> sync(Map<String, dynamic> changes, AppDatabase db) async {
    final taskChanges = changes[Task.serverTableName] as Map<String, dynamic>;
    final taskInstance = db.task;
    final createdOrUpdated = taskChanges['created'] + taskChanges['updated'];
    for (final record in createdOrUpdated) {
      final existingRecord = await (db.select(taskInstance)
            ..where((tbl) => tbl.id.equals(record['id'])))
          .getSingleOrNull();
      if (existingRecord == null ||
          DateTime.parse(record['updated_at'])
              .isAfter(existingRecord.updatedAt)) {
        await db.into(taskInstance).insertOnConflictUpdate(TaskData.fromJson(
            (record as Map<String, dynamic>)..addAll({'isRemote': true})));
      }
    }
  }
}

extension TaskGetChangesExtension on Task {
// Task getChanges code
  static Future<Map<String, Map<String, List<dynamic>>>> getChanges(
      DateTime lastSyncedAt,
      AppDatabase database,
      String currentInstanceId) async {
    final taskInstance = database.task;
    final created = await (database.select(taskInstance)
          ..where((tbl) =>
              tbl.createdAt.isBiggerOrEqualValue(lastSyncedAt) &
              tbl.isRemote.equals(false)))
        .get();
    final updated = await (database.select(taskInstance)
          ..where((tbl) =>
              tbl.updatedAt.isBiggerOrEqualValue(lastSyncedAt) &
              tbl.createdAt.isSmallerThanValue(lastSyncedAt) &
              tbl.isRemote.equals(false)))
        .get();
    final deleted = await (database.select(taskInstance)
          ..where((tbl) =>
              tbl.deletedAt.isBiggerOrEqualValue(lastSyncedAt) &
              tbl.isRemote.equals(false)))
        .get();
    return {
      Task.serverTableName: {
        'created': created
            .map((e) => e.toJson()
              ..remove('isRemote')
              ..addAll({
                'instance_id': currentInstanceId,
              }))
            .toList(),
        'updated': updated
            .map((e) => e.toJson()
              ..remove('isRemote')
              ..addAll({
                'instance_id': currentInstanceId,
              }))
            .toList(),
        'deleted': deleted.map((e) => e.id).toList(),
      }
    };
  }
}

extension ProjectSyncExtension on Project {
// Project sync code
  static Future<void> sync(Map<String, dynamic> changes, AppDatabase db) async {
    final projectChanges =
        changes[Project.serverTableName] as Map<String, dynamic>;
    final projectInstance = db.project;
    final createdOrUpdated =
        projectChanges['created'] + projectChanges['updated'];
    for (final record in createdOrUpdated) {
      final existingRecord = await (db.select(projectInstance)
            ..where((tbl) => tbl.id.equals(record['id'])))
          .getSingleOrNull();
      if (existingRecord == null ||
          DateTime.parse(record['updated_at'])
              .isAfter(existingRecord.updatedAt)) {
        await db.into(projectInstance).insertOnConflictUpdate(
            ProjectData.fromJson(
                (record as Map<String, dynamic>)..addAll({'isRemote': true})));
      }
    }
  }
}

extension ProjectGetChangesExtension on Project {
// Project getChanges code
  static Future<Map<String, Map<String, List<dynamic>>>> getChanges(
      DateTime lastSyncedAt,
      AppDatabase database,
      String currentInstanceId) async {
    final projectInstance = database.project;
    final created = await (database.select(projectInstance)
          ..where((tbl) =>
              tbl.createdAt.isBiggerOrEqualValue(lastSyncedAt) &
              tbl.isRemote.equals(false)))
        .get();
    final updated = await (database.select(projectInstance)
          ..where((tbl) =>
              tbl.updatedAt.isBiggerOrEqualValue(lastSyncedAt) &
              tbl.createdAt.isSmallerThanValue(lastSyncedAt) &
              tbl.isRemote.equals(false)))
        .get();
    final deleted = await (database.select(projectInstance)
          ..where((tbl) =>
              tbl.deletedAt.isBiggerOrEqualValue(lastSyncedAt) &
              tbl.isRemote.equals(false)))
        .get();
    return {
      Project.serverTableName: {
        'created': created
            .map((e) => e.toJson()
              ..remove('isRemote')
              ..addAll({
                'instance_id': currentInstanceId,
              }))
            .toList(),
        'updated': updated
            .map((e) => e.toJson()
              ..remove('isRemote')
              ..addAll({
                'instance_id': currentInstanceId,
              }))
            .toList(),
        'deleted': deleted.map((e) => e.id).toList(),
      }
    };
  }
}

extension DocupSyncExtension on Docup {
// Docup sync code
  static Future<void> sync(Map<String, dynamic> changes, AppDatabase db) async {
    final docupChanges = changes[Docup.serverTableName] as Map<String, dynamic>;
    final docupInstance = db.docup;
    final createdOrUpdated = docupChanges['created'] + docupChanges['updated'];
    for (final record in createdOrUpdated) {
      final existingRecord = await (db.select(docupInstance)
            ..where((tbl) => tbl.id.equals(record['id'])))
          .getSingleOrNull();
      if (existingRecord == null ||
          DateTime.parse(record['updated_at'])
              .isAfter(existingRecord.updatedAt)) {
        await db.into(docupInstance).insertOnConflictUpdate(DocupData.fromJson(
            (record as Map<String, dynamic>)..addAll({'isRemote': true})));
      }
    }
  }
}

extension DocupGetChangesExtension on Docup {
// Docup getChanges code
  static Future<Map<String, Map<String, List<dynamic>>>> getChanges(
      DateTime lastSyncedAt,
      AppDatabase database,
      String currentInstanceId) async {
    final docupInstance = database.docup;
    final created = await (database.select(docupInstance)
          ..where((tbl) =>
              tbl.createdAt.isBiggerOrEqualValue(lastSyncedAt) &
              tbl.isRemote.equals(false)))
        .get();
    final updated = await (database.select(docupInstance)
          ..where((tbl) =>
              tbl.updatedAt.isBiggerOrEqualValue(lastSyncedAt) &
              tbl.createdAt.isSmallerThanValue(lastSyncedAt) &
              tbl.isRemote.equals(false)))
        .get();
    final deleted = await (database.select(docupInstance)
          ..where((tbl) =>
              tbl.deletedAt.isBiggerOrEqualValue(lastSyncedAt) &
              tbl.isRemote.equals(false)))
        .get();
    return {
      Docup.serverTableName: {
        'created': created
            .map((e) => e.toJson()
              ..remove('isRemote')
              ..addAll({
                'instance_id': currentInstanceId,
              }))
            .toList(),
        'updated': updated
            .map((e) => e.toJson()
              ..remove('isRemote')
              ..addAll({
                'instance_id': currentInstanceId,
              }))
            .toList(),
        'deleted': deleted.map((e) => e.id).toList(),
      }
    };
  }
}
