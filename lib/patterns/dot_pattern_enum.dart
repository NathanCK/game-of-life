import 'dart:math';

import 'package:equatable/equatable.dart';

enum DotPattern {
  glider(points: [
    Cell(0, 0),
    Cell(1, 1),
    Cell(1, 2),
    Cell(2, 0),
    Cell(2, 1),
  ]),
  lightWeightSpaceship(points: [
    Cell(0, 1),
    Cell(0, 4),
    Cell(1, 0),
    Cell(2, 0),
    Cell(2, 4),
    Cell(3, 0),
    Cell(3, 1),
    Cell(3, 2),
    Cell(3, 3),
  ]),
  middleWeightSpaceship(points: [
    Cell(0, 3),
    Cell(1, 1),
    Cell(1, 5),
    Cell(2, 0),
    Cell(3, 0),
    Cell(3, 5),
    Cell(4, 0),
    Cell(4, 1),
    Cell(4, 2),
    Cell(4, 3),
    Cell(4, 4),
  ]),
  heavyWeightSpaceship(points: [
    Cell(0, 3),
    Cell(0, 4),
    Cell(1, 1),
    Cell(1, 6),
    Cell(2, 0),
    Cell(3, 0),
    Cell(3, 6),
    Cell(4, 0),
    Cell(4, 1),
    Cell(4, 2),
    Cell(4, 3),
    Cell(4, 4),
    Cell(4, 5),
  ]),
  blinker(points: [
    Cell(0, 0),
    Cell(0, 1),
    Cell(0, 2),
  ]),
  toad(points: [
    Cell(0, 0),
    Cell(1, 0),
    Cell(1, 1),
    Cell(2, 0),
    Cell(2, 1),
    Cell(3, 1),
  ]),
  beacon(points: [
    Cell(0, 0),
    Cell(0, 1),
    Cell(1, 0),
    Cell(1, 1),
    Cell(2, 2),
    Cell(2, 3),
    Cell(3, 2),
    Cell(3, 3),
  ]),
  // pulsar(points: []),
  // pentaDecathlon(points: []),
  block(points: [
    Cell(0, 0),
    Cell(0, 1),
    Cell(1, 0),
    Cell(1, 1),
  ]),
  beeHive(points: [
    Cell(0, 1),
    Cell(0, 2),
    Cell(1, 0),
    Cell(1, 3),
    Cell(2, 1),
    Cell(2, 2),
  ]),
  loaf(points: [
    Cell(0, 1),
    Cell(0, 2),
    Cell(1, 0),
    Cell(1, 3),
    Cell(2, 1),
    Cell(2, 3),
    Cell(3, 2),
  ]),
  boat(points: [
    Cell(0, 0),
    Cell(0, 1),
    Cell(1, 0),
    Cell(1, 2),
    Cell(2, 1),
  ]),
  tub(points: [
    Cell(0, 1),
    Cell(1, 0),
    Cell(1, 2),
    Cell(2, 1),
  ]),
  ;

  const DotPattern({required this.points});

  final List<Cell> points;

  int get maxSpace =>
      points.fold(
          0, (previousValue, p) => max(previousValue, max(p.row, p.col))) +
      1;
}

class Cell extends Equatable {
  final int row;
  final int col;

  const Cell(this.row, this.col);

  @override
  List<Object?> get props => [row, col];
}
