import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/io.dart';

import '../model/barrage_model.dart';

abstract class ISocket {
  // 连接服务器
  ISocket open(String vid);
  // 发送弹幕
  ISocket send(String message);
  // 关闭连接
  void close();
  // 接收弹幕
  ISocket listen(ValueChanged<List<BarrageModel>> callBack);
}

class HiSocket implements ISocket {
  final Map<String, dynamic> headers;
  static const _url = 'wss://api.devio.org/uapi/fa/barrage/';
  IOWebSocketChannel? _channel;
  ValueChanged<List<BarrageModel>>? _callBack;

  final int _intervalSeconds = 50;

  HiSocket(this.headers);

  @override
  void close() {
    if (_channel != null) {
      _channel?.sink.close();
    }
  }

  @override
  ISocket listen(callBack) {
    _callBack = callBack;
    return this;
  }

  @override
  ISocket open(String vid) {
    _channel = IOWebSocketChannel.connect(_url + vid,
        headers: headers, pingInterval: Duration(seconds: _intervalSeconds));
    _channel?.stream.handleError((error) {
      debugPrint('连接发生错误:$error');
    }).listen((message) {
      _handleMessage(message);
    });

    return this;
  }

  @override
  ISocket send(String message) {
    _channel?.sink.add(message);
    return this;
  }

  void _handleMessage(message) {
    debugPrint('received:$message');
    var result = BarrageModel.fromJsonString(message);
    if (_callBack != null) {
      _callBack!(result);
    }
  }
}
