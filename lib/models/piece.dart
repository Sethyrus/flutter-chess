enum PieceType {
  pawn,
  rook,
  knight,
  bishop,
  queen,
  king,
}

enum PieceTeam {
  white,
  black,
}

class Piece {
  final PieceType type;
  final PieceTeam team;

  Piece({
    required this.type,
    required this.team,
  });

  String get icon {
    switch (team) {
      case PieceTeam.white:
        switch (type) {
          case PieceType.pawn:
            return 'lib/assets/piece_icons/pawn_white.svg';
          case PieceType.rook:
            return 'lib/assets/piece_icons/rook_white.svg';
          case PieceType.knight:
            return 'lib/assets/piece_icons/knight_white.svg';
          case PieceType.bishop:
            return 'lib/assets/piece_icons/bishop_white.svg';
          case PieceType.queen:
            return 'lib/assets/piece_icons/queen_white.svg';
          case PieceType.king:
            return 'lib/assets/piece_icons/king_white.svg';
        }
      case PieceTeam.black:
        switch (type) {
          case PieceType.pawn:
            return 'lib/assets/piece_icons/pawn_black.svg';
          case PieceType.rook:
            return 'lib/assets/piece_icons/rook_black.svg';
          case PieceType.knight:
            return 'lib/assets/piece_icons/knight_black.svg';
          case PieceType.bishop:
            return 'lib/assets/piece_icons/bishop_black.svg';
          case PieceType.queen:
            return 'lib/assets/piece_icons/queen_black.svg';
          case PieceType.king:
            return 'lib/assets/piece_icons/king_black.svg';
        }
    }
  }
}
