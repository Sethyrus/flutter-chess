import 'package:chess_one/helpers/utils.dart';
import 'package:chess_one/models/position.dart';
import 'package:chess_one/models/tile.dart';
import 'package:chess_one/services/game_service.dart';
import 'package:chess_one/widgets/game_tile.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  Position? selectedPosition;

  @override
  Widget build(BuildContext context) {
    // Cálculo del tamaño del cuadrao
    const int tilesPerSide = 8;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    double minSideSize = 0;
    double tileSize = 0;
    double offset = 0;

    if (screenHeight > (screenWidth + 64)) {
      minSideSize = screenWidth;
      offset = 32;
    } else {
      minSideSize = screenHeight;
      offset = 128;
    }

    tileSize = ((minSideSize - offset) / tilesPerSide);

    return StreamBuilder(
      stream: GameService().gameBoardStream,
      builder: (
        context,
        AsyncSnapshot<List<List<Tile>>> gameBoardSnapshot,
      ) {
        final List<List<Tile>>? gameBoard =
            gameBoardSnapshot.hasData ? gameBoardSnapshot.data : null;

        if (gameBoard == null) {
          return const SizedBox();
        }

        final List<Position> availableMovementsforSelectedPosition =
            Utils.getAvailableMovementsForPosition(
          position: selectedPosition,
          gameBoard: gameBoard,
          turnTeam: GameService().turnTeamSync,
        );

        return Row(
          children: List.generate(
            gameBoard.length,
            (colIndex) => Column(
              children: List.generate(
                gameBoard.length,
                (rowIndex) {
                  final isSelected = selectedPosition?.x == colIndex &&
                      selectedPosition?.y == rowIndex;

                  final isMovableTile =
                      availableMovementsforSelectedPosition.any((position) =>
                          position.x == colIndex && position.y == rowIndex);

                  return GestureDetector(
                    onTap: () {
                      if (isMovableTile) {
                        GameService().movePiece(
                          selectedPosition!,
                          availableMovementsforSelectedPosition.firstWhere(
                              (position) =>
                                  position.x == colIndex &&
                                  position.y == rowIndex),
                        );
                      }

                      setState(() => selectedPosition =
                          gameBoard[colIndex][rowIndex].position);
                    },
                    child: SizedBox(
                      height: tileSize,
                      width: tileSize,
                      child: GameTile(
                        isSelected || isMovableTile
                            ? gameBoard[colIndex][rowIndex].clone(
                                isSelected: isSelected,
                                isMovableTile: isMovableTile,
                              )
                            : gameBoard[colIndex][rowIndex],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
