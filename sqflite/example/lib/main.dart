import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:sqflite_sqlcipher_example/batch_test_page.dart';
import 'package:sqflite_sqlcipher_example/deprecated_test_page.dart';
import 'package:sqflite_sqlcipher_example/exception_test_page.dart';
import 'package:sqflite_sqlcipher_example/exp_test_page.dart';
import 'package:sqflite_sqlcipher_example/manual_test_page.dart';
import 'package:sqflite_sqlcipher_example/sqlcipher_test_page.dart';
import 'package:sqflite_sqlcipher_example/src/dev_utils.dart';

import 'model/main_item.dart';
import 'open_test_page.dart';
import 'raw_test_page.dart';
import 'slow_test_page.dart';
import 'src/main_item_widget.dart';
import 'todo_test_page.dart';
import 'type_test_page.dart';

void main() {
  runApp(MyApp());
}

/// Sqflite test app
class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

/// SqlCipher test page
const String testSqlCipherRoute = "/test/sqlcipher";

/// Simple test page.
const String testRawRoute = '/test/simple';

/// Open test page.
const String testOpenRoute = '/test/open';

/// Slow test page.
const String testSlowRoute = '/test/slow';

/// Type test page.
const String testTypeRoute = '/test/type';

/// Batch test page.
const String testBatchRoute = '/test/batch';

/// `todo` example test page.
const String testTodoRoute = '/test/todo';

/// Exception test page.
const String testExceptionRoute = '/test/exception';

/// Manual test page.
const String testManualRoute = '/test/manual';

/// Experiment test page.
const String testExpRoute = '/test/exp';

/// Deprecated test page.
const String testDeprecatedRoute = '/test/deprecated';

class _MyAppState extends State<MyApp> {
  var routes = <String, WidgetBuilder>{
    '/test': (BuildContext context) => MyHomePage(),
    testSqlCipherRoute: (BuildContext context) => SqlCipherTestPage(),
    testRawRoute: (BuildContext context) => RawTestPage(),
    testOpenRoute: (BuildContext context) => OpenTestPage(),
    testSlowRoute: (BuildContext context) => SlowTestPage(),
    testTodoRoute: (BuildContext context) => TodoTestPage(),
    testTypeRoute: (BuildContext context) => TypeTestPage(),
    testManualRoute: (BuildContext context) => ManualTestPage(),
    testBatchRoute: (BuildContext context) => BatchTestPage(),
    testExceptionRoute: (BuildContext context) => ExceptionTestPage(),
    testExpRoute: (BuildContext context) => ExpTestPage(),
    testDeprecatedRoute: (BuildContext context) => DeprecatedTestPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sqflite Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with 'flutter run'. You'll see
          // the application has a blue toolbar. Then, without quitting
          // the app, try changing the primarySwatch below to Colors.green
          // and then invoke 'hot reload' (press 'r' in the console where
          // you ran 'flutter run', or press Run > Hot Reload App in IntelliJ).
          // Notice that the counter didn't reset back to zero -- the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Sqflite Demo Home Page'),
        routes: routes);
  }
}

/// App home menu page.
class MyHomePage extends StatefulWidget {
  /// App home menu page.
  MyHomePage({Key key, this.title}) : super(key: key) {
    _items.add(
        MainItem("Sqlcipher tests", "Simple tests with an encrypted database", route: testSqlCipherRoute));
    _items.add(
        MainItem("Raw tests", "Raw SQLite operations", route: testRawRoute));
    _items.add(MainItem("Open tests", "Open onCreate/onUpgrade/onDowngrade",
        route: testOpenRoute));
    _items
        .add(MainItem('Type tests', 'Test value types', route: testTypeRoute));
    _items.add(MainItem('Batch tests', 'Test batch operations',
        route: testBatchRoute));
    _items.add(
        MainItem('Slow tests', 'Lengthy operations', route: testSlowRoute));
    _items.add(MainItem(
        'Todo database example', 'Simple Todo-like database usage example',
        route: testTodoRoute));
    _items.add(MainItem('Exp tests', 'Experimental and various tests',
        route: testExpRoute));
    _items.add(MainItem('Exception tests', 'Tests that trigger exceptions',
        route: testExceptionRoute));
    _items.add(MainItem('Manual tests', 'Tests that requires manual execution',
        route: testManualRoute));
    _items.add(MainItem('Deprecated test',
        'Keeping some old tests for deprecated functionalities',
        route: testDeprecatedRoute));

    // Uncomment to view all logs
    //Sqflite.devSetDebugModeOn(true);
  }

  final List<MainItem> _items = [];

  /// Page title.
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

String _debugAutoStartRouteName;

/// (debug) set the route to start with.
String get debugAutoStartRouteName => _debugAutoStartRouteName;

/// Deprecated to avoid calls
@deprecated
set debugAutoStartRouteName(String routeName) =>
    _debugAutoStartRouteName = routeName;

class _MyHomePageState extends State<MyHomePage> {
  String _platformVersion = 'Unknown';

  int get _itemCount => widget._items.length;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      // ignore: deprecated_member_use
      platformVersion = await Sqflite.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });

    print('running on: ' + _platformVersion);

    // Use it to auto start a test page
    if (debugAutoStartRouteName != null) {
      // only once

      // await Navigator.of(context).pushNamed(testExpRoute);
      // await Navigator.of(context).pushNamed(testRawRoute);
      var future = Navigator.of(context).pushNamed(debugAutoStartRouteName);
      // ignore: deprecated_member_use_from_same_package
      debugAutoStartRouteName = null;
      await future;
      // await Navigator.of(context).pushNamed(testExceptionRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Center(child: Text('Sqflite demo', textAlign: TextAlign.center)),
        ),
        body:
            ListView.builder(itemBuilder: _itemBuilder, itemCount: _itemCount));
  }

  //new Center(child: new Text('Running on: $_platformVersion\n')),

  Widget _itemBuilder(BuildContext context, int index) {
    return MainItemWidget(widget._items[index], (MainItem item) {
      Navigator.of(context).pushNamed(item.route);
    });
  }
}
