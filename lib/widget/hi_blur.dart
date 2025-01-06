import 'dart:ui';

import 'package:flutter/material.dart';

class HiBlur extends StatelessWidget {
  final double? sigma;
  final Widget? child;

  const HiBlur({
    super.key,
    this.sigma = 10,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma!, sigmaY: sigma!),
        child: Container(
          color: Colors.white10,
          child: child,
        ));
  }
}
