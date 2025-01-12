import 'dart:async';
import 'dart:math';

import 'package:bil_app/barrage/barrage_Item.dart';
import 'package:bil_app/barrage/barrage_view_util.dart';
import 'package:bil_app/barrage/hi_socket.dart';
import 'package:bil_app/barrage/i_barrage.dart';
import 'package:flutter/material.dart';

import '../model/barrage_model.dart';

enum BarrageStatus { play, pause }

class HiBarrage extends StatefulWidget {
  // 弹幕行数
  final int lineCount;
  // 视频id
  final String vid;
  // 弹幕速度
  final int speed;
  // 弹幕距离顶部高度
  final double top;
  // 弹幕是否自动播放
  final bool autoPlay;
  // 弹幕header
  final Map<String, dynamic> headers;

  const HiBarrage(
      {super.key,
      this.lineCount = 4,
      required this.vid,
      this.speed = 800,
      this.top = 0,
      this.autoPlay = false,
      required this.headers});

  @override
  State<HiBarrage> createState() => HiBarrageState();
}

class HiBarrageState extends State<HiBarrage> implements IBarrage {
  late HiSocket _hiSocket;
  late double _height;
  late double _width;
  // 弹幕widget集合
  List<BarrageItem> _barrageItemList = [];
  // 弹幕模型 每一条弹幕组成的集合
  List<BarrageModel> _barrageModelList = [];
  // 第几条弹幕
  int _barrageIndex = 0;
  // 随机数
  Random _random = Random();
  BarrageStatus? _barrageStatus;
  // 计时器
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // 创建socket实例
    _hiSocket = HiSocket(widget.headers);
    _hiSocket.open(widget.vid).listen((value) {
      _handleMessage(value);
    });
  }

  @override
  void dispose() {
    _hiSocket.close();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = _width * 16 / 9;
    return SizedBox(
      width: _width,
      height: _height,
      child: Stack(
        children: [Container(), ..._barrageItemList],
      ),
    );
  }

  @override
  void pause() {
    _barrageStatus = BarrageStatus.pause;
    // 清空屏幕上的弹幕
    _barrageItemList.clear();
    setState(() {});
    print('action:pause');
    _timer?.cancel();
  }

  @override
  void play() {
    _barrageStatus = BarrageStatus.play;
    print('action:play');
    // 如果已经设置了定时器，并且是开启状态
    if (_timer != null && (_timer?.isActive ?? false)) return;
    _timer = Timer.periodic(Duration(milliseconds: widget.speed), (timer) {
      if (_barrageModelList.isNotEmpty) {
        // 从弹幕列表中逐个取出后，放入弹幕widget列表中
        var temp = _barrageModelList.removeAt(0);
        addBarrage(temp);
      }
    });
  }

  @override
  void send(String? message) {
    if (message == null) return;
    _hiSocket.send(message);
    _handleMessage(
        [BarrageModel(content: message, vid: '-1', priority: 1, type: 1)]);
  }

  // 接收消息，处理消息
  // instant 是否立即处理
  void _handleMessage(List<BarrageModel> modelList, {bool instant = false}) {
    if (instant) {
      _barrageModelList.insertAll(0, modelList);
    } else {
      _barrageModelList.addAll(modelList);
    }
    if (_barrageStatus == BarrageStatus.play) {
      play();
      return;
    }
    if (widget.autoPlay && _barrageStatus != BarrageStatus.pause) {
      play();
    }
  }

  void addBarrage(BarrageModel model) {
    double perRowHeight = 30;
    var line = _barrageIndex % widget.lineCount;
    _barrageIndex++;
    var top = line * perRowHeight + widget.top;
    String id = '${_random.nextInt(10000)}:${model.content}';
    var item = BarrageItem(
      id: id,
      top: top,
      onComplete: _onComplete,
      child: BarrageViewUtil.barrageView(model),
    );
    _barrageItemList.add(item);
    setState(() {});
  }

  void _onComplete(id) {
    print('Done:$id');
    _barrageItemList.removeWhere((element) => element.id == id);
  }
}
