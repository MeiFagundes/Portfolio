import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/views/home/home_view.dart';
import 'package:meifagundesdotcom/views/shared/shared.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mei Fagundes',
      theme: ThemeData(
        fontFamily: 'OpenSans',
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.pink, brightness: Brightness.light),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: IconThemeData(color: Colors.pinkAccent, size: 25),
        buttonTheme: ButtonThemeData(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BorderRadiusSizes.level2),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            textStyle: WidgetStateProperty.all<TextStyle>(TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w600,
            )),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.pinkAccent),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(horizontal: 8, vertical: 15)),
            shape: WidgetStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(BorderRadiusSizes.level2),
              ),
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            textStyle: WidgetStateProperty.all<TextStyle>(TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w600,
            )),
            backgroundColor: WidgetStateProperty.all<Color>(Colors.pinkAccent),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(horizontal: 8, vertical: 15)),
            shape: WidgetStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(BorderRadiusSizes.level2),
              ),
            ),
          ),
        ),
      ),
      home: Home(),
    );
  }
}
