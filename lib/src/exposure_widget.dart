import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'scroll_notification_publisher.dart';

enum ScrollState { visible, invisible }

typedef OnHide = Function(Duration duration);

// 控制曝光
class Exposure extends StatefulWidget {
  const Exposure({
    Key? key,
    required this.onExpose,
    required this.child,
    this.onHide,
    this.exposeFactor = 0.5,
    this.exposureController,
  }) : super(key: key);

  final VoidCallback onExpose;
  final OnHide? onHide;
  final Widget child;
  final double exposeFactor;
  final ExposureController? exposureController;

  @override
  State<Exposure> createState() => _ExposureState();
}

class _ExposureState extends State<Exposure> {
  bool show = false;
  ScrollState state = ScrollState.invisible;
  DateTime? _exposeDate;
  double _scrollOffset = 0.0;
  Axis direction = Axis.vertical;
  late StreamSubscription _scrollNotificationSubscription;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        subscribeScrollNotification(context);
      }
    });
    widget.exposureController?._addState(this);
    super.initState();
  }

  @override
  void dispose() {
    widget.exposureController?._removeState(this);
    _scrollNotificationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void subscribeScrollNotification(BuildContext context) {
    final StreamController<ScrollNotification> publisher =
        ScrollNotificationPublisher.of(context);
    _scrollNotificationSubscription =
        publisher.stream.listen((scrollNotification) {
      _scrollOffset = scrollNotification.metrics.pixels;
      direction = scrollNotification.metrics.axis;
      trackWidgetPosition();
    });
  }

  void trackWidgetPosition() {
    if (!mounted) {
      return;
    }
    final exposureOffset = getExposureOffset(context);
    final exposurePitSize = (context.findRenderObject() as RenderBox).size;
    final viewPortSize = getViewPortSize(context) ?? const Size(1, 1);
    if (direction == Axis.vertical) {
      checkExposure(exposureOffset, _scrollOffset, exposurePitSize.height,
          viewPortSize.height);
    } else {
      checkExposure(exposureOffset, _scrollOffset, exposurePitSize.width,
          viewPortSize.width);
    }
  }

  Size? getViewPortSize(BuildContext context) {
    final RenderObject? box = context.findRenderObject();
    final RenderAbstractViewport? viewport = RenderAbstractViewport.of(box);
    final Size? size = viewport?.paintBounds.size;
    return size;
  }

  double getExposureOffset(BuildContext context) {
    final RenderObject? box = context.findRenderObject();
    final RenderAbstractViewport? viewport = RenderAbstractViewport.of(box);

    if (viewport == null || box == null || !box.attached) {
      return 0.0;
    }

    final RevealedOffset offsetRevealToTop =
        viewport.getOffsetToReveal(box, 0.0, rect: Rect.zero);
    return offsetRevealToTop.offset;
  }

  void checkExposure(double exposureOffset, double scrollOffset,
      double currentSize, double viewPortSize) {
    final exposeFactor = min(max(widget.exposeFactor, 0.1), 0.9);
    bool becomeVisible =
        (exposureOffset + currentSize * (1 - exposeFactor)) > scrollOffset &&
            (exposureOffset + currentSize * exposeFactor) <
                (scrollOffset + viewPortSize);

    bool becomeInvisible =
        (exposureOffset + currentSize * exposeFactor) < scrollOffset ||
            (exposureOffset + (currentSize * (exposeFactor))) >
                scrollOffset + viewPortSize;

    if (state == ScrollState.invisible) {
      if (becomeVisible) {
        state = ScrollState.visible;
        widget.onExpose.call();
        _recordExposeTime();
        return;
      }
    } else {
      if (becomeInvisible) {
        state = ScrollState.invisible;
        _onHide();
        return;
      }
    }
  }

  _recordExposeTime() {
    _exposeDate = DateTime.now();
  }

  _onHide() {
    widget.onHide?.call(DateTime.now().difference(_exposeDate!));
  }

  void reCheckExposeState() {
    state = ScrollState.invisible;
    show = false;
    _scrollNotificationSubscription.cancel();
    subscribeScrollNotification(context);
    trackWidgetPosition();
  }
}

class ExposureController {
  final List<_ExposureState> _states = [];

  void _addState(_ExposureState state) {
    _states.add(state);
  }

  void _removeState(_ExposureState state) {
    _states.remove(state);
  }

  void reCheckExposeState() {
    for (var _state in _states) {
      _state.reCheckExposeState();
    }
  }
}
