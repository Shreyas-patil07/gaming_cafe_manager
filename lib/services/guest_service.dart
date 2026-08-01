import 'package:shared_preferences/shared_preferences.dart';

class GuestService {

  static const String _dateKey =
      'guest_date';

  static const String _counterKey =
      'guest_counter';

  static Future<void> _checkDate() async {

    final prefs =
    await SharedPreferences
        .getInstance();

    final today =
    DateTime.now();

    final todayString =
        '${today.year}-${today.month}-${today.day}';

    final savedDate =
    prefs.getString(
      _dateKey,
    );

    if (savedDate != todayString) {

      await prefs.setString(
        _dateKey,
        todayString,
      );

      await prefs.setInt(
        _counterKey,
        0,
      );
    }
  }

  static Future<String>
  getNextGuestName() async {

    await _checkDate();

    final prefs =
    await SharedPreferences
        .getInstance();

    final counter =
        prefs.getInt(
          _counterKey,
        ) ??
            0;

    return 'Guest ${counter + 1}';
  }

  static Future<void>
  consumeGuestNumber() async {

    await _checkDate();

    final prefs =
    await SharedPreferences
        .getInstance();

    int counter =
        prefs.getInt(
          _counterKey,
        ) ??
            0;

    counter++;

    await prefs.setInt(
      _counterKey,
      counter,
    );
  }
}