import 'package:chess_one/models/piece.dart';
import 'package:chess_one/services/game_service.dart';
import 'package:flutter/material.dart';

class CurrentTurn extends StatelessWidget {
  const CurrentTurn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: GameService().teamTurnStream,
      builder: (
        context,
        AsyncSnapshot<PieceTeam> teamTurnSnapshot,
      ) {
        if (!teamTurnSnapshot.hasData) {
          return const SizedBox();
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mueven ${teamTurnSnapshot.data == PieceTeam.white ? 'blancas' : 'negras'}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: teamTurnSnapshot.data == PieceTeam.white
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ],
        );
      },
    );
  }
}
