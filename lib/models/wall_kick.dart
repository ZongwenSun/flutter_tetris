
import 'mino.dart';

class KickOffset {
  final int dx;
  final int dy;

  KickOffset(this.dx, this.dy);
}

class WallKickData {
  static List<List<KickOffset>> rightRotationForMiniI = [
    [KickOffset(0, 0), KickOffset(-2, 0), KickOffset(1, 0), KickOffset(-2, -1), KickOffset(1, 2)], // up->right
    [KickOffset(0, 0), KickOffset(-1, 0), KickOffset(2, 0), KickOffset(-1, 2), KickOffset(2, -1)], //right->down
    [KickOffset(0, 0), KickOffset(2, 0), KickOffset(-1, 0), KickOffset(2, 1), KickOffset(-1, -2)], // down->left
    [KickOffset(0, 0), KickOffset(1, 0), KickOffset(-2, 0), KickOffset(1, -2), KickOffset(-2, 1)], //left->up
  ];

  static List<List<KickOffset>> leftRotationForMiniI = [
    [KickOffset(0, 0), KickOffset(-1, 0), KickOffset(2, 0), KickOffset(-1, 2), KickOffset(2, -1)], // up->left
    [KickOffset(0, 0), KickOffset(2, 0), KickOffset(-1, 0), KickOffset(2, 1), KickOffset(-1, -2)], // right->up
    [KickOffset(0, 0), KickOffset(1, 0), KickOffset(-2, 0), KickOffset(1, -2), KickOffset(-2, 1)], // down->right
    [KickOffset(0, 0), KickOffset(-2, 0), KickOffset(1, 0), KickOffset(-2, -1), KickOffset(1, 2)], // left->down
  ];

  static List<List<KickOffset>> rightRotatioinForOtherMini = [
    [KickOffset(0, 0), KickOffset(-1, 0), KickOffset(-1, 1), KickOffset(0, -2), KickOffset(-1, -2)], // up->right
    [KickOffset(0, 0), KickOffset(1, 0), KickOffset(1, -1), KickOffset(0, 2), KickOffset(1, 2)], //right->down
    [KickOffset(0, 0), KickOffset(1, 0), KickOffset(1, 1), KickOffset(0, -2), KickOffset(1, -2)], // down->left
    [KickOffset(0, 0), KickOffset(-1, 0), KickOffset(-1, -1), KickOffset(0, 2), KickOffset(-1, 2)], //left->up
  ];

  static List<List<KickOffset>> leftRotatioinForOtherMini = [
    [KickOffset(0, 0), KickOffset(1, 0), KickOffset(1, 1), KickOffset(0, -2), KickOffset(1, -2)], // up->left
    [KickOffset(0, 0), KickOffset(1, 0), KickOffset(1, -1), KickOffset(0, 2), KickOffset(1, 2)], // right->up
    [KickOffset(0, 0), KickOffset(-1, 0), KickOffset(-1, 1), KickOffset(0, -2), KickOffset(-1, -2)], // down->right
    [KickOffset(0, 0), KickOffset(-1, 0), KickOffset(-1, -1), KickOffset(0, 2), KickOffset(-1, 2)], // left->down
  ];

  static List<KickOffset> getRightRotationWallKickOffsets(MinoType type, MinoState state) {
    if (type == MinoType.I) {
      return rightRotationForMiniI[state.index];
    } else if (type == MinoType.O) {
      return [];
    } else {
      return rightRotatioinForOtherMini[state.index];
    }
  }

  static List<KickOffset> getLeftRotationWallKickOffsets(MinoType type, MinoState state) {
    if (type == MinoType.I) {
      return leftRotationForMiniI[state.index];
    } else if (type == MinoType.O) {
      return [];
    } else {
      return leftRotatioinForOtherMini[state.index];
    }
  }
}
