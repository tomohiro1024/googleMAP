// 場所を管理するクラス

import 'dart:typed_data';

class Place {
  String? name;
  String? address;
  late List<Uint8List?> images;
  Place({required this.name, required this.address, required this.images});
}
