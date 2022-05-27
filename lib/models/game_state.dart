import 'dart:async';

import 'package:flutter/material.dart';

import 'mino.dart';

class GameConfig {
  final int row;
  final int col;

  GameConfig({required this.row, required this.col});
}

class GameState extends ChangeNotifier {
  GameConfig config;
  late List<List<SquareImage?>> squares;

  Mino? currentMino;

  late int bornX;
  late int bornY;

  GameState(this.config) {
    squares = List.generate(config.row, (index) => List.filled(config.col, null));

    bornX = config.col ~/ 2 - 2;
    bornY = config.row - 4;
    currentMino = Mino.random(bornX, bornY);
    start();
  }

  void start() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentMino != null) {
        Mino downMino = currentMino!.clone()..down();
        if (allowMino(downMino)) {
          currentMino = downMino;
        } else {
          if (allowMino(currentMino!)) {
            addMino(currentMino!);
            check(currentMino!.squares);
            currentMino = Mino.random(bornX, bornY);
          } else {
            currentMino = null;
          }
        }
      }
      notifyListeners();
    });
  }

  void onPressLeft() {
    if (currentMino == null) {
      return;
    }
    Mino nextMino = currentMino!.clone()..left();
    if (allowMino(nextMino)) {
      currentMino = nextMino;
      notifyListeners();
    }
  }

  void onPressRight() {
    if (currentMino == null) {
      return;
    }
    Mino nextMino = currentMino!.clone()..right();
    if (allowMino(nextMino)) {
      currentMino = nextMino;
      notifyListeners();
    }
  }

  void rotateLeft() {
    if (currentMino == null || currentMino!.type == MinoType.O) {
      return;
    }
    List<KickOffset> kickOffsets = WallKickData.getLeftRotationWallKickOffsets(currentMino!.type, currentMino!.state);
    for (var item in kickOffsets) {
      Mino nextMino = currentMino!.clone()
        ..moveDelta(item.dx, item.dy)
        ..rotateLeft();
      if (allowMino(nextMino)) {
        currentMino = nextMino;
        notifyListeners();
        break;
      }
    }
  }

  void dropDown() {
    if (currentMino == null) {
      return;
    }
    do {
      Mino bottomMino = currentMino!.clone()..down();
      if (allowMino(bottomMino)) {
        currentMino = bottomMino;
      } else {
        break;
      }
    } while (true);
    notifyListeners();
  }

  bool allowMino(Mino mino) {
    return mino.squares.every((square) => allowSquare(square));
  }

  bool allowSquare(Square square) {
    bool inRange = square.x >= 0 && square.x < config.col && square.y >= 0 && square.y < config.row;
    if (!inRange) {
      return false;
    }
    return squares[square.y][square.x] == null;
  }

  void addMino(Mino mino) {
    for (var square in mino.squares) {
      squares[square.y][square.x] = mino.color;
    }
  }

  void check(List<Square> newSquares) {
    int newTopRow = 0;
    for (int row = 0; row < config.row; row++) {
      bool isFull = true;
      for (int col = 0; col < config.col; col++) {
        if (squares[row][col] == null) {
          isFull = false;
          break;
        }
      }
      if (!isFull) {
        squares[newTopRow] = squares[row];
        newTopRow++;
      }
    }

    for (int i = newTopRow; i < config.row; i++) {
      squares[i] = List.filled(config.col, null);
    }
  }
}

class KickOffset {
  final int dx;
  final int dy;

  KickOffset(this.dx, this.dy);
}

class WallKickData {
  static List<List<KickOffset>> rightRotationForMiniI = [
    [KickOffset(0, 0), KickOffset(-2, 0), KickOffset(1, 0), KickOffset(-2, -1), KickOffset(1, 2)], // up->right
    [KickOffset(0, 0), KickOffset(-1, 0), KickOffset(2, 0), KickOffset(-1, 2), KickOffset(2, -1)], //right->down
    [KickOffset(0, 0), KickOffset(2, 0), KickOffset(-1, 0), KickOffset(2, 1), KickOffset(-1, -2)], // down->left
    [KickOffset(0, 0), KickOffset(1, 0), KickOffset(-2, 0), KickOffset(1, -2), KickOffset(-2, 1)], //left->up
  ];

  static List<List<KickOffset>> leftRotationForMiniI = [
    [KickOffset(0, 0), KickOffset(-1, 0), KickOffset(2, 0), KickOffset(-1, 2), KickOffset(2, -1)], // up->left
    [KickOffset(0, 0), KickOffset(2, 0), KickOffset(-1, 0), KickOffset(2, 1), KickOffset(-1, -2)], // right->up
    [KickOffset(0, 0), KickOffset(1, 0), KickOffset(-2, 0), KickOffset(1, -2), KickOffset(-2, 1)], // down->right
    [KickOffset(0, 0), KickOffset(-2, 0), KickOffset(1, 0), KickOffset(-2, -1), KickOffset(1, 2)], // left->down
  ];

  static List<List<KickOffset>> rightRotatioinForOtherMini = [
    [KickOffset(0, 0), KickOffset(-1, 0), KickOffset(-1, 1), KickOffset(0, -2), KickOffset(-1, -2)], // up->right
    [KickOffset(0, 0), KickOffset(1, 0), KickOffset(1, -1), KickOffset(0, 2), KickOffset(1, 2)], //right->down
    [KickOffset(0, 0), KickOffset(1, 0), KickOffset(1, 1), KickOffset(0, -2), KickOffset(1, -2)], // down->left
    [KickOffset(0, 0), KickOffset(-1, 0), KickOffset(-1, -1), KickOffset(0, 2), KickOffset(-1, 2)], //left->up
  ];

  static List<List<KickOffset>> leftRotatioinForOtherMini = [
    [KickOffset(0, 0), KickOffset(1, 0), KickOffset(1, 1), KickOffset(0, -2), KickOffset(1, -2)], // up->left
    [KickOffset(0, 0), KickOffset(1, 0), KickOffset(1, -1), KickOffset(0, 2), KickOffset(1, 2)], // right->up
    [KickOffset(0, 0), KickOffset(-1, 0), KickOffset(-1, 1), KickOffset(0, -2), KickOffset(-1, -2)], // down->right
    [KickOffset(0, 0), KickOffset(-1, 0), KickOffset(-1, -1), KickOffset(0, 2), KickOffset(-1, 2)], // left->down
  ];

  static List<KickOffset> getRightRotationWallKickOffsets(MinoType type, MinoState state) {
    if (type == MinoType.I) {
      return rightRotationForMiniI[state.index];
    } else if (type == MinoType.O) {
      return [];
    } else {
      return rightRotatioinForOtherMini[state.index];
    }
  }

  static List<KickOffset> getLeftRotationWallKickOffsets(MinoType type, MinoState state) {
    if (type == MinoType.I) {
      return leftRotationForMiniI[state.index];
    } else if (type == MinoType.O) {
      return [];
    } else {
      return leftRotatioinForOtherMini[state.index];
    }
  }
}
