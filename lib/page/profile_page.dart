import 'package:bil_app/http/core/hi_error.dart';
import 'package:bil_app/http/dao/profile_dao.dart';
import 'package:bil_app/model/profile_mo.dart';
import 'package:bil_app/util/toast.dart';
import 'package:bil_app/util/view_util.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileMo _profileMo;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 10),
              title: _buildHead(),
              background: Container(
                color: Colors.deepOrangeAccent,
              ),
            ),
          )
        ];
      },
      body: ListView.builder(
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text("标题$index"),
            );
          }),
    ));
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
    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.only(bottom: 30, left: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(23),
            child: cachedImage(_profileMo.face, width: 46, height: 46),
          ),
          hiSpace(width: 8),
          Text(
            _profileMo.name,
            style: const TextStyle(fontSize: 11),
          )
        ],
      ),
    );
  }
}
