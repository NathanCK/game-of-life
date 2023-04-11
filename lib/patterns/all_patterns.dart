import 'package:conway_game_of_life/patterns/cell.dart';
import 'package:conway_game_of_life/patterns/dot_pattern.dart';

class Glider extends DotPattern {
  Glider({super.angle})
      : super(const [
          Cell(0, 0),
          Cell(1, 1),
          Cell(1, 2),
          Cell(2, 0),
          Cell(2, 1),
        ]);
}

class LightWeightSpaceship extends DotPattern {
  LightWeightSpaceship({super.angle})
      : super(const [
          Cell(0, 1),
          Cell(0, 4),
          Cell(1, 0),
          Cell(2, 0),
          Cell(2, 4),
          Cell(3, 0),
          Cell(3, 1),
          Cell(3, 2),
          Cell(3, 3),
        ]);
}

class MiddleWeightSpaceship extends DotPattern {
  MiddleWeightSpaceship({super.angle})
      : super(const [
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
        ]);
}

class HeavyWeightSpaceship extends DotPattern {
  HeavyWeightSpaceship({super.angle})
      : super(const [
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
        ]);
}

class Blinker extends DotPattern {
  Blinker({super.angle})
      : super(const [
          Cell(0, 0),
          Cell(0, 1),
          Cell(0, 2),
        ]);
}

class Toad extends DotPattern {
  Toad({super.angle})
      : super(const [
          Cell(0, 0),
          Cell(1, 0),
          Cell(1, 1),
          Cell(2, 0),
          Cell(2, 1),
          Cell(3, 1),
        ]);
}

class Beacon extends DotPattern {
  Beacon({super.angle})
      : super(const [
          Cell(0, 0),
          Cell(0, 1),
          Cell(1, 0),
          Cell(1, 1),
          Cell(2, 2),
          Cell(2, 3),
          Cell(3, 2),
          Cell(3, 3),
        ]);
}

class Block extends DotPattern {
  Block({super.angle})
      : super(const [
          Cell(0, 0),
          Cell(0, 1),
          Cell(1, 0),
          Cell(1, 1),
        ]);
}

class BeeHive extends DotPattern {
  BeeHive({super.angle})
      : super(const [
          Cell(0, 1),
          Cell(0, 2),
          Cell(1, 0),
          Cell(1, 3),
          Cell(2, 1),
          Cell(2, 2),
        ]);
}

class Loaf extends DotPattern {
  Loaf({super.angle})
      : super(const [
          Cell(0, 1),
          Cell(0, 2),
          Cell(1, 0),
          Cell(1, 3),
          Cell(2, 1),
          Cell(2, 3),
          Cell(3, 2),
        ]);
}

class Boat extends DotPattern {
  Boat({super.angle})
      : super(const [
          Cell(0, 0),
          Cell(0, 1),
          Cell(1, 0),
          Cell(1, 2),
          Cell(2, 1),
        ]);
}

class Tub extends DotPattern {
  Tub({super.angle})
      : super(const [
          Cell(0, 1),
          Cell(1, 0),
          Cell(1, 2),
          Cell(2, 1),
        ]);
}
