// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:conway_game_of_life/game_controller_bar.dart';
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
  late Animation<Set<int>> animation;
  late AnimationController controller;

  late final Tween<Set<int>> _rotationTween;

  late final Set<int> aliveCells;
  late final int rowCount;
  late final int colCount;

  @override
  void initState() {
    super.initState();

    rowCount = widget.height ~/ widget.cellSize;
    colCount = widget.width ~/ widget.cellSize;

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

    _rotationTween = Tween(begin: {}, end: {});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        size: Size(widget.width, widget.height),
        painter: GameDisplayView(
          columnCount: colCount,
          rowCount: rowCount,
          cellSize: widget.cellSize,
          aliveColor: Colors.black,
          deadColor: Colors.white,
          aliveIndexes: aliveCells,
        ),
      ),
      floatingActionButton: const GameControllerBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
