import 'package:flutter/material.dart';

class GameOfLifeTheme extends ThemeExtension<GameOfLifeTheme> {
  final Color activeCellColor;
  final Color deadCellColor;
  final Color gridColor;
  final Color controlButtonColor;

  const GameOfLifeTheme({
    required this.activeCellColor,
    required this.deadCellColor,
    required this.gridColor,
    required this.controlButtonColor,
  });

  @override
  GameOfLifeTheme copyWith({
    Color? activeCellColor,
    Color? deadCellColor,
    Color? gridColor,
    Color? controlButtonColor,
  }) {
    return GameOfLifeTheme(
      activeCellColor: activeCellColor ?? this.activeCellColor,
      deadCellColor: deadCellColor ?? this.deadCellColor,
      gridColor: gridColor ?? this.gridColor,
      controlButtonColor: controlButtonColor ?? this.controlButtonColor,
    );
  }

  @override
  GameOfLifeTheme lerp(ThemeExtension<GameOfLifeTheme>? other, double t) {
    if (other is! GameOfLifeTheme) return this;

    return GameOfLifeTheme(
      activeCellColor: Color.lerp(activeCellColor, other.activeCellColor, t)!,
      deadCellColor: Color.lerp(deadCellColor, other.deadCellColor, t)!,
      gridColor: Color.lerp(gridColor, other.gridColor, t)!,
      controlButtonColor:
          Color.lerp(controlButtonColor, other.controlButtonColor, t)!,
    );
  }
}
