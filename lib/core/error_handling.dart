import 'package:talker_flutter/talker_flutter.dart';

class E {
  static Talker t = TalkerFlutter.init(
    settings: TalkerSettings(
      /// Length of history that saving logs data
      maxHistoryItems: 2000,
    ),
  );
}
