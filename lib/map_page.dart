import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
    zoom: 17,
  );

  // 現在の場所
  late final CameraPosition currentPosition;
  // 現在の場所を取得
  Future<void> getCurrentPosition() async {
    // 現在地の場所の権限を与えられているかのチェック
    LocationPermission permission = await Geolocator.checkPermission();
    // 権限が拒否されている場合
    if (permission == LocationPermission.denied) {
      // 権限をリクエストする
      permission = await Geolocator.requestPermission();
      // リクエストしても拒否される場合
      if (permission == LocationPermission.denied) {
        return Future.error('現在地が取得できません');
      }
    }
    // 権限が拒否されていない場合は現在地を取得する
    final Position _currentPosition = await Geolocator.getCurrentPosition();
    currentPosition = CameraPosition(
        target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        zoom: 17);
  }

  // ピンの表示
  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('1'),
      position: LatLng(35.71027175858155, 139.8107862279798),
      infoWindow: InfoWindow(title: '東京スカイツリー', snippet: '634M'),
    ),
    const Marker(
      markerId: MarkerId('2'),
      position: LatLng(35.71055052892032, 139.8091661738491),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        markers: _markers,
        // 衛生写真かノーマルを表示
        mapType: MapType.hybrid,
        //　Mapの初期位置
        initialCameraPosition: _initialPosition,
        // Mapが作成されたタイミングの処理
        onMapCreated: (GoogleMapController controller) async {
          await getCurrentPosition();
          _controller = controller;
          setState(() {
            _markers.add(
              Marker(
                markerId: const MarkerId('3'),
                position: currentPosition.target,
                infoWindow: const InfoWindow(title: '現在地'),
              ),
            );
          });
          _controller
              .animateCamera(CameraUpdate.newCameraPosition(currentPosition));
        },
        // 右下のボタンを押下すると現在地に移動する
        myLocationEnabled: true,
      ),
    );
  }
}
