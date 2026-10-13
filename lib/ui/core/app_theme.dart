import 'package:flutter/material.dart';

import 'border_radius_sizes.dart';

ThemeData buildAppTheme() => ThemeData(
  fontFamily: 'OpenSans',
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.pink,
    brightness: Brightness.light,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  iconTheme: const IconThemeData(color: Colors.pinkAccent, size: 25),
  buttonTheme: ButtonThemeData(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(BorderRadiusSizes.level2),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      textStyle: WidgetStateProperty.all<TextStyle>(
        const TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w600),
      ),
      foregroundColor: WidgetStateProperty.all<Color>(Colors.pinkAccent),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      ),
      shape: WidgetStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BorderRadiusSizes.level2),
        ),
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      textStyle: WidgetStateProperty.all<TextStyle>(
        const TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w600),
      ),
      backgroundColor: WidgetStateProperty.all<Color>(Colors.pinkAccent),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      ),
      shape: WidgetStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BorderRadiusSizes.level2),
        ),
      ),
    ),
  ),
);
