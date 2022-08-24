import 'package:chess_one/services/game_service.dart';
import 'package:chess_one/widgets/current_turn.dart';
import 'package:chess_one/widgets/game_board.dart';
import 'package:chess_one/widgets/main_title.dart';
import 'package:chess_one/widgets/options_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.teal.shade800,
        body: SafeArea(
          child: StreamBuilder(
            stream: GameService().gameStartStream,
            builder: (
              context,
              AsyncSnapshot<bool> gameStartSnapshot,
            ) {
              bool? gameStart =
                  gameStartSnapshot.hasData ? gameStartSnapshot.data : false;

              if (gameStart == null) {
                return const SizedBox();
              }

              return Stack(
                children: [
                  if (gameStart)
                    const Positioned(
                      top: 16,
                      right: 16,
                      child: OptionsButton(),
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (gameStart) ...[
                        const CurrentTurn(),
                        const SizedBox(height: 24),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!gameStart) const MainTitle(),
                          if (gameStart) const GameBoard(),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
