import 'package:flutter/material.dart';
import '../models/device.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const DeviceCard({
    super.key,
    required this.device,
    required this.onEdit,
    required this.onDelete,
  });

  String getDeviceImage(String type) {
    switch (type) {
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
        return 'assets/images/logo0.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isBusy = device.isActive;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                    ),
                    child: ClipRRect(
                      child: Image.asset(
                        getDeviceImage(device.type),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          device.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge,
                        ),

                        const SizedBox(height: 4),

                        Text(
                          device.type,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          '₹${device.halfHourRate.toInt()} / 30 min',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          '₹${(device.halfHourRate * 2).toInt()} / hr',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isBusy
                                ? const Color(0x22EF4444)
                                : const Color(0x2222C55E),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 10,
                                color: isBusy
                                    ? const Color(0xFFEF4444)
                                    : const Color(0xFF22C55E),
                              ),

                              const SizedBox(width: 6),

                              Text(
                                isBusy ? 'BUSY' : 'READY',
                                style: TextStyle(
                                  color: isBusy
                                      ? const Color(0xFFEF4444)
                                      : const Color(0xFF22C55E),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0x44878787),
                    ),
                  ),
                  child: TextButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 18,
                    ),
                    label: const Text('Edit'),
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0x44EF4444),
                    ),
                  ),
                  child: TextButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Color(0xFFEF4444),
                    ),
                    label: const Text(
                      'Delete',
                      style: TextStyle(
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}