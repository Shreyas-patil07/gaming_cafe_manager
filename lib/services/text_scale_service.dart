import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextScaleService {

  static const String _key =
      'text_scale';

  static final ValueNotifier<double>
  textScaleNotifier =
  ValueNotifier(1.0);

  static Future<void> init() async {

    final prefs =
    await SharedPreferences.getInstance();

    textScaleNotifier.value =
        prefs.getDouble(_key) ?? 1.0;
  }

  static Future<void> setScale(
      double scale,
      ) async {

    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setDouble(
      _key,
      scale,
    );

    textScaleNotifier.value =
        scale;
  }
}