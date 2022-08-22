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
                if (position.x > 0 &&
                    position.y < 7 &&
                    gameBoardSync[position.x - 1][position.y + 1].piece !=
                        null) {
                  validPositions.add(Position(position.x - 1, position.y + 1));
                }

                if (position.x < 7 &&
                    position.y < 7 &&
                    gameBoardSync[position.x + 1][position.y + 1].piece !=
                        null) {
                  validPositions.add(Position(position.x + 1, position.y + 1));
                }

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
                if (isInitialPosition) {
                  validPositions.addAll([
                    Position(position.x, position.y - 1),
                    Position(position.x, position.y - 2),
                  ]);
                } else {
                  validPositions.add(Position(position.x, position.y - 1));
                }
            }

            break;
          case PieceType.rook:
            // TODO: Handle this case.
            break;
          case PieceType.knight:
            // TODO: Handle this case.
            break;
          case PieceType.bishop:
            // TODO: Handle this case.
            break;
          case PieceType.queen:
            // TODO: Handle this case.
            break;
          case PieceType.king:
            // TODO: Handle this case.
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
