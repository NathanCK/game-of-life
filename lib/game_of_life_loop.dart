import 'package:conway_game_of_life/game_of_life_engine.dart';
import 'package:flutter/scheduler.dart';

class GameOfLifeLoop {
  final GameOfLifeEngine engine;
  Duration _speed;

  late final Ticker _ticker;
  Duration _elapsed = Duration.zero;

  GameOfLifeLoop(
    this.engine, {
    required TickerProvider vsync,
    required Duration speed,
    required bool autoStart,
  }) : _speed = speed {
    _ticker = vsync.createTicker(_onTick);
    if (autoStart) {
      _ticker.start();
    }
  }

  Future<void> _onTick(Duration elapsed) async {
    final delta = elapsed - _elapsed;

    if ((_elapsed != Duration.zero && delta < _speed)) {
      return;
    }

    _elapsed = elapsed;
    engine.calculateNextMove();
  }

  bool get running => _ticker.isTicking;

  void resumeGame() {
    if (running) return;
    _ticker.start();
  }

  void pauseGame() {
    if (!running) return;
    _elapsed = Duration.zero;
    _ticker.stop(canceled: false);
  }

  void setSpeed(Duration speed) {
    _speed = speed;
  }

  void dispose() {
    _ticker.dispose();
  }
}
