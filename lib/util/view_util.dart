import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'format_util.dart';

Widget cachedImage(String url, {double? width, double? height}) {
  return CachedNetworkImage(
    imageUrl: url,
    height: height,
    width: width,
    fit: BoxFit.cover,
    placeholder: (
      BuildContext context,
      String url,
    ) =>
        Container(
      color: Colors.grey[200],
    ),
    errorWidget: (
      BuildContext context,
      String url,
      Object error,
    ) =>
        const Icon(Icons.error),
  );
}

LinearGradient blackLinearGradient({bool fromTop = true}) {
  return LinearGradient(
    colors: const [
      Colors.black54,
      Colors.black45,
      Colors.black38,
      Colors.black26,
      Colors.black12,
      Colors.transparent
    ],
    begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
    end: fromTop ? Alignment.bottomCenter : Alignment.topCenter,
  );
}

smallIconText(IconData iconData, var text) {
  var style = const TextStyle(fontSize: 12, color: Colors.grey);
  if (text is int) {
    text = countFormat(text);
  }
  return [
    Icon(
      iconData,
      color: Colors.grey,
      size: 12,
    ),
    Text(' $text', style: style)
  ];
}
