import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'game_control_state.dart';

class GameControlCubit extends Cubit<GameControlState> {
  GameControlCubit({
    required bool autoStart,
    required Duration speed,
  }) : super(GameControlState(running: autoStart, speed: speed));

  void startGame() {
    emit(state.copyWith(running: true));
  }

  void stopGame() {
    emit(state.copyWith(running: false));
  }

  void resetGame() {
    emit(state.copyWith(running: false, resetCount: state.resetCount + 1));
  }

  void setSpeed(Duration speed) {
    emit(state.copyWith(speed: speed));
  }
}
