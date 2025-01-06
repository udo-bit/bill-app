import 'package:bil_app/http/core/hi_error.dart';
import 'package:bil_app/http/dao/profile_dao.dart';
import 'package:bil_app/model/profile_mo.dart';
import 'package:bil_app/util/toast.dart';
import 'package:bil_app/util/view_util.dart';
import 'package:bil_app/widget/course_card.dart';
import 'package:bil_app/widget/hi_banner.dart';
import 'package:bil_app/widget/hi_blur.dart';
import 'package:bil_app/widget/hi_flexible_header.dart';
import 'package:flutter/material.dart';

import '../widget/benefit_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileMo? _profileMo;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            controller: _controller,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[_buildAppBar()];
            },
            body: _buildBody()));
  }

  Future<void> _loadData() async {
    try {
      var result = await ProfileDao.get();
      setState(() {
        _profileMo = result;
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
    }
  }

  _buildHead() {
    if (_profileMo == null) return Container();
    return HiFlexibleHeader(
        name: _profileMo!.name,
        face: _profileMo!.face,
        controller: _controller);
  }

  _buildBody() {
    return ListView(
      padding: const EdgeInsets.only(top: 5),
      children: [..._buildContentList()],
    );
  }

  _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        titlePadding: const EdgeInsets.only(left: 10),
        title: _buildHead(),
        background: Stack(
          children: [
            Positioned.fill(
                child: cachedImage(
                    'https://www.devio.org/img/beauty_camera/beauty_camera4.jpg')),
            const Positioned.fill(
                child: HiBlur(
              sigma: 20,
            )),
            Positioned(
              child: _buildProfileTab(),
              bottom: 0,
              left: 0,
              right: 0,
            )
          ],
        ),
      ),
    );
  }

  _buildContentList() {
    if (_profileMo == null) return [];
    return [
      _buildBanner(),
      CourseCard(courseList: _profileMo!.courseList),
      BenefitCard(
        benefitList: _profileMo!.benefitList,
      )
    ];
  }

  _buildBanner() {
    return HiBanner(
      _profileMo!.bannerList,
      bannerHeight: 120,
      padding: const EdgeInsets.only(left: 10, right: 10),
    );
  }

  _buildProfileTab() {
    if (_profileMo == null) return Container();
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: const BoxDecoration(color: Colors.white54),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconText('收藏', _profileMo!.favorite),
          _buildIconText('点赞', _profileMo!.like),
          _buildIconText('浏览', _profileMo!.browsing),
          _buildIconText('金币', _profileMo!.coin),
          _buildIconText('粉丝', _profileMo!.fans),
        ],
      ),
    );
  }

  _buildIconText(String text, int count) {
    return Column(
      children: [
        Text(
          '$count',
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
