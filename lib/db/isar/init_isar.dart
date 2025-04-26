import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'sync_info_schema.dart';

Future<Isar> initializeIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    schemas: [SyncInfoSchema],
    directory: dir.path,
  );
}
