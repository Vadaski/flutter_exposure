// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_exposure/exposure.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exposure Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ''),
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8),
                  color: Colors.amber,
                  child: NormalListView())),
          Expanded(
              child: Container(
            color: Colors.blue,
            alignment: Alignment.center,
            padding: EdgeInsets.all(8),
                child: ListViewWithDifferentSize(),
          )),
          Expanded(
              child: Container(
            color: Colors.redAccent,
            alignment: Alignment.center,
            padding: EdgeInsets.all(8),
                child: GridScrollView(),
          )),
        ],
      ),
    );
  }
}

class NormalListView extends StatelessWidget {
  const NormalListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollDetailProvider(
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 20,
          itemBuilder: (context, index) {
            return Center(
              child: Exposure(
                onExpose: () => print('NormalListView: $index expose'),
                child: Container(
                  height: 200,
                  width: 200,
                  color: Colors.white70,
                  margin: EdgeInsets.all(8),
                ),
              ),
            );
          }),
    );
  }
}

class ListViewWithDifferentSize extends StatefulWidget {
  @override
  _ListViewWithDifferentSizeState createState() =>
      _ListViewWithDifferentSizeState();
}

class _ListViewWithDifferentSizeState extends State<ListViewWithDifferentSize> {
  final List items = List(20);

  @override
  void initState() {
    items.fillRange(0, 20, 'X');
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ScrollDetailProvider(
      lazy: false,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 20,
          itemBuilder: (context, index) {
            return Center(
              child: Exposure(
                exposeFactor: 0,
                onExpose: () {
                  print('ListViewWithDifferentSize: $index expose');
                  setState(() {});
                },
                child: Container(
                  height: 100.0 + (10 * index),
                  width: 100.0 + (10 * index),
                  color: Colors.white70,
                  margin: EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: Text(items[index],style: TextStyle(
                    fontSize: 30
                  )),
                ),
              ),
            );
          }),
    );
  }
}

class GridScrollView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScrollDetailProvider(
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
          itemCount: 20,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2
          ), itemBuilder: (BuildContext context, int index){
            return Exposure(
              child: Container(
                height: 100.0,
                width: 100.0,
                color: Colors.white70,
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              ),
            );
      }),
    );
  }
}