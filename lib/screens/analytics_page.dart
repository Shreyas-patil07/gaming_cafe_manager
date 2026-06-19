import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../database/history_db.dart';
import '../models/history_item.dart';
import '../services/export_service.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() =>
      _AnalyticsPageState();
}

class DeviceRevenue {
  final String deviceName;
  final double revenue;
  final int sessions;
  final double totalHours;

  DeviceRevenue({
    required this.deviceName,
    required this.revenue,
    required this.sessions,
    required this.totalHours,
  });
}

class DeviceTypeRevenue {
  final String type;
  final double revenue;
  final int sessions;
  final double totalHours;

  DeviceTypeRevenue({
    required this.type,
    required this.revenue,
    required this.sessions,
    required this.totalHours,
  });
}

class _AnalyticsPageState
    extends State<AnalyticsPage> {

  final HistoryDB historyDB =
  HistoryDB();

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history =
    await historyDB.getHistory();

    if (!mounted) return;

    setState(() {
      AppData.history = history;
    });
  }

  String selectedPeriod = 'today';

  double getTotalRevenue() {
    return AppData.history.fold(
      0,
          (sum, item) => sum + item.amount,
    );
  }

  double getSelectedRevenue() {
    return getFilteredHistory().fold(
      0,
          (sum, item) => sum + item.amount,
    );
  }

  double getTodayRevenue() {
    final now = DateTime.now();

    return AppData.history
        .where(
          (item) =>
      item.endTime.day == now.day &&
          item.endTime.month == now.month &&
          item.endTime.year == now.year,
    )
        .fold(
      0,
          (sum, item) => sum + item.amount,
    );

  }

  double getMonthlyRevenue() {
    final now = DateTime.now();

    return AppData.history
        .where(
          (item) =>
      item.endTime.month == now.month &&
          item.endTime.year == now.year,
    )
        .fold(
      0.0,
          (sum, item) => sum + item.amount,
    );
  }

  int getTodaySessions() {
    final now = DateTime.now();

    return AppData.history.where(
          (item) =>
      item.endTime.day == now.day &&
          item.endTime.month == now.month &&
          item.endTime.year == now.year,
    ).length;
  }

  int getCompletedSessions() {
    return AppData.history.length;
  }

  double getYesterdayRevenue() {
    final yesterday = DateTime.now().subtract(
      const Duration(days: 1),
    );

    return AppData.history
        .where(
          (item) =>
      item.endTime.day == yesterday.day &&
          item.endTime.month == yesterday.month &&
          item.endTime.year == yesterday.year,
    )
        .fold(
      0,
          (sum, item) => sum + item.amount,
    );
  }

  double getRevenueChangePercent() {
    final today = getTodayRevenue();
    final yesterday = getYesterdayRevenue();

    if (yesterday == 0) {
      return 0;
    }

    return ((today - yesterday) / yesterday) * 100;
  }

  bool isRevenueUp() {
    return getTodayRevenue() >=
        getYesterdayRevenue();
  }

  String getMostUsedDevice() {
    if (AppData.history.isEmpty) {
      return 'N/A';
    }


    final Map<String, int> counts = {};

    for (final item in getFilteredHistory()) {
      counts[item.deviceName] =
          (counts[item.deviceName] ?? 0) + 1;
    }

    return counts.entries
        .reduce(
          (a, b) =>
      a.value > b.value ? a : b,
    )
        .key;
  }

  Widget _periodButton(
      String value,
      String label,
      ) {
    final selected =
        selectedPeriod == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPeriod = value;
        });
      },
      child: AnimatedContainer(
        duration:
        const Duration(
          milliseconds: 200,
        ),
        width: 75,
        alignment:
        Alignment.center,
        decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(
            20,
          ),
          color: selected
              ? const Color(
            0xFF8B5CF6,
          )
              : Colors.transparent,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? Colors.white
                : Theme.of(context)
                .textTheme
                .bodyMedium
                ?.color,
            fontWeight:
            FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  List<DeviceRevenue> getTopDevices() {
    final Map<String, DeviceRevenue> devices = {};

    for (final item in getFilteredHistory()) {

      final hours =
          item.endTime
              .difference(item.startTime)
              .inMinutes / 60;

      final name = item.deviceName;

      if (devices.containsKey(name)) {

        final existing = devices[name]!;

        devices[name] = DeviceRevenue(
          deviceName: name,
          revenue: existing.revenue + item.amount,
          sessions: existing.sessions + 1,
          totalHours: existing.totalHours + hours,
        );

      } else {

        devices[name] = DeviceRevenue(
          deviceName: name,
          revenue: item.amount,
          sessions: 1,
          totalHours: hours,
        );
      }
    }

    final result = devices.values.toList();

    result.sort(
          (a, b) => b.revenue.compareTo(a.revenue),
    );

    return result;
  }

  List<DeviceTypeRevenue> getDeviceTypeRevenue() {
    final Map<String, DeviceTypeRevenue> types = {};

    for (final item in getFilteredHistory()) {

      final durationHours =
          item.endTime
              .difference(item.startTime)
              .inMinutes /
              60;

      final type = item.deviceType;

      if (types.containsKey(type)) {

        final existing = types[type]!;

        types[type] = DeviceTypeRevenue(
          type: type,
          revenue: existing.revenue + item.amount,
          sessions: existing.sessions + 1,
          totalHours: existing.totalHours + durationHours,
        );

      } else {

        types[type] = DeviceTypeRevenue(
          type: type,
          revenue: item.amount,
          sessions: 1,
          totalHours: durationHours,
        );
      }
    }

    final result = types.values.toList();

    result.sort(
          (a, b) => b.revenue.compareTo(a.revenue),
    );

    return result;
  }

  List<HistoryItem> getFilteredHistory() {
    final now = DateTime.now();

    switch (selectedPeriod) {
      case 'week':
        return AppData.history.where((item) {
          return item.endTime.isAfter(
            now.subtract(const Duration(days: 7)),
          );
        }).toList();

      case 'month':
        return AppData.history.where((item) {
          return item.endTime.month == now.month &&
              item.endTime.year == now.year;
        }).toList();

      default:
        return AppData.history.where((item) {
          return item.endTime.day == now.day &&
              item.endTime.month == now.month &&
              item.endTime.year == now.year;
        }).toList();
    }
  }

  List<Widget> buildRevenueBars() {


    final devices =
    getDeviceTypeRevenue();

    if (devices.isEmpty) {
      return [
        const Text(
          'No revenue data',
        )
      ];
    }

    final maxRevenue =
        devices.first.revenue;

    return devices.map((device) {


      final displayPercent =
          device.revenue / maxRevenue;

      return _revenueBar(
        device.type,
        displayPercent,
        '₹${device.revenue.toInt()}',
      );

    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Row(
                children: [
                  Text(
                    'Revenue',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                      fontSize: 20,
                    ),
                  ),

                  const Spacer(),

                  Container(
                    height: 42,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _periodButton('today', 'Today'),
                        _periodButton('week', 'Week'),
                        _periodButton('month', 'Month'),
                      ],
                    ),
                  )

                ],
              ),

              const SizedBox(height: 10),

              _RevenueHeroCard(
                title: selectedPeriod == 'today' ? "Today's Revenue" : selectedPeriod == 'week' ? "Weekly Revenue" : "Monthly Revenue",
                totalRevenue: getSelectedRevenue(),
                monthlyRevenue: getMonthlyRevenue(),
                onExport: () => ExportService.showExportDialog(context),
                changePercent: getRevenueChangePercent(),
                isUp: isRevenueUp(),

              ),

              const SizedBox(height: 10),

              AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 300,
                ),
                transitionBuilder:
                    (child, animation) {

                  return FadeTransition(
                    opacity: animation,

                    child: SlideTransition(
                      position: Tween(
                        begin: const Offset(
                          0.05,
                          0,
                        ),
                        end: Offset.zero,
                      ).animate(animation),

                      child: child,
                    ),
                  );
                },
                child: Card(
                  key: ValueKey(selectedPeriod),

                  child: Padding(
                    padding: const EdgeInsets.all(18),

                    child: Column(
                      children: [

                        const SizedBox(height: 20),

                        ...buildRevenueBars(),

                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Top Devices',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge,
              ),

              SizedBox(height: 12),

              Row(
                children: const [

                  SizedBox(
                    width: 45,
                    child: Text(
                      'Rank',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 4,
                    child: Text(
                      'Device',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child: Text(
                      'Sessions',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child: Text(
                      'Hours',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 3,
                    child: Text(
                      'Revenue',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const Divider(),

              const SizedBox(height: 12),

              AnimatedSwitcher(
                duration: const Duration(
                  milliseconds: 300,
                ),
                transitionBuilder:
                    (child, animation) {

                  return FadeTransition(
                    opacity: animation,

                    child: SlideTransition(
                      position: Tween(
                        begin: const Offset(
                          0.05,
                          0,
                        ),
                        end: Offset.zero,
                      ).animate(animation),

                      child: child,
                    ),
                  );
                },
                child: Column(
                  key: ValueKey(selectedPeriod),
                    children: getTopDevices()
                        .take(20)
                        .toList()
                        .asMap()
                        .entries
                        .map((entry) {

                      final index = entry.key;
                      final device = entry.value;

                      final medals = [
                        '🥇',
                        '🥈',
                        '🥉',
                        ' 4',
                        ' 5',
                        ' 6',
                        ' 7',
                        ' 8',
                        ' 9',
                        ' 10',
                        ' 11',
                        ' 12',
                        ' 13',
                        ' 14',
                        ' 15',
                        ' 16',
                        ' 17',
                        ' 18',
                        ' 19',
                        ' 20'
                      ];


                      return Column(
                      children: [
                      _deviceRow(
                      medals[index],
                      device.deviceName,
                      device.sessions.toString(),
                      device.totalHours
                          .toStringAsFixed(1),
                      '₹${device.revenue.toInt()}',
                      ),
                      ],
                      );

                    }).toList(),

                ),
              ),
            ],
          ),
    );
  }
}

class _RevenueHeroCard extends StatelessWidget {
  final String title;
  final double totalRevenue;
  final double monthlyRevenue;
  final double changePercent;
  final VoidCallback onExport;
  final bool isUp;

  const _RevenueHeroCard({
    required this.title,
    required this.totalRevenue,
    required this.monthlyRevenue,
    required this.changePercent,
    required this.onExport,
    required this.isUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(32),

        gradient:
        const LinearGradient(
          colors: [
            Color(0xFF7C3AED),
            Color(0xFF4F46E5),
          ],
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color:
                  Colors.white,
                  fontSize: 20,
                ),
              ),

              const Spacer(),

              InkWell(
                onTap: () {
                  onExport();
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xD7438C00),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.download_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Export',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          Text(
            '₹${totalRevenue.toInt()}',
            style: TextStyle(
                color: Colors.white,
              fontSize: 42,
              fontWeight:
              FontWeight.w800,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Icon(
                isUp
                    ? Icons.trending_up
                    : Icons.trending_down,
                color: isUp
                    ? Colors.greenAccent
                    : Colors.redAccent,
              ),

              const SizedBox(width: 6),

              Text(
                '${changePercent.abs().toStringAsFixed(1)}% ${isUp ? "more" : "less"} than yesterday',
                style: TextStyle(
                  color: isUp
                      ? Colors.greenAccent
                      : Colors.redAccent,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _deviceRow(
    String rank,
    String name,
    String sessions,
    String hours,
    String revenue,
    ) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 8,
    ),
    child: Row(
      children: [

        SizedBox(
          width: 45,
          child: Text(rank),
        ),

        Expanded(
          flex: 4,
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        Expanded(
          flex: 2,
          child: Text(
            sessions,
            textAlign: TextAlign.center,
          ),
        ),

        Expanded(
          flex: 2,
          child: Text(
            hours,
            textAlign: TextAlign.center,
          ),
        ),

        Expanded(
          flex: 3,
          child: Text(
            revenue,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),
  );
}

Widget _revenueBar(
    String device,
    double percent,
    String revenue,
    ) {
  return Padding(
    padding:
    const EdgeInsets.only(
      bottom: 14,
    ),
    child: Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            device,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        Expanded(
          child: ClipRRect(
            borderRadius:
            BorderRadius.circular(
              20,
            ),
            child:
            Container(
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.15,),
                borderRadius: BorderRadius.circular(20),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percent,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            )
          ),
        ),

        const SizedBox(width: 12),

        SizedBox(
          width: 90,
          child: Text(
            revenue,
            textAlign:
            TextAlign.right,
          ),
        ),
      ],
    ),
  );
}