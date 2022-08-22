import 'package:chess_one/models/tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameTile extends StatelessWidget {
  final Tile tile;

  const GameTile(this.tile, {Key? key}) : super(key: key);

  BoxBorder? get tileBorder {
    if (tile.isSelected) {
      return Border.all(color: Colors.blueGrey, width: 3);
    } else if (tile.isMovableTile) {
      return Border.all(color: Colors.green, width: 3);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: tile.color, border: tileBorder),
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
