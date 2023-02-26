import 'dart:async';
import 'package:chess_one/helpers/debugger.dart';
import 'package:chess_one/helpers/utils.dart';
import 'package:chess_one/models/piece.dart';
import 'package:chess_one/models/position.dart';
import 'package:chess_one/models/tile.dart';
import 'package:rxdart/rxdart.dart';

class GameService {
  static final GameService _instance = GameService._internal();

  final _gameStartFetcher = BehaviorSubject<bool>()..startWith(false);
  final _gameBoardFetcher = BehaviorSubject<List<List<Tile>>>()..startWith([]);
  final _turnTeamFetcher = BehaviorSubject<PieceTeam>()
    ..startWith(PieceTeam.white);
  final _winnerTeamFetcher = BehaviorSubject<PieceTeam?>();

  bool get gameStartSync => _gameStartFetcher.value;
  Stream<bool> get gameStartStream => _gameStartFetcher.stream;
  List<List<Tile>> get gameBoardSync => Utils.deepCloneList(
        _gameBoardFetcher.value,
      );
  Stream<List<List<Tile>>> get gameBoardStream => _gameBoardFetcher.stream;
  PieceTeam get turnTeamSync => _turnTeamFetcher.value;
  Stream<PieceTeam> get turnTeamStream => _turnTeamFetcher.stream;
  PieceTeam? get winnerTeamSync => _winnerTeamFetcher.value;
  Stream<PieceTeam?> get winnerTeamStream => _winnerTeamFetcher.stream;

  factory GameService() {
    return _instance;
  }

  GameService._internal();

  void _resetGameBoard() {
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
  }

  void movePiece(Position originPosition, Position targetPosition) {
    final List<List<Tile>> newGameBoard = gameBoardSync;
    final Piece? piece = newGameBoard[originPosition.x][originPosition.y].piece;

    newGameBoard[originPosition.x][originPosition.y] = Tile(
      position: Position(
        originPosition.x,
        originPosition.y,
      ),
    );

    newGameBoard[targetPosition.x][targetPosition.y] =
        newGameBoard[originPosition.x][originPosition.y].clone(
      piece: piece?.clone(hasBeenMoved: true),
      position: Position(targetPosition.x, targetPosition.y),
    );

    if (targetPosition.isCastling) {
      if (piece?.team == PieceTeam.white) {
        if (targetPosition.x == 5) {
          newGameBoard[4][0] = newGameBoard[7][0].clone(
            piece: newGameBoard[7][0].piece?.clone(hasBeenMoved: true),
            position: Position(4, 0),
          );
          newGameBoard[7][0] = Tile(position: Position(7, 0));
        } else if (targetPosition.x == 1) {
          newGameBoard[2][0] = newGameBoard[0][0].clone(
            piece: newGameBoard[0][0].piece?.clone(hasBeenMoved: true),
            position: Position(2, 0),
          );
          newGameBoard[0][0] = Tile(position: Position(0, 0));
        }
      } else if (piece?.team == PieceTeam.black) {
        if (targetPosition.x == 1) {
          newGameBoard[2][7] = newGameBoard[0][7].clone(
            piece: newGameBoard[0][7].piece?.clone(hasBeenMoved: true),
            position: Position(2, 7),
          );
          newGameBoard[0][7] = Tile(position: Position(0, 7));
        } else if (targetPosition.x == 5) {
          newGameBoard[4][7] = newGameBoard[7][7].clone(
            piece: newGameBoard[7][7].piece?.clone(hasBeenMoved: true),
            position: Position(4, 7),
          );
          newGameBoard[7][7] = Tile(position: Position(7, 7));
        }
      }
    }

    PieceTeam currentTurn = turnTeamSync;

    PieceTeam newTurnTeam =
        currentTurn == PieceTeam.white ? PieceTeam.black : PieceTeam.white;

    _gameBoardFetcher.sink.add(newGameBoard);
    _turnTeamFetcher.sink.add(newTurnTeam);

    if (!Utils.checkTeamHasValidMovements(
      gameBoard: newGameBoard,
      turnTeam: newTurnTeam,
    )) {
      Debugger.log('Fin del juego');

      _winnerTeamFetcher.sink.add(currentTurn);
    }
  }

  void restartGame() {
    _gameStartFetcher.sink.add(true);
    _resetGameBoard();
    _turnTeamFetcher.sink.add(PieceTeam.white);
    _winnerTeamFetcher.sink.add(null);
  }

  void finishGame() {
    _gameStartFetcher.sink.add(false);
  }

  void dispose() {
    _gameBoardFetcher.close();
  }
}
