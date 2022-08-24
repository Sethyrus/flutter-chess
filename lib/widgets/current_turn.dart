import 'package:chess_one/models/piece.dart';
import 'package:chess_one/services/game_service.dart';
import 'package:flutter/material.dart';

class CurrentTurn extends StatelessWidget {
  const CurrentTurn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: GameService().winnerTeamStream,
        builder: (
          context,
          AsyncSnapshot<PieceTeam?> winnerTeamSnapshot,
        ) {
          PieceTeam? winner =
              winnerTeamSnapshot.hasData ? winnerTeamSnapshot.data : null;

          return StreamBuilder(
            stream: GameService().turnTeamStream,
            builder: (
              context,
              AsyncSnapshot<PieceTeam> turnTeamSnapshot,
            ) {
              if (!turnTeamSnapshot.hasData) {
                return const SizedBox();
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (winner == null)
                    Text(
                      'Mueven ${turnTeamSnapshot.data == PieceTeam.white ? 'blancas' : 'negras'}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: turnTeamSnapshot.data == PieceTeam.white
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  if (winner != null)
                    Text(
                      'Ganan ${winner == PieceTeam.white ? 'blancas' : 'negras'}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: winner == PieceTeam.white
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                ],
              );
            },
          );
        });
  }
}
