import '../models/session.dart';
import 'database_helper.dart';

class SessionDB {
  Future<void> insertSession(
      Session session,
      ) async {
    final db =
    await DatabaseHelper.instance.database;

    final id = await db.insert(
      'sessions',
      session.toMap(),
    );

    session.id = id;
  }

  Future<List<Session>>
  getSessions() async {
    final db =
    await DatabaseHelper.instance.database;

    final maps =
    await db.query('sessions');

    return maps
        .map(
          (e) =>
          Session.fromMap(e),
    )
        .toList();
  }

  Future<void> deleteSession(
      int deviceId,
      ) async {
    final db =
    await DatabaseHelper.instance.database;

    await db.delete(
      'sessions',
      where: 'deviceId = ?',
      whereArgs: [deviceId],
    );
  }

  Future<void> updateSession(
      Session session,
      ) async {

    final db =
    await DatabaseHelper.instance.database;

    final map =
    session.toMap();

    map.remove('id');

    await db.update(
      'sessions',
      map,
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  Future<void> updateSessionDeviceName(
      int deviceId,
      String newName,
      ) async {
    final db =
    await DatabaseHelper.instance.database;

    await db.update(
      'sessions',
      {
        'deviceName': newName,
      },
      where: 'deviceId = ?',
      whereArgs: [deviceId],
    );
  }

}