import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/hydration_provider.dart';

class WeeklyChart extends StatelessWidget {
  final Map<DateTime, double> weeklyData;
  final double dailyGoalMl;
  final HydrationProvider provider;

  const WeeklyChart({
    super.key,
    required this.weeklyData,
    required this.dailyGoalMl,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    // Find max value to scale chart height
    double maxVal = dailyGoalMl;
    for (var val in weeklyData.values) {
      if (val > maxVal) maxVal = val;
    }
    if (maxVal == 0) maxVal = 2500;

    final sortedEntries = weeklyData.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                "Weekly Hydration",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF00F5D4).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "Goal: ${provider.formatVolume(dailyGoalMl)}",
                  style: const TextStyle(
                    color: Color(0xFF00F5D4),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 140,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: sortedEntries.map((entry) {
              final date = entry.key;
              final amountMl = entry.value;
              final isToday = DateTime.now().year == date.year &&
                  DateTime.now().month == date.month &&
                  DateTime.now().day == date.day;

              final ratio = (amountMl / maxVal).clamp(0.05, 1.0);
              final isGoalMet = amountMl >= dailyGoalMl;

              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        provider.formatVolume(amountMl).replaceAll(' ', ''),
                        style: TextStyle(
                          color: isToday ? const Color(0xFF00F5D4) : Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 20,
                      height: 85 * ratio,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: isGoalMet
                            ? const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF00F5D4),
                                  Color(0xFF00BBF9),
                                ],
                              )
                            : LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xFF3A506B).withValues(alpha: 0.8),
                                  const Color(0xFF1C2541).withValues(alpha: 0.8),
                                ],
                              ),
                        boxShadow: isGoalMet
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF00F5D4).withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : [],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      DateFormat('E').format(date).substring(0, 1),
                      style: TextStyle(
                        color: isToday ? const Color(0xFF00F5D4) : Colors.white54,
                        fontSize: 12,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
