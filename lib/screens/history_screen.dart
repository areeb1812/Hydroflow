import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/hydration_provider.dart';
import '../widgets/weekly_chart.dart';
import '../widgets/glass_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HydrationProvider>(
      builder: (context, provider, child) {
        final weeklyData = provider.getWeeklyData();
        final totalWeeklyMl = weeklyData.values.fold(0.0, (a, b) => a + b);
        final avgDailyMl = totalWeeklyMl / 7;
        final dailyGoal = provider.settings.dailyGoalMl;

        // Calculate goal achievement days count
        int goalMetDays =
            weeklyData.values.where((val) => val >= dailyGoal).length;

        // Group all logs by date
        final sortedLogs = provider.logs
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Analytics & History",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Track your hydration trend over time",
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(height: 20),

              // Weekly Chart Card
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: WeeklyChart(
                  weeklyData: weeklyData,
                  dailyGoalMl: dailyGoal,
                  provider: provider,
                ),
              ),
              const SizedBox(height: 20),

              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.show_chart_rounded,
                              color: Color(0xFF00F5D4), size: 22),
                          const SizedBox(height: 8),
                          const Text(
                            "Daily Avg",
                            style: TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                          const SizedBox(height: 2),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              provider.formatVolume(avgDailyMl),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.emoji_events_rounded,
                              color: Color(0xFFFF9E00), size: 22),
                          const SizedBox(height: 8),
                          const Text(
                            "Goals Hit",
                            style: TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                          const SizedBox(height: 2),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "$goalMetDays / 7 Days",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // History Logs List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "All Logged Entries",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${sortedLogs.length} total",
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (sortedLogs.isEmpty)
                const GlassCard(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      "No historical logs recorded yet.",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sortedLogs.length,
                  itemBuilder: (context, index) {
                    final log = sortedLogs[index];
                    final dateStr =
                        DateFormat('MMM d, yyyy • h:mm a').format(log.timestamp);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    const Color(0xFF00BBF9).withValues(alpha: 0.15),
                              ),
                              child: const Icon(
                                Icons.water_drop_outlined,
                                color: Color(0xFF00BBF9),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      provider.formatVolume(log.amountMl),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    dateStr,
                                    style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 11,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded,
                                  color: Colors.white30, size: 18),
                              onPressed: () => provider.removeLog(log.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
