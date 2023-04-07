// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:conway_game_of_life/game_controller_bar.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/game_board_bloc.dart';

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

  late final Tween<Set<int>> _displayTween;

  late final int rowCount;
  late final int colCount;
  late final GameBoardBloc _gameBoardBloc;

  Set<int> aliveIndexes = {};

  @override
  void initState() {
    super.initState();

    rowCount = widget.height ~/ widget.cellSize;
    colCount = widget.width ~/ widget.cellSize;

    _gameBoardBloc = GameBoardBloc(
        colCount: colCount, rowCount: rowCount, cellSize: widget.cellSize);

    _displayTween = Tween(begin: {}, end: {});

    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    animation = _displayTween.animate(controller)..addListener(animateListener);

    controller.forward();
    controller.addStatusListener(animateStatusListener);
  }

  void animateListener() {
    setState(() {});
  }

  void animateStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _gameBoardBloc.add(GameMoveCompleted());
      controller.reset();
      controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<GameBoardBloc, GameBoardState>(
        bloc: _gameBoardBloc,
        listener: (context, state) {
          if (state is GameBoardNextMoveSuccess) {
            _displayTween.end = state.aliveCellIndexes;
          }

          if (state is GameBoardNextMoveSuccess) {
            aliveIndexes = state.aliveCellIndexes;
          }

          if (state is GameBoardPauseSuccess) {
            controller.stop();
          }
        },
        builder: (context, state) {
          if (state is GameBoardNextMoveSuccess) {
            aliveIndexes = state.aliveCellIndexes;
          }

          return CustomPaint(
            size: Size(widget.width, widget.height),
            painter: GameDisplayView(
              columnCount: colCount,
              rowCount: rowCount,
              cellSize: widget.cellSize,
              aliveColor: Colors.black,
              deadColor: Colors.white,
              aliveIndexes: aliveIndexes,
            ),
          );
        },
      ),
      floatingActionButton: GameControllerBar(
        gameBoardBloc: _gameBoardBloc,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  void dispose() {
    animation.removeListener(animateListener);
    animation.removeStatusListener(animateStatusListener);
    controller.removeListener(animateListener);
    controller.removeStatusListener(animateStatusListener);

    controller.dispose();
    _gameBoardBloc.close();

    super.dispose();
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
