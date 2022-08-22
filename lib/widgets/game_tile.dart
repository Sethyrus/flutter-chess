import 'package:chess_one/models/tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameTile extends StatelessWidget {
  final Tile tile;

  const GameTile(this.tile, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: tile.color,
        border: tile.isSelected
            ? Border.all(
                width: 8,
                color: Colors.green,
              )
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (tile.piece != null)
            SvgPicture.asset(
              tile.piece!.icon,
              width: double.infinity,
              height: double.infinity,
            ),
        ],
      ),
    );
  }
}
