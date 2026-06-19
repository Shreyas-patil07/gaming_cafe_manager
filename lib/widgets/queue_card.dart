import 'dart:async';

import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../models/queue_item.dart';

class QueueCard extends StatefulWidget {
  final QueueItem queue;

  final VoidCallback onStart;
  final VoidCallback onEdit;
  final VoidCallback onCancel;

  const QueueCard({
    super.key,
    required this.queue,
    required this.onStart,
    required this.onEdit,
    required this.onCancel,
  });

  @override
  State<QueueCard> createState() =>
      _QueueCardState();
}

class _QueueCardState
    extends State<QueueCard> {

  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(seconds: 30),
          (_) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String _waitingTime() {
    final diff =
    DateTime.now().difference(
      widget.queue.queuedAt,
    );

    final hours =
        diff.inHours;

    final minutes =
        diff.inMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }

    return '${minutes} min';
  }

  @override
  Widget build(BuildContext context) {

    final matchingDevices =
    AppData.devices.where(
          (d) =>
      d.id ==
          widget.queue.deviceId,
    );

    final device =
    matchingDevices.isNotEmpty
        ? matchingDevices.first
        : null;

    final canStart =
        device != null &&
            !AppData.sessions.any(
                  (session) =>
              session.deviceId ==
                  device.id,
            );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(
          18,
        ),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(
                        widget.queue.guestName,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                          fontSize: 24,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        '${widget.queue.deviceName} - ${widget.queue.deviceType}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),

                  decoration:
                  BoxDecoration(
                    color: Colors.orange
                        .withValues(
                      alpha: 0.15,
                    ),

                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
                  ),

                  child: const Text(
                    'QUEUED',
                    style:
                    TextStyle(
                      color:
                      Colors.orange,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 14,
            ),

            Text(
              '${widget.queue.durationMinutes} Minutes '
                  '(${widget.queue.durationMinutes ~/ 60}:'
                  '${(widget.queue.durationMinutes % 60).toString().padLeft(2, '0')} hr)',
            ),

            const SizedBox(
              height: 6,
            ),

            Text(
              'Waiting: ${_waitingTime()}',
              style: TextStyle(
                color: Theme.of(
                    context)
                    .textTheme
                    .bodyMedium
                    ?.color,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Row(
              children: [

                Expanded(
                  child: Text(
                    '₹${widget.queue.amount.toInt()}',
                    style:
                    TextStyle(
                      fontSize: 28,
                      fontWeight:
                      FontWeight.w700,
                      color: Theme.of(
                          context)
                          .textTheme
                          .titleLarge
                          ?.color,
                    ),
                  ),
                ),

                TextButton.icon(
                  onPressed:
                  widget.onCancel,

                  icon: const Icon(
                    Icons.close,
                    color:
                    Colors.redAccent,
                    size: 18,
                  ),

                  label: const Text(
                    'Cancel',
                    style: TextStyle(
                      color:
                      Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 14,
            ),

            Row(
              children: [

                Expanded(
                  child:
                  ElevatedButton.icon(
                    onPressed:
                    canStart
                        ? widget.onStart
                        : null,

                    icon: Icon(
                      canStart
                          ? Icons
                          .play_arrow
                          : Icons
                          .lock_clock,
                    ),

                    label: Text(
                      canStart
                          ? 'Start'
                          : 'Busy',
                    ),
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                Expanded(
                  child:
                  ElevatedButton.icon(
                    onPressed:
                    widget.onEdit,

                    icon: const Icon(
                      Icons.edit,
                    ),

                    label: const Text(
                      'Edit',
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