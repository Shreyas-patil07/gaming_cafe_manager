import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryBlue = Color(0xFF00004C);
  static const Color accentPurple = Color(0xFF7C3AED);

  // Core UI
  static const Color background = Color(0xFF09090F);
  static const Color headerColor = Color(0xFF0F172A);
  static const Color cardColor = Color(0xFF0D1B34);
  static const Color borderColor = Color(0xFF1F2937);

  // Text
  static const Color primaryText = Colors.white;
  static const Color secondaryText = Color(0xFF94A3B8);

  // Status
  static const Color readyColor = Color(0xFF22C55E);
  static const Color busyColor = Color(0xFFEF4444);

  // White theme
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightHeader = Colors.white;
  static const Color lightCard = Colors.white;
  static const Color lightBorder = Color(0xFFE2E8F0);

  static const Color lightPrimaryText = Color(0xFF0F172A);
  static const Color lightSecondaryText = Color(0xFF64748B);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: lightBackground,

    colorScheme: const ColorScheme.light(
      primary: accentPurple,
      secondary: accentPurple,
      surface: lightCard,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: lightHeader,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: lightPrimaryText,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: IconThemeData(
        color: lightPrimaryText,
      ),
    ),

    cardTheme: CardThemeData(
      color: lightCard,
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: lightBorder,
        ),
      ),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: lightHeader,

      indicatorColor: const Color(0x227C3AED),

      labelTextStyle:
      WidgetStateProperty.resolveWith(
            (states) {
          return TextStyle(
            fontSize: 13,
            fontWeight:
            states.contains(
              WidgetState.selected,
            )
                ? FontWeight.w700
                : FontWeight.w500,

            color:
            states.contains(
              WidgetState.selected,
            )
                ? accentPurple
                : lightSecondaryText,
          );
        },
      ),

      iconTheme:
      WidgetStateProperty.resolveWith(
            (states) {
          return IconThemeData(
            color:
            states.contains(
              WidgetState.selected,
            )
                ? accentPurple
                : lightSecondaryText,
          );
        },
      ),
    ),

    floatingActionButtonTheme:
    const FloatingActionButtonThemeData(
      backgroundColor: accentPurple,
      foregroundColor: Colors.white,
    ),

    elevatedButtonTheme:
    ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(14),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentPurple,
      ),
    ),

    inputDecorationTheme:
    InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,

      border: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: lightBorder,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: lightBorder,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: accentPurple,
          width: 2,
        ),
      ),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: lightCard,

      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(24),
      ),
    ),

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: lightPrimaryText,
        fontWeight: FontWeight.w700,
        fontSize: 22,
      ),

      bodyLarge: TextStyle(
        color: lightPrimaryText,
        fontSize: 16,
      ),

      bodyMedium: TextStyle(
        color: lightSecondaryText,
        fontSize: 14,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: background,

    colorScheme: const ColorScheme.dark(
      primary: accentPurple,
      secondary: accentPurple,
      surface: cardColor,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: headerColor,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: primaryText,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
    ),

    cardTheme: CardThemeData(
      color: cardColor,
      shadowColor: Colors.black,
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: borderColor,
          width: 1,
        ),
      ),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: headerColor,

      indicatorColor: const Color(0x337C3AED),

      indicatorShape: StadiumBorder(),

      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (states) {
          return TextStyle(
            fontSize: 13,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? Colors.white
                : const Color(0xFF94A3B8),
          );
        },
      ),

      iconTheme: WidgetStateProperty.resolveWith(
            (states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: Colors.white,
              size: 28,
            );
          }

          return const IconThemeData(
            color: Color(0xFF94A3B8),
            size: 24,
          );
        },
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentPurple,
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentPurple,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF111827),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: borderColor,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: borderColor,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: accentPurple,
          width: 2,
        ),
      ),

      hintStyle: const TextStyle(
        color: secondaryText,
      ),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: cardColor,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),

      titleTextStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 22,
      ),

      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),

      bodyMedium: TextStyle(
        color: Color(0xFFCBD5E1),
        fontSize: 14,
      ),

      headlineSmall: TextStyle(
        color: primaryText,
        fontWeight: FontWeight.w700,
      ),


      labelLarge: TextStyle(
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}