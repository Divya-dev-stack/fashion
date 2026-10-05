import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext c) => MediaQuery.of(c).size.width < 700;
  static bool isDesktop(BuildContext c) => MediaQuery.of(c).size.width >= 1100;

  static int gridCount(BuildContext c) {
    final w = MediaQuery.of(c).size.width;
    if (w >= 1300) return 5;
    if (w >= 1000) return 4;
    if (w >= 700) return 3;
    return 2;
  }
}