part of 'game_control_cubit.dart';

class GameControlState extends Equatable {
  final bool running;
  final int resetCount;
  final Duration speed;

  const GameControlState({
    this.running = false,
    this.resetCount = 0,
    required this.speed,
  });

  GameControlState copyWith({
    bool? running,
    int? resetCount,
    Duration? speed,
  }) {
    return GameControlState(
      running: running ?? this.running,
      resetCount: resetCount ?? this.resetCount,
      speed: speed ?? this.speed,
    );
  }

  @override
  List<Object> get props => [running, resetCount, speed];
}
