import 'package:chess_one/models/piece.dart';
import 'package:chess_one/models/position.dart';
import 'package:flutter/material.dart';

class Tile {
  final Position position;
  final Piece? piece;

  Tile({
    required this.position,
    this.piece,
  });

  Color get color {
    if ((position.x + position.y) % 2 == 0) {
      return Colors.brown.shade100;
    } else {
      return Colors.brown.shade500;
    }
  }
}
