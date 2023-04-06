// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  final double width;
  final double height;
  final double cellSize;
  final Duration duration;

  const GameBoard({
    super.key,
    required this.height,
    required this.width,
    required this.cellSize,
    required this.duration,
  });

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard>
    with TickerProviderStateMixin<GameBoard> {
  static const int _ALIVE = 1;
  static const int _DEAD = 0;

  late Animation<Set<int>> animation;
  late AnimationController controller;

  late final Tween<Set<int>> _rotationTween;

  late final Set<int> aliveCells;
  late final int totalCellCount;
  late final int rowCount;
  late final int colCount;
  late final List<int> cellStatus;

  @override
  void initState() {
    super.initState();
    totalCellCount = (widget.height * widget.width).toInt() ~/
        (widget.cellSize * widget.cellSize);

    rowCount = widget.height ~/ widget.cellSize;
    colCount = widget.width ~/ widget.cellSize;

    cellStatus = List.filled(rowCount * colCount, _DEAD);

    final start1Row =
        Random().nextInt(rowCount - 3); // make sure there is space.
    final start1Col = Random().nextInt(colCount - 3);
    final start1Index = start1Row * colCount + start1Col;

    final start2Row = start1Row + 1;
    final start2Col = start1Col + 1;
    final start2Index = start2Row * colCount + start2Col;

    final start3Row = start1Row + 1;
    final start3Col = start1Col + 2;
    final start3Index = start3Row * colCount + start3Col;

    final start4Row = start1Row + 2;
    final start4Col = start1Col;
    final start4Index = start4Row * colCount + start4Col;

    final start5Row = start1Row + 2;
    final start5Col = start1Col + 1;
    final start5Index = start5Row * colCount + start5Col;

    aliveCells = {
      (start1Index),
      (start2Index),
      (start3Index),
      (start4Index),
      (start5Index),
    };

    for (final aliveCell in aliveCells) {
      cellStatus[aliveCell] = _ALIVE;
    }

    _rotationTween = Tween(begin: {}, end: aliveCells);

    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    animation = _rotationTween.animate(controller)
      ..addListener(() {
        setState(() {});
      });

    controller.forward();
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        nextGeneration();
        _rotationTween.end = aliveCells;
        controller.reset();
        controller.forward();
      }
    });
  }

  void nextGeneration() {
    final Set<int> deadCellCandidates = {};
    final Set<int> aliveCellCandidates = {};
    for (int r = 0; r < rowCount; r++) {
      for (int c = 0; c < colCount; c++) {
        final currentIndex = r * colCount + c;

        final topIndex = r - 1 >= 0 ? (r - 1) * colCount + c : -1;
        final topLeftIndex =
            r - 1 >= 0 && c - 1 >= 0 ? (r - 1) * colCount + (c - 1) : -1;
        final topRightIndex =
            r - 1 >= 0 && c + 1 < colCount ? (r - 1) * colCount + (c + 1) : -1;
        final leftIndex = c - 1 >= 0 ? r * colCount + (c - 1) : -1;
        final rightIndex = c + 1 < colCount ? r * colCount + (c + 1) : -1;
        final botIndex = r + 1 < rowCount ? (r + 1) * colCount + c : -1;
        final botLeftIndex =
            r + 1 < rowCount && c - 1 >= 0 ? (r + 1) * colCount + (c - 1) : -1;
        final botRightIndex = r + 1 < rowCount && c + 1 < colCount
            ? (r + 1) * colCount + (c + 1)
            : -1;

        final indexes = {
          topIndex,
          topLeftIndex,
          topRightIndex,
          leftIndex,
          rightIndex,
          botIndex,
          botLeftIndex,
          botRightIndex
        }..remove(-1);

        int aliveNeighbors = 0;

        for (int neighborIndex in indexes) {
          aliveNeighbors += cellStatus[neighborIndex];
        }

        if (aliveNeighbors < 2 || aliveNeighbors > 3) {
          deadCellCandidates.add(currentIndex);
        } else if (aliveNeighbors == 3 && !aliveCells.contains(currentIndex)) {
          aliveCellCandidates.add(currentIndex);
        }
      }
    }

    for (final deadCellIndex in deadCellCandidates) {
      cellStatus[deadCellIndex] = _DEAD;
      aliveCells.remove(deadCellIndex);
    }

    for (final aliveCellIndex in aliveCellCandidates) {
      cellStatus[aliveCellIndex] = _ALIVE;
      aliveCells.add(aliveCellIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.width, widget.height),
      painter: GameDisplayView(
        columnCount: colCount,
        rowCount: rowCount,
        cellSize: widget.cellSize,
        aliveColor: Colors.black,
        deadColor: Colors.white,
        aliveIndexes: aliveCells,
      ),
    );
  }
}

class GameDisplayView extends CustomPainter {
  final double cellGapSize;
  final Paint painter;

  final int rowCount;
  final double cellSize;
  final int columnCount;
  final Color aliveColor;
  final Color deadColor;
  final Set<int> aliveIndexes;

  GameDisplayView({
    required this.rowCount,
    required this.cellSize,
    required this.columnCount,
    required this.aliveColor,
    required this.deadColor,
    required this.aliveIndexes,
    this.cellGapSize = 1,
  }) : painter = Paint()
          ..strokeWidth = 1
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    for (int r = 0; r < rowCount; r++) {
      for (int c = 0; c < columnCount; c++) {
        final i = r * columnCount + c;

        if (aliveIndexes.contains(i)) {
          painter.color = aliveColor;
        } else {
          painter.color = deadColor;
        }

        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTWH(
                  getLeft1(c),
                  getTop1(r),
                  cellSize - cellGapSize,
                  cellSize - cellGapSize,
                ),
                const Radius.circular(1.0)),
            painter);
      }
    }
  }

  double getTop1(int rowIndex) {
    return rowIndex * cellSize;
  }

  double getLeft1(int colIndex) {
    return colIndex * cellSize;
  }

  @override
  bool shouldRepaint(GameDisplayView oldDelegate) => true;
  @override
  bool shouldRebuildSemantics(GameDisplayView oldDelegate) => true;
}

class CellCoordinate extends Equatable {
  final int x;
  final int y;

  const CellCoordinate(this.x, this.y);

  @override
  List<Object?> get props => [x, y];
}
