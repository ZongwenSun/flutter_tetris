

import 'dart:math';
import 'dart:ui';

class Square {
  final int y;
  final int x;

  const Square({
    required this.x,
    required this.y,
  });
}

enum MinoType { I, L, J, O, S, T, Z }

enum MinoState { up, right, down, left }

class SquareImage {
  final int color;

  SquareImage(this.color);
}

class Mino {
  static const minoSquares = [
    [
      [Square(x: 0, y: 2), Square(x: 1, y: 2), Square(x: 2, y: 2), Square(x: 3, y: 2)], // I up
      [Square(x: 2, y: 0), Square(x: 2, y: 1), Square(x: 2, y: 2), Square(x: 2, y: 3)], // I right
      [Square(x: 0, y: 1), Square(x: 1, y: 1), Square(x: 2, y: 1), Square(x: 3, y: 1)], // I down
      [Square(x: 1, y: 0), Square(x: 1, y: 1), Square(x: 1, y: 2), Square(x: 1, y: 3)], // I left
    ],
    [
      [Square(x: 0, y: 3), Square(x: 0, y: 2), Square(x: 1, y: 2), Square(x: 2, y: 2)], // L up
      [Square(x: 1, y: 1), Square(x: 1, y: 2), Square(x: 1, y: 3), Square(x: 2, y: 3)], // L right
      [Square(x: 0, y: 2), Square(x: 1, y: 2), Square(x: 2, y: 2), Square(x: 2, y: 1)], // L down
      [Square(x: 0, y: 1), Square(x: 1, y: 1), Square(x: 1, y: 2), Square(x: 1, y: 3)], // L left
    ],
    [
      [Square(x: 0, y: 3), Square(x: 0, y: 2), Square(x: 1, y: 2), Square(x: 2, y: 2)], // J up
      [Square(x: 1, y: 1), Square(x: 1, y: 2), Square(x: 1, y: 3), Square(x: 2, y: 3)], // J right
      [Square(x: 0, y: 2), Square(x: 1, y: 2), Square(x: 2, y: 2), Square(x: 2, y: 1)], // J down
      [Square(x: 0, y: 1), Square(x: 1, y: 1), Square(x: 1, y: 2), Square(x: 1, y: 3)], // J left
    ],
    [
      [Square(x: 1, y: 2), Square(x: 1, y: 3), Square(x: 2, y: 2), Square(x: 2, y: 3)], // O up
      [Square(x: 1, y: 2), Square(x: 1, y: 3), Square(x: 2, y: 2), Square(x: 2, y: 3)], // O right
      [Square(x: 1, y: 2), Square(x: 1, y: 3), Square(x: 2, y: 2), Square(x: 2, y: 3)], // O down
      [Square(x: 1, y: 2), Square(x: 1, y: 3), Square(x: 2, y: 2), Square(x: 2, y: 3)], // O left
    ],
    [
      [Square(x: 0, y: 2), Square(x: 1, y: 2), Square(x: 1, y: 3), Square(x: 2, y: 3)], // S up
      [Square(x: 1, y: 3), Square(x: 1, y: 2), Square(x: 2, y: 2), Square(x: 2, y: 1)], // S right
      [Square(x: 0, y: 1), Square(x: 1, y: 1), Square(x: 1, y: 2), Square(x: 2, y: 2)], // S down
      [Square(x: 0, y: 3), Square(x: 0, y: 2), Square(x: 1, y: 2), Square(x: 1, y: 1)], // S left
    ],
    [
      [Square(x: 0, y: 2), Square(x: 1, y: 2), Square(x: 2, y: 2), Square(x: 1, y: 3)], // T up
      [Square(x: 1, y: 1), Square(x: 1, y: 2), Square(x: 1, y: 3), Square(x: 2, y: 2)], // T right
      [Square(x: 0, y: 2), Square(x: 1, y: 2), Square(x: 2, y: 2), Square(x: 1, y: 1)], // T down
      [Square(x: 1, y: 1), Square(x: 1, y: 2), Square(x: 1, y: 3), Square(x: 0, y: 2)], // T left
    ],
    [
      [Square(x: 0, y: 3), Square(x: 1, y: 3), Square(x: 1, y: 2), Square(x: 2, y: 2)], // Z up
      [Square(x: 1, y: 1), Square(x: 1, y: 2), Square(x: 2, y: 2), Square(x: 2, y: 3)], // Z right
      [Square(x: 0, y: 2), Square(x: 1, y: 2), Square(x: 1, y: 1), Square(x: 2, y: 1)], // Z down
      [Square(x: 0, y: 1), Square(x: 0, y: 2), Square(x: 1, y: 2), Square(x: 1, y: 3)], // Z left
    ],
  ];

  static List<Color> colors = [
    const Color(0x902DFFFE),
    const Color(0x900B24F8),
    const Color(0x90FDA929),
    const Color(0x90FBF993),
    const Color(0x902AF82D),
    const Color(0x909E26F9),
    const Color(0x90FC0B1D),
  ];

  final MinoType type;
  MinoState state;
  int x;
  int y;

  factory Mino.random(int x, int y) {
    int rand = Random().nextInt(MinoType.values.length);
    MinoType type = MinoType.values[rand];
    return Mino(type, MinoState.up, x, y);
  }

  Mino(this.type, this.state, this.x, this.y);

  Mino clone() => Mino(type, state, x, y);

  SquareImage get color => SquareImage(colors[type.index].value);

  List<Square> get squares {
    List<Square> squares = minoSquares[type.index][state.index];
    return squares.map((e) => Square(x: e.x + x, y: e.y + y)).toList();
  }

  void left() {
    x--;
  }

  void down() {
    y--;
  }

  void right() {
    x++;
  }

  void moveDelta(int dx, int dy) {
    x += dx;
    y += dy;
  }

  void rotateRight() {
    int newIndex = (state.index + 1) % MinoState.values.length;
    state = MinoState.values[newIndex];
  }

  void rotateLeft() {
    int newIndex = (state.index - 1) % MinoState.values.length;
    state = MinoState.values[newIndex];
  }
}
