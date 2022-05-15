import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';

class SearchedListPage extends StatefulWidget {
  const SearchedListPage({Key? key}) : super(key: key);

  @override
  State<SearchedListPage> createState() => _SearchedListPageState();
}

class _SearchedListPageState extends State<SearchedListPage> {
  late GooglePlace googlePlace;
  List<AutocompletePrediction>? prediction = [];

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
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: SizedBox(
          height: 40,
          child: TextField(
            autofocus: true,
            style: TextStyle(
              color: Colors.cyan,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.place,
                color: Colors.cyan,
              ),
              hintText: '場所を検索',
              hintStyle: const TextStyle(fontSize: 15, color: Colors.cyan),
              filled: true,
              fillColor: Colors.cyanAccent.withOpacity(0.1),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.cyan),
              ),
            ),
            // 検索した後の処理
            onSubmitted: (value) async {},
          ),
        ),
      ),
    );
  }
}
