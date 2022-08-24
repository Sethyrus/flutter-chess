import 'dart:async';
import 'package:chess_one/helpers/utils.dart';
import 'package:chess_one/models/piece.dart';
import 'package:chess_one/models/position.dart';
import 'package:chess_one/models/tile.dart';
import 'package:rxdart/rxdart.dart';

class GameService {
  static final GameService _instance = GameService._internal();

  final _gameBoardFetcher = BehaviorSubject<List<List<Tile>>>()..startWith([]);
  final _teamTurnFetcher = BehaviorSubject<PieceTeam>()
    ..startWith(PieceTeam.white);

  List<List<Tile>> get gameBoardSync =>
      Utils.deepCloneList(_gameBoardFetcher.value);
  Stream<List<List<Tile>>> get gameBoardStream => _gameBoardFetcher.stream;
  PieceTeam get teamTurnSync => _teamTurnFetcher.value;
  Stream<PieceTeam> get teamTurnStream => _teamTurnFetcher.stream;

  factory GameService() {
    return _instance;
  }

  GameService._internal();

  void movePiece(Position originPosition, Position destinyPosition) {
    final List<List<Tile>> newGameBoard = gameBoardSync;
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

    _gameBoardFetcher.add(newGameBoard);
    _teamTurnFetcher.add(
      teamTurnSync == PieceTeam.white ? PieceTeam.black : PieceTeam.white,
    );
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
            piece: Utils.getOriginalPieceAtPosition(position),
          );
        },
      ),
    );

    _gameBoardFetcher.sink.add(cleanGameBoard);
    _teamTurnFetcher.add(PieceTeam.white);
  }

  void restartGame() {
    resetGameBoard();
  }

  void dispose() {
    _gameBoardFetcher.close();
  }
}
