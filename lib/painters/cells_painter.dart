import 'package:conway_game_of_life/patterns/cell.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Custom painter for the cells in the Game of Life board.
class CellsPainter extends CustomPainter {
  final double cellGapSize;
  final Paint painter;
  final int rowCount;
  final double cellSize;
  final int columnCount;
  final Color aliveColor;
  final Set<Cell> aliveCells;
  final int generation;

  CellsPainter({
    required this.rowCount,
    required this.cellSize,
    required this.columnCount,
    required this.aliveColor,
    required this.aliveCells,
    required this.generation,
    this.cellGapSize = 1,
  }) : painter = Paint()
          ..strokeWidth = 1
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    painter.color = aliveColor;
    for (var aliveCell in aliveCells) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(
                getLeft1(aliveCell.col),
                getTop1(aliveCell.row),
                cellSize - cellGapSize,
                cellSize - cellGapSize,
              ),
              const Radius.circular(1.0)),
          painter);
    }
  }

  double getTop1(int rowIndex) {
    return rowIndex * cellSize;
  }

  double getLeft1(int colIndex) {
    return colIndex * cellSize;
  }

  @override
  bool shouldRepaint(CellsPainter oldDelegate) =>
      cellGapSize != oldDelegate.cellGapSize ||
      generation != oldDelegate.generation ||
      columnCount != oldDelegate.columnCount ||
      rowCount != oldDelegate.rowCount ||
      cellSize != oldDelegate.cellSize ||
      aliveColor != oldDelegate.aliveColor ||
      !setEquals(aliveCells, oldDelegate.aliveCells);

  @override
  bool shouldRebuildSemantics(CellsPainter oldDelegate) => false;
}
