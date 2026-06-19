import 'dart:io';

import 'package:flutter/material.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../data/app_data.dart';
import '../database/history_db.dart';
import '../models/history_item.dart';

class ExportService {
  static Future<void> exportRevenue(
      List<HistoryItem> data,
      DateTime fromDate,
      DateTime toDate,
      ) async {
    try {
      final excel = Excel.createExcel();

      final sheet = excel['Revenue Report'];
      excel.delete('Sheet1');

      sheet.appendRow([
        TextCellValue('Device'),
        TextCellValue('Type'),
        TextCellValue('Start'),
        TextCellValue('End'),
        TextCellValue('Minutes'),
        TextCellValue('Amount'),
      ]);

      for (final item in data) {
        sheet.appendRow([
          TextCellValue(item.deviceName),
          TextCellValue(item.deviceType),
          TextCellValue(
            DateFormat(
              'dd/MM/yyyy HH:mm',
            ).format(item.startTime),
          ),
          TextCellValue(
            DateFormat(
              'dd/MM/yyyy HH:mm',
            ).format(item.endTime),
          ),
          IntCellValue(
            item.durationMinutes,
          ),
          DoubleCellValue(
            item.amount,
          ),
        ]);
      }

      final bytes = excel.encode();

      if (bytes == null) return;

      final dir =
      await getTemporaryDirectory();

      final timestamp =
      DateFormat(
        'yyyyMMdd_HHmmss',
      ).format(DateTime.now());

      final file = File(
        '${dir.path}/Revenue_${DateFormat('dd-MM-yyyy').format(fromDate)}_to_${DateFormat('dd-MM-yyyy').format(toDate)}.xlsx',
      );

      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        subject:
        'Revenue Report $timestamp',
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> showExportDialog(
      BuildContext context,
      ) async {
    final historyDB = HistoryDB();

    final firstDate =
    await historyDB.getFirstHistoryDate();

    final lastDate =
    await historyDB.getLastHistoryDate();

    if (firstDate == null ||
        lastDate == null) {
      return;
    }

    DateTime startDate = firstDate;
    DateTime endDate = lastDate;

    if (!context.mounted) return;

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
                'Export Revenue',
              ),

              content: SizedBox(
                width: 450,
                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text(
                        'From',
                      ),
                      subtitle: Text(
                        '${startDate.day}/${startDate.month}/${startDate.year}',
                      ),
                      onTap: () async {
                        final picked =
                        await showDatePicker(
                          context: context,
                          firstDate:
                          firstDate,
                          lastDate:
                          lastDate,
                          initialDate:
                          startDate,
                        );

                        if (picked != null) {
                          setDialogState(() {
                            startDate =
                                picked;
                          });
                        }
                      },
                    ),

                    ListTile(
                      title: const Text(
                        'To',
                      ),
                      subtitle: Text(
                        '${endDate.day}/${endDate.month}/${endDate.year}',
                      ),
                      onTap: () async {
                        final picked =
                        await showDatePicker(
                          context: context,
                          firstDate:
                          firstDate,
                          lastDate:
                          lastDate,
                          initialDate:
                          endDate,
                        );

                        if (picked != null) {
                          setDialogState(() {
                            endDate =
                                picked;
                          });
                        }
                      },
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
                    final exportData =
                    AppData.history
                        .where(
                          (h) {
                        return h.startTime
                            .isAfter(
                          startDate.subtract(
                            const Duration(
                              days: 1,
                            ),
                          ),
                        ) &&
                            h.startTime
                                .isBefore(
                              endDate.add(
                                const Duration(
                                  days: 1,
                                ),
                              ),
                            );
                      },
                    ).toList();

                    await exportRevenue(
                      exportData,
                      startDate,
                      endDate,
                    );

                    if (context.mounted) {
                      Navigator.pop(
                        context,
                      );
                    }
                  },
                  child: const Text(
                    'Export',
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