import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tetris/models/game_ticker.dart';

import 'mino.dart';
import 'wall_kick.dart';

class GameConfig {
  final int row;
  final int col;

  GameConfig({required this.row, required this.col});
}

enum PlayState {
  init,
  started,
  paused,
  finished,
}

class GameState extends ChangeNotifier {
  GameConfig config;
  PlayState state = PlayState.init;
  late List<List<SquareImage?>> squares;
  late GameTicker gameTicker;

  Mino? currentMino;

  late int bornX;
  late int bornY;

  GameState(this.config) {
    bornX = config.col ~/ 2 - 2;
    bornY = config.row - 4;

    gameTicker = GameTicker(const Duration(milliseconds: 1000), ((ticker, passedTime) => onTick(passedTime)));

    reset();
  }

  void reset() {
    squares = List.generate(config.row, (index) => List.filled(config.col, null));
    gameTicker.reset();
    state = PlayState.init;
  }

  void startOrContinue() {
    assert(state == PlayState.init || state == PlayState.paused || state == PlayState.finished);
    if (state == PlayState.finished) {
      reset();
    }
    if (state == PlayState.init) {
      currentMino = Mino.random(bornX, bornY);
      gameTicker.start();
    } else if (state == PlayState.paused) {
      gameTicker.start();
    }
    state = PlayState.started;
    notifyListeners();
  }

  void pause() {
    gameTicker.pause();
    state = PlayState.paused;
    notifyListeners();
  }

  void _gameOver() {
    gameTicker.reset();
    state = PlayState.finished;
  }

  void onTick(Duration passedTime) {
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
          _gameOver();
        }
      }
    }
    notifyListeners();
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
