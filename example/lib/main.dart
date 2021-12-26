import 'package:flutter/material.dart';
import 'package:flutter_exposure/exposure.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollDetailProvider(
        child: StaggeredGridView.countBuilder(
            shrinkWrap: true,
            controller: _scrollController,
            crossAxisCount: 4,
            crossAxisSpacing: 4,
            mainAxisSpacing: 10,
            itemCount: 30,
            itemBuilder: (context, index) {
              return Exposure(
                onExpose: (){
                  print(index);
                },
                child: Container(
                    color: Colors.green,
                    child: Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Text('$index'),
                      ),
                    )),
              );
            },
            staggeredTileBuilder: (index) =>
                StaggeredTile.count(2, index == 0 ? 2.5 : 3)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          print('123');
        },
      ),
    );
  }
}
