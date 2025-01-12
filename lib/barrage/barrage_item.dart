import 'package:bil_app/barrage/barrage_transition.dart';
import 'package:flutter/material.dart';

class BarrageItem extends StatelessWidget {
  final String id;
  final double top;
  final Widget child;
  final ValueChanged onComplete;
  final Duration duration;
  BarrageItem(
      {super.key,
      required this.top,
      required this.child,
      required this.onComplete,
      this.duration = const Duration(milliseconds: 9000),
      required this.id});

  final _key = GlobalKey<BarrageTransitionState>();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        top: top,
        child: BarrageTransition(
          key: _key,
          duration: duration,
          callback: (value) {
            onComplete(id);
          },
          child: child,
        ));
  }
}
