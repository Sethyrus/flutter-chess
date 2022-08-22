import 'package:chess_one/models/piece.dart';
import 'package:chess_one/models/position.dart';
import 'package:flutter/material.dart';

class Tile {
  final Position position;
  final bool isSelected;
  final bool isMovableTile;
  final bool isRiskTile;
  final Piece? piece;

  Tile({
    required this.position,
    this.isSelected = false,
    this.isMovableTile = false,
    this.isRiskTile = false,
    this.piece,
  });

  Color get color {
    if ((position.x + position.y) % 2 == 0) {
      return Colors.brown.shade100;
    } else {
      return Colors.brown.shade500;
    }
  }

  Tile clone({
    Position? position,
    Piece? piece,
    bool? isSelected,
    bool? isMovableTile,
    bool? isRiskTile,
  }) {
    return Tile(
      position: position ?? this.position,
      isSelected: isSelected ?? this.isSelected,
      isMovableTile: isMovableTile ?? this.isMovableTile,
      isRiskTile: isRiskTile ?? this.isRiskTile,
      piece: piece ?? this.piece,
    );
  }
}
