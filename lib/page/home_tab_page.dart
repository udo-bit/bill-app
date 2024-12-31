import 'dart:convert';

import 'package:bil_app/widget/hi_banner.dart';
import 'package:flutter/material.dart';

import '../model/home_mo.dart';

class HomeTabPage extends StatefulWidget {
  final String name;
  final List<BannerMo>? bannerList;
  const HomeTabPage({super.key, required this.name, this.bannerList});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  Widget build(BuildContext context) {
    print(json.encode(widget.bannerList));
    return Scaffold(
        body: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView(
              children: [
                if (widget.bannerList != null) _banner(),
              ],
            )));
  }

  _banner() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 1),
      child: HiBanner(widget.bannerList!),
    );
  }
}
