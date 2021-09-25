## Features
A Flutter point-of-the-spot solution that currently supports scrollable Widget exposure
- Scrollable Exposure

## Getting started

1. Depend on it 
Add this to your package's pubspec.yaml file:

``` yaml
dependencies:
  exposure: ^0.0.1
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
Wrap ScrollDetailProvider widget on your ScrollView, 
then Wrap Exposure on the widget you want to know when user see it.
You can get onExpose callback when widget expose;
```dart
    ScrollDetailProvider(
        child: ListView.builder(
            itemCount: 200,
            itemBuilder: (context, index) {
                return Exposure(
                    onExpose: () {debugPrint('$index');},
                    child: Text('$index'),
                );
            },
        ),
    )
```

## Bugs or Requests 
If you encounter any problems feel free to open an [issue](https://github.com/Vadaski/flutter_exposure/issues). If you feel the library is missing a feature, please raise a ticket on GitHub and I'll look into it. Pull request are also welcome.
