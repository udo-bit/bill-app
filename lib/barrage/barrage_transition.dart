import 'package:flutter/material.dart';

class BarrageTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final ValueChanged callback;
  const BarrageTransition(
      {super.key,
      required this.child,
      required this.duration,
      required this.callback});

  @override
  State<BarrageTransition> createState() => BarrageTransitionState();
}

class BarrageTransitionState extends State<BarrageTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: widget.duration)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              widget.callback('');
            }
          });
    var begin = const Offset(1.0, 0);
    var end = const Offset(-1.0, 0);
    _animation = Tween(begin: begin, end: end).animate(_animationController);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
