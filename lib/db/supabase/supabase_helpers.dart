import 'package:custom_supabase_drift_sync/db/supabase/app_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHelpers {
  static bool isLoggedIn() {
    return Supabase.instance.client.auth.currentSession?.accessToken != null;
  }

  /// id of the user currently logged in
  static String? getUserId() {
    return Supabase.instance.client.auth.currentSession?.user.id;
  }

  static Future<Supabase> loadSupabase() async {
    return await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
  }
}
