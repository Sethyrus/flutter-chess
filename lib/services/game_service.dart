import 'dart:async';
import 'package:chess_one/models/piece.dart';
import 'package:chess_one/models/position.dart';
import 'package:chess_one/models/tile.dart';
import 'package:rxdart/rxdart.dart';

class GameService {
  static final GameService _instance = GameService._internal();
  final _dataFetcher = BehaviorSubject<List<List<Tile>>>()..startWith([]);
  PieceTeam _currentTurnTeam = PieceTeam.white;

  List<List<Tile>> get gameBoardSync => _dataFetcher.value;
  Stream<List<List<Tile>>> get gameBoardStream => _dataFetcher.stream;

  factory GameService() {
    return _instance;
  }

  GameService._internal();

  Piece? getOriginalPieceAtPosition(Position position) {
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

  List<Position> getAvailableMovementsForRookAtPosition(
    Position position,
    PieceTeam pieceTeam,
  ) {
    final List<Position> validPositions = [];

    // Avanzar hacia arriba y comer si hay pieza
    for (int i = position.y + 1; i < 8; i++) {
      if (gameBoardSync[position.x][i].piece == null) {
        validPositions.add(Position(position.x, i));
      } else {
        if (gameBoardSync[position.x][i].piece?.team != pieceTeam) {
          validPositions.add(Position(position.x, i));
        }
        break;
      }
    }
    // Avanzar hacia abajo y comer si hay pieza
    for (int i = position.y - 1; i >= 0; i--) {
      if (gameBoardSync[position.x][i].piece == null) {
        validPositions.add(Position(position.x, i));
      } else {
        if (gameBoardSync[position.x][i].piece?.team != pieceTeam) {
          validPositions.add(Position(position.x, i));
        }
        break;
      }
    }
    // Avanzar hacia la derecha y comer si hay pieza
    for (int i = position.x + 1; i < 8; i++) {
      if (gameBoardSync[i][position.y].piece == null) {
        validPositions.add(Position(i, position.y));
      } else {
        if (gameBoardSync[i][position.y].piece?.team != pieceTeam) {
          validPositions.add(Position(i, position.y));
        }
        break;
      }
    }
    // Avanzar hacia la izquierda y comer si hay pieza
    for (int i = position.x - 1; i >= 0; i--) {
      if (gameBoardSync[i][position.y].piece == null) {
        validPositions.add(Position(i, position.y));
      } else {
        if (gameBoardSync[i][position.y].piece?.team != pieceTeam) {
          validPositions.add(Position(i, position.y));
        }
        break;
      }
    }

    return validPositions;
  }

  List<Position> getAvailableMovementsForBishopAtPosition(
    Position position,
    PieceTeam pieceTeam,
  ) {
    final List<Position> validPositions = [];

    // Avanzar hacia arriba y derecha
    for (int i = position.y + 1, j = position.x + 1; i < 8 && j < 8; i++, j++) {
      if (gameBoardSync[j][i].piece == null) {
        validPositions.add(Position(j, i));
      } else {
        if (gameBoardSync[j][i].piece?.team != pieceTeam) {
          validPositions.add(Position(j, i));
        }
        break;
      }
    }
    // Avanzar hacia arriba y izquierda
    for (int i = position.y + 1, j = position.x - 1;
        i < 8 && j >= 0;
        i++, j--) {
      if (gameBoardSync[j][i].piece == null) {
        validPositions.add(Position(j, i));
      } else {
        if (gameBoardSync[j][i].piece?.team != pieceTeam) {
          validPositions.add(Position(j, i));
        }
        break;
      }
    }
    // Avanzar hacia abajo y derecha
    for (int i = position.y - 1, j = position.x + 1;
        i >= 0 && j < 8;
        i--, j++) {
      if (gameBoardSync[j][i].piece == null) {
        validPositions.add(Position(j, i));
      } else {
        if (gameBoardSync[j][i].piece?.team != pieceTeam) {
          validPositions.add(Position(j, i));
        }
        break;
      }
    }
    // Avanzar hacia abajo y izquierda
    for (int i = position.y - 1, j = position.x - 1;
        i >= 0 && j >= 0;
        i--, j--) {
      if (gameBoardSync[j][i].piece == null) {
        validPositions.add(Position(j, i));
      } else {
        if (gameBoardSync[j][i].piece?.team != pieceTeam) {
          validPositions.add(Position(j, i));
        }
        break;
      }
    }

    return validPositions;
  }

  List<Position> getAvailableMovementsForPieceAtPosition(
    Position? position,
  ) {
    final List<Position> validPositions = [];

    if (position != null) {
      final Piece? selectedPiece = gameBoardSync[position.x][position.y].piece;

      if (selectedPiece?.team != _currentTurnTeam) {
        return [];
      }

      if (selectedPiece != null) {
        switch (selectedPiece.type) {
          case PieceType.pawn:
            final bool isInitialPosition =
                selectedPiece.team == PieceTeam.white && position.y == 1 ||
                    selectedPiece.team == PieceTeam.black && position.y == 6;

            switch (selectedPiece.team) {
              case PieceTeam.white:
                // "Comer" a la izquierda
                if (position.x > 0 &&
                    position.y < 7 &&
                    gameBoardSync[position.x - 1][position.y + 1].piece?.team ==
                        PieceTeam.black) {
                  validPositions.add(Position(position.x - 1, position.y + 1));
                }

                // "Comer" a la derecha
                if (position.x < 7 &&
                    position.y < 7 &&
                    gameBoardSync[position.x + 1][position.y + 1].piece?.team ==
                        PieceTeam.black) {
                  validPositions.add(Position(position.x + 1, position.y + 1));
                }

                // Avanzar
                if (position.y < 7 &&
                    gameBoardSync[position.x][position.y + 1].piece == null) {
                  validPositions.add(Position(position.x, position.y + 1));

                  if (isInitialPosition &&
                      gameBoardSync[position.x][position.y + 2].piece == null) {
                    validPositions.add(Position(position.x, position.y + 2));
                  }
                }

                break;
              case PieceTeam.black:
                // "Comer" a la izquierda
                if (position.x > 0 &&
                    position.y > 0 &&
                    gameBoardSync[position.x - 1][position.y - 1].piece?.team ==
                        PieceTeam.white) {
                  validPositions.add(Position(position.x - 1, position.y - 1));
                }

                // "Comer" a la derecha
                if (position.x < 7 &&
                    position.y > 0 &&
                    gameBoardSync[position.x + 1][position.y - 1].piece?.team ==
                        PieceTeam.white) {
                  validPositions.add(Position(position.x + 1, position.y - 1));
                }

                // Avanzar
                if (position.y > 0 &&
                    gameBoardSync[position.x][position.y - 1].piece == null) {
                  validPositions.add(Position(position.x, position.y - 1));

                  if (isInitialPosition &&
                      gameBoardSync[position.x][position.y - 2].piece == null) {
                    validPositions.add(Position(position.x, position.y - 2));
                  }
                }
            }

            break;
          case PieceType.knight:
            // Avanzar hacia arriba y derecha
            if (position.x < 7 &&
                position.y > 1 &&
                gameBoardSync[position.x + 1][position.y - 2].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x + 1, position.y - 2));
            }
            // Avanzar hacia arriba y izquierda
            if (position.x > 0 &&
                position.y > 1 &&
                gameBoardSync[position.x - 1][position.y - 2].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x - 1, position.y - 2));
            }
            // Avanzar hacia abajo y derecha
            if (position.x < 7 &&
                position.y < 6 &&
                gameBoardSync[position.x + 1][position.y + 2].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x + 1, position.y + 2));
            }
            // Avanzar hacia abajo y izquierda
            if (position.x > 0 &&
                position.y < 6 &&
                gameBoardSync[position.x - 1][position.y + 2].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x - 1, position.y + 2));
            }
            // Avanzar hacia la derecha y arriba
            if (position.x < 6 &&
                position.y > 0 &&
                gameBoardSync[position.x + 2][position.y - 1].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x + 2, position.y - 1));
            }
            // Avanzar hacia la derecha y abajo
            if (position.x < 6 &&
                position.y < 7 &&
                gameBoardSync[position.x + 2][position.y + 1].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x + 2, position.y + 1));
            }
            // Avanzar hacia la izquierda y arriba
            if (position.x > 1 &&
                position.y > 0 &&
                gameBoardSync[position.x - 2][position.y - 1].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x - 2, position.y - 1));
            }
            // Avanzar hacia la izquierda y abajo
            if (position.x > 1 &&
                position.y < 7 &&
                gameBoardSync[position.x - 2][position.y + 1].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x - 2, position.y + 1));
            }
            break;
          case PieceType.rook:
            validPositions.addAll(
              getAvailableMovementsForRookAtPosition(
                position,
                selectedPiece.team,
              ),
            );

            break;
          case PieceType.bishop:
            validPositions.addAll(
              getAvailableMovementsForBishopAtPosition(
                position,
                selectedPiece.team,
              ),
            );

            break;
          case PieceType.queen:
            validPositions.addAll(
              getAvailableMovementsForRookAtPosition(
                position,
                selectedPiece.team,
              ),
            );
            validPositions.addAll(
              getAvailableMovementsForBishopAtPosition(
                position,
                selectedPiece.team,
              ),
            );
            break;
          case PieceType.king:
            // Avanzar hacia arriba
            if (position.y > 0 &&
                gameBoardSync[position.x][position.y - 1].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x, position.y - 1));
            }
            // Avanzar hacia abajo
            if (position.y < 7 &&
                gameBoardSync[position.x][position.y + 1].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x, position.y + 1));
            }
            // Avanzar hacia la derecha
            if (position.x < 7 &&
                gameBoardSync[position.x + 1][position.y].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x + 1, position.y));
            }
            // Avanzar hacia la izquierda
            if (position.x > 0 &&
                gameBoardSync[position.x - 1][position.y].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x - 1, position.y));
            }
            // Avanzar hacia arriba y derecha
            if (position.x < 7 &&
                position.y > 0 &&
                gameBoardSync[position.x + 1][position.y - 1].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x + 1, position.y - 1));
            }
            // Avanzar hacia arriba y izquierda
            if (position.x > 0 &&
                position.y > 0 &&
                gameBoardSync[position.x - 1][position.y - 1].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x - 1, position.y - 1));
            }
            // Avanzar hacia abajo y derecha
            if (position.x < 7 &&
                position.y < 7 &&
                gameBoardSync[position.x + 1][position.y + 1].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x + 1, position.y + 1));
            }
            // Avanzar hacia abajo y izquierda
            if (position.x > 0 &&
                position.y < 7 &&
                gameBoardSync[position.x - 1][position.y + 1].piece?.team !=
                    selectedPiece.team) {
              validPositions.add(Position(position.x - 1, position.y + 1));
            }
            break;
        }
      }
    }

    return validPositions;
  }

  List<Position> getAvailableMovements(Position? position) {
    final List<Position> availableMovements =
        getAvailableMovementsForPieceAtPosition(position);

    return availableMovements;
  }

  void movePiece(originPosition, destinyPositon) {
    final List<List<Tile>> newGameBoard = List.from(gameBoardSync);
    final Piece? piece = newGameBoard[originPosition.x][originPosition.y].piece;

    newGameBoard[originPosition.x][originPosition.y] = Tile(
      position: Position(
        originPosition.x,
        originPosition.y,
      ),
    );

    newGameBoard[destinyPositon.x][destinyPositon.y] =
        newGameBoard[destinyPositon.x][destinyPositon.y].clone(piece: piece);

    _currentTurnTeam =
        _currentTurnTeam == PieceTeam.white ? PieceTeam.black : PieceTeam.white;
    _dataFetcher.add(newGameBoard);
  }

  void resetGameBoard() {
    final List<List<Tile>> cleanGameBoard = List.generate(
      8,
      (colIndex) => List.generate(
        8,
        (rowIndex) {
          final Position position = Position(colIndex, rowIndex);

          return Tile(
            position: position,
            piece: getOriginalPieceAtPosition(position),
          );
        },
      ),
    );

    _currentTurnTeam = PieceTeam.white;
    _dataFetcher.sink.add(cleanGameBoard);
  }

  void restartGame() {
    resetGameBoard();
  }

  void dispose() {
    _dataFetcher.close();
  }
}
