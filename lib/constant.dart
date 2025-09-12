import 'package:flutter/material.dart';

class Constant {
  static const int alive = 1;
  static const int dead = 0;
}

class DefaultGameSettings {
  static const double cellSize = 7.0;
  static const bool showControlPanel = true;
  static const bool autoStart = false;
  static const Duration speed = Duration(milliseconds: 500);
}

class DefaultLightColors {
  static const Color alive = Colors.black;
  static final Color dead = Colors.grey[50]!;
  static const Color gridLine = Colors.white;
}

class DefaultDarkColors {
  static const Color alive = Colors.black;
  static final Color dead = Colors.grey[850]!;
  static const Color gridLine = Colors.white;
}
