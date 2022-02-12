import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';

var isShown = false;
BuildContext context_tmp;

enum XSToast {
  loading,
  success,
  done,
  none,
}

void hideToast() {
  if (isShown) {
    isShown = false;
    Navigator.pop(context_tmp);
  }
}

void showToast({
  @required BuildContext context,
  @required XSToast type,
  String txt,
  int duration,
}) {
  if (isShown) return;
  isShown = true;

  if (type == XSToast.loading) {
    popDialog(
      delay: duration ?? 3000,
      context: context,
      widget: Container(
        padding: EdgeInsets.all(30),
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0xBB000000),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: os_white, strokeWidth: 4),
            Container(height: 20),
            Text(txt ?? "加载中…", style: TextStyle(color: os_white)),
          ],
        ),
      ),
    );
  }
  if (type == XSToast.success) {
    popDialog(
      delay: duration ?? 700,
      context: context,
      widget: Container(
        padding: EdgeInsets.all(30),
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0xBB000000),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.done,
              color: os_white,
              size: 50,
            ),
            Container(height: 20),
            Text(txt ?? "完成", style: TextStyle(color: os_white)),
          ],
        ),
      ),
    );
  }
}

void popDialog({
  @required BuildContext context,
  @required Widget widget,
  int delay = 600,
  Color back = Colors.black38,
}) {
  context_tmp = context;
  showDialog(
    context: context,
    barrierColor: back,
    barrierDismissible: false,
    builder: (ctx) {
      return WillPopScope(
        //阻止用户返回
        onWillPop: () {
          return;
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 150),
          child: Center(child: widget),
        ),
      );
    },
  );
  Future.delayed(Duration(milliseconds: delay)).then((value) {
    if (!isShown) return; //已经取消弹窗了
    Navigator.pop(context);
    isShown = false;
  });
}
