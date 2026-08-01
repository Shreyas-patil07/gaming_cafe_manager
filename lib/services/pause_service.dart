import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../database/session_db.dart';

class PauseService {
  static final SessionDB sessionDB =
  SessionDB();

  static final ValueNotifier<bool>
  isPaused = ValueNotifier(false);

  static Future<void> loadPauseState() async {
    isPaused.value =
        AppData.sessions.any(
              (s) => s.isPaused,
        );
  }

  static Future<void> pauseAll() async {
    if (isPaused.value) return;
    final now = DateTime.now();

    for (final session in AppData.sessions) {
      session.isPaused = true;
      session.pausedAt = now;

      await sessionDB.updateSession(
        session,
      );
    }

    await loadPauseState();
  }

  static Future<void> resumeAll() async {
    if (!isPaused.value) return;

    final now = DateTime.now();

    for (final session in AppData.sessions) {
      if (!session.isPaused ||
          session.pausedAt == null) {
        continue;
      }

      final pausedDuration =
      now.difference(
        session.pausedAt!,
      );

      session.endTime =
          session.endTime.add(
            pausedDuration,
          );

      session.isPaused = false;
      session.pausedAt = null;

      await sessionDB.updateSession(
        session,
      );
    }

    await loadPauseState();
  }
}