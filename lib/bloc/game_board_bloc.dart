import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:conway_game_of_life/patterns/angle_enum.dart';
import 'package:conway_game_of_life/patterns/cell.dart';
import 'package:conway_game_of_life/patterns/dot_pattern_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'game_board_event.dart';
part 'game_board_state.dart';

class GameBoardBloc extends Bloc<GameBoardEvent, GameBoardState> {
  int colCount;
  int rowCount;
  double cellSize;
  final Set<Cell> aliveCells = {};
  final bool _shouldAutoStart;

  GameBoardBloc({
    required this.colCount,
    required this.rowCount,
    required this.cellSize,
    bool shouldAutoStart = false,
  })  : _shouldAutoStart = shouldAutoStart,
        super(GameNotYetStarted()) {
    on<GameInitialized>(_onGameInitialized);
    on<GameMoveCompleted>(_onGameMoveCompleted);
    on<GamePauseRequested>(_onGamePauseRequested);
    on<GameResumeRequested>(_onGameResumeRequested);
    on<GameResetRequested>(_onGameResetRequested);
    on<GameBoardSizeChanged>(_onGameBoardSizeChanged);

    add(GameInitialized());
  }

  void _onGameMoveCompleted(
      GameMoveCompleted event, Emitter<GameBoardState> emit) {
    _calculateNextMove();
    emit(GameBoardNextMoveSuccess(aliveCells));
  }

  void _calculateNextMove() {
    final Set<Cell> deadCellCandidates = {};
    final Set<Cell> aliveCellCandidates = {};
    for (int r = 0; r < rowCount; r++) {
      for (int c = 0; c < colCount; c++) {
        final currentCell = Cell(r, c);
        final Set<Cell> neighborCells = {};

        if (r - 1 >= 0) {
          neighborCells.add(Cell(r - 1, c));
        }

        if (r - 1 >= 0 && c - 1 >= 0) {
          neighborCells.add(Cell(r - 1, c - 1));
        }

        if (r - 1 >= 0 && c + 1 < colCount) {
          neighborCells.add(Cell(r - 1, c + 1));
        }

        if (c - 1 >= 0) {
          neighborCells.add(Cell(r, c - 1));
        }

        if (c + 1 < colCount) {
          neighborCells.add(Cell(r, c + 1));
        }

        if (r + 1 < rowCount) {
          neighborCells.add(Cell(r + 1, c));
        }

        if (r + 1 < rowCount && c - 1 >= 0) {
          neighborCells.add(Cell(r + 1, c - 1));
        }

        if (r + 1 < rowCount && c + 1 < colCount) {
          neighborCells.add(Cell(r + 1, c + 1));
        }

        int aliveNeighbors = 0;

        for (Cell neighborCell in neighborCells) {
          if (aliveCells.contains(neighborCell)) aliveNeighbors++;
        }

        if (aliveNeighbors < 2 || aliveNeighbors > 3) {
          deadCellCandidates.add(currentCell);
        } else if (aliveNeighbors == 3 && !aliveCells.contains(currentCell)) {
          aliveCellCandidates.add(currentCell);
        }
      }
    }

    aliveCells.removeAll(deadCellCandidates);
    aliveCells.addAll(aliveCellCandidates);
  }

  void _onGameInitialized(GameInitialized event, Emitter<GameBoardState> emit) {
    _generateRandomStartingPoints();

    if (_shouldAutoStart) {
      emit(GameBoardNextMoveSuccess(aliveCells));
    } else {
      emit(GameBoardInitialSuccess(aliveCells));
    }
  }

  void _onGamePauseRequested(
      GamePauseRequested event, Emitter<GameBoardState> emit) {
    emit(GameBoardPauseSuccess());
  }

  void _onGameResumeRequested(
      GameResumeRequested event, Emitter<GameBoardState> emit) {
    emit(GameBoardResumeSuccess());
  }

  void _onGameResetRequested(
      GameResetRequested event, Emitter<GameBoardState> emit) {
    aliveCells.clear();

    _generateRandomStartingPoints();
    emit(GameBoardResetSuccess(aliveCells));
  }

  void _generateRandomStartingPoints() {
    final totalPatterns = Random().nextInt(20) + 10;

    for (var count = 0; count < totalPatterns; count++) {
      const allPatterns = DotPatternType.values;
      final patternType = allPatterns[Random().nextInt(allPatterns.length - 1)];
      const allDegree = Angle.values;
      final randomDegree = allDegree[Random().nextInt(allDegree.length - 1)];
      final pattern = DotPatternTypeExtension.getDotPatternObject(
          patternType, randomDegree);
      final maxSpace = pattern.maxSpace;
      final startRow = Random().nextInt(rowCount - maxSpace);
      final startCol = Random().nextInt(colCount - maxSpace);
      for (int i = 0; i < pattern.cells.length; i++) {
        final p = pattern.cells[i];
        final startRowIndex = startRow + p.row;
        final startColIndex = startCol + p.col;
        aliveCells.add(Cell(startRowIndex, startColIndex));
      }
    }
  }

  void _onGameBoardSizeChanged(
      GameBoardSizeChanged event, Emitter<GameBoardState> emit) {
    colCount = event.newColCount;
    rowCount = event.newRowCount;
    cellSize = event.newCellSize;
  }
}
