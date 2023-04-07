part of 'game_board_bloc.dart';

abstract class GameBoardState extends Equatable {
  const GameBoardState();

  @override
  List<Object> get props => [];
}

class GameBoardInitial extends GameBoardState {}

class GameBoardNextMoveSuccess extends GameBoardState {
  final Set<int> aliveCellIndexes;

  const GameBoardNextMoveSuccess(this.aliveCellIndexes);

  @override
  List<Object> get props => [setEquals];
}
