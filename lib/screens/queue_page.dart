import 'package:flutter/material.dart';
import '../database/device_db.dart';
import '../database/queue_db.dart';
import '../models/queue_item.dart';
import '../data/app_data.dart';
import '../widgets/queue_card.dart';
import '../database/session_db.dart';
import '../models/session.dart';
import '../services/pause_service.dart';
import '../services/guest_service.dart';
import '../utils/snackbar_helper.dart';

class QueuePage extends StatefulWidget {
  const QueuePage({super.key});

  @override
  State<QueuePage> createState() =>
      _QueuePageState();
}

class _QueuePageState
    extends State<QueuePage> {

  final SessionDB sessionDB =
  SessionDB();

  final QueueDB queueDB =
  QueueDB();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
      FloatingActionButton(
        onPressed:
        _showAddQueueDialog,
        child: const Icon(
          Icons.add,
        ),
      ),

      body:
      AppData.queue.isEmpty
          ? const Center(
        child: Text(
          'No Queue Items',
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(
          16,
        ),

        itemCount:
        AppData.queue.length,

        itemBuilder: (context,
            index,) {
          final queue =
          AppData.queue[index];

          return Padding(
            padding:
            const EdgeInsets.only(
              bottom: 12,
            ),

            child: QueueCard(
              queue: queue,

              onStart: () async {
                if (PauseService.isPaused.value) {
                  SnackbarHelper.error(
                    context,
                    'Cafe Paused',
                    'Resume sessions first',
                  );
                  return;
                }

                final device =
                AppData.devices.firstWhere(
                      (d) =>
                  d.id ==
                      queue.deviceId,
                );

                if (device.isActive) {
                  return;
                }

                final session = Session(
                  deviceId: queue.deviceId,

                  deviceName:
                  queue.deviceName,

                  deviceType:
                  queue.deviceType,

                  guestName:
                  queue.guestName,

                  startTime:
                  DateTime.now(),

                  endTime:
                  DateTime.now().add(
                    Duration(
                      minutes:
                      queue.durationMinutes,
                    ),
                  ),

                  durationMinutes:
                  queue.durationMinutes,

                  amount:
                  queue.amount,

                  isPaused: false,

                  pausedAt: null,

                  createdAt:
                  DateTime.now(),
                );

                await sessionDB.insertSession(
                  session,
                );

                await queueDB.deleteQueue(
                  queue.id!,
                );

                device.isActive = true;

                await DeviceDB().updateDevice(
                  device,
                );

                setState(() {
                  AppData.sessions.add(
                    session,
                  );

                  AppData.queue.remove(
                    queue,
                  );
                });

                SnackbarHelper.success(
                  context,
                  'Session Started',
                  '${queue.deviceName} session started',
                );
              },

              onEdit: () {
                _showEditDialog(
                  queue,
                );
              },

              onCancel: () async {
                final confirmed =
                await showDialog<bool>(
                  context: context,

                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        'Cancel Queue',
                      ),

                      content: SizedBox(
                        width: 450,
                        child: Text(
                          'Remove ${queue.deviceName} from queue?',
                        ),
                      ),

                      actions: [

                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                              false,
                            );
                          },

                          child: const Text(
                            'No',
                          ),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                              true,
                            );
                          },

                          child: const Text(
                            'Yes',
                          ),
                        ),
                      ],
                    );
                  },
                );

                if (confirmed != true) {
                  return;
                }

                await queueDB.deleteQueue(
                  queue.id!,
                );

                setState(() {
                  AppData.queue.remove(
                    queue,
                  );
                });
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _showEditDialog(
      QueueItem queue,
      ) async {

    int duration =
        queue.durationMinutes;

    final guestController =
    TextEditingController(
      text: queue.guestName,
    );

    final device =
    AppData.devices.firstWhere(
          (d) =>
      d.id ==
          queue.deviceId,
    );

    await showDialog(
      context: context,

      builder: (context) {
        return StatefulBuilder(
          builder: (
              context,
              setDialogState,
              ) {

            final amount =
                (duration ~/ 30) *
                    device.halfHourRate;

            return AlertDialog(
              title: const Text(
                'Edit Queue',
              ),

              content: SizedBox(
                width: 450,

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                  TextField(
                  controller: guestController,
                  maxLength: 20,
                  decoration: const InputDecoration(
                    labelText: 'Guest Name',
                    counterText: '',
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                DropdownButtonFormField<int>(
                  value: duration,

                  decoration:
                  const InputDecoration(
                    labelText: 'Duration',
                  ),

                  items: const [
                    DropdownMenuItem(
                      value: 30,
                      child: Text(
                        '30 Minutes (0:30 hr)',
                      ),
                    ),

                    DropdownMenuItem(
                      value: 60,
                      child: Text(
                        '60 Minutes (1:00 hr)',
                      ),
                    ),

                    DropdownMenuItem(
                      value: 90,
                      child: Text(
                        '90 Minutes (1:30 hr)',
                      ),
                    ),

                    DropdownMenuItem(
                      value: 120,
                      child: Text(
                        '120 Minutes (2:00 hr)',
                      ),
                    ),

                    DropdownMenuItem(
                      value: 180,
                      child: Text(
                        '180 Minutes (3:00 hr)',
                      ),
                    ),
                  ],

                  onChanged: (value) {
                    setDialogState(() {
                      duration =
                      value!;
                    });
                  },
                ),
                  ],
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

                    final guestName =
                    guestController.text.trim();

                    if (guestName.isEmpty) {
                      SnackbarHelper.error(
                        this.context,
                        'Invalid Name',
                        'Guest name cannot be empty',
                      );
                      return;
                    }

                    queue.guestName =
                        guestName;

                    queue.durationMinutes =
                        duration;

                    queue.amount =
                        amount;

                    await queueDB.updateQueue(
                      queue,
                    );

                    setState(() {});

                    if (context.mounted) {
                      Navigator.pop(
                        context,
                      );
                    }
                  },

                  child: Text(
                    'Save',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showAddQueueDialog() async {

    final busyDevices =
    AppData.devices.where(
          (device) {
        return AppData.sessions.any(
              (session) =>
          session.deviceId ==
              device.id,
        );
      },
    ).toList();

    if (busyDevices.isEmpty) {
      SnackbarHelper.error(
        context,
        'No Busy Devices',
        'Queue can only be added for occupied devices',
      );
      return;
    }

    final guestController =
    TextEditingController(
      text: await GuestService.getNextGuestName(),
    );

    var selectedDevice =
        busyDevices.first;

    int duration = 60;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (
              context,
              setDialogState,
              ) {

            final amount =
                (duration ~/ 30) *
                    selectedDevice.halfHourRate;

            return AlertDialog(
              title: const Text(
                'Add To Queue',
              ),

              content: SizedBox(
                width: 450,

                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,

                  children: [

                    TextField(
                      controller: guestController,
                      maxLength: 20,
                      decoration: const InputDecoration(
                        labelText: 'Guest Name',
                        counterText: '',
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    DropdownButtonFormField(
                      value:
                      selectedDevice,

                      decoration:
                      const InputDecoration(
                        labelText:
                        'Device',
                      ),

                      items:
                      busyDevices.map(
                            (device) {
                          return DropdownMenuItem(
                            value: device,
                            child: Text(
                              device.name,
                            ),
                          );
                        },
                      ).toList(),

                      onChanged: (value) {
                        setDialogState(() {
                          selectedDevice =
                          value!;
                        });
                      },
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    DropdownButtonFormField<int>(
                      value: duration,

                      decoration:
                      const InputDecoration(
                        labelText:
                        'Duration',
                      ),

                      items: const [

                        DropdownMenuItem(
                          value: 30,
                          child: Text(
                            '30 Minutes (0:30 hr)',
                          ),
                        ),

                        DropdownMenuItem(
                          value: 60,
                          child: Text(
                            '60 Minutes (1:00 hr)',
                          ),
                        ),

                        DropdownMenuItem(
                          value: 90,
                          child: Text(
                            '90 Minutes (1:30 hr)',
                          ),
                        ),

                        DropdownMenuItem(
                          value: 120,
                          child: Text(
                            '120 Minutes (2:00 hr)',
                          ),
                        ),

                        DropdownMenuItem(
                          value: 180,
                          child: Text(
                            '180 Minutes (3:00 hr)',
                          ),
                        ),
                      ],

                      onChanged: (value) {
                        setDialogState(() {
                          duration =
                          value!;
                        });
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Text(
                      'Amount: ₹${amount.toInt()}',
                      style:
                      const TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              actions: [

                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  child:
                  const Text(
                    'Cancel',
                  ),
                ),

                ElevatedButton(
                  onPressed: () async {

                    final guestName =
                    guestController.text.trim();

                    if (guestName.isEmpty) {
                      SnackbarHelper.error(
                        this.context,
                        'Invalid Name',
                        'Guest name cannot be empty',
                      );
                      return;
                    }

                    if (guestName.length > 20) {
                      SnackbarHelper.error(
                        this.context,
                        'Invalid Name',
                        'Maximum 20 characters allowed',
                      );
                      return;
                    }

                    await GuestService.consumeGuestNumber();

                    final queue = QueueItem(
                      deviceId:
                      selectedDevice.id!,

                      deviceName:
                      selectedDevice.name,

                      deviceType:
                      selectedDevice.type,

                      guestName:
                      guestName,

                      durationMinutes:
                      duration,

                      amount:
                      amount,

                      queuedAt:
                      DateTime.now(),
                    );

                    await queueDB.insertQueue(
                      queue,
                    );

                    setState(() {
                      AppData.queue.add(
                        queue,
                      );
                    });

                    if (context.mounted) {
                      Navigator.pop(
                        context,
                      );
                    }

                    SnackbarHelper.success(
                      this.context,
                      'Queue Added',
                      '${queue.guestName} added to queue',
                    );
                  },
                  child:
                  const Text(
                    'Add',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

}