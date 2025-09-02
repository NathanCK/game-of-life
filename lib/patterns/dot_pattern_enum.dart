import 'package:conway_game_of_life/patterns/all_patterns.dart';
import 'package:conway_game_of_life/patterns/angle_enum.dart';
import 'package:conway_game_of_life/patterns/dot_pattern.dart';

enum DotPatternType {
  glider,
  lightWeightSpaceship,
  middleWeightSpaceship,
  heavyWeightSpaceship,
  blinker,
  toad,
  beacon,
  block,
  beeHive,
  loaf,
  boat,
  tub,
}

extension DotPatternTypeExtension on DotPatternType {
  static DotPattern getDotPatternObject(DotPatternType type, Angle angle) {
    switch (type) {
      case DotPatternType.glider:
        return Glider(angle: angle);
      case DotPatternType.lightWeightSpaceship:
        return LightWeightSpaceship(angle: angle);
      case DotPatternType.middleWeightSpaceship:
        return MiddleWeightSpaceship(angle: angle);
      case DotPatternType.heavyWeightSpaceship:
        return HeavyWeightSpaceship(angle: angle);
      case DotPatternType.blinker:
        return Blinker(angle: angle);
      case DotPatternType.toad:
        return Toad(angle: angle);
      case DotPatternType.beacon:
        return Beacon(angle: angle);
      case DotPatternType.block:
        return Block(angle: angle);
      case DotPatternType.beeHive:
        return BeeHive(angle: angle);
      case DotPatternType.loaf:
        return Loaf(angle: angle);
      case DotPatternType.boat:
        return Boat(angle: angle);
      case DotPatternType.tub:
        return Tub(angle: angle);
      }
  }
}

// enum DotPatternType {
//   glider(points: [
//     Cell(0, 0),
//     Cell(1, 1),
//     Cell(1, 2),
//     Cell(2, 0),
//     Cell(2, 1),
//   ]),
//   lightWeightSpaceship(points: [
//     Cell(0, 1),
//     Cell(0, 4),
//     Cell(1, 0),
//     Cell(2, 0),
//     Cell(2, 4),
//     Cell(3, 0),
//     Cell(3, 1),
//     Cell(3, 2),
//     Cell(3, 3),
//   ]),
//   middleWeightSpaceship(points: [
//     Cell(0, 3),
//     Cell(1, 1),
//     Cell(1, 5),
//     Cell(2, 0),
//     Cell(3, 0),
//     Cell(3, 5),
//     Cell(4, 0),
//     Cell(4, 1),
//     Cell(4, 2),
//     Cell(4, 3),
//     Cell(4, 4),
//   ]),
//   heavyWeightSpaceship(points: [
//     Cell(0, 3),
//     Cell(0, 4),
//     Cell(1, 1),
//     Cell(1, 6),
//     Cell(2, 0),
//     Cell(3, 0),
//     Cell(3, 6),
//     Cell(4, 0),
//     Cell(4, 1),
//     Cell(4, 2),
//     Cell(4, 3),
//     Cell(4, 4),
//     Cell(4, 5),
//   ]),
//   blinker(points: [
//     Cell(0, 0),
//     Cell(0, 1),
//     Cell(0, 2),
//   ]),
//   toad(points: [
//     Cell(0, 0),
//     Cell(1, 0),
//     Cell(1, 1),
//     Cell(2, 0),
//     Cell(2, 1),
//     Cell(3, 1),
//   ]),
//   beacon(points: [
//     Cell(0, 0),
//     Cell(0, 1),
//     Cell(1, 0),
//     Cell(1, 1),
//     Cell(2, 2),
//     Cell(2, 3),
//     Cell(3, 2),
//     Cell(3, 3),
//   ]),
//   // pulsar(points: []),
//   // pentaDecathlon(points: []),
//   block(points: [
//     Cell(0, 0),
//     Cell(0, 1),
//     Cell(1, 0),
//     Cell(1, 1),
//   ]),
//   beeHive(points: [
//     Cell(0, 1),
//     Cell(0, 2),
//     Cell(1, 0),
//     Cell(1, 3),
//     Cell(2, 1),
//     Cell(2, 2),
//   ]),
//   loaf(points: [
//     Cell(0, 1),
//     Cell(0, 2),
//     Cell(1, 0),
//     Cell(1, 3),
//     Cell(2, 1),
//     Cell(2, 3),
//     Cell(3, 2),
//   ]),
//   boat(points: [
//     Cell(0, 0),
//     Cell(0, 1),
//     Cell(1, 0),
//     Cell(1, 2),
//     Cell(2, 1),
//   ]),
//   tub(points: [
//     Cell(0, 1),
//     Cell(1, 0),
//     Cell(1, 2),
//     Cell(2, 1),
//   ]),
//   ;

//   const DotPatternType({required this.points});

//   final List<Cell> points;
// }

