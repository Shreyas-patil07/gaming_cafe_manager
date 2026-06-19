import 'package:flutter/material.dart';
import '../utils/snackbar_helper.dart';
import '../widgets/device_card.dart';
import '../database/session_db.dart';
import '../database/history_db.dart';
import '../database/device_db.dart';
import '../data/app_data.dart';
import '../models/device.dart';
class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {

  final DeviceDB deviceDB = DeviceDB();
  final SessionDB sessionDB = SessionDB();
  final HistoryDB historyDB = HistoryDB();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDeviceDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Device'),
      ),

      body: AppData.devices.isEmpty
          ? Center(
        child: Text(
          'No Devices Added',
          style: Theme.of(context)
              .textTheme
              .bodyMedium,
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: AppData.devices.length,
        itemBuilder: (context, index) {
          return DeviceCard(
            device: AppData.devices[index],

            onEdit: () {
              _showEditDeviceDialog(index);
            },

            onDelete: () {
              _showDeleteDialog(index);
            },
          );
        },
      ),
    );
  }

  void _showAddDeviceDialog() {
    final nameController = TextEditingController();
    final rateController = TextEditingController();

    String selectedType = 'Gaming PC';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Device'),

                content: SizedBox(
                    width: 450,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Device Name',
                    ),
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: selectedType,

                    decoration: const InputDecoration(
                      labelText: 'Device Type',
                    ),

                    items: const [
                      DropdownMenuItem(
                        value: 'Gaming PC',
                        child: Text('Gaming PC'),
                      ),
                      DropdownMenuItem(
                        value: 'PlayStation 5',
                        child: Text('PlayStation 5'),
                      ),
                      DropdownMenuItem(
                        value: 'Xbox Series X',
                        child: Text('Xbox Series X'),
                      ),
                      DropdownMenuItem(
                        value: 'Racing Simulator',
                        child: Text('Racing Simulator'),
                      ),
                      DropdownMenuItem(
                        value: 'VR Station',
                        child: Text('VR Station'),
                      ),
                    ],

                    onChanged: (value) {
                      setDialogState(() {
                        selectedType = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                          TextField(
                            controller: rateController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: '30 Minute Rate',
                            ),
                          ),

                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                ),

              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final rate = double.tryParse(rateController.text);

                    if (name.isEmpty) {
                      SnackbarHelper.error(
                        context,
                        'Invalid Name',
                        'Device name cannot be empty',
                      );
                      return;
                    }

                    if (AppData.devices.any((d) => d.name.toLowerCase() == name.toLowerCase())) {
                      SnackbarHelper.error(
                        context,
                        'Duplicate Name',
                        'A device with this name already exists',
                      );
                      return;
                    }

                    if (rate == null || rate <= 0) {
                      SnackbarHelper.error(
                        context,
                        'Invalid Rate',
                        'Please enter a valid rate',
                      );
                      return;
                    }

                    final device = Device(
                      name: name,
                      type: selectedType,
                      halfHourRate: rate,
                      isActive: false,
                    );

                    await deviceDB.insertDevice(device);

                    setState(() {
                      AppData.devices.add(device);
                    });

                    SnackbarHelper.success(
                      context,
                      'Device Added',
                      '${device.name} has been added successfully',
                    );

                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditDeviceDialog(int index) {
    final device = AppData.devices[index];

    final nameController =
    TextEditingController(text: device.name);

    final rateController =
    TextEditingController(
      text: device.halfHourRate.toString(),
    );

    String selectedType = device.type;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Device'),

                content: SizedBox(
                    width: 450,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Device Name',
                    ),
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: selectedType,

                    decoration: const InputDecoration(
                      labelText: 'Device Type',
                    ),

                    items: const [
                      DropdownMenuItem(
                        value: 'Gaming PC',
                        child: Text('Gaming PC'),
                      ),
                      DropdownMenuItem(
                        value: 'PlayStation 5',
                        child: Text('PlayStation 5'),
                      ),
                      DropdownMenuItem(
                        value: 'Xbox Series X',
                        child: Text('Xbox Series X'),
                      ),
                      DropdownMenuItem(
                        value: 'Racing Simulator',
                        child: Text('Racing Simulator'),
                      ),
                      DropdownMenuItem(
                        value: 'VR Station',
                        child: Text('VR Station'),
                      ),
                    ],

                    onChanged: (value) {
                      setDialogState(() {
                        selectedType = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                          TextField(
                            controller: rateController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: '30 Minute Rate',
                            ),
                          ),

                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                ),

              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    final newName = nameController.text.trim();

                    if (newName.isEmpty) {
                      SnackbarHelper.error(
                        context,
                        'Invalid Name',
                        'Device name cannot be empty',
                      );
                      return;
                    }

                    final hasActiveSession =
                    AppData.sessions.any(
                          (s) =>
                      s.deviceId ==
                          device.id,
                    );

                    if (hasActiveSession &&
                        selectedType != device.type) {

                      SnackbarHelper.error(
                        context,
                        'Active Session',
                        'Cannot change device type while a session is active',
                      );

                      return;
                    }

                    final rate = double.tryParse(
                      rateController.text,
                    );

                    if (rate == null || rate <= 0) {
                      SnackbarHelper.error(
                        context,
                        'Invalid Rate',
                        'Please enter a valid rate',
                      );
                      return;
                    }

                    if (hasActiveSession &&
                        rate !=
                            device.halfHourRate) {

                      SnackbarHelper.error(
                        context,
                        'Active Session',
                        'Cannot change rate while a session is active',
                      );

                      return;
                    }

                    final exists =
                    AppData.devices.any(
                          (d) =>
                      d != device &&
                          d.name.toLowerCase() ==
                              newName.toLowerCase(),
                    );

                    if (exists) {
                      SnackbarHelper.error(
                        context,
                        'Duplicate Name',
                        'Device name already exists',
                      );

                      return;
                    }

                    for (final session in AppData.sessions) {
                      if (session.deviceId == device.id) {
                        session.deviceName = newName;
                      }
                    }

                    for (final history in AppData.history) {
                      if (history.deviceId == device.id) {
                        history.deviceName = newName;
                      }
                    }

                    setState(() {
                      device.name = newName;
                      device.type = selectedType;
                      device.halfHourRate = rate;
                    });

                    await deviceDB.updateDevice(device);
                    if (!mounted) return;

                    await sessionDB.updateSessionDeviceName(
                      device.id!,
                      newName,
                    );

                    await historyDB.updateHistoryDeviceName(
                      device.id!,
                      newName,
                    );

                    if (context.mounted) {
                      SnackbarHelper.success(
                        context,
                        'Device Updated',
                        '$newName has been updated',
                      );
                    }

                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            width: 450,
            padding: const EdgeInsets.all(24),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  'Delete Device',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'Are you sure you want to delete ${AppData.devices[index].name}?',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),

                    const SizedBox(width: 12),

                    ElevatedButton(
                      onPressed: () async {
                        final deviceName = AppData.devices[index].name;

                        if (AppData.devices[index].isActive) {
                          Navigator.pop(context);

                          SnackbarHelper.error(
                            context,
                            'Active Session',
                            'Cannot delete a device with an active session',
                          );

                          return;
                        }

                        await deviceDB.deleteDevice(
                          AppData.devices[index].id!,
                        );
                        if (!mounted) return;

                        setState(() {
                          AppData.devices.removeAt(index);
                        });

                        SnackbarHelper.success(
                          context,
                          'Device Deleted',
                          '$deviceName has been removed',
                        );

                        Navigator.pop(context);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}