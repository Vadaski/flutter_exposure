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
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const TabBar(tabs: [
          Tab(text: 'StaggeredGridViewDemo'),
          Tab(text: 'CustomScrollViewDemo'),
        ]),
        body: TabBarView(
          children: [
            StaggeredGridViewDemo(),
            const CustomScrollViewDemo(),
          ],
        ),
      ),
    );
  }
}

class StaggeredGridViewDemo extends StatelessWidget {
  StaggeredGridViewDemo({Key? key}) : super(key: key);
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ScrollDetailProvider(
      lazy: false,
      child: StaggeredGridView.countBuilder(
          shrinkWrap: true,
          controller: _scrollController,
          crossAxisCount: 4,
          crossAxisSpacing: 4,
          mainAxisSpacing: 10,
          itemCount: 30,
          itemBuilder: (context, index) {
            return Exposure(
              exposeFactor: 0,
              onExpose: () {
                debugPrint('$index');
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
    );
  }
}

class CustomScrollViewDemo extends StatelessWidget {
  const CustomScrollViewDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ScrollDetailProvider(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverGrid(
                //Grid
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //Grid???????????????
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 4.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    //?????????widget
                    return Exposure(
                        onExpose: () {
                          debugPrint('SliverGrid$index');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.cyan[100 * (index % 9)],
                          child: Text('grid item $index'),
                        ));
                  },
                  childCount: 20,
                ),
              ),
            ),
            SliverFixedExtentList(
              itemExtent: 50.0,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  //???????????????
                  return Exposure(
                    onExpose: (){
                      debugPrint('SliverFixedExtentList:$index');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.lightBlue[100 * (index % 9)],
                      child: Text('list item $index'),
                    ),
                  );
                },
                childCount: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
