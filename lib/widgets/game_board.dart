import 'package:flutter/material.dart';
import 'package:flutter_tetris/models/game_state.dart';

class GameBoard extends StatefulWidget {
  final GameState gameState;
  final double borderWith = 4;
  final double lineWidth = 1;
  final double squareCornerSize = 2;
  final double outerBorderRadius = 20;
  final double squareSize = 30;

  const GameBoard({Key? key, required this.gameState}) : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  @override
  Widget build(BuildContext context) {
    GameConfig config = widget.gameState.config;
    double width = widget.squareSize * config.col + widget.lineWidth * (config.col - 1);
    double height = widget.squareSize * config.row + widget.lineWidth * (config.row - 1);

    return CustomPaint(
      painter: BoardPainter(
        gameState: widget.gameState,
        col: config.col,
        row: config.row,
        squareSize: widget.squareSize,
        lineWidth: widget.lineWidth,
      ),
      size: Size(width, height),
    );
  }
}

class BoardPainter extends CustomPainter {
  final Color bgColor = const Color(0xff000000);
  final Color lineColor = const Color(0xff242323);
  final GameState gameState;
  final double dotRadius = 2;
  final int row;
  final int col;
  final double lineWidth;
  final double squareSize;
  late List<List<Square?>> squares;

  BoardPainter({
    required this.gameState,
    required this.row,
    required this.col,
    required this.lineWidth,
    required this.squareSize,
  }) {
    squares = List.generate(row, (index) => List.filled(col, null));
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    Paint linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    canvas.drawColor(bgColor, BlendMode.src);

    // draw horizontal line
    for (int i = 1; i < row; i++) {
      double top = (squareSize + lineWidth) * i - lineWidth;
      canvas.drawRect(Rect.fromLTWH(0, top, size.width, lineWidth), linePaint);
    }

    // draw vertical line
    for (int i = 1; i < col; i++) {
      double left = (squareSize + lineWidth) * i - lineWidth;
      canvas.drawRect(Rect.fromLTWH(left, 0, lineWidth, size.height), linePaint);
    }

    Paint squarePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    for (int row = 0; row < gameState.squares.length; row++) {
      for (int col = 0; col < gameState.squares[row].length; col++) {
        if (gameState.squares[row][col] != null) {
          double left = col * (squareSize + lineWidth);
          double top = row * (squareSize + lineWidth);
          canvas.drawRect(Rect.fromLTWH(left, top, squareSize, squareSize), squarePaint);
        }
      }
    }

    if (gameState.currentMino != null) {
      Mino mino = gameState.currentMino!;
      for (Square square in mino.squares) {
        int row = square.row;
        int col = square.col;
        double left = col * (squareSize + lineWidth);
        double top = row * (squareSize + lineWidth);
        canvas.drawRect(Rect.fromLTWH(left, top, squareSize, squareSize), squarePaint);
      }
    }

    // draw dot
    for (int i = 0; i <= row; i++) {
      double y;
      if (i == 0) {
        y = 0;
      } else if (i == row) {
        y = size.height;
      } else {
        y = (squareSize + lineWidth) * i - lineWidth / 2;
      }
      for (int j = 0; j <= col; j++) {
        double x;
        if (j == 0) {
          x = 0;
        } else if (j == col) {
          x = size.width;
        } else {
          x = (squareSize + lineWidth) * j - lineWidth / 2;
        }

        canvas.drawOval(Rect.fromCircle(center: Offset(x, y), radius: dotRadius), linePaint);
      }
    }

    // canvas.drawLine(p1, p2, paint)
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
