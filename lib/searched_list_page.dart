import 'package:flutter/material.dart';

class SearchedListPage extends StatefulWidget {
  const SearchedListPage({Key? key}) : super(key: key);

  @override
  State<SearchedListPage> createState() => _SearchedListPageState();
}

class _SearchedListPageState extends State<SearchedListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: SizedBox(
          height: 40,
          child: TextField(
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
