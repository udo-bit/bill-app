import 'package:bil_app/http/request/ranking_request.dart';
import 'package:bil_app/model/ranking_mo.dart';

import '../core/hi_net.dart';

class RankingDao {
  static get(String sort, {pageIndex = 1, pageSize = 10}) async {
    RankingRequest request = RankingRequest();
    request
        .add("sort", sort)
        .add('pageIndex', pageIndex)
        .add('pageSize', pageSize);

    var result = await HiNet.getInstance().fire(request);
    print(result);
    return RankingMo.fromJson(result['data']);
  }
}
