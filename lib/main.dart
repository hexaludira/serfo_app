import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

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
    //this._getData();
    super.initState();
  }

  //widget utama
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      // body: Container(
      //   child: _buildList(),
      // ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildList(),
          //_buildFloatingSearchBar(),
          _buildFloatingSearchAppBar(),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildFloatingSearchAppBar(){
    return FloatingSearchAppBar(
      title: const Text('Title'),
      transitionDuration: const Duration(milliseconds: 800),
      color: Colors.greenAccent.shade100,
      colorOnScroll: Colors.greenAccent.shade200,
      body: ListView.separated(
        padding: EdgeInsets.zero, 
        itemCount: 100,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item $index'),
          );
        }, 
        
      ),

    );
  }

  Widget _buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      maxWidth: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {},
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place), 
            onPressed: (){}
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],

      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 112, color: color,);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  //widget appbar
  Widget _buildBar(BuildContext context) {
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
        if (filteredData[i]['name'].contains(_searchtext.toLowerCase())) {
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
