import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';

import 'niw.dart';

class BackToTop extends StatefulWidget {
  ScrollController controller;
  Widget child;
  bool show;
  double bottom;
  bool animation;
  bool attachBtn;
  Function tap;
  Color color;
  BackToTop({
    Key key,
    this.child,
    @required this.show,
    this.color,
    this.controller,
    this.bottom,
    this.animation,
    this.attachBtn,
    this.tap,
  }) : super(key: key);

  @override
  _BackToTopState createState() => _BackToTopState();
}

class _BackToTopState extends State<BackToTop> with TickerProviderStateMixin {
  AnimationController controller; //动画控制器
  Animation<double> animation;
  double _right = -200;
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (widget.show ?? false) {
        controller.forward();
      } else {
        controller.reverse();
      }
    });
    controller = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    )..addListener(() {
        setState(() {});
      });
    final CurvedAnimation curve = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
    animation = Tween(begin: -200.0, end: 20.0).animate(curve)
      ..addListener(() {
        setState(() {
          _right = animation.value;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: widget.child ?? Container(),
        ),
        widget.attachBtn == null
            ? Container()
            : Positioned(
                right: 20,
                bottom: (widget.bottom ?? 25) + (_right + 200) / 3.5 + 10,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 10,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  child: myInkWell(
                    tap: () {
                      if (widget.tap != null) widget.tap();
                    },
                    color: widget.color ?? os_color,
                    widget: Container(
                      width: 55,
                      height: 55,
                      child: Center(
                        child: Icon(
                          Icons.add_rounded,
                          color: os_white,
                          size: 22,
                        ),
                      ),
                    ),
                    radius: 100,
                  ),
                )),
        Positioned(
            right: _right,
            bottom: widget.bottom ?? 20,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 10,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
              child: myInkWell(
                tap: () {
                  widget.controller.animateTo(
                    0,
                    duration: Duration(
                        milliseconds: (widget.animation ?? true ? 500 : 1)),
                    curve: Curves.ease,
                  );
                  widget.show = false;
                  setState(() {});
                },
                color: widget.color ?? os_color,
                widget: Container(
                  width: 55,
                  height: 55,
                  // padding: EdgeInsets.all(20),
                  child: Icon(
                    Icons.arrow_drop_up,
                    size: 25,
                    color: os_white,
                  ),
                ),
                radius: 100,
              ),
            )),
      ],
    );
  }
}
