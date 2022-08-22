import 'package:chess_one/models/piece.dart';
import 'package:chess_one/models/position.dart';
import 'package:flutter/material.dart';

class Tile {
  final Position position;
  final bool isSelected;
  final Piece? piece;

  Tile({
    required this.position,
    this.isSelected = false,
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
    Piece? piece,
    bool? isSelected,
  }) {
    return Tile(
      position: position,
      isSelected: isSelected ?? this.isSelected,
      piece: piece ?? this.piece,
    );
  }
}
