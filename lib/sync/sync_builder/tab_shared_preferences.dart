import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// TabSeparateSharedPreferences
/// Is a class that on native platforms uses SharedPreferences to store data
/// But on the web it creates a wrapper that makes sure that each app instance has a unique storage space
/// So on the native it looks like this:
/// key: value
/// On the web it looks like this:
/// sessionId_key:  {
///  key: value,
/// ...
/// }

class TabSeparateSharedPreferences {
  static TabSeparateSharedPreferences? _instance;
  final SharedPreferences prefs;
  final String _sessionId;

  // Private constructor
  TabSeparateSharedPreferences._(this.prefs, this._sessionId);

  /// Factory method to get singleton instance
  static TabSeparateSharedPreferences getInstance(SharedPreferences prefs) {
    String sessionId;

    if (kIsWeb) {
      // On web, always generate a new session ID for each app instance
      // This ensures each browser tab/window gets a unique storage space
      sessionId = const Uuid().v4();
    } else {
      // On native platforms, use an empty string as session ID (no namespacing)
      sessionId = '';
    }

    // Always create a new instance to ensure fresh session ID
    _instance = TabSeparateSharedPreferences._(prefs, sessionId);
    return _instance!;
  }

  /// Gets the effective key based on platform
  String _getEffectiveKey(String key) {
    if (!kIsWeb || _sessionId.isEmpty) return key;
    return '${_sessionId}_$key';
  }

  /// Get a string value
  String? getString(String key) {
    if (!kIsWeb) {
      return prefs.getString(key);
    }

    final effectiveKey = _getEffectiveKey('data');
    final webDataStr = prefs.getString(effectiveKey);
    if (webDataStr == null) return null;

    try {
      final webData = jsonDecode(webDataStr) as Map<String, dynamic>;
      return webData[key] as String?;
    } catch (e) {
      return null;
    }
  }

  /// Set a string value
  Future<bool> setString(String key, String value) async {
    if (!kIsWeb) {
      return prefs.setString(key, value);
    }

    final effectiveKey = _getEffectiveKey('data');
    final webDataStr = prefs.getString(effectiveKey);
    Map<String, dynamic> webData = {};

    if (webDataStr != null) {
      try {
        webData = jsonDecode(webDataStr) as Map<String, dynamic>;
      } catch (e) {
        // If parsing fails, start with an empty map
      }
    }

    webData[key] = value;
    return prefs.setString(effectiveKey, jsonEncode(webData));
  }

  /// Get an int value
  int? getInt(String key) {
    if (!kIsWeb) {
      return prefs.getInt(key);
    }

    final effectiveKey = _getEffectiveKey('data');
    final webDataStr = prefs.getString(effectiveKey);
    if (webDataStr == null) return null;

    try {
      final webData = jsonDecode(webDataStr) as Map<String, dynamic>;
      return webData[key] as int?;
    } catch (e) {
      return null;
    }
  }

  /// Set an int value
  Future<bool> setInt(String key, int value) async {
    if (!kIsWeb) {
      return prefs.setInt(key, value);
    }

    final effectiveKey = _getEffectiveKey('data');
    final webDataStr = prefs.getString(effectiveKey);
    Map<String, dynamic> webData = {};

    if (webDataStr != null) {
      try {
        webData = jsonDecode(webDataStr) as Map<String, dynamic>;
      } catch (e) {
        // If parsing fails, start with an empty map
      }
    }

    webData[key] = value;
    return prefs.setString(effectiveKey, jsonEncode(webData));
  }

  /// Get a double value
  double? getDouble(String key) {
    if (!kIsWeb) {
      return prefs.getDouble(key);
    }

    final effectiveKey = _getEffectiveKey('data');
    final webDataStr = prefs.getString(effectiveKey);
    if (webDataStr == null) return null;

    try {
      final webData = jsonDecode(webDataStr) as Map<String, dynamic>;
      return webData[key] as double?;
    } catch (e) {
      return null;
    }
  }

  /// Set a double value
  Future<bool> setDouble(String key, double value) async {
    if (!kIsWeb) {
      return prefs.setDouble(key, value);
    }

    final effectiveKey = _getEffectiveKey('data');
    final webDataStr = prefs.getString(effectiveKey);
    Map<String, dynamic> webData = {};

    if (webDataStr != null) {
      try {
        webData = jsonDecode(webDataStr) as Map<String, dynamic>;
      } catch (e) {
        // If parsing fails, start with an empty map
      }
    }

    webData[key] = value;
    return prefs.setString(effectiveKey, jsonEncode(webData));
  }

  /// Get a bool value
  bool? getBool(String key) {
    if (!kIsWeb) {
      return prefs.getBool(key);
    }

    final effectiveKey = _getEffectiveKey('data');
    final webDataStr = prefs.getString(effectiveKey);
    if (webDataStr == null) return null;

    try {
      final webData = jsonDecode(webDataStr) as Map<String, dynamic>;
      return webData[key] as bool?;
    } catch (e) {
      return null;
    }
  }

  /// Set a bool value
  Future<bool> setBool(String key, bool value) async {
    if (!kIsWeb) {
      return prefs.setBool(key, value);
    }

    final effectiveKey = _getEffectiveKey('data');
    final webDataStr = prefs.getString(effectiveKey);
    Map<String, dynamic> webData = {};

    if (webDataStr != null) {
      try {
        webData = jsonDecode(webDataStr) as Map<String, dynamic>;
      } catch (e) {
        // If parsing fails, start with an empty map
      }
    }

    webData[key] = value;
    return prefs.setString(effectiveKey, jsonEncode(webData));
  }

  /// Get a list of strings
  List<String>? getStringList(String key) {
    if (!kIsWeb) {
      return prefs.getStringList(key);
    }

    final effectiveKey = _getEffectiveKey('data');
    final webDataStr = prefs.getString(effectiveKey);
    if (webDataStr == null) return null;

    try {
      final webData = jsonDecode(webDataStr) as Map<String, dynamic>;
      final value = webData[key];
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Set a list of strings
  Future<bool> setStringList(String key, List<String> value) async {
    if (!kIsWeb) {
      return prefs.setStringList(key, value);
    }

    final effectiveKey = _getEffectiveKey('data');
    final webDataStr = prefs.getString(effectiveKey);
    Map<String, dynamic> webData = {};

    if (webDataStr != null) {
      try {
        webData = jsonDecode(webDataStr) as Map<String, dynamic>;
      } catch (e) {
        // If parsing fails, start with an empty map
      }
    }

    webData[key] = value;
    return prefs.setString(effectiveKey, jsonEncode(webData));
  }

  /// Check if a key exists
  bool containsKey(String key) {
    if (!kIsWeb) {
      return prefs.containsKey(key);
    }

    final effectiveKey = _getEffectiveKey('data');
    final webDataStr = prefs.getString(effectiveKey);
    if (webDataStr == null) return false;

    try {
      final webData = jsonDecode(webDataStr) as Map<String, dynamic>;
      return webData.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  /// Remove a key
  Future<bool> remove(String key) async {
    if (!kIsWeb) {
      return prefs.remove(key);
    }

    final effectiveKey = _getEffectiveKey('data');
    final webDataStr = prefs.getString(effectiveKey);
    if (webDataStr == null) return true;

    try {
      final webData = jsonDecode(webDataStr) as Map<String, dynamic>;
      webData.remove(key);
      return prefs.setString(effectiveKey, jsonEncode(webData));
    } catch (e) {
      return false;
    }
  }

  /// Clear all values
  Future<bool> clear() async {
    if (!kIsWeb) {
      return prefs.clear();
    }

    final effectiveKey = _getEffectiveKey('data');
    return prefs.remove(effectiveKey);
  }

  /// Get all keys (web implementation is approximate)
  Set<String> getKeys() {
    if (!kIsWeb) {
      return prefs.getKeys();
    }

    final effectiveKey = _getEffectiveKey('data');
    final webDataStr = prefs.getString(effectiveKey);
    if (webDataStr == null) return {};

    try {
      final webData = jsonDecode(webDataStr) as Map<String, dynamic>;
      return webData.keys.toSet();
    } catch (e) {
      return {};
    }
  }
}
