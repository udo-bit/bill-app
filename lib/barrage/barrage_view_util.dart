import 'package:bil_app/model/barrage_model.dart';
import 'package:flutter/material.dart';

class BarrageViewUtil {
  static barrageView(BarrageModel model) {
    switch (model.type) {
      case 1:
        return _barrageType1(model);
    }
    return Text(model.content, style: const TextStyle(color: Colors.white));
  }

  static _barrageType1(BarrageModel model) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white)),
        child: Text(
          model.content,
          style: const TextStyle(color: Colors.deepOrangeAccent),
        ),
      ),
    );
  }
}
