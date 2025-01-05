import 'package:bil_app/http/core/hi_error.dart';
import 'package:bil_app/util/color.dart';
import 'package:bil_app/util/toast.dart';
import 'package:flutter/material.dart';

import 'hi_state.dart';

abstract class HiBaseTabState<M, L, T extends StatefulWidget> extends HiState<T>
    with AutomaticKeepAliveClientMixin {
  List<L> dataList = [];
  int pageIndex = 1;
  bool loading = false;
  ScrollController controller = ScrollController();

  // 子元素
  get contentChild;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      var dis =
          controller.position.maxScrollExtent - controller.position.pixels;
      if (dis < 300 && !loading && controller.position.maxScrollExtent != 0) {
        loadData(loadMore: true);
      }
    });
    loadData(loadMore: false);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
        color: primary,
        onRefresh: loadData,
        child: MediaQuery.removePadding(
          context: context,
          child: contentChild,
          removeTop: true,
        ));
  }

  Future<M> getData(int pageIndex);
  List<L> parseList(M result);

  Future<void> loadData({bool loadMore = false}) async {
    if (loading) {
      return;
    }
    loading = true;
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    try {
      M result = await getData(currentIndex);
      setState(() {
        if (loadMore) {
          dataList = [...dataList, ...parseList(result)];
          if (parseList(result).isNotEmpty) {
            pageIndex++;
          }
        } else {
          dataList = parseList(result);
        }
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        loading = false;
      });
    } on NeedAuth catch (e) {
      loading = false;
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      loading = false;
      showWarnToast(e.message);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
