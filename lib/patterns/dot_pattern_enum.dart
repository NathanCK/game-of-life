import 'dart:math';

import 'package:equatable/equatable.dart';

enum DotPattern {
  glider(points: [
    Point(0, 0),
    Point(1, 1),
    Point(1, 2),
    Point(2, 0),
    Point(2, 1),
  ]),
  lightWeightSpaceship(points: [
    Point(0, 1),
    Point(0, 4),
    Point(1, 0),
    Point(2, 0),
    Point(2, 4),
    Point(3, 0),
    Point(3, 1),
    Point(3, 2),
    Point(3, 3),
  ]),
  middleWeightSpaceship(points: [
    Point(0, 3),
    Point(1, 1),
    Point(1, 5),
    Point(2, 0),
    Point(3, 0),
    Point(3, 5),
    Point(4, 0),
    Point(4, 1),
    Point(4, 2),
    Point(4, 3),
    Point(4, 4),
  ]),
  heavyWeightSpaceship(points: [
    Point(0, 3),
    Point(0, 4),
    Point(1, 1),
    Point(1, 6),
    Point(2, 0),
    Point(3, 0),
    Point(3, 6),
    Point(4, 0),
    Point(4, 1),
    Point(4, 2),
    Point(4, 3),
    Point(4, 4),
    Point(4, 5),
  ]),
  blinker(points: [
    Point(0, 0),
    Point(0, 1),
    Point(0, 2),
  ]),
  toad(points: [
    Point(0, 0),
    Point(1, 0),
    Point(1, 1),
    Point(2, 0),
    Point(2, 1),
    Point(3, 1),
  ]),
  beacon(points: [
    Point(0, 0),
    Point(0, 1),
    Point(1, 0),
    Point(1, 1),
    Point(2, 2),
    Point(2, 3),
    Point(3, 2),
    Point(3, 3),
  ]),
  // pulsar(points: []),
  // pentaDecathlon(points: []),
  block(points: [
    Point(0, 0),
    Point(0, 1),
    Point(1, 0),
    Point(1, 1),
  ]),
  beeHive(points: [
    Point(0, 1),
    Point(0, 2),
    Point(1, 0),
    Point(1, 3),
    Point(2, 1),
    Point(2, 2),
  ]),
  loaf(points: [
    Point(0, 1),
    Point(0, 2),
    Point(1, 0),
    Point(1, 3),
    Point(2, 1),
    Point(2, 3),
    Point(3, 2),
  ]),
  boat(points: [
    Point(0, 0),
    Point(0, 1),
    Point(1, 0),
    Point(1, 2),
    Point(2, 1),
  ]),
  tub(points: [
    Point(0, 1),
    Point(1, 0),
    Point(1, 2),
    Point(2, 1),
  ]),
  ;

  const DotPattern({required this.points});

  final List<Point> points;

  int get maxSpace =>
      points.fold(
          0, (previousValue, p) => max(previousValue, max(p.row, p.col))) +
      1;
}

class Point extends Equatable {
  final int row;
  final int col;

  const Point(this.row, this.col);

  @override
  List<Object?> get props => [row, col];
}
