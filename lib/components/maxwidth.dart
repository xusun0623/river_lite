import 'package:flutter/material.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';

class MaxWidth extends StatefulWidget {
  Widget child;
  double width;
  MaxWidth({
    Key key,
    this.child,
    this.width,
  }) : super(key: key);

  @override
  State<MaxWidth> createState() => _MaxWidthState();
}

class _MaxWidthState extends State<MaxWidth> {
  @override
  Widget build(BuildContext context) {
    double margin =
        (MediaQuery.of(context).size.width < (widget.width ?? BigWidthScreen))
            ? 0
            : (MediaQuery.of(context).size.width - BigWidthScreen) / 2;
    return Container(
      width: MediaQuery.of(context).size.width - 2 * margin,
      margin: EdgeInsets.symmetric(horizontal: margin),
      child: widget.child,
    );
  }
}
