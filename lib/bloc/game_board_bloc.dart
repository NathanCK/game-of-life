import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../constant.dart';

part 'game_board_event.dart';
part 'game_board_state.dart';

class GameBoardBloc extends Bloc<GameBoardEvent, GameBoardState> {
  final int colCount;
  final int rowCount;
  final double cellSize;
  final List<int> cellStatus;
  final Set<int> aliveCells = {};

  GameBoardBloc({
    required this.colCount,
    required this.rowCount,
    required this.cellSize,
  })  : cellStatus = List.filled(rowCount * colCount, Constant.dead),
        super(GameBoardInitial()) {
    on<GameStarted>(onGameStarted);
    on<GameMoveCompleted>(_onGameMoveCompleted);
    add(GameStarted());
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
      cellStatus[deadCellIndex] = Constant.dead;
      aliveCells.remove(deadCellIndex);
    }

    for (final aliveCellIndex in aliveCellCandidates) {
      cellStatus[aliveCellIndex] = Constant.alive;
      aliveCells.add(aliveCellIndex);
    }
  }

  void onGameStarted(GameStarted event, Emitter<GameBoardState> emit) {
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

    aliveCells.addAll({
      (start1Index),
      (start2Index),
      (start3Index),
      (start4Index),
      (start5Index),
    });

    for (final aliveCell in aliveCells) {
      cellStatus[aliveCell] = Constant.alive;
    }

    emit(GameBoardNextMoveSuccess(aliveCells));
  }
}
