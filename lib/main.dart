import 'package:bil_app/db/hi_cache.dart';
import 'package:bil_app/http/core/hi_error.dart';
import 'package:bil_app/http/core/hi_net.dart';
import 'package:bil_app/http/dao/login_dao.dart';
import 'package:bil_app/http/request/notice_request.dart';
import 'package:bil_app/page/register_page.dart';
import 'package:bil_app/util/color.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: white),
      home: const RegisterPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HiCache.preInit();
  }

  void _incrementCounter() async {
    try {
      var result = await LoginDao.login("", "");
      debugPrint(result.toString());
    } on NeedLogin catch (e) {
      debugPrint(e.message);
    } on NeedAuth catch (e) {
      debugPrint(e.message);
    } on HiNetError catch (e) {
      debugPrint(e.message);
    }

    test();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void test() async {
    try {
      var result = await HiNet.getInstance().fire(NoticeRequest());
      print(result.toString());
    } catch (e) {
      print(e.toString());
    }
  }
}
