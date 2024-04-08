import 'package:flutter/material.dart';

var theme = ThemeData(
  colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Colors.black,
      onPrimary: Color(0xFF6200EE),
      secondary: Color(0xFF797979),
      onSecondary: Color(0xFF797979),
      error: Color(0xFFCE3426),
      onError: Color(0xFFCE3426),
      background: Colors.white,
      onBackground: Colors.white,
      surface: Color(0xFFE8E8E8),
      onSurface: Colors.white),
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 24),
    titleMedium: TextStyle(fontSize: 22),
    headlineLarge: TextStyle(fontSize: 22),
    displayLarge: TextStyle(fontSize: 18),
    bodyLarge: TextStyle(fontSize: 16),
    bodyMedium: TextStyle(fontSize: 12),
    bodySmall: TextStyle(fontSize: 10),
  ),
);
