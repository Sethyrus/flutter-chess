import 'package:chess_one/models/piece.dart';
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

        final List<Position> riskMovements = GameService().getRiskMovements();

        final Tile? selectedTile = selectedPosition != null
            ? gameBoard[selectedPosition!.x][selectedPosition!.y]
            : null;

        final List<Position> availableMovements = [];

        GameService()
            .getAvailableMovements(selectedPosition)
            .forEach((Position position) {
          if (selectedTile?.piece?.type == PieceType.king) {
            if (!riskMovements.any((Position riskPosition) =>
                riskPosition.x == position.x && riskPosition.y == position.y)) {
              availableMovements.add(position);
            }
          } else {
            availableMovements.add(position);
          }
        });

        return Row(
          children: List.generate(
            gameBoard.length,
            (colIndex) => Column(
              children: List.generate(
                gameBoard.length,
                (rowIndex) {
                  final isSelected = selectedPosition?.x == colIndex &&
                      selectedPosition?.y == rowIndex;

                  final isMovableTile = availableMovements.any((position) =>
                      position.x == colIndex && position.y == rowIndex);

                  final isRiskTile = riskMovements.any((position) =>
                      position.x == colIndex && position.y == rowIndex);

                  return GestureDetector(
                    onTap: () {
                      if (isMovableTile) {
                        GameService().movePiece(
                          selectedPosition!,
                          availableMovements.firstWhere((position) =>
                              position.x == colIndex && position.y == rowIndex),
                        );
                      }

                      setState(() {
                        selectedPosition =
                            gameBoard[colIndex][rowIndex].position;
                      });
                    },
                    child: SizedBox(
                      height: tileSize,
                      width: tileSize,
                      child: GameTile(
                        isSelected || isMovableTile || isRiskTile
                            ? gameBoard[colIndex][rowIndex].clone(
                                isSelected: isSelected,
                                isMovableTile: isMovableTile,
                                isRiskTile: isRiskTile,
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
