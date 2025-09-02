import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:conway_game_of_life/constant.dart';
import 'package:conway_game_of_life/patterns/angle_enum.dart';
import 'package:conway_game_of_life/patterns/cell.dart';
import 'package:conway_game_of_life/patterns/dot_pattern_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:synchronized/synchronized.dart';

part 'game_board_event.dart';
part 'game_board_state.dart';

class GameBoardBloc extends Bloc<GameBoardEvent, GameBoardState> {
  int colCount;
  int rowCount;
  double cellSize;
  final Set<Cell> aliveCells = {};
  final bool _shouldAutoStart;
  List<List<int>> _gameBoard;
  final Lock _screenLock = Lock();

  GameBoardBloc({
    required this.colCount,
    required this.rowCount,
    required this.cellSize,
    bool shouldAutoStart = false,
  })  : _shouldAutoStart = shouldAutoStart,
        _gameBoard = List.generate(rowCount,
            (_) => List.filled(colCount, Constant.dead, growable: true)),
        super(GameNotYetStarted()) {
    on<GameInitialized>(_onGameInitialized);
    on<GameMoveCompleted>(
      _onGameMoveCompleted,
      transformer: sequential(),
    );
    on<GamePauseRequested>(_onGamePauseRequested);
    on<GameResumeRequested>(_onGameResumeRequested);
    on<GameResetRequested>(_onGameResetRequested);
    on<GameBoardSizeChanged>(
      _onGameBoardSizeChanged,
      transformer: sequential(),
    );
    add(GameInitialized());
  }

  Future<void> _onGameMoveCompleted(
      GameMoveCompleted event, Emitter<GameBoardState> emit) async {
    await _screenLock.synchronized(() => _calculateNextMove());

    emit(GameBoardNextMoveSuccess(aliveCells));
  }

  void _calculateNextMove() {
    final Set<Cell> deadCellCandidates = {};
    final Set<Cell> aliveCellCandidates = {};
    for (int r = 0; r < rowCount; r++) {
      for (int c = 0; c < colCount; c++) {
        int aliveNeighbors = 0;

        if (r - 1 >= 0 && _gameBoard[r - 1][c] == Constant.alive) {
          aliveNeighbors++;
        }

        if (r - 1 >= 0 &&
            c - 1 >= 0 &&
            _gameBoard[r - 1][c - 1] == Constant.alive) {
          aliveNeighbors++;
        }

        if (r - 1 >= 0 &&
            c + 1 < colCount &&
            _gameBoard[r - 1][c + 1] == Constant.alive) {
          aliveNeighbors++;
        }

        if (c - 1 >= 0 && _gameBoard[r][c - 1] == Constant.alive) {
          aliveNeighbors++;
        }

        if (c + 1 < colCount && _gameBoard[r][c + 1] == Constant.alive) {
          aliveNeighbors++;
        }

        if (r + 1 < rowCount && _gameBoard[r + 1][c] == Constant.alive) {
          aliveNeighbors++;
        }

        if (r + 1 < rowCount &&
            c - 1 >= 0 &&
            _gameBoard[r + 1][c - 1] == Constant.alive) {
          aliveNeighbors++;
        }

        if (r + 1 < rowCount &&
            c + 1 < colCount &&
            _gameBoard[r + 1][c + 1] == Constant.alive) {
          aliveNeighbors++;
        }

        final Cell currentCell = (row: r, col: c);

        if (_gameBoard[r][c] == Constant.alive &&
            (aliveNeighbors < 2 || aliveNeighbors > 3)) {
          deadCellCandidates.add(currentCell);
        } else if (_gameBoard[r][c] != Constant.alive && aliveNeighbors == 3) {
          aliveCellCandidates.add(currentCell);
        }
      }
    }

    for (var deadCellCandidate in deadCellCandidates) {
      _gameBoard[deadCellCandidate.row][deadCellCandidate.col] = Constant.dead;
    }

    for (var aliveCellCandidate in aliveCellCandidates) {
      _gameBoard[aliveCellCandidate.row][aliveCellCandidate.col] =
          Constant.alive;
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
    _gameBoard = List.generate(
        rowCount, (_) => List.filled(colCount, Constant.dead, growable: true));

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
        aliveCells.add((row: startRowIndex, col: startColIndex));
        _gameBoard[startRowIndex][startColIndex] = Constant.alive;
      }
    }
  }

  Future<void> _onGameBoardSizeChanged(
      GameBoardSizeChanged event, Emitter<GameBoardState> emit) async {
    await _screenLock.synchronized(() {
      final currentMapRowCount = _gameBoard.length;
      final currentMapColCount = _gameBoard[0].length;
      if (event.newColCount > currentMapColCount &&
          event.newRowCount > currentMapRowCount) {
        for (var i = 0; i < event.newRowCount; i++) {
          if (i < currentMapRowCount) {
            _gameBoard[i].addAll(List.filled(
                event.newColCount - currentMapColCount, Constant.dead));
          } else {
            _gameBoard.add(
                List.filled(event.newColCount, Constant.dead, growable: true));
          }
        }
      } else if (event.newColCount > currentMapColCount) {
        for (var i = 0; i < _gameBoard.length; i++) {
          _gameBoard[i].addAll(List.filled(
              event.newColCount - currentMapColCount, Constant.dead));
        }
      } else if (event.newRowCount > currentMapRowCount) {
        final extraRowCount = List.generate(
            event.newRowCount - currentMapRowCount,
            (_) =>
                List.filled(currentMapColCount, Constant.dead, growable: true));
        _gameBoard.addAll(extraRowCount);
      }

      colCount = event.newColCount;
      rowCount = event.newRowCount;
      cellSize = event.newCellSize;
    });
  }
}
