import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meifagundesdotcom/views/home/home_view.dart';

Future<void> main() async {
  await Firebase.initializeApp().catchError((e) {
    print(e);
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mei Fagundes',
      theme: ThemeData(
          fontFamily: 'OpenSans',
          primarySwatch: Colors.pink,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          buttonColor: Colors.pinkAccent,
          iconTheme: IconThemeData(color: Colors.pinkAccent, size: 25)),
      home: Home(),
    );
  }
}
