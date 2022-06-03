import 'package:flutter_tetris/models/game_ticker.dart';

void main() {
  GameTicker gameTicker = GameTicker(const Duration(seconds: 1), (ticker, time) {
    print(time);
    if (time.inSeconds > 5) {
      ticker.reset();
      ticker.start();
    }
  });
  gameTicker.start();
}
