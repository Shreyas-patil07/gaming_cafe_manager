import '../models/queue_item.dart';
import 'database_helper.dart';

class QueueDB {

  Future<void> insertQueue(
      QueueItem item,
      ) async {

    final db =
    await DatabaseHelper.instance.database;

    final id = await db.insert(
      'queue',
      item.toMap(),
    );

    item.id = id;
  }

  Future<List<QueueItem>>
  getQueue() async {

    final db =
    await DatabaseHelper.instance.database;

    final maps = await db.query(
      'queue',
      orderBy: 'queuedAt ASC',
    );

    return maps
        .map(
          (e) =>
          QueueItem.fromMap(e),
    )
        .toList();
  }

  Future<void> deleteQueue(
      int id,
      ) async {

    final db =
    await DatabaseHelper.instance.database;

    await db.delete(
      'queue',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateQueue(
      QueueItem item,
      ) async {

    final db =
    await DatabaseHelper
        .instance
        .database;

    final map =
    item.toMap();

    map.remove('id');

    await db.update(
      'queue',
      map,
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

}