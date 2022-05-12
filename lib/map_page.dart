import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
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

  String? errorText;

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

  // 緯度と経度を検索する
  Future<CameraPosition> searchLatlng(String address) async {
    // locationFromAddressはgeocodingに用意されているメソッド
    List<Location> locations = await locationFromAddress(address);
    return CameraPosition(
        target: LatLng(locations[0].latitude, locations[0].longitude),
        zoom: 16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.place,
                  color: Colors.cyan,
                ),
                hintText: '場所を検索',
                filled: true,
                fillColor: Colors.cyanAccent.withOpacity(0.1),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                ),
              ),
              // 検索した後の処理
              onSubmitted: (value) async {
                try {
                  CameraPosition result = await searchLatlng(value);
                  // 画面を検索した場所に移動する
                  _controller
                      .animateCamera(CameraUpdate.newCameraPosition(result));
                  setState(() {
                    _markers.add(
                      Marker(
                        markerId: const MarkerId('4'),
                        position: result.target,
                        infoWindow: const InfoWindow(title: '検索した場所'),
                      ),
                    );
                  });
                } catch (e) {
                  print(e);
                  setState(() {
                    errorText = '正しい場所を入力して下さい';
                    final snackBar = SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(errorText!),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  });
                }
              },
            ),
            Expanded(
              child: GoogleMap(
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
                  _controller.animateCamera(
                      CameraUpdate.newCameraPosition(currentPosition));
                },
                // 右下のボタンを押下すると現在地に移動する
                myLocationEnabled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
