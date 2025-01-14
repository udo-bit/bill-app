import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final bool cover;
  const LoadingContainer(
      {super.key,
      required this.child,
      required this.isLoading,
      this.cover = false});

  get _loadingView {
    return Center(
      child: Lottie.asset(
        'assets/loading.json',
        width: 120,
        height: 120,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cover) {
      return Stack(
        children: [child, isLoading ? _loadingView : Container()],
      );
    } else {
      return isLoading ? _loadingView : child;
    }
  }
}
