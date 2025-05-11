import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

mixin TableServer on Table {
  String get serverTblName;

  BoolColumn get isRemote => boolean().withDefault(const Constant(false))();
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  @JsonKey('created_at')
  DateTimeColumn get createdAt => dateTime()();
  @JsonKey('updated_at')
  DateTimeColumn get updatedAt => dateTime()();
  @JsonKey('deleted_at')
  DateTimeColumn get deletedAt => dateTime().nullable()();

  Insertable<DataClass> fromJson(Map<String, dynamic> json);
}
