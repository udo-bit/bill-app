import 'package:flutter/material.dart';

import '../util/view_util.dart';

class HiFlexibleHeader extends StatefulWidget {
  final String name;
  final String face;
  final ScrollController controller;
  const HiFlexibleHeader(
      {super.key,
      required this.name,
      required this.face,
      required this.controller});

  @override
  State<HiFlexibleHeader> createState() => _HiFlexibleHeaderState();
}

class _HiFlexibleHeaderState extends State<HiFlexibleHeader> {
  static const double MAX_BOTTOM = 40;
  static const double MIN_BOTTOM = 10;
  static const MAX_OFFSET = 80;

  double _dyBottom = MAX_BOTTOM;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      var offset = widget.controller.offset;
      print(offset);
      var dyOffset = (MAX_OFFSET - offset) / MAX_OFFSET;
      var dy = dyOffset * (MAX_BOTTOM - MIN_BOTTOM);

      if (dy > (MAX_BOTTOM - MIN_BOTTOM)) {
        dy = MAX_BOTTOM - MIN_BOTTOM;
      } else if (dy < 0) {
        dy = 0;
      }

      setState(() {
        _dyBottom = MIN_BOTTOM + dy;
      });
      print("_dyBottom:$_dyBottom");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(bottom: _dyBottom, left: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: cachedImage(widget.face, width: 46, height: 46),
          ),
          hiSpace(width: 8),
          Text(
            widget.name,
            style: const TextStyle(fontSize: 11),
          )
        ],
      ),
    );
  }
}
