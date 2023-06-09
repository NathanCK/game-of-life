part of 'game_board_bloc.dart';

abstract class GameBoardState extends Equatable {
  const GameBoardState();

  @override
  List<Object> get props => [];
}

class GameNotYetStarted extends GameBoardState {}

class GameBoardInitialSuccess extends GameBoardNextMoveSuccess {
  const GameBoardInitialSuccess(super.aliveCellIndexes);
}

class GameBoardNextMoveSuccess extends GameBoardState {
  final Set<Cell> aliveCellIndexes;

  const GameBoardNextMoveSuccess(this.aliveCellIndexes);

  @override
  List<Object> get props => [setEquals];
}

class GameBoardPauseSuccess extends GameBoardState {}

class GameBoardResumeSuccess extends GameBoardState {}

class GameBoardResetSuccess extends GameBoardNextMoveSuccess {
  const GameBoardResetSuccess(super.aliveCellIndexes);
}
