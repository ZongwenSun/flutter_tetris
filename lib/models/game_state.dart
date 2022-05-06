import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class GameState extends ChangeNotifier {
  GameConfig config;
  List<Square> fixedSquares = [];

  Mino? currentMino;

  GameState(this.config) {
    currentMino = Mino.random();
    start();
  }

  void start() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentMino != null) {
        Mino downMino = currentMino!.down();
        if (allowMino(downMino)) {
          currentMino = downMino;
        } else {
          if (allowMino(currentMino!)) {
            addMino(currentMino!);
            currentMino = Mino.random();
          } else {
            currentMino = null;
          }
        }
      }
      notifyListeners();
    });
  }

  void onPressLeft() {
    Mino nextMino = currentMino!.left();
    if (allowMino(nextMino)) {
      currentMino = nextMino;
      notifyListeners();
    }
  }

  void onPressRight() {
    Mino nextMino = currentMino!.right();
    if (allowMino(nextMino)) {
      currentMino = nextMino;
      notifyListeners();
    }
  }

  bool allowMino(Mino mino) {
    return mino.squares.every((square) => allowSquare(square));
  }

  bool allowSquare(Square square) {
    bool inRange = square.col >= 0 && square.col < config.col && square.row >= 0 && square.row < config.row;
    if (!inRange) {
      return false;
    }
    bool alreadyExist = fixedSquares.any((e) => e.row == square.row && e.col == square.col);
    return !alreadyExist;
  }

  void addMino(Mino mino) {
    fixedSquares.addAll(mino.squares);
  }
}

class GameConfig {
  final int row;
  final int col;

  GameConfig({required this.row, required this.col});
}

class Square {
  int row = 0;
  int col = 0;

  Square({
    required this.row,
    required this.col,
  });
}

enum MinoType { I, O, S, Z, L, J, T }

class Mino {
  final MinoType type;
  final List<Square> squares;

  factory Mino.random() {
    int rand = Random().nextInt(MinoType.values.length);
    MinoType type = MinoType.values[rand];
    List<Square> squares;
    switch (type) {
      case MinoType.I:
        squares = [Square(row: 0, col: 0), Square(row: 0, col: 1), Square(row: 0, col: 2), Square(row: 0, col: 3)];
        break;
      case MinoType.J:
        squares = [Square(row: 0, col: 2), Square(row: 1, col: 0), Square(row: 1, col: 1), Square(row: 1, col: 2)];
        break;
      case MinoType.L:
        squares = [Square(row: 0, col: 0), Square(row: 1, col: 0), Square(row: 1, col: 1), Square(row: 1, col: 2)];
        break;
      case MinoType.O:
        squares = [Square(row: 0, col: 0), Square(row: 0, col: 1), Square(row: 1, col: 0), Square(row: 1, col: 1)];
        break;
      case MinoType.S:
        squares = [Square(row: 0, col: 1), Square(row: 0, col: 2), Square(row: 1, col: 0), Square(row: 1, col: 1)];
        break;
      case MinoType.T:
        squares = [Square(row: 0, col: 1), Square(row: 1, col: 0), Square(row: 1, col: 1), Square(row: 1, col: 2)];
        break;
      case MinoType.Z:
        squares = [Square(row: 0, col: 0), Square(row: 0, col: 1), Square(row: 1, col: 1), Square(row: 1, col: 2)];
    }
    return Mino(type, squares);
  }

  Mino(this.type, this.squares);

  Mino left() {
    return Mino(type, moveDelta(0, -1));
  }

  Mino down() {
    return Mino(type, moveDelta(1, 0));
  }

  Mino right() {
    return Mino(type, moveDelta(0, 1));
  }

  Mino up() {
    return Mino(type, moveDelta(-1, 0));
  }

  List<Square> moveDelta(int deltaRow, int deltaCol) {
    return squares.map((e) => Square(row: e.row + deltaRow, col: e.col + deltaCol)).toList();
  }
}
