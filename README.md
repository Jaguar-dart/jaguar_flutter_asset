# jaguar_flutter_asset

Serve files from Flutter assets.

[Example](https://github.com/jaguar-examples/flutter_webview) showing
how to use it in a project.

## Usage

Use `FlutterAssetServer` request handler to serve files from flutter assets.

```dart
  final server = new Jaguar();
  server.addApi(new FlutterAssetServer());
  await server.serve();
```

## Complete example

```dart
import 'package:flutter/material.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

final flutterWebviewPlugin = new FlutterWebviewPlugin();

main() async {
  final server = new Jaguar();
  server.addApi(new FlutterAssetServer());
  await server.serve();

  server.log.onRecord.listen((r) => print(r));

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Jaguar Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Jaguar Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Press the button to launch webview!',
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          flutterWebviewPlugin.launch('http://localhost:8080/',
              fullScreen: true);
        },
        tooltip: 'Launch',
        child: new Icon(Icons.web),
      ),
    );
  }
}
```