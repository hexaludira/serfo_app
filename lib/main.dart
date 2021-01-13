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

      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
