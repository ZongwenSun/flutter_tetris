import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tetris/models/game_state.dart';
import 'package:flutter_tetris/widgets/game_board.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
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
                }
              },
              child: Center(
                child: GameBoard(
                  gameState: gameState,
                ),
              ),
            ),
          ),
        ),
        // body: Center(child: Text('hello')),
      ),
    );
  }
}
