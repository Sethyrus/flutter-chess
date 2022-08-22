import 'package:chess_one/models/tile.dart';
import 'package:chess_one/services/game_service.dart';
import 'package:chess_one/widgets/game_tile.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Cálculo del tamaño del cuadrao
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    double minSideSize = 0;
    double tileSize = 0;

    if (screenHeight > screenWidth) {
      minSideSize = screenWidth;
    } else {
      minSideSize = screenHeight;
    }

    tileSize = (minSideSize) / 16;

    return StreamBuilder(
      stream: GameService().gameMatrixStream,
      builder: (context, AsyncSnapshot<List<List<Tile>>> gameMatrixSnapshot) {
        final List<List<Tile>>? gameMatrix =
            gameMatrixSnapshot.hasData ? gameMatrixSnapshot.data : null;

        if (gameMatrix == null) {
          return const SizedBox();
        }

        return Row(
          children: List.generate(
            gameMatrix.length,
            (colIndex) => Column(
              children: List.generate(
                gameMatrix.length,
                (rowIndex) => SizedBox(
                  height: tileSize,
                  width: tileSize,
                  child: GameTile(gameMatrix[colIndex][rowIndex]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
