import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get supabaseUrl {
    // For web builds, use the build-time values
    if (kIsWeb) {
      return const String.fromEnvironment('DEMO_SUPABASE_URL',
          defaultValue: 'https://your-default-url.supabase.co');
    }

    // For local/mobile, use dotenv
    return dotenv.env['SUPABASE_URL'] ?? 'https://your-default-url.supabase.co';
  }

  static String get supabaseAnonKey {
    if (kIsWeb) {
      return const String.fromEnvironment('DEMO_SUPABASE_ANON_KEY',
          defaultValue: 'your-default-key');
    }

    return dotenv.env['SUPABASE_ANON_KEY'] ?? 'your-default-key';
  }

  static String get supabaseStorageBucket {
    if (kIsWeb) {
      return const String.fromEnvironment('DEMO_SUPABASE_STORAGE_BUCKET',
          defaultValue: 'default-bucket');
    }

    return dotenv.env['SUPABASE_STORAGE_BUCKET'] ?? 'default-bucket';
  }
}
