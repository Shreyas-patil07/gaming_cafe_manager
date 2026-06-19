import 'package:flutter/material.dart';
import '../models/history_item.dart';

class HistoryCard extends StatelessWidget {
  final HistoryItem item;

  const HistoryCard({
    super.key,
    required this.item,
  });

  String getImagePath() {
    switch (item.deviceType) {
      case 'Gaming PC':
        return 'assets/images/devices/gaming_pc.png';

      case 'PlayStation 5':
        return 'assets/images/devices/ps5.png';

      case 'Xbox Series X':
        return 'assets/images/devices/xbox.png';

      case 'Racing Simulator':
        return 'assets/images/devices/racing_sim.png';

      case 'VR Station':
        return 'assets/images/devices/vr_station.png';

      default:
        return 'assets/images/devices/gaming_pc.png';
    }
  }

  String formatDuration() {
    final hours = item.durationMinutes ~/ 60;
    final minutes = item.durationMinutes % 60;

    return '$hours:${minutes.toString().padLeft(2, '0')} hr';
  }

  String formatDateTime(DateTime dateTime) {
    final day =
    dateTime.day.toString().padLeft(2, '0');

    final month =
    dateTime.month.toString().padLeft(2, '0');

    final year = dateTime.year;

    final hour =
    dateTime.hour.toString().padLeft(2, '0');

    final minute =
    dateTime.minute.toString().padLeft(2, '0');

    return '$day/$month/$year  $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          children: [
            Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Image.asset(
                  getImagePath(),
                  width: 64,
                  height: 64,
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      Text(
                        item.deviceName,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge,
                      ),

                      Text(
                        item.deviceType,
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color,
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.end,

                  children: [
                    Text(
                      formatDateTime(
                        item.startTime,
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.color,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      formatDateTime(
                        item.endTime,
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 18),

            Align(
              alignment:
              Alignment.centerLeft,
              child: Text(
                formatDuration(),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Divider(),

            Row(
              children: [
                Expanded(
                  child: Text(
                    '₹${item.amount.toInt()}',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                      fontSize: 28,
                    ),
                  ),
                ),

                const Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 18,
                    ),

                    SizedBox(width: 6),

                    Text(
                      'Completed',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}