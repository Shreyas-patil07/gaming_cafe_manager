import '../models/device.dart';
import 'database_helper.dart';

class DeviceDB {
  Future<void> insertDevice(
      Device device,
      ) async {
    final db =
    await DatabaseHelper.instance.database;

    final id = await db.insert(
      'devices',
      device.toMap(),
    );

    device.id = id;
  }

  Future<List<Device>>
  getDevices() async {
    final db =
    await DatabaseHelper.instance.database;

    final maps =
    await db.query('devices');

    return maps
        .map(
          (e) =>
          Device.fromMap(e),
    )
        .toList();
  }

  Future<void> deleteDevice(
      int id,
      ) async {
    final db =
    await DatabaseHelper.instance.database;

    await db.delete(
      'devices',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearDevices()
  async {
    final db =
    await DatabaseHelper.instance.database;

    await db.delete('devices');
  }

  Future<void> updateDevice(
      Device device,
      ) async {
    final db =
    await DatabaseHelper.instance.database;

    await db.update(
      'devices',
      device.toMap(),
      where: 'id = ?',
      whereArgs: [device.id],
    );
  }

}