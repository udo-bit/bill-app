//barrage_model.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';

class BarrageModel {
  late String content;
  late String vid;
  late int priority;
  late int type;

  BarrageModel(
      {required this.content,
      required this.vid,
      required this.priority,
      required this.type});

  BarrageModel.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    vid = json['vid'];
    priority = json['priority'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['vid'] = vid;
    data['priority'] = priority;
    data['type'] = type;
    return data;
  }

  static List<BarrageModel> fromJsonString(json) {
    List<BarrageModel> list = [];
    if (json is! String || !json.startsWith('[')) {
      debugPrint('json is not invalid');
      return [];
    }

    var jsonArray = jsonDecode(json);
    jsonArray.forEach((v) {
      list.add(BarrageModel.fromJson(v));
    });
    return list;
  }
}
