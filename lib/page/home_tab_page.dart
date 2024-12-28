import 'package:flutter/material.dart';

class HomeTabPage extends StatefulWidget {
  final String name;
  const HomeTabPage({super.key, required this.name});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView(
              children: [
                Text(widget.name),
              ],
            )));
  }
}
