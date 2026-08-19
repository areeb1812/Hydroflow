import 'package:flutter/material.dart';
import '../models/water_log.dart';
import '../models/user_settings.dart';
import '../services/storage_service.dart';

class HydrationProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<WaterLog> _logs = [];
  UserSettings _settings = UserSettings();
  bool _isLoading = true;

  List<WaterLog> get logs => _logs;
  UserSettings get settings => _settings;
  bool get isLoading => _isLoading;

  HydrationProvider() {
    _init();
  }

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    _settings = await _storageService.loadSettings();
    _logs = await _storageService.loadLogs();

    _checkStreak();
    _isLoading = false;
    notifyListeners();
  }

  // Get logs for a specific date (default today)
  List<WaterLog> getTodayLogs() {
    final now = DateTime.now();
    return _logs.where((log) {
      return log.timestamp.year == now.year &&
          log.timestamp.month == now.month &&
          log.timestamp.day == now.day;
    }).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // Calculate today's total intake in ml
  double get todayIntakeMl {
    final todayLogs = getTodayLogs();
    return todayLogs.fold(0.0, (sum, item) => sum + item.amountMl);
  }

  // Progress double from 0.0 to 1.0 (or higher)
  double get todayProgress {
    if (_settings.dailyGoalMl <= 0) return 0.0;
    return (todayIntakeMl / _settings.dailyGoalMl).clamp(0.0, 1.5);
  }

  // Unit conversion helper
  double convertMl(double ml) {
    if (_settings.unit == 'oz') {
      return ml * 0.033814;
    }
    return ml;
  }

  String formatVolume(double ml) {
    if (_settings.unit == 'oz') {
      final oz = convertMl(ml);
      return '${oz.toStringAsFixed(1)} oz';
    }
    return '${ml.toInt()} ml';
  }

  // Add water intake
  Future<void> addWater(double amountMl, {String containerType = 'glass'}) async {
    final newLog = WaterLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amountMl: amountMl,
      timestamp: DateTime.now(),
      containerType: containerType,
    );

    _logs.add(newLog);
    await _storageService.saveLogs(_logs);
    await _checkStreak();

    notifyListeners();
  }

  // Remove log entry
  Future<void> removeLog(String id) async {
    _logs.removeWhere((log) => log.id == id);
    await _storageService.saveLogs(_logs);
    await _checkStreak();

    notifyListeners();
  }

  // Update Settings
  Future<void> updateSettings(UserSettings newSettings) async {
    _settings = newSettings;
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  // Update Daily Goal
  Future<void> updateDailyGoal(double goalMl) async {
    _settings.dailyGoalMl = goalMl;
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  // Toggle Units
  Future<void> toggleUnit() async {
    _settings.unit = _settings.unit == 'ml' ? 'oz' : 'ml';
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  // Streak logic check
  Future<void> _checkStreak() async {
    final todayStr = _formatDateKey(DateTime.now());
    final yesterdayStr = _formatDateKey(DateTime.now().subtract(const Duration(days: 1)));

    // Calculate yesterday intake
    final yesterdayLogs = _logs.where((log) => _formatDateKey(log.timestamp) == yesterdayStr);
    final yesterdayTotal = yesterdayLogs.fold(0.0, (sum, item) => sum + item.amountMl);

    // If today's goal is met
    if (todayIntakeMl >= _settings.dailyGoalMl) {
      if (_settings.lastLogDate != todayStr) {
        if (_settings.lastLogDate == yesterdayStr || yesterdayTotal >= _settings.dailyGoalMl) {
          _settings.currentStreak += 1;
        } else if (_settings.lastLogDate.isEmpty) {
          _settings.currentStreak = 1;
        }
        _settings.lastLogDate = todayStr;
        await _storageService.saveSettings(_settings);
      }
    }
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Weekly data map: Date -> total Ml
  Map<DateTime, double> getWeeklyData() {
    final Map<DateTime, double> map = {};
    final now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final dayLogs = _logs.where((log) {
        return log.timestamp.year == date.year &&
            log.timestamp.month == date.month &&
            log.timestamp.day == date.day;
      });
      final total = dayLogs.fold(0.0, (sum, item) => sum + item.amountMl);
      map[date] = total;
    }
    return map;
  }

  Future<void> clearAllData() async {
    _logs.clear();
    _settings = UserSettings();
    await _storageService.clearAll();
    notifyListeners();
  }
}
