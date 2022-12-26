import 'package:flutter/material.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/outer/card_swiper/swiper.dart';

class ImgBanner extends StatefulWidget {
  const ImgBanner({Key? key}) : super(key: key);

  @override
  State<ImgBanner> createState() => _ImgBannerState();
}

class _ImgBannerState extends State<ImgBanner> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - os_edge * 2,
      height: (MediaQuery.of(context).size.width - os_edge * 2) / 360 * 144,
      child: Swiper(
        physics: BouncingScrollPhysics(),
        itemCount: 1,
        autoplay: true,
        duration: 800,
        loop: false,
        autoplayDelay: 15000,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (index == 0) {
                Navigator.pushNamed(context, "/explore");
              }
            },
            child: os_svg(
              path: "lib/img/banner/banner2.svg",
              width: MediaQuery.of(context).size.width - os_edge * 2,
              height:
                  (MediaQuery.of(context).size.width - os_edge * 2) / 360 * 144,
            ),
          );
        },
      ),
    );
  }
}
