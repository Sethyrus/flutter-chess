import 'package:chess_one/models/tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameTile extends StatelessWidget {
  final Tile tile;

  const GameTile(this.tile, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: tile.color,
      child: Stack(
        children: [
          if (tile.piece != null)
            SvgPicture.asset(
              tile.piece!.icon,
              // semanticsLabel: 'van icon',
              // width: 18,
              // height: 18,
              // fit: BoxFit.fitWidth,
              // color: grey,
            ),
        ],
      ),
    );
  }
}
