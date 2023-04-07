part of 'game_board_bloc.dart';

abstract class GameBoardEvent extends Equatable {
  const GameBoardEvent();

  @override
  List<Object> get props => [];
}

class GameMoveCompleted extends GameBoardEvent {}

class GameStarted extends GameBoardEvent {}

class GamePauseRequested extends GameBoardEvent {}
