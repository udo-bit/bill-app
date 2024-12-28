import 'package:bil_app/navigator/route_delegate.dart';
import 'package:flutter/material.dart';

import 'db/hi_cache.dart';

void main() {
  runApp(const BiliApp());
}

class BiliApp extends StatefulWidget {
  const BiliApp({super.key});

  @override
  State<BiliApp> createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  final BiliRouteDelegate _routeDelegate = BiliRouteDelegate();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HiCache>(
        future: HiCache.preInit(),
        builder: (BuildContext context, AsyncSnapshot<HiCache> snapshot) {
          var widget = snapshot.connectionState == ConnectionState.done
              ? Router(
                  routerDelegate: _routeDelegate,
                )
              : const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
          return MaterialApp(
            home: widget,
          );
        });
  }
}
