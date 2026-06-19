import 'package:flutter/material.dart';
import 'database/history_db.dart';
import 'services/theme_service.dart';
import 'services/pause_service.dart';
import 'services/text_scale_service.dart';
import 'theme/app_theme.dart';
import 'screens/main_screen.dart';
import 'database/device_db.dart';
import 'database/queue_db.dart';
import 'database/session_db.dart';
import 'data/app_data.dart';

Future<void> loadAppData() async {
  final deviceDB = DeviceDB();
  final queueDB = QueueDB();
  final sessionDB = SessionDB();
  final historyDB = HistoryDB();

  AppData.devices =
  await deviceDB.getDevices();

  AppData.queue =
  await queueDB.getQueue();

  AppData.sessions =
  await sessionDB.getSessions();

  AppData.history =
  await historyDB.getHistory();
}


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await TextScaleService.init();
  await ThemeService.loadTheme();
  await loadAppData();
  await PauseService.loadPauseState();

  runApp(
    const PCManagerApp(),
  );
}

class PCManagerApp extends StatelessWidget {
  const PCManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
      ThemeService.themeNotifier,

      builder: (
          context,
          theme,
          _,
          ) {
        return ValueListenableBuilder<double>(
          valueListenable:
          TextScaleService
              .textScaleNotifier,

          builder: (
              context,
              scale,
              _,
              ) {

            return MaterialApp(

              builder: (
                  context,
                  child,
                  ) {

                return MediaQuery(
                  data:
                  MediaQuery.of(context)
                      .copyWith(
                    textScaler:
                    TextScaler.linear(
                      scale,
                    ),
                  ),

                  child: child!,
                );
              },

              title: 'Zuzu Manage',

              themeMode:
              ThemeService
                  .themeNotifier
                  .value,

              theme:
              AppTheme.lightTheme,

              darkTheme:
              AppTheme.darkTheme,

              home:
              const MainScreen(),
            );
          },
        );
      },
    );
  }
}