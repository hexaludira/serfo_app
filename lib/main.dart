import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test search',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: ExamplePage(),
    );
  }
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
  List data_list = List();

  List filteredData = List();

  Icon _iconSearch = Icon(Icons.search);

  Widget _appBarTitle = Text('Contoh cari data');

  //constructor
  _ExamplePageState() {
    _filter.addListener(() { 
      if (_filter.text.isEmpty) {
        setState(() {
          _searchtext = "";
          filteredData = data_list;
        });
      } else {
        setState(() {
          _searchtext = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    this._getData();
    super.initState();
    
  }

  //widget utama
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomInset: false,
    );
    
  }


  //widget appbar
  Widget _buildBar(BuildContext context){
    return AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: IconButton(
        icon: _iconSearch, 
        onPressed: () {
          _searchPressed();
        },
      ),
    );
  }

  void _getData() async {
    final response = await dio.get('https://swapi.dev/api/people');
    // if (response.statusCode == 200) {
    //   print("data OK");
    // } else {
    //   print ("can't get data"); 
    // }
    //print('WArning');
    List tempList = List();
    for (int i = 0; i < response.data['results'].length; i++) {
      tempList.add(response.data['results'][i]);
    }

    setState(() {
      data_list = tempList;
      filteredData = data_list;
    });
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
        filteredData = data_list;
        _filter.clear();
      }
    });
  }

  Widget _buildList() {
    if (!(_searchtext.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < filteredData.length; i++) {
        //mengecek apakah search text sama dengan filtered data
        if(filteredData[i]['name'].toLowerCase().contains(_searchtext.toLowerCase())) {
          tempList.add(filteredData[i]);
        }
      }
      filteredData = tempList;
    }

    return ListView.builder(
      itemCount: data_list == null ? 0 : filteredData.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: Text(filteredData[index]['name']),
          onTap: () => print(filteredData[index]['name']),
        );
      },

    );

  }
}
