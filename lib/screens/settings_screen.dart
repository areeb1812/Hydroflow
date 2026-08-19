import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hydration_provider.dart';
import '../widgets/glass_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showResetConfirmDialog(BuildContext context, HydrationProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF151C33),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Reset All Data?",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          "This will delete all water logs, reset your streak, and restore default settings. This action cannot be undone.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              provider.clearAllData();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("All data reset successfully")),
              );
            },
            child: const Text("Reset Everything",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HydrationProvider>(
      builder: (context, provider, child) {
        final settings = provider.settings;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Preferences & Settings",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Customize your daily goal and reminder notifications",
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(height: 24),

              // Daily Goal Section
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Daily Water Goal",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            provider.formatVolume(settings.dailyGoalMl),
                            style: const TextStyle(
                              color: Color(0xFF00F5D4),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Slider(
                      value: settings.dailyGoalMl.clamp(1000.0, 5000.0),
                      min: 1000.0,
                      max: 5000.0,
                      divisions: 40,
                      activeColor: const Color(0xFF00F5D4),
                      inactiveColor: Colors.white12,
                      onChanged: (val) {
                        provider.updateDailyGoal(val);
                      },
                    ),
                    const SizedBox(height: 8),
                    // Presets using Wrap to prevent overflow on narrow screens
                    Center(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: [2000.0, 2500.0, 3000.0, 3500.0].map((goal) {
                          final isSelected = settings.dailyGoalMl == goal;
                          return ChoiceChip(
                            label: Text(
                              provider.formatVolume(goal).replaceAll(' ', ''),
                              style: TextStyle(
                                color: isSelected ? const Color(0xFF0B132B) : Colors.white,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: const Color(0xFF00F5D4),
                            backgroundColor: const Color(0xFF1C2541),
                            onSelected: (_) => provider.updateDailyGoal(goal),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Unit Selector Section
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Volume Unit",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Switch between Milliliters and Fluid Ounces",
                            style: TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF151C33),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (settings.unit != 'ml') provider.toggleUnit();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: settings.unit == 'ml'
                                    ? const Color(0xFF00F5D4)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "ML",
                                style: TextStyle(
                                  color: settings.unit == 'ml'
                                      ? const Color(0xFF0B132B)
                                      : Colors.white60,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (settings.unit != 'oz') provider.toggleUnit();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: settings.unit == 'oz'
                                    ? const Color(0xFF00F5D4)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "OZ",
                                style: TextStyle(
                                  color: settings.unit == 'oz'
                                      ? const Color(0xFF0B132B)
                                      : Colors.white60,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Hydration Reminders Card
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.notifications_active_rounded,
                                  color: Color(0xFF00BBF9), size: 22),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Hydration Reminders",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: settings.remindersEnabled,
                          activeThumbColor: const Color(0xFF00F5D4),
                          onChanged: (val) {
                            settings.remindersEnabled = val;
                            provider.updateSettings(settings);
                          },
                        ),
                      ],
                    ),
                    if (settings.remindersEnabled) ...[
                      const Divider(color: Colors.white12, height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Remind every",
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          DropdownButton<int>(
                            value: settings.reminderIntervalHours,
                            dropdownColor: const Color(0xFF151C33),
                            style: const TextStyle(
                              color: Color(0xFF00F5D4),
                              fontWeight: FontWeight.bold,
                            ),
                            underline: const SizedBox(),
                            items: [1, 2, 3, 4].map((hours) {
                              return DropdownMenuItem<int>(
                                value: hours,
                                child: Text("$hours Hour${hours > 1 ? 's' : ''}"),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                settings.reminderIntervalHours = val;
                                provider.updateSettings(settings);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Active Window",
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          Text(
                            "${settings.startTime} - ${settings.endTime}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Danger Zone: Reset Data
              GlassCard(
                padding: const EdgeInsets.all(16),
                borderColor: Colors.redAccent.withValues(alpha: 0.3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: Colors.redAccent, size: 22),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Reset All App Data",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _showResetConfirmDialog(context, provider),
                      child: const Text("Reset",
                          style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
