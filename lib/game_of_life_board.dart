import 'package:conway_game_of_life/constant.dart';
import 'package:conway_game_of_life/cubit/game_control_cubit.dart';
import 'package:conway_game_of_life/game_controller_bar.dart';
import 'package:conway_game_of_life/game_of_life_engine.dart';
import 'package:conway_game_of_life/game_of_life_loop.dart';
import 'package:conway_game_of_life/painters/cells_painter.dart';
import 'package:conway_game_of_life/painters/game_board_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameOfLife extends StatelessWidget {
  final double cellSize;
  final bool showControlPanel;

  final bool autoStart;
  final Duration? speed;

  const GameOfLife({
    super.key,
    required this.cellSize,
    required this.showControlPanel,
    required this.autoStart,
    this.speed,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final gameSpeed = speed ?? DefaultGameSettings.speed;
    final rowCount = screenSize.height ~/ cellSize;
    final colCount = screenSize.width ~/ cellSize;

    return BlocProvider(
      create: (context) => GameControlCubit(
        autoStart: autoStart,
        speed: gameSpeed,
      ),
      child: _GameOfLifeBoard(
        width: screenSize.width,
        height: screenSize.height,
        cellSize: cellSize,
        autoStart: autoStart,
        showControlPanel: showControlPanel,
        rowCount: rowCount,
        colCount: colCount,
        speed: gameSpeed,
      ),
    );
  }
}

/// The main widget for the Game of Life board.
class _GameOfLifeBoard extends StatefulWidget {
  final double width;
  final double height;
  final double cellSize;
  final bool showControlPanel;

  final int rowCount;
  final int colCount;

  final bool autoStart;
  final Duration speed;

  const _GameOfLifeBoard({
    required this.height,
    required this.width,
    required this.cellSize,
    required this.autoStart,
    required this.showControlPanel,
    required this.speed,
    required this.rowCount,
    required this.colCount,
  });

  @override
  State<_GameOfLifeBoard> createState() => _GameOfLifeBoardState();
}

class _GameOfLifeBoardState extends State<_GameOfLifeBoard>
    with SingleTickerProviderStateMixin<_GameOfLifeBoard> {
  static const _defaultCellGap = 1.0;

  late final GameOfLifeLoop _loop;
  late final GameOfLifeEngine _engine;

  int _resetCount = 0;

  @override
  void initState() {
    super.initState();

    _engine = GameOfLifeEngine(
      colCount: widget.colCount,
      rowCount: widget.rowCount,
      cellSize: widget.cellSize,
    );

    _loop = GameOfLifeLoop(
      _engine,
      vsync: this,
      autoStart: widget.autoStart,
      speed: widget.speed,
    );
  }

  @override
  void didUpdateWidget(covariant _GameOfLifeBoard oldWidget) {
    if (oldWidget.colCount != widget.colCount ||
        oldWidget.rowCount != widget.rowCount) {
      _engine.resizeGameBoard(
        newColCount: widget.colCount,
        newRowCount: widget.rowCount,
        newCellSize: widget.cellSize,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final controlBar = widget.showControlPanel ? GameControllerBar() : null;
    final gridBackground = _buildGridBackground();

    return BlocListener<GameControlCubit, GameControlState>(
      listener: (context, state) {
        if (state.running) {
          _loop.resumeGame();
        } else if (!state.running) {
          _loop.pauseGame();
        }

        if (state.resetCount != _resetCount) {
          _resetCount = state.resetCount;
          _engine.resetGame();
        }

        if (state.speed != DefaultGameSettings.speed) {
          _loop.setSpeed(state.speed);
        }
      },
      child: Scaffold(
        backgroundColor: DefaultLightColors.dead,
        body: AnimatedBuilder(
          animation: _engine,
          builder: (context, child) {
            final cellsBoard = _buildCellsView(child: child);

            return cellsBoard;
          },
          child: gridBackground,
        ),
        floatingActionButton: controlBar,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildCellsView({Widget? child}) {
    return RepaintBoundary(
      child: CustomPaint(
        willChange: true,
        size: Size(widget.width, widget.height),
        foregroundPainter: CellsPainter(
          columnCount: widget.colCount,
          rowCount: widget.rowCount,
          cellSize: widget.cellSize,
          aliveColor: DefaultLightColors.alive,
          generation: _engine.generation,
          aliveCells: _engine.aliveCells,
          cellGapSize: _defaultCellGap,
        ),
        child: child,
      ),
    );
  }

  Widget _buildGridBackground() {
    return RepaintBoundary(
      child: CustomPaint(
        size: Size(widget.width, widget.height),
        painter: GameBoardPainter(
          columnCount: widget.colCount,
          rowCount: widget.rowCount,
          cellSize: widget.cellSize,
          lineColor: DefaultLightColors.gridLine,
          cellGapSize: _defaultCellGap,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _engine.dispose();
    _loop.dispose();
    super.dispose();
  }
}
