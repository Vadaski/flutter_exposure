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
  final ExposureController _controller = ExposureController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const TabBar(
          tabs: [
            Tab(text: 'ListViewDemo'),
            Tab(text: 'StaggeredGridViewDemo'),
            Tab(text: 'CustomScrollViewDemo'),
          ],
          labelColor: Colors.black,
        ),
        body: TabBarView(
          children: [
            ListViewDemo(),
            StaggeredGridViewDemo(controller: _controller),
            const CustomScrollViewDemo(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _controller.reCheckExposeState();
          },
        ),
      ),
    );
  }
}

class ListViewDemo extends StatefulWidget {
  const ListViewDemo({super.key});

  @override
  State<ListViewDemo> createState() => _ListViewDemoState();
}

class _ListViewDemoState extends State<ListViewDemo> {
  List<Color> colors = List.generate(20, (index) => Colors.red);

  void onHide(int index) {
    setState(() {
      colors[index] = Colors.red;
    });
  }

  void onExpose(int index) {
    setState(() {
      colors[index] = Colors.green;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollDetailProvider(
        child: ListView.builder(
          itemCount: colors.length,
          itemBuilder: (context, index) {
            return Exposure(
              exposeFactor: 0.9,
              onExpose: () => onExpose(index),
              onHide: (_) {
                onHide(index);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: 100,
                    color: colors[index],
                    child: Center(
                      child: Text('$index', style: TextStyle(fontSize: 20)),
                    )),
              ),
            );
          },
        ),
      ),
    );
  }
}

class StaggeredGridViewDemo extends StatelessWidget {
  StaggeredGridViewDemo({Key? key, required this.controller}) : super(key: key);
  final ScrollController _scrollController = ScrollController();
  ExposureController controller;

  @override
  Widget build(BuildContext context) {
    return ScrollDetailProvider(
      lazy: false,
      child: MasonryGridView.count(
        shrinkWrap: true,
        controller: _scrollController,
        crossAxisCount: 4,
        crossAxisSpacing: 4,
        mainAxisSpacing: 10,
        itemCount: 30,
        itemBuilder: (context, index) {
          return Exposure(
            exposureController: controller,
            // exposeFactor: 0.5,
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
      ),
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
                  crossAxisCount: 2, //Grid按两列显示
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 4.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    //创建子widget
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
                  //创建列表项
                  return Exposure(
                    onExpose: () {
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
