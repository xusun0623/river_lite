import 'package:flutter/Material.dart';
import 'package:offer_show/asset/svg.dart';

class ImgBanner extends StatefulWidget {
  const ImgBanner({Key key}) : super(key: key);

  @override
  State<ImgBanner> createState() => _ImgBannerState();
}

class _ImgBannerState extends State<ImgBanner> {
  @override
  Widget build(BuildContext context) {
    return os_svg(
      path: "lib/img/banner.svg",
      width: MediaQuery.of(context).size.width - 30,
      height: (MediaQuery.of(context).size.width - 30) / 360 * 144,
    );
  }
}
