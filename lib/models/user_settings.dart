import 'dart:convert';

class UserSettings {
  double dailyGoalMl;
  String unit; // 'ml' or 'oz'
  bool remindersEnabled;
  int reminderIntervalHours;
  String startTime;
  String endTime;
  int currentStreak;
  String lastLogDate; // YYYY-MM-DD

  UserSettings({
    this.dailyGoalMl = 2500.0,
    this.unit = 'ml',
    this.remindersEnabled = true,
    this.reminderIntervalHours = 2,
    this.startTime = "08:00",
    this.endTime = "22:00",
    this.currentStreak = 1,
    this.lastLogDate = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'dailyGoalMl': dailyGoalMl,
      'unit': unit,
      'remindersEnabled': remindersEnabled,
      'reminderIntervalHours': reminderIntervalHours,
      'startTime': startTime,
      'endTime': endTime,
      'currentStreak': currentStreak,
      'lastLogDate': lastLogDate,
    };
  }

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      dailyGoalMl: (map['dailyGoalMl'] as num?)?.toDouble() ?? 2500.0,
      unit: map['unit'] ?? 'ml',
      remindersEnabled: map['remindersEnabled'] ?? true,
      reminderIntervalHours: map['reminderIntervalHours'] ?? 2,
      startTime: map['startTime'] ?? "08:00",
      endTime: map['endTime'] ?? "22:00",
      currentStreak: map['currentStreak'] ?? 1,
      lastLogDate: map['lastLogDate'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory UserSettings.fromJson(String source) =>
      UserSettings.fromMap(json.decode(source));
}
