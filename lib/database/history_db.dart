import '../models/history_item.dart';
import 'database_helper.dart';

class HistoryDB {
  Future<void> insertHistory(
      HistoryItem item,
      ) async {
    final db =
    await DatabaseHelper.instance.database;

    await db.insert(
      'history',
      item.toMap(),
    );
  }

  Future<List<HistoryItem>>
  getHistory() async {
    final db =
    await DatabaseHelper.instance.database;

    final maps =
    await db.query(
      'history',
      orderBy: 'id ASC',
    );

    return maps
        .map(
          (e) =>
          HistoryItem.fromMap(e),
    )
        .toList();
  }

  Future<void> updateHistoryDeviceName(
      int deviceId,
      String newName,
      ) async {
    final db =
    await DatabaseHelper.instance.database;

    await db.update(
      'history',
      {
        'deviceName': newName,
      },
      where: 'deviceId = ?',
      whereArgs: [deviceId],
    );
  }

  Future<void> clearHistory()
  async {
    final db =
    await DatabaseHelper.instance.database;

    await db.delete('history');
  }

  Future<DateTime?> getFirstHistoryDate() async {
    final db =
    await DatabaseHelper.instance.database;

    final result = await db.query(
      'history',
      orderBy: 'startTime ASC',
      limit: 1,
    );

    if (result.isEmpty) return null;

    return DateTime.parse(
      result.first['startTime'] as String,
    );
  }

  Future<DateTime?> getLastHistoryDate() async {
    final db =
    await DatabaseHelper.instance.database;

    final result = await db.query(
      'history',
      orderBy: 'startTime DESC',
      limit: 1,
    );

    if (result.isEmpty) return null;

    return DateTime.parse(
      result.first['startTime'] as String,
    );
  }

}