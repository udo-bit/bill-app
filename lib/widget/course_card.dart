import 'package:bil_app/util/view_util.dart';
import 'package:flutter/material.dart';

import '../model/profile_mo.dart';

class CourseCard extends StatelessWidget {
  final List<Course> courseList;
  const CourseCard({super.key, required this.courseList});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 5, top: 15),
      child: Column(
        children: [_buildTitle(), ...buildCardList(context)],
      ),
    );
  }

  _buildTitle() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Text(
            '职场进阶',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          hiSpace(width: 10),
          Text(
            '带你突破职场瓶颈',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          )
        ],
      ),
    );
  }

  buildCardList(BuildContext context) {
    var courseGroup = {};
    for (var mo in courseList) {
      if (!courseGroup.containsKey(mo.group)) {
        courseGroup[mo.group] = [];
      }
      List list = courseGroup[mo.group];
      list.add(mo);
    }
    return courseGroup.entries.map((e) {
      List list = e.value;
      var width =
          (MediaQuery.of(context).size.width - 20 - (list.length - 1) * 5) /
              list.length;
      var height = width / 16 * 6;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [...list.map((mo) => _buildCard(mo, width, height)).toSet()],
      );
    });
  }

  _buildCard(Course mo, double width, double height) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(right: 5, bottom: 7),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: cachedImage(mo.cover, width: width, height: height),
        ),
      ),
    );
  }
}
