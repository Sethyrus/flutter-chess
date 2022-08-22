import 'dart:async';
import 'package:chess_one/helpers/debugger.dart';
import 'package:chess_one/models/piece.dart';
import 'package:chess_one/models/position.dart';
import 'package:chess_one/models/tile.dart';
import 'package:rxdart/rxdart.dart';

enum SnakeDirection {
  up,
  down,
  left,
  right,
}

class GameService {
  static final GameService _instance = GameService._internal();
  final _gameBoardFetcher = BehaviorSubject<List<List<Tile>>>()..startWith([]);
  final _selectedPositionFetcher = BehaviorSubject<Position?>()
    ..startWith(null);

  List<List<Tile>> get gameBoardSync => _gameBoardFetcher.value;
  Stream<List<List<Tile>>> get gameBoardStream => _gameBoardFetcher.stream;
  Position? get selectedPositionSync => _selectedPositionFetcher.value;
  Stream<Position?> get selectedPositionStream =>
      _selectedPositionFetcher.stream;

  factory GameService() {
    return _instance;
  }

  GameService._internal();

  Piece? getOriginalPieceAtPosition(Position position) {
    // Piezas principales blancas
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
    // Piezas principales negras
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

  void resetGameMatrix() {
    final List<List<Tile>> gameMatrix = List.generate(
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

    _gameBoardFetcher.sink.add(gameMatrix);
  }

  void startGame() {
    resetGameMatrix();
  }

  void selectTile({Position? position}) {
    Debugger.log('Selected tile: $position');

    _selectedPositionFetcher.sink.add(position);
  }

  void dispose() {
    _gameBoardFetcher.close();
  }
}
