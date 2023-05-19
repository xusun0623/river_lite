import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class Loading extends StatefulWidget {
  Color? backgroundColor;
  bool? showError;
  bool? showCancel;
  bool? showRefresh;
  String? msg;
  Function? tap;
  Function? tap1;
  Function? cancel;
  Function? refresh;
  String? tapTxt;
  String? tapTxt1;
  Widget? loadingWidget;
  Loading({
    Key? key,
    this.backgroundColor,
    this.showError,
    this.showCancel,
    this.showRefresh,
    this.msg,
    this.tap,
    this.tap1,
    this.cancel,
    this.refresh,
    this.tapTxt,
    this.tapTxt1,
    this.loadingWidget,
  }) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Provider.of<ColorProvider>(context, listen: false).isDark
          ? os_light_dark_card
          : (widget.backgroundColor ?? os_white),
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
                : widget.loadingWidget ??
                    Container(
                      width: 200,
                      height: 150,
                      child: Lottie.asset("lib/lottie/loading.json"),
                      // CircularProgressIndicator(
                      //   color: Color(0xFFCCCCCC),
                      //   strokeWidth: 3,
                      // ),
                    ),
            // widget.showError ?? false ? Container() : Container(height: 20),
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
            widget.showCancel ?? false
                ? GestureDetector(
                    onTap: () {
                      if (widget.cancel != null) {
                        widget.cancel!();
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 3.5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Color(0xFFBBBBBB),
                        ),
                      ),
                      child: Text(
                        "取消",
                        style: TextStyle(
                          color: Color(0xFFBBBBBB),
                        ),
                      ),
                    ),
                  )
                : Container(),
            widget.tap == null || !widget.showError!
                ? Container()
                : Container(height: 30),
            widget.tap == null || !widget.showError!
                ? Container()
                : GestureDetector(
                    onTap: () async {
                      widget.tap!();
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
            widget.tap1 == null || !widget.showError!
                ? Container()
                : GestureDetector(
                    onTap: () async {
                      widget.tap1!();
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
            ((widget.showRefresh ?? false) && (widget.showError ?? false))
                ? GestureDetector(
                    onTap: () {
                      if (widget.refresh != null) {
                        widget.refresh!();
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        // color: os_color,
                        border: Border.all(
                          color: Provider.of<ColorProvider>(context).isDark
                              ? os_dark_white
                              : os_deep_blue,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        "重新加载",
                        style: TextStyle(
                          color: Provider.of<ColorProvider>(context).isDark
                              ? os_dark_white
                              : os_deep_blue,
                        ),
                      ),
                    ),
                  )
                : Container(),
            widget.tap == null || !widget.showError!
                ? Container()
                : Container(height: 30),
            Container(height: 100),
          ],
        ),
      ),
    );
  }
}
