part of 'game_board_bloc.dart';

abstract class GameBoardState extends Equatable {
  const GameBoardState();
  
  @override
  List<Object> get props => [];
}

class GameBoardInitial extends GameBoardState {}
