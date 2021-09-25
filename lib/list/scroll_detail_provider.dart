import 'package:exposure/list/scroll_notification_publisher.dart';
import 'package:flutter/material.dart';

class ScrollDetailProvider extends StatefulWidget {
  const ScrollDetailProvider({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  _ScrollDetailProviderState createState() => _ScrollDetailProviderState();
}

class _ScrollDetailProviderState extends State<ScrollDetailProvider>
    with AutomaticKeepAliveClientMixin {
  // void initState() {

  //   super.initState();
  // }

  @override
  void dispose() {
    ScrollNotificationPublisher.of(context).close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScrollNotificationPublisher(
      child: Builder(builder: (context) {
        postStartPosition(context);
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            ScrollNotificationPublisher.of(context).add(scrollNotification);
            return false;
          },
          child: widget.child,
        );
      }),
    );
  }

  void postStartPosition(BuildContext context) async {
    await Future.delayed(Duration(microseconds: 500));
    ScrollNotificationPublisher.of(context).add(
      ScrollStartNotification(
        context: context,
        metrics: FixedScrollMetrics(
          minScrollExtent: 0.0,
          maxScrollExtent: 0.0,
          pixels: 0.0,
          viewportDimension: 0.0,
          axisDirection: AxisDirection.down,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
