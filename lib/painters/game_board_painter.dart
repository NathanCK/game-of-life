import 'package:flutter/widgets.dart';

/// Custom painter for the game board grid.
class GameBoardPainter extends CustomPainter {
  final double cellGapSize;
  final Paint painter;

  final int rowCount;
  final double cellSize;
  final int columnCount;
  final Color lineColor;

  GameBoardPainter({
    required this.cellGapSize,
    required this.rowCount,
    required this.cellSize,
    required this.columnCount,
    required this.lineColor,
  }) : painter = Paint()
          ..strokeWidth = 1
          ..style = PaintingStyle.fill
          ..color = lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    for (int r = 0; r < rowCount; r++) {
      canvas.drawLine(
          Offset(getLeft1(0), getTop1(r) - (cellGapSize / 2)),
          Offset(getLeft1(columnCount), getTop1(r) - (cellGapSize / 2)),
          painter);
    }

    for (int c = 0; c < columnCount; c++) {
      canvas.drawLine(Offset(getLeft1(c) - (cellGapSize / 2), getTop1(0)),
          Offset(getLeft1(c) - (cellGapSize / 2), getTop1(rowCount)), painter);
    }
  }

  double getTop1(int rowIndex) {
    return rowIndex * cellSize;
  }

  double getLeft1(int colIndex) {
    return colIndex * cellSize;
  }

  @override
  bool shouldRepaint(GameBoardPainter oldDelegate) =>
      cellGapSize != oldDelegate.cellGapSize ||
      columnCount != oldDelegate.columnCount ||
      rowCount != oldDelegate.rowCount ||
      cellSize != oldDelegate.cellSize ||
      lineColor != oldDelegate.lineColor;
}
