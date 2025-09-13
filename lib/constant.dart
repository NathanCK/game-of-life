import 'package:conway_game_of_life/theme/game_of_life_theme.dart';
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

class DefaultLightTheme {
  static final themeData = GameOfLifeTheme(
    activeCellColor: DefaultLightTheme.alive,
    deadCellColor: DefaultLightTheme.dead,
    gridColor: DefaultLightTheme.gridLine,
    controlButtonColor: DefaultLightTheme.controlButton,
  );

  static const Color alive = Colors.black;
  static final Color dead = Colors.grey[50]!;
  static const Color gridLine = Colors.white;
  static final Color controlButton = Colors.grey[850]!;
}

class DefaultDarkTheme {
  static final themeData = GameOfLifeTheme(
    activeCellColor: DefaultDarkTheme.alive,
    deadCellColor: DefaultDarkTheme.dead,
    gridColor: DefaultDarkTheme.gridLine,
    controlButtonColor: DefaultDarkTheme.controlButton,
  );

  static const Color alive = Colors.white;
  static final Color dead = Colors.grey[700]!;
  static final Color gridLine = Colors.grey[600]!;
  static final Color controlButton = Colors.grey[850]!;
}
