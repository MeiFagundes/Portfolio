import 'package:flutter/material.dart';

class ApplicationUtil {
  static bool isMobileDevice(BuildContext context) =>
      MediaQuery.of(context).size.width <= 950;
}
