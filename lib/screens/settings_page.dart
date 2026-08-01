import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import '../services/export_service.dart';
import '../services/backup_service.dart';
import '../services/text_scale_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage
    extends StatefulWidget {

  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage>
  createState() =>
      _SettingsPageState();
}

class _SettingsPageState
    extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),

      body: Column(
          children: [

      Expanded(
      child: ListView(
      padding: const EdgeInsets.all(16),
      children: [

          ListTile(
            leading: const Icon(
              Icons.text_fields,
            ),

            title: const Text(
              'Text Size',
            ),

            subtitle:
            ValueListenableBuilder<double>(
              valueListenable:
              TextScaleService
                  .textScaleNotifier,

              builder: (
                  context,
                  scale,
                  _,
                  ) {

                return Text(
                  '${(scale * 100).toInt()}%',
                );
              },
            ),

            onTap: () {
              _showTextScaleDialog();
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.palette_outlined,
            ),

            title: const Text(
              'Theme',
            ),

            subtitle: Text(
              ThemeService.themeNotifier.value.name[0]
                  .toUpperCase() +
                  ThemeService
                      .themeNotifier
                      .value
                      .name
                      .substring(1),
            ),

            onTap: () {
              showModalBottomSheet(
                context: context,

                builder: (context) {
                  return Column(
                    mainAxisSize:
                    MainAxisSize.min,

                    children: [

                      ListTile(
                        title:
                        const Text(
                          'Dark',
                        ),

                        onTap: () async {
                          await ThemeService
                              .setTheme(
                            ThemeMode.dark,
                          );

                          Navigator.pop(
                              context);
                        },
                      ),

                      ListTile(
                        title:
                        const Text(
                          'Light',
                        ),

                        onTap: () async {
                          await ThemeService
                              .setTheme(
                            ThemeMode.light,
                          );

                          Navigator.pop(
                              context);
                        },
                      ),

                      ListTile(
                        title:
                        const Text(
                          'System',
                        ),

                        onTap: () async {
                          await ThemeService
                              .setTheme(
                            ThemeMode.system,
                          );

                          Navigator.pop(
                              context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),

          const SizedBox(height: 5),

          ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: const Text('Backup'),
            onTap: () async {
              await BackupService
                  .backupDatabase();
            },
          ),

          const SizedBox(height: 5),

          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Restore '),
            onTap: () async {
              await BackupService
                  .restoreDatabase();

              if (context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Database restored. Please restart the app.',
                    ),
                  ),
                );
              }
            },
          ),

          const SizedBox(height: 5),

          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Export Revenue'),
            onTap: () {
              ExportService.showExportDialog(context);
            },
          ),

          const SizedBox(height: 5),

          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            subtitle: Text('v6.03.007'),
          ),

          const SizedBox(height: 5),

          ListTile(
            leading: const Icon(
              Icons.storefront_outlined,
            ),
            title: const Text(
              'Client - ________  _______  _______',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            subtitle: const Text(
              '_____  _____',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ],
        ),
      ),
      Padding(
      padding: const EdgeInsets.all(16),
      child:

      Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  const CircleAvatar(
                    radius: 20,
                    child: Icon(
                      Icons.person,
                      size: 28,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Shreyas Ravindra Patil',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'Developer',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [

                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () async {
                            final uri = Uri(
                              scheme: 'tel',
                              path: '8591460867',
                            );
                            await launchUrl(uri);
                          },
                          icon: const Icon(Icons.phone),
                          label: const Text('Call'),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () async {
                            final uri = Uri(
                              scheme: 'mailto',
                              path: '3shreyas2007@gmail.com',
                            );
                            await launchUrl(uri);
                          },
                          icon: const Icon(Icons.email),
                          label: const Text('Email'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ),
    ],
    )
    );
  }
  Future<void> _showTextScaleDialog() async {

    double scale =
        TextScaleService
            .textScaleNotifier
            .value;

    await showDialog(
      context: context,

      builder: (context) {

        return StatefulBuilder(
          builder: (
              context,
              setDialogState,
              ) {

            return AlertDialog(
              title: const Text(
                'Text Size',
              ),

              content: SizedBox(
                width: 400,

                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,

                  children: [

                    Text(
                      '${(scale * 100).toInt()}%',
                      style:
                      const TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    Slider(
                      min: 0.7,
                      max: 1.2,

                      divisions: 8,

                      value: scale,

                      label:
                      '${(scale * 100).toInt()}%',

                      onChanged: (
                          value,
                          ) {

                        setDialogState(() {
                          scale = value;
                        });
                      },
                    ),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                      children: const [

                        Text(
                          '70%',
                        ),

                        Text(
                          '120%',
                        ),
                      ],
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

                    await TextScaleService
                        .setScale(
                      scale,
                    );

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
      },
    );
  }
}