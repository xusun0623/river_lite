import 'package:flutter/material.dart';
import 'package:offer_show/asset/bigScreen.dart';

final BigWidthScreen = 800;

///用于计算由于转为大屏幕模式损失了多少横向空间
double MinusSpace(BuildContext context) {
  if (isDesktop())
    return MediaQuery.of(context).size.width < BigWidthScreen
        ? 0
        : MediaQuery.of(context).size.width - BigWidthScreen;
  else
    return 0;
}

///主页适配大屏幕，主要是针对帖子专栏进行适配
class ResponsiveWidget extends StatefulWidget {
  Widget? child;
  ResponsiveWidget({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  State<ResponsiveWidget> createState() => _ResponsiveWidgetState();
}

class _ResponsiveWidgetState extends State<ResponsiveWidget> {
  @override
  Widget build(BuildContext context) {
    if (!isDesktop() || MediaQuery.of(context).size.width < BigWidthScreen) {
      return widget.child!;
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: (MediaQuery.of(context).size.width - BigWidthScreen) / 2,
        ),
        child: widget.child,
      );
    }
  }
}
