import 'package:conway_game_of_life/constant.dart';
import 'package:flutter/material.dart';

import 'game_of_life_board.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conway\'s Game of Life',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameOfLife(
        cellSize: DefaultGameSettings.cellSize,
        showControlPanel: DefaultGameSettings.showControlPanel,
        autoStart: DefaultGameSettings.autoStart,
      ),
    );
  }
}
