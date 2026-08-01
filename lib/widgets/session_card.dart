import 'dart:async';
import 'package:flutter/material.dart';
import '../models/session.dart';

class SessionCard extends StatefulWidget {
  final Session session;
  final VoidCallback onRename;
  final VoidCallback onExtend;
  final VoidCallback onEnd;
  final VoidCallback onCancel;
  final VoidCallback onExpired;


  const SessionCard({
    super.key,
    required this.session,
    required this.onRename,
    required this.onExtend,
    required this.onEnd,
    required this.onCancel,
    required this.onExpired,
  });

  @override
  State<SessionCard> createState() =>
      _SessionCardState();
}

class _SessionCardState
    extends State<SessionCard> {
  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) {
        if (mounted) {
          setState(() {});
        }

        if (widget.session.isPaused) {
          return;
        }

        final expired =
        widget.session.endTime.isBefore(
          DateTime.now(),
        );

        if (expired) {
          timer.cancel();
          widget.onExpired();
        }
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String _formatRemainingTime() {
    if (widget.session.isPaused &&
        widget.session.pausedAt != null) {
      final remaining =
      widget.session.endTime.difference(
        widget.session.pausedAt!,
      );

      final hours =
          remaining.inHours;

      final minutes =
          remaining.inMinutes % 60;

      final seconds =
          remaining.inSeconds % 60;

      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }

    final remaining =
    widget.session.endTime.difference(
      DateTime.now(),
    );

    if (remaining.isNegative) {
      return 'Expired';
    }

    final hours =
        remaining.inHours;

    final minutes =
        remaining.inMinutes % 60;

    final seconds =
        remaining.inSeconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final expired =
    widget.session.endTime.isBefore(
      DateTime.now(),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Flexible(
                            child: Text(
                              widget.session.guestName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                fontSize: 24,
                              ),
                            ),
                          ),

                          const SizedBox(width: 4),

                          InkWell(
                            onTap: widget.onRename,
                            borderRadius:
                            BorderRadius.circular(20),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.edit,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Text(
                        '${widget.session.deviceName} - ${widget.session.deviceType}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color,
                        ),
                      ),

                      if (widget.session.isPaused) ...[
                        const SizedBox(height: 2),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius:
                            BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.pause_circle,
                                color: Colors.red,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'PAUSED',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                Text(
                  _formatRemainingTime(),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: widget.session.isPaused
                        ? Colors.red
                        : expired
                        ? Colors.redAccent
                        : Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.color,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Text(
              '${widget.session.durationMinutes} Minutes (${widget.session.durationMinutes ~/ 60}:${(widget.session.durationMinutes % 60).toString().padLeft(2, '0')} hr)',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Text(
                    '₹${widget.session.amount.toInt()}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.color,
                    ),
                  ),
                ),

                TextButton.icon(
                  onPressed: widget.onCancel,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.redAccent,
                    size: 18,
                  ),
                  label: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                    widget.session.isPaused
                        ? null
                        : widget.onExtend,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Time'),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                    widget.session.isPaused
                        ? null
                        : widget.onEnd,
                    icon: const Icon(
                      Icons.stop_circle_outlined,
                    ),
                    label: const Text('End'),
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