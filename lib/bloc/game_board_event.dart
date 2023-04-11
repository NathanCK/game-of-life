part of 'game_board_bloc.dart';

abstract class GameBoardEvent extends Equatable {
  const GameBoardEvent();

  @override
  List<Object> get props => [];
}

class GameMoveCompleted extends GameBoardEvent {}

class GameInitialized extends GameBoardEvent {}

class GamePauseRequested extends GameBoardEvent {}

class GameResumeRequested extends GameBoardEvent {}

class GameResetRequested extends GameBoardEvent {}

class GameBoardSizeChanged extends GameBoardEvent {
  final int newColCount;
  final int newRowCount;
  final double newCellSize;

  const GameBoardSizeChanged({
    required this.newColCount,
    required this.newRowCount,
    required this.newCellSize,
  });

  @override
  List<Object> get props => [newColCount, newCellSize, newRowCount];
}
