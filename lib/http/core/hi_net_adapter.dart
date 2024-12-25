import 'dart:convert';

import '../request/base_request.dart';

abstract class HiNetAdapter {
  Future<HiNetResponse<T>> send<T>(BaseRequest request);
}

/// 返回相应
class HiNetResponse<T> {
  T? data;
  BaseRequest request;
  int? status;
  String? statusMessage;
  late dynamic extra;

  HiNetResponse(
      {this.data,
      required this.request,
      this.status,
      this.statusMessage,
      this.extra});

  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    } else {
      return data.toString();
    }
  }
}
