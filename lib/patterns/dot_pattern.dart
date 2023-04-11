import 'dart:math';

import 'package:conway_game_of_life/patterns/angle_enum.dart';
import 'package:conway_game_of_life/patterns/cell.dart';
import 'package:equatable/equatable.dart';

abstract class DotPattern extends Equatable {
  // TODO: unit test
  static List<Cell> rotateCells(List<Cell> cells, Angle degree) {
    if (degree == Angle.zeroDegree) return cells;

    final maxRow =
        cells.fold(0, (previousValue, c) => max(previousValue, c.row)) + 1;
    final maxCol =
        cells.fold(0, (previousValue, c) => max(previousValue, c.col)) + 1;
    final originalCellSet = cells.toSet();
    final originalMap = List.generate(
        maxRow,
        (rowIndex) => List.generate(maxCol, (colIndex) {
              if (originalCellSet.contains(Cell(rowIndex, colIndex))) {
                return 1;
              }

              return 0;
            }));

    List<List<int>> rotatedMap = [];

    if (degree == Angle.ninetyDegree) {
      rotatedMap = List.generate(
          maxCol,
          (colIndex) => List.generate(maxRow, (rowIndex) {
                return originalMap[maxRow - rowIndex - 1][colIndex];
              }));
    }

    if (degree == Angle.twoSeventyDegree) {
      rotatedMap = List.generate(maxRow, (rowIndex) {
        final targetRow = maxRow - rowIndex - 1;
        return originalMap[targetRow].reversed.toList();
      });
    }

    if (degree == Angle.threeSixtyDegree) {
      rotatedMap = List.generate(maxCol, (colIndex) {
        final targetCol = maxCol - colIndex - 1;
        return List.generate(maxRow, (rowIndex) {
          return originalMap[maxRow][targetCol];
        });
      });
    }

    List<Cell> rotatedCells = [];

    for (int i = 0; i < rotatedMap.length; i++) {
      for (int j = 0; j < rotatedMap[0].length; j++) {
        if (rotatedMap[i][j] == 1) {
          rotatedCells.add(Cell(i, j));
        }
      }
    }

    return rotatedCells;
  }

  final List<Cell> cells;
  final Angle angle;
  final int maxSpace;

  DotPattern(List<Cell> cells, {this.angle = Angle.zeroDegree})
      : maxSpace = cells.fold(0,
                (previousValue, p) => max(previousValue, max(p.row, p.col))) +
            1,
        cells = rotateCells(cells, angle);

  @override
  List<Object?> get props => [cells, angle];
}
