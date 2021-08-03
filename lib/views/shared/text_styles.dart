import 'package:flutter/material.dart';

class TextStyles {
  static final TextStyle title = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: Colors.pinkAccent,
    letterSpacing: 0.7,
    shadows: [
      Shadow(
        color: Colors.grey[400]!,
        blurRadius: 1.2,
        offset: Offset(0.7, 0.7),
      ),
    ],
  );

  static final TextStyle profileName = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: Colors.pinkAccent,
    letterSpacing: 0.7,
    shadows: [
      Shadow(
        color: Colors.grey[400]!,
        blurRadius: 1.5,
        offset: Offset(0.7, 0.7),
      ),
    ],
  );

  static final TextStyle profileDescription = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.grey[600],
    letterSpacing: 0.7,
  );

  static final TextStyle projectTitle = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w400,
    color: Colors.grey[800],
    letterSpacing: 0.7,
  );

  static final TextStyle projectDescription = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: Colors.grey[600],
    letterSpacing: 0.7,
  );

  static final TextStyle profileButton = TextStyle(
    fontSize: 14.5,
    fontWeight: FontWeight.w600,
    color: Colors.pinkAccent,
  );
}
