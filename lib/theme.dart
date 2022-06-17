import 'package:flutter/material.dart';

final globalTheme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0D014D),
    onPrimary: Colors.white,
    secondary: Color(0xFFFCD03C),
    onSecondary: Color(0xFF0D014D),
    error: Colors.red,
    onError: Colors.black,
    background: Color(0xFFFDFDFD),
    onBackground: Colors.black,
    surface: Color(0xFFFDFDFD),
    onSurface: Color(0xFF0D014D),
  ),
  primaryColor: const Color(0xFF0D014D),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    toolbarTextStyle: TextStyle(fontFamily: 'Merriweather'),
  ),
);
