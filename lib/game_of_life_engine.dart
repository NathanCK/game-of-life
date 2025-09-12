import 'dart:math';

import 'package:conway_game_of_life/constant.dart';
import 'package:conway_game_of_life/patterns/angle_enum.dart';
import 'package:conway_game_of_life/patterns/cell.dart';
import 'package:conway_game_of_life/patterns/dot_pattern_enum.dart';
import 'package:flutter/widgets.dart';

class GameOfLifeEngine with ChangeNotifier {
  Set<Cell> _aliveCells = {};
  int _generation = 0;

  int colCount;
  int rowCount;
  double cellSize;

  List<List<int>> _gameBoard;

  Set<Cell> get aliveCells => _aliveCells;

  int get generation => _generation;

  GameOfLifeEngine({
    required this.colCount,
    required this.rowCount,
    required this.cellSize,
  }) : _gameBoard = List.generate(rowCount,
            (_) => List.filled(colCount, Constant.dead, growable: true)) {
    _initializeGame();
  }
  void _initializeGame() {
    _generateRandomStartingPoints();

    notifyListeners();
  }

  void _generateRandomStartingPoints() {
    final totalPatterns = Random().nextInt(20) + 40;

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
        _aliveCells.add((row: startRowIndex, col: startColIndex));
        _gameBoard[startRowIndex][startColIndex] = Constant.alive;
      }
    }
  }

  void resetGame() {
    _generation = 0;
    _aliveCells = {};
    _gameBoard = List.generate(
        rowCount, (_) => List.filled(colCount, Constant.dead, growable: true));

    _generateRandomStartingPoints();
    notifyListeners();
  }

  void resizeGameBoard({
    required int newColCount,
    required int newRowCount,
    required double newCellSize,
  }) {
    final currentMapRowCount = _gameBoard.length;
    final currentMapColCount = _gameBoard[0].length;
    if (newColCount > currentMapColCount && newRowCount > currentMapRowCount) {
      for (var i = 0; i < newRowCount; i++) {
        if (i < currentMapRowCount) {
          _gameBoard[i].addAll(
              List.filled(newColCount - currentMapColCount, Constant.dead));
        } else {
          _gameBoard
              .add(List.filled(newColCount, Constant.dead, growable: true));
        }
      }
    } else if (newColCount > currentMapColCount) {
      for (var i = 0; i < _gameBoard.length; i++) {
        _gameBoard[i].addAll(
            List.filled(newColCount - currentMapColCount, Constant.dead));
      }
    } else if (newRowCount > currentMapRowCount) {
      final extraRowCount = List.generate(
          newRowCount - currentMapRowCount,
          (_) =>
              List.filled(currentMapColCount, Constant.dead, growable: true));
      _gameBoard.addAll(extraRowCount);
    }

    colCount = newColCount;
    rowCount = newRowCount;
    cellSize = newCellSize;
  }

  void calculateNextMove() {
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

    _aliveCells.removeAll(deadCellCandidates);
    _aliveCells.addAll(aliveCellCandidates);

    _generation++;
    notifyListeners();
  }
}
