## Features
A Flutter point-of-the-spot solution that currently supports scrollable Widget exposure
- Scrollable Exposure: It can be used at all ScrollView Widgets like: ListView , GridView, CustomScrollView and so on.

## Getting started

1. Depend on it 
Add this to your package's pubspec.yaml file:

``` yaml
dependencies:
  flutter_exposure: ^0.0.2
```

2. Install it 
You can install packages from the command line:
with pub:

```
$ pub get
```
with Flutter:

```
$ flutter pub get
```

3. Import it #
Now in your Dart code, you can use:

``` dart
import 'package:exposure/exposure.dart';
```
## Usage
Wrap `ScrollDetailProvider` widget on your ScrollView, 
then Wrap `Exposure` on the widget you want to know when user see it.
You can get `onExpose` callback when widget expose.

If you want to wait until the scroll is over to detect exposure, 
you can set the `lazy` property of `ScrollDetailProvider` to true.

You can also control the proportion of widgets you want to expose through `exposeFactor`.

```dart
    ScrollDetailProvider(
        lazy: true,                     // default value: false
            child: ListView.builder(
                itemCount: 200,
                itemBuilder: (context, index) {
                    return Exposure(
                    exposeFactor: 0.9,  // default value: 0.5
                    onExpose: () {      // required
                        debugPrint('$index');
                    },
                    onHide: (duration) {
                        debugPrint('$duration');
                    },
                    child: Text('$index'),
                );
            },
        ),
    )
```

### check current expose widget
Sometimes you may want to check current widget is exposed or not.
For example the data send back from network, then you update the list.
At this time, you want to get which item is exposed. 
You can use `ExposureController` to trigger `onExpose` callback，
which item current visible on the screen.

```dart
// create a ExposureController
ExposureController _controller = ExposureController();

// set _controller to exposureController 
ScrollDetailProvider(
        lazy: true,                     // default value: false
            child: ListView.builder(
                itemCount: 200,
                itemBuilder: (context, index) {
                    return Exposure(
                    exposureController: controller,
                    exposeFactor: 0.9,  // default value: 0.5
                    onExpose: () {      // required
                        debugPrint('$index');
                    },
                    onHide: (duration) {
                        debugPrint('$duration');
                    },
                    child: Text('$index'),
                );
            },
        ),
    )

// trigger a expose check event
_controller.reCheckExposeState();
```

## Example

Here is some example of usage.

#### Track It Every Time

A `ListView` has items of different heights, tracking the time when each item enters the user's field of vision.

![hight_change_listview_without_lazy_track](./asset/hight_change_listview_without_lazy_track.gif)

#### Lazy Track

A `ListView` has items of different heights, and only when the scrolling is over, the items in the field of view are tracked.

![hight_change_listview_with_lazy_track](./asset/hight_change_listview_with_lazy_track.gif)



#### CustomScrollView

It also support track in `CustomScrollView` with different slivers.



![custom_scrollview_with_lazy_track](./asset/custom_scrollview_with_lazy_track.gif)

## Bugs or Requests 

If you encounter any problems feel free to open an [issue](https://github.com/Vadaski/flutter_exposure/issues). If you feel the library is missing a feature, please raise a ticket on GitHub and I'll look into it. Pull request are also welcome.

