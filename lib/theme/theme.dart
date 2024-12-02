import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade200,
    primary: Color.fromRGBO(207, 207, 207, 1.0),
    secondary: Color.fromRGBO(210, 210, 210, 1.0)
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
      surface: Colors.grey.shade900,
      primary: Color.fromRGBO(0, 0, 0, 1.0),
      secondary: Color.fromRGBO(16, 16, 16, 1.0)
  ),
);