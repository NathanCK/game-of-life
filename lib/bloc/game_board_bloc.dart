import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:conway_game_of_life/patterns/angle_enum.dart';
import 'package:conway_game_of_life/patterns/dot_pattern_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'game_board_event.dart';
part 'game_board_state.dart';

class GameBoardBloc extends Bloc<GameBoardEvent, GameBoardState> {
  int colCount;
  int rowCount;
  double cellSize;
  final Set<int> aliveCells = {};
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

    add(GameInitialized());
  }

  void _onGameMoveCompleted(
      GameMoveCompleted event, Emitter<GameBoardState> emit) {
    _calculateNextMove();
    emit(GameBoardNextMoveSuccess(aliveCells));
  }

  void _calculateNextMove() {
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
          if (aliveCells.contains(neighborIndex)) aliveNeighbors++;
        }

        if (aliveNeighbors < 2 || aliveNeighbors > 3) {
          deadCellCandidates.add(currentIndex);
        } else if (aliveNeighbors == 3 && !aliveCells.contains(currentIndex)) {
          aliveCellCandidates.add(currentIndex);
        }
      }
    }

    for (final deadCellIndex in deadCellCandidates) {
      aliveCells.remove(deadCellIndex);
    }

    for (final aliveCellIndex in aliveCellCandidates) {
      aliveCells.add(aliveCellIndex);
    }
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
        final currentIndex = (startRow + p.row) * colCount + (startCol + p.col);
        aliveCells.add(currentIndex);
      }
    }
  }
}
