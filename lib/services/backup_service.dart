import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../database/database_helper.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

class BackupService {
  static Future<void> backupDatabase() async {
    final dbPath =
    await getDatabasesPath();

    final dbFile = File(
      join(
        dbPath,
        'gaming_cafe.db',
      ),
    );

    if (!await dbFile.exists()) {
      return;
    }

    final tempDir =
    await getTemporaryDirectory();

    final backupFile = File(
      join(
        tempDir.path,
        'gaming_cafe_backup.db',
      ),
    );

    await dbFile.copy(
      backupFile.path,
    );

    await Share.shareXFiles(
      [
        XFile(
          backupFile.path,
        ),
      ],
      subject:
      'Gaming Cafe Backup',
    );
  }

  static Future<void> restoreDatabase() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['db'],
    );

    if (result == null) {
      return;
    }

    final selectedFile =
    File(result.files.single.path!);

    final db =
    await DatabaseHelper.instance.database;

    await DatabaseHelper.instance
        .resetDatabase();

    final dbPath =
    await getDatabasesPath();

    final destination = File(
      join(
        dbPath,
        'gaming_cafe.db',
      ),
    );

    if (await destination.exists()) {
      await destination.delete();
    }

    await selectedFile.copy(
      destination.path,
    );
  }
}