import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/page/me/me.dart';

class Loading extends StatefulWidget {
  Color backgroundColor;
  bool showError;
  String msg;
  Loading({
    Key key,
    this.backgroundColor,
    this.showError,
    this.msg,
  }) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor ?? os_white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.showError ?? false
                ? Container()
                : Container(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      color: Color(0xFFCCCCCC),
                      strokeWidth: 3,
                    ),
                  ),
            widget.showError ?? false ? Container() : Container(height: 20),
            Text(
              widget.showError ?? false ? widget.msg ?? "未知错误" : "加载中…",
              style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 14),
            ),
            Container(height: 100),
          ],
        ),
      ),
    );
  }
}
