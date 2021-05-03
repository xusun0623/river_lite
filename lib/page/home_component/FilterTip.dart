import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/niw.dart';

class FilterTip extends StatefulWidget {
  final double width;
  final double height;
  final bool selected;
  final String txt;
  final Function tap;

  const FilterTip(
      {Key key, this.selected, this.width, this.height, this.txt, this.tap})
      : super(key: key);
  @override
  _FilterTipState createState() => _FilterTipState();
}

class _FilterTipState extends State<FilterTip> {
  @override
  Widget build(BuildContext context) {
    return myInkWell(
      tap: () {
        if (widget.tap != null) widget.tap();
      },
      color: Colors.transparent,
      widget: Container(
        child: Row(
          children: [
            (widget.selected ?? false)
                ? os_svg(
                    path: "lib/img/filter-tick.svg",
                    size: 20,
                  )
                : Container(),
            Container(width: 5),
            Text(
              widget.txt ?? "选项",
              style: TextStyle(
                color: os_black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      width: widget.width ?? os_width,
      height: widget.height ?? 40,
      radius: 0,
    );
  }
}
