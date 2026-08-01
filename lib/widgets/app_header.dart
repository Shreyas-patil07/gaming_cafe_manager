import '../services/pause_service.dart';
import 'package:flutter/material.dart';
import '../screens/settings_page.dart';
import '../data/app_data.dart';
import '../utils/snackbar_helper.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context)
            .appBarTheme
            .backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context)
                .brightness == Brightness.dark
                ? Colors.grey.withValues(alpha: 0.20)
                : Colors.grey.withValues(alpha: 0.40),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: SafeArea(
        bottom: false,

        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 8,
          ),

          child: Row(
            children: [

              Expanded(
                child: Row(
                  children: [

                    Text(
                      'Zuzu Management',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge,
                    ),

                    const SizedBox(
                      width: 6,
                    ),

                    ValueListenableBuilder<bool>(
                      valueListenable:
                      PauseService.isPaused,

                      builder: (
                          context,
                          paused,
                          _,
                          ) {

                        final isOnline =
                        !paused;

                        final statusColor =
                        isOnline
                            ? Colors.greenAccent
                            : Colors.redAccent;

                        return Container(
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),

                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                              10,
                            ),

                            border: Border(
                              top: BorderSide(
                                color: statusColor,
                                width: 1.5,
                              ),

                              right: BorderSide(
                                color: statusColor,
                                width: 1.5,
                              ),

                              bottom: BorderSide(
                                color: statusColor,
                                width: 1.5,
                              ),
                            ),

                            boxShadow: [

                              BoxShadow(
                                color: statusColor
                                    .withValues(
                                  alpha: 0.25,
                                ),

                                blurRadius: 8,
                                spreadRadius: 1,
                              ),

                              BoxShadow(
                                color: statusColor
                                    .withValues(
                                  alpha: 0.12,
                                ),

                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ],
                          ),

                          child: Text(
                            isOnline
                                ? 'ON'
                                : 'OFF',

                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                              FontWeight.w700,

                              color: statusColor,

                              shadows: [

                                Shadow(
                                  color: statusColor,
                                  blurRadius: 4,
                                ),

                                Shadow(
                                  color: statusColor,
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              ValueListenableBuilder<bool>(
                valueListenable: PauseService.isPaused,
                builder: (
                    context,
                    paused,
                    _,
                    ) {
                  return Transform.scale(
                    scale: 1,
                    child:
                    Switch(
                        value: paused,
                        activeThumbColor: Colors.white,
                        activeTrackColor: Colors.red,
                        inactiveTrackColor: Colors.grey,
                        inactiveThumbColor: Colors.white,

                        onChanged: (value) async {
                          if (value && AppData.sessions.isEmpty) {
                            SnackbarHelper.error(
                              context,
                              'No Active Sessions',
                              'There are no sessions to pause',
                            );
                            return;
                          }

                          final confirmed =
                          await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  value
                                      ? 'Pause All Sessions'
                                      : 'Resume All Sessions',
                                ),

                                content: SizedBox(
                                  width: 450,
                                  child: Text(
                                    value
                                        ? 'All active sessions will be paused until power returns.'
                                        : 'All paused sessions will resume from where they stopped.',
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
                                      'Cancel',
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
                                      'Confirm',
                                    ),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirmed != true) {
                            return;
                          }

                          if (value) {
                            await PauseService.pauseAll();
                          } else {
                            await PauseService.resumeAll();
                          }
                        }
                    ),
                  );
                },
              ),

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .appBarTheme
                      .backgroundColor,
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const SettingsPage(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.settings_outlined,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}