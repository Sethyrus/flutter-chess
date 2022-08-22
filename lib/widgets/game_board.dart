import 'package:chess_one/helpers/debugger.dart';
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
      stream: GameService().gameBoardStream,
      builder: (
        context,
        AsyncSnapshot<List<List<Tile>>> gameMatrixSnapshot,
      ) {
        final List<List<Tile>>? gameBoard =
            gameMatrixSnapshot.hasData ? gameMatrixSnapshot.data : null;

        if (gameBoard == null) {
          return const SizedBox();
        }

        final List<Position> availableMovements =
            GameService().getAvailableMovements(selectedPosition);

        return Row(
          children: List.generate(
            gameBoard.length,
            (colIndex) => Column(
              children: List.generate(
                gameBoard.length,
                (rowIndex) {
                  final isTileSelected = selectedPosition == null
                      ? false
                      : selectedPosition!.x == colIndex &&
                          selectedPosition!.y == rowIndex;

                  final isMovableTile = availableMovements.any((position) =>
                      position.x == colIndex && position.y == rowIndex);

                  return GestureDetector(
                    onTap: () {
                      if (isMovableTile) {
                        GameService().movePiece(
                          selectedPosition!,
                          Position(colIndex, rowIndex),
                        );
                      }

                      setState(() {
                        selectedPosition = Position(colIndex, rowIndex);
                      });
                    },
                    child: SizedBox(
                      height: tileSize,
                      width: tileSize,
                      child: GameTile(
                        isTileSelected || isMovableTile
                            ? gameBoard[colIndex][rowIndex].clone(
                                isSelected: isTileSelected,
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
