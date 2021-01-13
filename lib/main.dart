import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class ExamplePage extends StatefulWidget {
  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final TextEditingController _filter = TextEditingController();

  final dio = Dio();

  String _searchtext = "";

  //membuat list
  List data = List();

  List filteredData = List();

  Icon _iconSearch = Icon(Icons.search);

  Widget _appBarTitle = Text('Contoh cari data');

  @override
  void initState() {
    super.initState();
    void _getData() async {
      final response = await dio.get('https://reqres.in/api/users?page=2');
      List tempList = List();
      for (int i = 0; i < response.data['results'].length; i++) {
        tempList.add(response.data['results'][i]);
      }

      setState(() {
        data = tempList;
        filteredData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        leading: IconButton(
          icon: _iconSearch,
          onPressed: _searchPressed(),
        ),
        title: _appBarTitle,
        centerTitle: true,
      );
    
  }

  void _searchPressed() {
    setState(() {
      if (this._iconSearch.icon == Icons.search) {
        this._iconSearch = Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search...',
          ),
        );
      } else {
        this._iconSearch = Icon(Icons.search);
        this._appBarTitle = Text('Search data');
        filteredData = data;
        _filter.clear();
      }
    });
  }
}
