import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _controller;
  // Google Mapの初期表示
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(35.71027175858155, 139.8107862279798),
    zoom: 16,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        // 衛生写真かノーマルを表示
        mapType: MapType.hybrid,
        //　Mapの初期位置
        initialCameraPosition: _initialPosition,
        // Mapが作成されたタイミングの処理
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
    );
  }
}
