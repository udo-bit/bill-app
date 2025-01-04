import 'package:bil_app/model/video_model.dart';
import 'package:flutter/material.dart';

import '../util/view_util.dart';

class ExpandableContent extends StatefulWidget {
  final VideoModel mo;
  const ExpandableContent({super.key, required this.mo});

  @override
  State<ExpandableContent> createState() => _ExpandableContentState();
}

class _ExpandableContentState extends State<ExpandableContent>
    with SingleTickerProviderStateMixin {
  final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  // CurveTween(curve: Curves.easeIn).animate(parent);
  bool _expand = false;
  late AnimationController _controller;
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _heightFactor = _easeInTween.animate(_controller);
    _heightFactor.addListener(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
      child: Column(
        children: [
          _buildTitle(),
          const Padding(padding: EdgeInsets.only(bottom: 8)),
          _buildInfo(),
          _buildDocs(),
        ],
      ),
    );
  }

  _buildTitle() {
    return InkWell(
      onTap: _toggleExpand,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              widget.mo.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 15)),
          Icon(
            _expand
                ? Icons.keyboard_arrow_up_sharp
                : Icons.keyboard_arrow_down_sharp,
            color: Colors.grey,
            size: 16,
          ),
        ],
      ),
    );
  }

  void _toggleExpand() {
    setState(() {
      _expand = !_expand;
      if (_expand) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  _buildInfo() {
    var style = const TextStyle(fontSize: 12, color: Colors.grey);
    var dateStr = widget.mo.createTime.length > 10
        ? widget.mo.createTime.substring(5, 10)
        : widget.mo.createTime;
    return Row(
      children: [
        ...smallIconText(Icons.ondemand_video, widget.mo.view),
        const Padding(
          padding: EdgeInsets.only(left: 10),
        ),
        ...smallIconText(Icons.list_alt, widget.mo.reply),
        Text(
          '  $dateStr',
          style: style,
        )
      ],
    );
  }

  _buildDocs() {
    var child = _expand
        ? Text(
            widget.mo.desc,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          )
        : null;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: (BuildContext context, Widget? child) {
        return Align(
          heightFactor: _heightFactor.value,
          alignment: Alignment.topCenter,
          child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(top: 8),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
