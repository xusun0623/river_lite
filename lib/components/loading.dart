import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/page/me/me.dart';
import 'package:url_launcher/url_launcher.dart';

class Loading extends StatefulWidget {
  Color backgroundColor;
  bool showError;
  String msg;
  Function tap;
  Function tap1;
  String tapTxt;
  String tapTxt1;
  Loading({
    Key key,
    this.backgroundColor,
    this.showError,
    this.msg,
    this.tap,
    this.tap1,
    this.tapTxt,
    this.tapTxt1,
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
                ? Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Icon(
                      Icons.cloud_off_rounded,
                      color: Color(0xFFDDDDDD),
                      size: 100,
                    ),
                  )
                : Container(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      color: Color(0xFFCCCCCC),
                      strokeWidth: 3,
                    ),
                  ),
            widget.showError ?? false ? Container() : Container(height: 20),
            Center(
              child: Container(
                width: 280,
                child: Text(
                  widget.showError ?? false ? widget.msg ?? "未知错误" : "加载中…",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFBBBBBB),
                    fontSize: 14,
                    height: 1.8,
                  ),
                ),
              ),
            ),
            widget.tap == null || !widget.showError
                ? Container()
                : Container(height: 30),
            widget.tap == null || !widget.showError
                ? Container()
                : GestureDetector(
                    onTap: () async {
                      widget.tap();
                    },
                    child: Container(
                      width: 150,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        // color: Color.fromRGBO(0, 0, 0, 0.05),
                      ),
                      child: Center(
                        child: Text(
                          widget.tapTxt ?? "查看帖子",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFAAAAAA),
                          ),
                        ),
                      ),
                    ),
                  ),
            widget.tap1 == null || !widget.showError
                ? Container()
                : GestureDetector(
                    onTap: () async {
                      widget.tap1();
                    },
                    child: Container(
                      width: 150,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        // color: Color.fromRGBO(0, 0, 0, 0.05),
                      ),
                      child: Center(
                        child: Text(
                          widget.tapTxt1 ?? "刷新",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFAAAAAA),
                          ),
                        ),
                      ),
                    ),
                  ),
            Container(height: 100),
          ],
        ),
      ),
    );
  }
}
