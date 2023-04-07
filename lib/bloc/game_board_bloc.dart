import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'game_board_event.dart';
part 'game_board_state.dart';

class GameBoardBloc extends Bloc<GameBoardEvent, GameBoardState> {
  GameBoardBloc() : super(GameBoardInitial()) {
    on<GameBoardEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
