import 'dart:convert';

class WaterLog {
  final String id;
  final double amountMl;
  final DateTime timestamp;
  final String containerType; // 'glass', 'bottle', 'flask', 'jug', 'custom'

  WaterLog({
    required this.id,
    required this.amountMl,
    required this.timestamp,
    this.containerType = 'glass',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amountMl': amountMl,
      'timestamp': timestamp.toIso8601String(),
      'containerType': containerType,
    };
  }

  factory WaterLog.fromMap(Map<String, dynamic> map) {
    return WaterLog(
      id: map['id'] ?? '',
      amountMl: (map['amountMl'] as num).toDouble(),
      timestamp: DateTime.parse(map['timestamp']),
      containerType: map['containerType'] ?? 'glass',
    );
  }

  String toJson() => json.encode(toMap());

  factory WaterLog.fromJson(String source) =>
      WaterLog.fromMap(json.decode(source));
}
