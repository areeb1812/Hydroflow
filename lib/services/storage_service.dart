import 'package:shared_preferences/shared_preferences.dart';
import '../models/water_log.dart';
import '../models/user_settings.dart';

class StorageService {
  static const String _keyLogs = 'hydroflow_water_logs';
  static const String _keySettings = 'hydroflow_user_settings';

  Future<void> saveLogs(List<WaterLog> logs) async {
    final prefs = await SharedPreferences.getInstance();
    final listString = logs.map((log) => log.toJson()).toList();
    await prefs.setStringList(_keyLogs, listString);
  }

  Future<List<WaterLog>> loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? listString = prefs.getStringList(_keyLogs);
    if (listString == null) return [];
    return listString.map((item) => WaterLog.fromJson(item)).toList();
  }

  Future<void> saveSettings(UserSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySettings, settings.toJson());
  }

  Future<UserSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? settingsJson = prefs.getString(_keySettings);
    if (settingsJson == null) return UserSettings();
    try {
      return UserSettings.fromJson(settingsJson);
    } catch (_) {
      return UserSettings();
    }
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLogs);
    await prefs.remove(_keySettings);
  }
}
