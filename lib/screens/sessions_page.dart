import 'package:flutter/material.dart';
import '../database/device_db.dart';
import '../services/guest_service.dart';
import '../services/pause_service.dart';
import '../utils/snackbar_helper.dart';
import '../widgets/session_card.dart';
import '../models/history_item.dart';
import '../database/history_db.dart';
import '../database/session_db.dart';
import '../models/session.dart';
import '../data/app_data.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});
  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  List<Session> get sessions =>
      AppData.sessions;
  final SessionDB sessionDB = SessionDB();
  final HistoryDB historyDB = HistoryDB();

  Future<void> _autoEndSession(
      Session session,
      ) async {
    final device =
    AppData.devices.firstWhere(
          (d) =>
      d.id ==
          session.deviceId,
    );

    final historyItem =
    HistoryItem(
      deviceId: session.deviceId,
      deviceName:
      session.deviceName,
      deviceType:
      session.deviceType,
      startTime:
      session.startTime,
      endTime:
      session.endTime,
      durationMinutes:
      session.durationMinutes,
      amount:
      session.amount,
    );

    await historyDB.insertHistory(
      historyItem,
    );

    await sessionDB.deleteSession(
      session.deviceId,
    );

    setState(() {
      device.isActive = false;

      AppData.history.insert(
        0,
        historyItem,
      );

      AppData.sessions.remove(session);
    });

    await DeviceDB().updateDevice(
      device,
    );

    await PauseService.loadPauseState();

    SnackbarHelper.success(
      context,
      'Session Completed',
      '${session.deviceName} session completed',
    );
  }

  String formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    return '$minutes Minutes (${hours}:${mins.toString().padLeft(2, '0')} hr)';
  }

  String? selectedDevice;
  int selectedDuration = 60;

  @override
  Widget build(BuildContext context) {
    if (AppData.devices.isEmpty) {
      selectedDevice = null;
    }

    final availableDevices = AppData.devices
        .where(
          (device) => !sessions.any(
            (session) => session.deviceId == device.id,
      ),
    )
        .toList();

    if (selectedDevice != null &&
        !availableDevices.any(
              (d) => d.name == selectedDevice,
        )) {
      selectedDevice = availableDevices.isNotEmpty
          ? availableDevices.first.name
          : null;
    }

    return ListView(
      padding: const EdgeInsets.all(16),

      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  'Start New Session',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge,
                ),

                const SizedBox(height: 20),

                if (AppData.devices.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color:
                      const Color(0x22EF4444),
                      borderRadius:
                      BorderRadius.circular(12),
                    ),

                    child: const Text(
                      'No devices available. Add a device first.',
                    ),
                  ),

                if (AppData.devices.isNotEmpty)
                  DropdownButtonFormField<String>(
                    value: AppData.devices.any(
                          (d) =>
                      d.name ==
                          selectedDevice,
                    )
                        ? selectedDevice
                        : null,

                    decoration:
                    const InputDecoration(
                      labelText: 'Device',
                    ),

                    items: availableDevices.map(
                          (device) {
                        return DropdownMenuItem<
                            String>(
                          value: device.name,
                          child:
                          Text(device.name),
                        );
                      },
                    ).toList(),

                    onChanged: (value) {
                      setState(() {
                        selectedDevice = value;
                      });
                    },
                  ),

                const SizedBox(height: 16),

                DropdownButtonFormField<int>(
                  value: selectedDuration,

                  decoration:
                  const InputDecoration(
                    labelText: 'Duration',
                  ),

                  items: const [
                    DropdownMenuItem(
                      value: 30,child: Text('30 Minutes (0:30 hr)'),
                    ),
                    DropdownMenuItem(
                      value: 60,child: Text('60 Minutes (1:00 hr)'),
                    ),
                    DropdownMenuItem(
                      value: 90,child: Text('90 Minutes (1:30 hr)'),
                    ),
                    DropdownMenuItem(
                      value: 120,child: Text('120 Minutes (2:00 hr)'),
                    ),
                    DropdownMenuItem(
                      value: 180,child: Text('180 Minutes (3:00 hr)'),
                    ),
                  ],

                  onChanged: (value) {
                    setState(() {
                      selectedDuration = value!;
                    });
                  },
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed:
                    availableDevices.isEmpty
                        ? null
                        : _startSession,

                    child: const Text(
                      'Start Session',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        Text(
          'Active Sessions',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(
            fontSize: 28,
          ),
        ),

        const SizedBox(height: 12),

        if (sessions.isEmpty)
           Padding(
            padding: EdgeInsets.only(
              top: 20,
            ),
            child: Text(
            'No Active Sessions',
            style: TextStyle(
            color: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.color,
            ),
            ),

            ),


        ValueListenableBuilder(
          valueListenable: PauseService.isPaused,
          builder: (_, __, ___) {
            return Column(
              children: sessions.map(
                    (session) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: SessionCard(
                    session: session,

                    onRename: () {
                      _showRenameDialog(
                        session,
                      );
                    },

                    onExtend: () {
                      _showExtendDialog(
                        session,
                      );
                    },

                    onEnd: () {
                      _showEndSessionDialog(
                        session,
                      );
                    },

                    onCancel: () {
                      _showCancelSessionDialog(
                        session,
                      );
                    },

                    onExpired: () {
                      _autoEndSession(
                        session,
                      );
                    },
                  ),
                ),
              ).toList(),
            );
          },
        ),
      ],
    );
  }

  Future<void> _startSession() async {
    if (PauseService.isPaused.value) {
      SnackbarHelper.error(
        context,
        'Cafe Paused',
        'Resume sessions first',
      );
      return;
    }

    if (selectedDevice == null) return;

    final device =
    AppData.devices.firstWhere(
          (d) => d.name == selectedDevice,
    );

    final alreadyRunning = sessions.any(
          (session) =>
      session.deviceId ==
          device.id,
    );

    if (alreadyRunning) {
      SnackbarHelper.error(
        context,
        'Error',
        '$selectedDevice already has an active session',
      );
      return;
    }

    final amount =
        (selectedDuration ~/ 30) *
            device.halfHourRate;

    final guestName =
      await GuestService.getNextGuestName();

    await GuestService.consumeGuestNumber();

    final session = Session(
      deviceId: device.id!,
      deviceName: selectedDevice!,
      deviceType: device.type,
      guestName: guestName,

      startTime: DateTime.now(),

      endTime: DateTime.now().add(
        Duration(
          minutes: selectedDuration,
        ),
      ),

      durationMinutes: selectedDuration,
      amount: amount,

      isPaused: false,
      pausedAt: null,

      createdAt: DateTime.now(),
    );

    await sessionDB.insertSession(
      session,
    );

    setState(() {
      device.isActive = true;
      AppData.sessions.add(session);
    });

    SnackbarHelper.success(
      context,
      'Session Started',
      '$selectedDevice session started',
    );
  }

  void _showCancelSessionDialog(
      Session session,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Cancel Session',
          ),

          content: SizedBox(
            width: 450,
            child: Text(
              'Cancel session for ${session.deviceName}?',
            ),
          ),

          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),

            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _cancelSession(session);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showExtendDialog(
      Session session,
      ) {
    int extraMinutes = 30;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (
              context,
              setDialogState,
              ) {
            return AlertDialog(
              title:
              const Text('Add Time'),

              content: SizedBox(
                width: 450,
                child: DropdownButtonFormField<int>(
                value: extraMinutes,

                decoration:
                const InputDecoration(
                  labelText:
                  'Additional Time',
                ),

                items: const [
                  DropdownMenuItem(
                    value: 30,
                    child: Text('30 Minutes (0:30 hr)'),
                  ),
                  DropdownMenuItem(
                    value: 60,
                    child: Text('60 Minutes (1:00 hr)'),
                  ),
                  DropdownMenuItem(
                    value: 90,
                    child: Text('90 Minutes (1:30 hr)'),
                  ),
                  DropdownMenuItem(
                    value: 120,
                    child: Text('120 Minutes (2:00 hr)'),
                  ),
                  DropdownMenuItem(
                    value: 180,
                    child: Text('180 Minutes (3:00 hr)'),
                  ),
                ],

                onChanged: (value) {
                  setDialogState(() {
                    extraMinutes =
                    value!;
                  });
                },
              ),
            ),

              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.pop(
                        context);
                  },
                  child:
                  const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    await _extendSession(
                      session,
                      extraMinutes,
                    );

                    Navigator.pop(
                        context);
                  },
                  child:
                  const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _extendSession(
      Session session,
      int extraMinutes,
      ) async {
    final device =
    AppData.devices.firstWhere(
          (d) =>
      d.id ==
          session.deviceId,
    );

    setState(() {
      session.durationMinutes +=
          extraMinutes;

      session.endTime =
          session.endTime.add(
            Duration(
              minutes: extraMinutes,
            ),
          );

      session.amount +=
          (extraMinutes ~/ 30) *
              device.halfHourRate;
    });

    await sessionDB.updateSession(
      session,
    );

    SnackbarHelper.success(
      context,
      'Session Extended',
      '${session.deviceName} extended by $extraMinutes minutes',
    );
  }

  void _showEndSessionDialog(
      Session session,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
          const Text('End Session'),

            content: SizedBox(
              width: 450,
              child: Column(
            mainAxisSize:
            MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Text(
                session.deviceName,
                style: const TextStyle(
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                  height: 12),

              Text(
                  'Duration: ${session.durationMinutes} Minutes (${session.durationMinutes ~/ 60}:${(session.durationMinutes % 60).toString().padLeft(2, '0')} hr)',
              ),

              const SizedBox(height: 8),

              Text(
                'Final Bill: ₹${session.amount.toInt()}',
              ),
            ],
              ),
            ),

          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(
                    context);
              },
              child:
              const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {
                Navigator.pop(
                    context);

                await _endSession(session);
              },
              child: const Text(
                'End Session',
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showRenameDialog(
      Session session,
      ) async {

    final controller =
    TextEditingController(
      text: session.guestName,
    );

    await showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(
          title: const Text(
            'Rename Guest',
          ),

          content: SizedBox(
            width: 450,
            child: TextField(
              controller: controller,
              maxLength: 20,
              decoration: const InputDecoration(
                labelText: 'Guest Name',
                counterText: '',
              ),
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),

            ElevatedButton(
              onPressed: () async {

                final name =
                controller.text.trim();

                if (name.isEmpty) {
                  return;
                }

                if (name.isEmpty) {
                  SnackbarHelper.error(
                    context,
                    'Invalid Name',
                    'Guest name cannot be empty',
                  );
                  return;
                }

                if (name.length > 20) {
                  SnackbarHelper.error(
                    context,
                    'Invalid Name',
                    'Maximum 20 characters allowed',
                  );
                  return;
                }

                session.guestName =
                    name;

                await sessionDB
                    .updateSession(
                  session,
                );

                setState(() {});

                if (context.mounted) {
                  Navigator.pop(
                    context,
                  );
                }
              },
              child: const Text(
                'Save',
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _endSession(
      Session session,
      ) async {
    final device =
    AppData.devices.firstWhere(
          (d) =>
      d.id ==
          session.deviceId,
    );

    final historyItem =
    HistoryItem(
      deviceId: session.deviceId,
      deviceName:
      session.deviceName,
      deviceType:
      session.deviceType,
      startTime:
      session.startTime,
      endTime:
      session.endTime,
      durationMinutes:
      session.durationMinutes,
      amount:
      session.amount,
    );

    await historyDB.insertHistory(
      historyItem,
    );

    await sessionDB.deleteSession(
      session.deviceId,
    );

    setState(() {
      device.isActive = false;

      AppData.history.insert(
        0,
        historyItem,
      );

      AppData.sessions.remove(session);
    });

    await DeviceDB().updateDevice(
      device,
    );

    await PauseService.loadPauseState();

    SnackbarHelper.success(
      context,
      'Session Ended',
      '${session.deviceName} session ended',
    );
  }

  Future<void> _cancelSession(
      Session session,
      ) async {
    final device =
    AppData.devices.firstWhere(
          (d) =>
      d.id ==
          session.deviceId,
    );

    await sessionDB.deleteSession(
      session.deviceId,
    );

    setState(() {
      device.isActive = false;
      AppData.sessions.remove(session);
    });

    await DeviceDB().updateDevice(
      device,
    );

    await PauseService.loadPauseState();

    SnackbarHelper.success(
      context,
      'Session Cancelled',
      '${session.deviceName} session cancelled',
    );
  }
}