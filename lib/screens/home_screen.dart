import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/hydration_provider.dart';
import '../widgets/wave_liquid_painter.dart';
import '../widgets/glass_card.dart';
import '../widgets/quick_add_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showCustomAddDialog(BuildContext context, HydrationProvider provider) {
    final TextEditingController controller = TextEditingController(text: '300');
    double selectedAmount = 300;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF151C33),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Log Custom Water Intake",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter amount",
                              hintStyle: const TextStyle(color: Colors.white38),
                              suffixText: provider.settings.unit,
                              suffixStyle: const TextStyle(
                                color: Color(0xFF00F5D4),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: const Color(0xFF00F5D4).withValues(alpha: 0.5),
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF00F5D4),
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (val) {
                              final parsed = double.tryParse(val);
                              if (parsed != null) {
                                setModalState(() {
                                  selectedAmount = parsed;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Preset Chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [150, 200, 350, 600, 800].map((preset) {
                        return ChoiceChip(
                          label: Text(
                            "+$preset ${provider.settings.unit}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          selected: selectedAmount == preset.toDouble(),
                          selectedColor: const Color(0xFF00F5D4).withValues(alpha: 0.3),
                          backgroundColor: const Color(0xFF1C2541),
                          onSelected: (selected) {
                            if (selected) {
                              setModalState(() {
                                selectedAmount = preset.toDouble();
                                controller.text = preset.toString();
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00F5D4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          final val = double.tryParse(controller.text) ?? selectedAmount;
                          if (val > 0) {
                            double ml = val;
                            if (provider.settings.unit == 'oz') {
                              ml = val / 0.033814;
                            }
                            provider.addWater(ml, containerType: 'custom');
                            Navigator.pop(ctx);
                          }
                        },
                        child: const Text(
                          "Add Water Intake",
                          style: TextStyle(
                            color: Color(0xFF0B132B),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HydrationProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF00F5D4)),
          );
        }

        final percentage = provider.todayProgress;
        final percentageInt = (percentage * 100).toInt();
        final todayLogs = provider.getTodayLogs();

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "HydroFlow",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat('EEEE, MMM d').format(DateTime.now()),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Streak Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9E00).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFFF9E00).withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          color: Color(0xFFFF9E00),
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "${provider.settings.currentStreak} Day Streak",
                          style: const TextStyle(
                            color: Color(0xFFFF9E00),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Animated Wave Liquid Container
              WaveLiquidWidget(
                percentage: percentage,
                height: 260,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "$percentageInt% Complete",
                          style: const TextStyle(
                            color: Color(0xFF00F5D4),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          provider.formatVolume(provider.todayIntakeMl),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Daily Target: ${provider.formatVolume(provider.settings.dailyGoalMl)}",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Quick Log Section Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Quick Add",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _showCustomAddDialog(context, provider),
                    icon: const Icon(Icons.add_rounded,
                        color: Color(0xFF00F5D4), size: 20),
                    label: const Text(
                      "Custom",
                      style: TextStyle(
                        color: Color(0xFF00F5D4),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Quick Add Buttons Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    QuickAddButton(
                      title: "Glass",
                      amountMl: 250,
                      icon: Icons.local_drink_rounded,
                      containerType: 'glass',
                      displayVolume: provider.formatVolume(250),
                      onTap: () => provider.addWater(250, containerType: 'glass'),
                    ),
                    const SizedBox(width: 12),
                    QuickAddButton(
                      title: "Bottle",
                      amountMl: 500,
                      icon: Icons.water_drop_rounded,
                      containerType: 'bottle',
                      displayVolume: provider.formatVolume(500),
                      onTap: () => provider.addWater(500, containerType: 'bottle'),
                    ),
                    const SizedBox(width: 12),
                    QuickAddButton(
                      title: "Flask",
                      amountMl: 750,
                      icon: Icons.local_drink_outlined,
                      containerType: 'flask',
                      displayVolume: provider.formatVolume(750),
                      onTap: () => provider.addWater(750, containerType: 'flask'),
                    ),
                    const SizedBox(width: 12),
                    QuickAddButton(
                      title: "Jug",
                      amountMl: 1000,
                      icon: Icons.fitness_center_rounded,
                      containerType: 'jug',
                      displayVolume: provider.formatVolume(1000),
                      onTap: () => provider.addWater(1000, containerType: 'jug'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Today's Logs Title
              const Text(
                "Today's History",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              if (todayLogs.isEmpty)
                const GlassCard(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: Colors.white54, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "No water logged yet today. Tap above!",
                          style: TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: todayLogs.length,
                  itemBuilder: (context, index) {
                    final log = todayLogs[index];
                    final timeStr = DateFormat('h:mm a').format(log.timestamp);

                    return Dismissible(
                      key: Key(log.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) {
                        provider.removeLog(log.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Intake entry deleted"),
                            backgroundColor: const Color(0xFF1C2541),
                            action: SnackBarAction(
                              label: "Undo",
                              textColor: const Color(0xFF00F5D4),
                              onPressed: () {
                                provider.addWater(log.amountMl,
                                    containerType: log.containerType);
                              },
                            ),
                          ),
                        );
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.delete_outline_rounded,
                            color: Colors.white),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: GlassCard(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF00F5D4).withValues(alpha: 0.15),
                                ),
                                child: const Icon(
                                  Icons.water_drop_rounded,
                                  color: Color(0xFF00F5D4),
                                  size: 20,
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      log.containerType.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white38,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                timeStr,
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
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
