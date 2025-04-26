import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'sync_info_schema.freezed.dart';
part 'sync_info_schema.g.dart';

@freezed
@Collection(ignore: {'copyWith'})
class SyncInfo with _$SyncInfo {
  const factory SyncInfo({
    required int id,
    DateTime? lastPulledAt,
  }) = _SyncInfo;

  factory SyncInfo.fromJson(Map<String, dynamic> json) =>
      _$SyncInfoFromJson(json);
}
