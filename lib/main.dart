import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tetris/models/game_state.dart';
import 'package:flutter_tetris/widgets/game_board.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class GameControllerBtn extends StatelessWidget {
  final GameState gameState;
  GameControllerBtn({Key? key, required this.gameState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool playing = gameState.state == PlayState.started;

    return IconButton(
      onPressed: () {
        if (playing) {
          gameState.pause();
        } else {
          gameState.startOrContinue();
        }
      },
      icon: Icon(playing ? Icons.pause : Icons.start),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('俄罗斯方块')),
        body: ChangeNotifierProvider<GameState>(
          create: (_) => GameState(GameConfig(row: 20, col: 10)),
          builder: (ctx, child) => Consumer<GameState>(
            builder: (ctx, gameState, child) => RawKeyboardListener(
              autofocus: true,
              focusNode: FocusNode(),
              onKey: (event) {
                if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                  gameState.onPressLeft();
                } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
                  gameState.onPressRight();
                } else if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                  gameState.rotateLeft();
                } else if (event.isKeyPressed(LogicalKeyboardKey.space)) {
                  gameState.dropDown();
                }
              },
              child: Row(
                children: [
                  GameBoard(
                    gameState: gameState,
                  ),
                  GameControllerBtn(
                    gameState: gameState,
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
