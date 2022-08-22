import 'package:chess_one/services/game_service.dart';
import 'package:chess_one/widgets/current_turn.dart';
import 'package:chess_one/widgets/game_board.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key) {
    GameService().resetGameBoard();

    Future.delayed(const Duration(seconds: 1), () {
      GameService().restartGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.teal,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CurrentTurn(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [GameBoard()],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
