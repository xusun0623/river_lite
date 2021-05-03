import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class HeadTab extends StatefulWidget {
  @override
  _HeadTabState createState() => _HeadTabState();
}

class _HeadTabState extends State<HeadTab> {
  @override
  Widget build(BuildContext context) {
    HomeTabIndex provider = Provider.of<HomeTabIndex>(context);
    FilterSchool provider_filter = Provider.of<FilterSchool>(context);
    return Container(
      width: os_width * 100,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HeadButtonSingle(
            tap: () {
              if (provider_filter.isOpen)
                provider_filter.close();
              else
                provider_filter.open();
              print("弹出");
            },
            txt: "校招",
            index: 0,
          ),
          Container(width: 10),
          HeadButtonSingle(txt: "实习", index: 1),
          Container(width: 10),
          HeadButtonSingle(txt: "薪资", index: 2),
        ],
      ),
    );
  }
}

class HeadButtonSingle extends StatefulWidget {
  final String txt;
  final int index;
  final Function tap;

  const HeadButtonSingle({Key key, this.txt, this.index, this.tap})
      : super(key: key);
  @override
  _HeadButtonSingleState createState() => _HeadButtonSingleState();
}

class _HeadButtonSingleState extends State<HeadButtonSingle> {
  @override
  Widget build(BuildContext context) {
    FilterSchool provider_filter = Provider.of<FilterSchool>(context);
    HomeTabIndex provider = Provider.of<HomeTabIndex>(context);
    return IconButton(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: (provider.tabIndex == widget.index)
                ? [
                    AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 100),
                      style: TextStyle(
                        color: os_color,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                      child: Text(widget.txt ?? "校招"),
                    ),
                  ]
                : [
                    AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 100),
                      style: TextStyle(
                        color: os_middle_grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      child: Text(widget.txt ?? "校招"),
                    ),
                  ],
          ),
          Container(
            width: 7,
            height: 3.5,
            margin: EdgeInsets.only(top: 3),
            decoration: BoxDecoration(
              color: (widget.index == provider.tabIndex)
                  ? os_color
                  : Colors.transparent,
              borderRadius: widget.index == 0
                  ? BorderRadius.only(
                      bottomLeft: Radius.circular(
                        (provider_filter.isOpen &&
                                provider.tabIndex == widget.index)
                            ? 0
                            : 10,
                      ),
                      bottomRight:
                          Radius.circular(provider_filter.isOpen ? 0 : 10),
                      topLeft: Radius.circular(provider_filter.isOpen ? 10 : 0),
                      topRight:
                          Radius.circular(provider_filter.isOpen ? 10 : 0),
                    )
                  : BorderRadius.circular(10),
            ),
          ),
        ],
      ),
      onPressed: () {
        if (provider.tabIndex == widget.index && widget.tap != null) {
          widget.tap();
        } else {
          provider.switchTab(widget.index);
        }
      },
    );
  }
}
