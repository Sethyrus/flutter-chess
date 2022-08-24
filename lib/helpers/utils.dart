import 'package:chess_one/models/piece.dart';
import 'package:chess_one/models/position.dart';
import 'package:chess_one/models/tile.dart';

class Utils {
  static List<List<T>> deepCloneList<T>(List<List<T>> list) {
    List<List<T>> newList = [];

    for (var i = 0; i < list.length; i++) {
      newList.add([]);
      for (var j = 0; j < list[i].length; j++) {
        newList[i].add(list[i][j]);
      }
    }

    return newList;
  }

  static Position? getKingPosition({
    required List<List<Tile>> gameBoard,
    required PieceTeam teamTurn,
  }) {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (gameBoard[i][j].piece?.type == PieceType.king &&
            gameBoard[i][j].piece?.team == teamTurn) {
          return Position(i, j);
        }
      }
    }

    return null;
  }

  // Devuelve las posiciones de riesgo del tablero para el equipo seleccionado
  static List<Position> getRiskPositions({
    required List<List<Tile>> gameBoard,
    required PieceTeam teamTurn,
  }) {
    final List<Position> riskTiles = [];

    final List<List<Tile>> board = Utils.deepCloneList((gameBoard));

    for (var x = 0; x < 8; x++) {
      for (var y = 0; y < 8; y++) {
        if (board[x][y].piece?.team ==
            (teamTurn == PieceTeam.white ? PieceTeam.black : PieceTeam.white)) {
          getAvailableMovementsForPosition(
            gameBoard: gameBoard,
            teamTurn: teamTurn,
            position: board[x][y].position,
            onlyKillMovements: true,
            bypassPieceTeamCheck: true,
            bypassKingRisk: true,
          ).forEach((position) {
            if (!riskTiles.any(
              ((tile) => tile.x == position.x && tile.y == position.y),
            )) {
              riskTiles.add(position);
            }
          });
        }
      }
    }

    return riskTiles;
  }

  static bool isKingInCheck({
    required PieceTeam teamTurn,
    required List<List<Tile>> gameBoard,
  }) {
    final Position? kingPosition = getKingPosition(
      gameBoard: gameBoard,
      teamTurn: teamTurn,
    );

    if (kingPosition == null) return false;

    final List<Position> riskPositions = getRiskPositions(
      gameBoard: gameBoard,
      teamTurn: teamTurn,
    );

    return riskPositions.any(((position) {
      return kingPosition.x == position.x && kingPosition.y == position.y;
    }));
  }

  static List<List<Tile>> simulateMovePiece({
    required List<List<Tile>> gameBoard,
    required Position originPosition,
    required Position destinyPosition,
  }) {
    final List<List<Tile>> newGameBoard = deepCloneList(gameBoard);
    final Piece? piece = newGameBoard[originPosition.x][originPosition.y].piece;

    newGameBoard[originPosition.x][originPosition.y] = Tile(
      position: Position(
        originPosition.x,
        originPosition.y,
      ),
    );

    newGameBoard[destinyPosition.x][destinyPosition.y] =
        newGameBoard[originPosition.x][originPosition.y].clone(
      piece: piece?.clone(hasBeenMoved: true),
      position: Position(destinyPosition.x, destinyPosition.y),
    );

    if (destinyPosition.isCastling) {
      if (piece?.team == PieceTeam.white) {
        if (destinyPosition.x == 5) {
          newGameBoard[4][0] = newGameBoard[7][0].clone(
            piece: newGameBoard[7][0].piece?.clone(hasBeenMoved: true),
            position: Position(4, 0),
          );
          newGameBoard[7][0] = Tile(position: Position(7, 0));
        } else if (destinyPosition.x == 1) {
          newGameBoard[2][0] = newGameBoard[0][0].clone(
            piece: newGameBoard[0][0].piece?.clone(hasBeenMoved: true),
            position: Position(2, 0),
          );
          newGameBoard[0][0] = Tile(position: Position(0, 0));
        }
      } else if (piece?.team == PieceTeam.black) {
        if (destinyPosition.x == 1) {
          newGameBoard[2][7] = newGameBoard[0][7].clone(
            piece: newGameBoard[0][7].piece?.clone(hasBeenMoved: true),
            position: Position(2, 7),
          );
          newGameBoard[0][7] = Tile(position: Position(0, 7));
        } else if (destinyPosition.x == 5) {
          newGameBoard[4][7] = newGameBoard[7][7].clone(
            piece: newGameBoard[7][7].piece?.clone(hasBeenMoved: true),
            position: Position(4, 7),
          );
          newGameBoard[7][7] = Tile(position: Position(7, 7));
        }
      }
    }

    return newGameBoard;
  }

  static List<Position> getAvailableMovementsForRookAtPosition({
    required List<List<Tile>> gameBoard,
    required Position position,
    required PieceTeam turnTeam,
  }) {
    final List<Position> validPositions = [];

    // Avanzar hacia arriba y comer si hay pieza
    for (int i = position.y + 1; i < 8; i++) {
      if (gameBoard[position.x][i].piece == null) {
        validPositions.add(Position(position.x, i));
      } else {
        if (gameBoard[position.x][i].piece?.team != turnTeam) {
          validPositions.add(Position(position.x, i));
        }
        break;
      }
    }

    // Avanzar hacia abajo y comer si hay pieza
    for (int i = position.y - 1; i >= 0; i--) {
      if (gameBoard[position.x][i].piece == null) {
        validPositions.add(Position(position.x, i));
      } else {
        if (gameBoard[position.x][i].piece?.team != turnTeam) {
          validPositions.add(Position(position.x, i));
        }
        break;
      }
    }

    // Avanzar hacia la derecha y comer si hay pieza
    for (int i = position.x + 1; i < 8; i++) {
      if (gameBoard[i][position.y].piece == null) {
        validPositions.add(Position(i, position.y));
      } else {
        if (gameBoard[i][position.y].piece?.team != turnTeam) {
          validPositions.add(Position(i, position.y));
        }
        break;
      }
    }

    // Avanzar hacia la izquierda y comer si hay pieza
    for (int i = position.x - 1; i >= 0; i--) {
      if (gameBoard[i][position.y].piece == null) {
        validPositions.add(Position(i, position.y));
      } else {
        if (gameBoard[i][position.y].piece?.team != turnTeam) {
          validPositions.add(Position(i, position.y));
        }
        break;
      }
    }

    return validPositions;
  }

  static List<Position> getAvailableMovementsForBishopAtPosition({
    required List<List<Tile>> gameBoard,
    required Position position,
    required PieceTeam turnTeam,
  }) {
    final List<Position> validPositions = [];

    // Avanzar hacia arriba y derecha
    for (int i = position.y + 1, j = position.x + 1; i < 8 && j < 8; i++, j++) {
      if (gameBoard[j][i].piece == null) {
        validPositions.add(Position(j, i));
      } else {
        if (gameBoard[j][i].piece?.team != turnTeam) {
          validPositions.add(Position(j, i));
        }
        break;
      }
    }
    // Avanzar hacia arriba y izquierda
    for (int i = position.y + 1, j = position.x - 1;
        i < 8 && j >= 0;
        i++, j--) {
      if (gameBoard[j][i].piece == null) {
        validPositions.add(Position(j, i));
      } else {
        if (gameBoard[j][i].piece?.team != turnTeam) {
          validPositions.add(Position(j, i));
        }
        break;
      }
    }
    // Avanzar hacia abajo y derecha
    for (int i = position.y - 1, j = position.x + 1;
        i >= 0 && j < 8;
        i--, j++) {
      if (gameBoard[j][i].piece == null) {
        validPositions.add(Position(j, i));
      } else {
        if (gameBoard[j][i].piece?.team != turnTeam) {
          validPositions.add(Position(j, i));
        }
        break;
      }
    }
    // Avanzar hacia abajo y izquierda
    for (int i = position.y - 1, j = position.x - 1;
        i >= 0 && j >= 0;
        i--, j--) {
      if (gameBoard[j][i].piece == null) {
        validPositions.add(Position(j, i));
      } else {
        if (gameBoard[j][i].piece?.team != turnTeam) {
          validPositions.add(Position(j, i));
        }
        break;
      }
    }

    return validPositions;
  }

  static List<Position> getAvailableMovementsForPosition({
    required List<List<Tile>> gameBoard,
    required PieceTeam teamTurn,
    required Position? position,
    bool onlyKillMovements = false,
    bool bypassPieceTeamCheck = false,
    bool bypassKingRisk = false,
  }) {
    final List<Position> validPositions = [];

    if (position != null) {
      // Posible pieza en la posición seleccionada
      final Piece? selectedPiece = gameBoard[position.x][position.y].piece;

      if (!bypassPieceTeamCheck && selectedPiece?.team != teamTurn) return [];

      if (selectedPiece != null) {
        switch (selectedPiece.type) {
          case PieceType.pawn:

            /// Para comer a izquierda o derecha se comprueba onlyKillMovements
            /// para añadir la posición incluso si no tienen pieza para comer
            switch (selectedPiece.team) {
              case PieceTeam.white:
                // "Comer" a la izquierda (hacia abajo)
                if (position.x > 0 &&
                    position.y < 7 &&
                    (onlyKillMovements ||
                        gameBoard[position.x - 1][position.y + 1].piece?.team ==
                            PieceTeam.black)) {
                  validPositions.add(Position(position.x - 1, position.y + 1));
                }

                // "Comer" a la derecha (hacia abajo)
                if (position.x < 7 &&
                    position.y < 7 &&
                    (onlyKillMovements ||
                        gameBoard[position.x + 1][position.y + 1].piece?.team ==
                            PieceTeam.black)) {
                  validPositions.add(Position(position.x + 1, position.y + 1));
                }

                // Avanzar (hacia abajo)
                if (!onlyKillMovements &&
                    position.y < 7 &&
                    gameBoard[position.x][position.y + 1].piece == null) {
                  validPositions.add(Position(position.x, position.y + 1));

                  if (!selectedPiece.hasBeenMoved &&
                      gameBoard[position.x][position.y + 2].piece == null) {
                    validPositions.add(Position(position.x, position.y + 2));
                  }
                }

                break;
              case PieceTeam.black:
                // "Comer" a la izquierda (hacia arriba)
                if (position.x > 0 &&
                    position.y > 0 &&
                    (onlyKillMovements ||
                        gameBoard[position.x - 1][position.y - 1].piece?.team ==
                            PieceTeam.white)) {
                  validPositions.add(Position(position.x - 1, position.y - 1));
                }

                // "Comer" a la derecha (hacia arriba)
                if (position.x < 7 &&
                    position.y > 0 &&
                    (onlyKillMovements ||
                        gameBoard[position.x + 1][position.y - 1].piece?.team ==
                            PieceTeam.white)) {
                  validPositions.add(Position(position.x + 1, position.y - 1));
                }

                // Avanzar (hacia arriba)
                if (!onlyKillMovements &&
                    position.y > 0 &&
                    gameBoard[position.x][position.y - 1].piece == null) {
                  validPositions.add(Position(position.x, position.y - 1));

                  if (!selectedPiece.hasBeenMoved &&
                      gameBoard[position.x][position.y - 2].piece == null) {
                    validPositions.add(Position(position.x, position.y - 2));
                  }
                }
            }

            break;
          case PieceType.knight:
            // Avanzar hacia arriba y derecha
            if (position.x < 7 &&
                position.y > 1 &&
                gameBoard[position.x + 1][position.y - 2].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x + 1, position.y - 2));
            }
            // Avanzar hacia arriba y izquierda
            if (position.x > 0 &&
                position.y > 1 &&
                gameBoard[position.x - 1][position.y - 2].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x - 1, position.y - 2));
            }
            // Avanzar hacia abajo y derecha
            if (position.x < 7 &&
                position.y < 6 &&
                gameBoard[position.x + 1][position.y + 2].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x + 1, position.y + 2));
            }
            // Avanzar hacia abajo y izquierda
            if (position.x > 0 &&
                position.y < 6 &&
                gameBoard[position.x - 1][position.y + 2].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x - 1, position.y + 2));
            }
            // Avanzar hacia la derecha y arriba
            if (position.x < 6 &&
                position.y > 0 &&
                gameBoard[position.x + 2][position.y - 1].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x + 2, position.y - 1));
            }
            // Avanzar hacia la derecha y abajo
            if (position.x < 6 &&
                position.y < 7 &&
                gameBoard[position.x + 2][position.y + 1].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x + 2, position.y + 1));
            }
            // Avanzar hacia la izquierda y arriba
            if (position.x > 1 &&
                position.y > 0 &&
                gameBoard[position.x - 2][position.y - 1].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x - 2, position.y - 1));
            }
            // Avanzar hacia la izquierda y abajo
            if (position.x > 1 &&
                position.y < 7 &&
                gameBoard[position.x - 2][position.y + 1].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x - 2, position.y + 1));
            }
            break;
          case PieceType.rook:
            validPositions.addAll(
              getAvailableMovementsForRookAtPosition(
                gameBoard: gameBoard,
                position: position,
                turnTeam: selectedPiece.team,
              ),
            );

            break;
          case PieceType.bishop:
            validPositions.addAll(
              getAvailableMovementsForBishopAtPosition(
                gameBoard: gameBoard,
                position: position,
                turnTeam: selectedPiece.team,
              ),
            );

            break;
          case PieceType.queen:
            validPositions.addAll(
              getAvailableMovementsForRookAtPosition(
                gameBoard: gameBoard,
                position: position,
                turnTeam: selectedPiece.team,
              ),
            );
            validPositions.addAll(
              getAvailableMovementsForBishopAtPosition(
                gameBoard: gameBoard,
                position: position,
                turnTeam: selectedPiece.team,
              ),
            );
            break;
          case PieceType.king:
            // Avanzar hacia arriba
            if (position.y > 0 &&
                gameBoard[position.x][position.y - 1].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x, position.y - 1));
            }
            // Avanzar hacia abajo
            if (position.y < 7 &&
                gameBoard[position.x][position.y + 1].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x, position.y + 1));
            }
            // Avanzar hacia la derecha
            if (position.x < 7 &&
                gameBoard[position.x + 1][position.y].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x + 1, position.y));
            }
            // Avanzar hacia la izquierda
            if (position.x > 0 &&
                gameBoard[position.x - 1][position.y].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x - 1, position.y));
            }
            // Avanzar hacia arriba y derecha
            if (position.x < 7 &&
                position.y > 0 &&
                gameBoard[position.x + 1][position.y - 1].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x + 1, position.y - 1));
            }
            // Avanzar hacia arriba y izquierda
            if (position.x > 0 &&
                position.y > 0 &&
                gameBoard[position.x - 1][position.y - 1].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x - 1, position.y - 1));
            }
            // Avanzar hacia abajo y derecha
            if (position.x < 7 &&
                position.y < 7 &&
                gameBoard[position.x + 1][position.y + 1].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x + 1, position.y + 1));
            }
            // Avanzar hacia abajo y izquierda
            if (position.x > 0 &&
                position.y < 7 &&
                gameBoard[position.x - 1][position.y + 1].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x - 1, position.y + 1));
            }
            // Enroque blancas
            if (selectedPiece.team == PieceTeam.white) {
              // Enroque corto blancas
              if (!onlyKillMovements &&
                  !selectedPiece.hasBeenMoved &&
                  gameBoard[0][0].piece?.hasBeenMoved == false) {
                if (gameBoard[1][0].piece == null &&
                    gameBoard[2][0].piece == null) {
                  validPositions.add(Position(1, 0, isCastling: true));
                }
              }
              // Enroque largo blancas
              if (!onlyKillMovements &&
                  !selectedPiece.hasBeenMoved &&
                  gameBoard[7][0].piece?.hasBeenMoved == false) {
                if (gameBoard[6][0].piece == null &&
                    gameBoard[5][0].piece == null &&
                    gameBoard[4][0].piece == null) {
                  validPositions.add(Position(5, 0, isCastling: true));
                }
              }
            }
            // Enroque negras
            if (selectedPiece.team == PieceTeam.black) {
              // Enroque corto negras
              if (!onlyKillMovements &&
                  !selectedPiece.hasBeenMoved &&
                  gameBoard[7][7].piece?.hasBeenMoved == false) {
                if (gameBoard[1][7].piece == null &&
                    gameBoard[2][7].piece == null) {
                  validPositions.add(Position(1, 7, isCastling: true));
                }
              }
              // Enroque largo negras
              if (!onlyKillMovements &&
                  !selectedPiece.hasBeenMoved &&
                  gameBoard[0][7].piece?.hasBeenMoved == false) {
                if (gameBoard[6][7].piece == null &&
                    gameBoard[5][7].piece == null &&
                    gameBoard[4][7].piece == null) {
                  validPositions.add(Position(5, 7, isCastling: true));
                }
              }
            }
            break;
        }
      }

      if (!bypassKingRisk) {
        for (int i = validPositions.length; i > 0; i--) {
          // Se comprueba el resultado de cada movimiento posible
          final List<List<Tile>> movementResult = simulateMovePiece(
            gameBoard: gameBoard,
            originPosition: position,
            destinyPosition: validPositions[i - 1],
          );

          // Si tras el movimiento el rey quedara en jaque se elimina el movimiento
          if (isKingInCheck(gameBoard: movementResult, teamTurn: teamTurn)) {
            validPositions.removeAt(i - 1);
          }
        }
      }
    }

    return validPositions;
  }

  static Piece? getOriginalPieceAtPosition(Position position) {
    // Piezas primera línea blancas
    if (position.y == 0) {
      if (position.x == 0 || position.x == 7) {
        return Piece(type: PieceType.rook, team: PieceTeam.white);
      } else if (position.x == 1 || position.x == 6) {
        return Piece(type: PieceType.knight, team: PieceTeam.white);
      } else if (position.x == 2 || position.x == 5) {
        return Piece(type: PieceType.bishop, team: PieceTeam.white);
      } else if (position.x == 3) {
        return Piece(type: PieceType.king, team: PieceTeam.white);
      } else if (position.x == 4) {
        return Piece(type: PieceType.queen, team: PieceTeam.white);
      }
    }
    // Peones blancos
    else if (position.y == 1) {
      return Piece(type: PieceType.pawn, team: PieceTeam.white);
    }
    // Peones negros
    else if (position.y == 6) {
      return Piece(type: PieceType.pawn, team: PieceTeam.black);
    }
    // Piezas primera línea negras
    else if (position.y == 7) {
      if (position.x == 0 || position.x == 7) {
        return Piece(type: PieceType.rook, team: PieceTeam.black);
      } else if (position.x == 1 || position.x == 6) {
        return Piece(type: PieceType.knight, team: PieceTeam.black);
      } else if (position.x == 2 || position.x == 5) {
        return Piece(type: PieceType.bishop, team: PieceTeam.black);
      } else if (position.x == 3) {
        return Piece(type: PieceType.king, team: PieceTeam.black);
      } else if (position.x == 4) {
        return Piece(type: PieceType.queen, team: PieceTeam.black);
      }
    }

    return null;
  }
}
