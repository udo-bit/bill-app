import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

import '../model/home_mo.dart';

class HiBanner extends StatelessWidget {
  final List<BannerMo> bannerList;
  final double bannerHeight;
  final EdgeInsetsGeometry? padding;
  const HiBanner(this.bannerList,
      {super.key, this.bannerHeight = 160, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: bannerHeight,
      child: _banner(),
    );
  }

  _banner() {
    var right = 10 + (padding?.horizontal ?? 0) / 2;
    return Swiper(
      itemCount: bannerList.length,
      autoplay: true,
      itemBuilder: (BuildContext context, int index) {
        return _image(bannerList[index]);
      },
      pagination: SwiperPagination(
          alignment: Alignment.bottomRight,
          margin: EdgeInsets.only(right: right, bottom: 10),
          builder: const DotSwiperPaginationBuilder(
              color: Colors.white38, size: 6, activeSize: 6)),
    );
  }

  _image(BannerMo bannerMo) {
    return InkWell(
      onTap: () {
        debugPrint('click the button');
      },
      child: Container(
          padding: padding,
          child: ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            child: Image.network(
              bannerMo.cover,
              fit: BoxFit.cover,
            ),
          )),
    );
  }
}
