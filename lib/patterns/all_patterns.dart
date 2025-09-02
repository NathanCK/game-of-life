import 'package:conway_game_of_life/patterns/dot_pattern.dart';

class Glider extends DotPattern {
  Glider({super.angle})
      : super(const [
          (row: 0, col: 0),
          (row: 1, col: 1),
          (row: 1, col: 2),
          (row: 2, col: 0),
          (row: 2, col: 1),
        ]);
}

class LightWeightSpaceship extends DotPattern {
  LightWeightSpaceship({super.angle})
      : super(const [
          (row: 0, col: 1),
          (row: 0, col: 4),
          (row: 1, col: 0),
          (row: 2, col: 0),
          (row: 2, col: 4),
          (row: 3, col: 0),
          (row: 3, col: 1),
          (row: 3, col: 2),
          (row: 3, col: 3),
        ]);
}

class MiddleWeightSpaceship extends DotPattern {
  MiddleWeightSpaceship({super.angle})
      : super(const [
          (row: 0, col: 3),
          (row: 1, col: 1),
          (row: 1, col: 5),
          (row: 2, col: 0),
          (row: 3, col: 0),
          (row: 3, col: 5),
          (row: 4, col: 0),
          (row: 4, col: 1),
          (row: 4, col: 2),
          (row: 4, col: 3),
          (row: 4, col: 4),
        ]);
}

class HeavyWeightSpaceship extends DotPattern {
  HeavyWeightSpaceship({super.angle})
      : super(const [
          (row: 0, col: 3),
          (row: 0, col: 4),
          (row: 1, col: 1),
          (row: 1, col: 6),
          (row: 2, col: 0),
          (row: 3, col: 0),
          (row: 3, col: 6),
          (row: 4, col: 0),
          (row: 4, col: 1),
          (row: 4, col: 2),
          (row: 4, col: 3),
          (row: 4, col: 4),
          (row: 4, col: 5),
        ]);
}

class Blinker extends DotPattern {
  Blinker({super.angle})
      : super(const [
          (row: 0, col: 0),
          (row: 0, col: 1),
          (row: 0, col: 2),
        ]);
}

class Toad extends DotPattern {
  Toad({super.angle})
      : super(const [
          (row: 0, col: 0),
          (row: 1, col: 0),
          (row: 1, col: 1),
          (row: 2, col: 0),
          (row: 2, col: 1),
          (row: 3, col: 1),
        ]);
}

class Beacon extends DotPattern {
  Beacon({super.angle})
      : super(const [
          (row: 0, col: 0),
          (row: 0, col: 1),
          (row: 1, col: 0),
          (row: 1, col: 1),
          (row: 2, col: 2),
          (row: 2, col: 3),
          (row: 3, col: 2),
          (row: 3, col: 3),
        ]);
}

class Block extends DotPattern {
  Block({super.angle})
      : super(const [
          (row: 0, col: 0),
          (row: 0, col: 1),
          (row: 1, col: 0),
          (row: 1, col: 1),
        ]);
}

class BeeHive extends DotPattern {
  BeeHive({super.angle})
      : super(const [
          (row: 0, col: 1),
          (row: 0, col: 2),
          (row: 1, col: 0),
          (row: 1, col: 3),
          (row: 2, col: 1),
          (row: 2, col: 2),
        ]);
}

class Loaf extends DotPattern {
  Loaf({super.angle})
      : super(const [
          (row: 0, col: 1),
          (row: 0, col: 2),
          (row: 1, col: 0),
          (row: 1, col: 3),
          (row: 2, col: 1),
          (row: 2, col: 3),
          (row: 3, col: 2),
        ]);
}

class Boat extends DotPattern {
  Boat({super.angle})
      : super(const [
          (row: 0, col: 0),
          (row: 0, col: 1),
          (row: 1, col: 0),
          (row: 1, col: 2),
          (row: 2, col: 1),
        ]);
}

class Tub extends DotPattern {
  Tub({super.angle})
      : super(const [
          (row: 0, col: 1),
          (row: 1, col: 0),
          (row: 1, col: 2),
          (row: 2, col: 1),
        ]);
}
