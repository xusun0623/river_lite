import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

void showMidActionSheet({
  @required BuildContext context,
  String title,
  @required List<String> list,
  @required Function select,
}) {
  List<Widget> _buildChidren() {
    List<Widget> tmp = [];
    for (var i = 0; i < list.length; i++) {
      tmp.add(
        myInkWell(
          color: Colors.transparent,
          tap: () {
            select(i);
            Navigator.pop(context);
          },
          radius: 10,
          widget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  list[i],
                  style: TextStyle(
                    fontSize: 16,
                    color: Provider.of<ColorProvider>(context, listen: false)
                            .isDark
                        ? os_dark_white
                        : os_black,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return tmp;
  }

  AlertDialog alert = AlertDialog(
    backgroundColor: Provider.of<ColorProvider>(context, listen: false).isDark
        ? os_dark_card
        : os_white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
    ),
    title: Padding(
      padding: const EdgeInsets.all(0),
      child: Center(
        child: Text(
          title ?? "搜索类型",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Provider.of<ColorProvider>(context, listen: false).isDark
                ? os_dark_white
                : os_black,
          ),
        ),
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildChidren(),
        ),
      ),
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void showModal({
  @required BuildContext context,
  String title,
  String cont,
  String confirmTxt,
  String cancelTxt,
  Function confirm,
  Function cancel,
}) {
  AlertDialog alert = AlertDialog(
    backgroundColor: Provider.of<ColorProvider>(context, listen: false).isDark
        ? os_light_dark_card
        : os_white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
    ),
    title: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Center(
        child: Text(
          title ?? "标题",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Provider.of<ColorProvider>(context, listen: false).isDark
                ? os_dark_white
                : os_black,
          ),
        ),
      ),
    ),
    content: Text(
      cont ?? "内容",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Provider.of<ColorProvider>(context, listen: false).isDark
            ? os_dark_dark_white
            : os_black,
      ),
    ),
    actions: [
      Container(
        // padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            cancelTxt == ""
                ? Container()
                : myInkWell(
                    color: Colors.transparent,
                    widget: Container(
                      // width: 130,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 50,
                      child: Center(
                        child: Text(
                          cancelTxt ?? "取消",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Provider.of<ColorProvider>(context,
                                        listen: false)
                                    .isDark
                                ? os_dark_dark_white
                                : os_black,
                          ),
                        ),
                      ),
                    ),
                    radius: 10,
                    tap: () {
                      Navigator.pop(context);
                      if (cancel != null) cancel();
                    },
                  ),
            myInkWell(
              // color: Provider.of<ColorProvider>(context, listen: false).isDark
              //     ? Color(0x11FFFFFF)
              //     : os_color_opa,
              color: Colors.transparent,
              widget: Container(
                // width: cancelTxt == "" ? 260 : 130,
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                    confirmTxt ?? "确认",
                    style: TextStyle(
                      color: Provider.of<ColorProvider>(context, listen: false)
                              .isDark
                          ? os_dark_white
                          : os_color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              radius: 10,
              tap: () {
                Navigator.pop(context);
                if (confirm != null) confirm();
              },
            ),
          ],
        ),
      ),
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

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
  if (type == XSToast.none) {
    popDialogNoWill(
      delay: duration ?? 1500,
      context: context,
      widget: Container(
        // padding: EdgeInsets.all(30),
        width: 240,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0xBB000000),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(
                txt ?? "加载中…",
                textAlign: TextAlign.center,
                style: TextStyle(color: os_white),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
            Container(
              child: Text(txt ?? "加载中…", style: TextStyle(color: os_white)),
            ),
          ],
        ),
      ),
    );
  }
  if (type == XSToast.success) {
    popDialogNoWill(
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

void popDialogNoWill({
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
      return Material(
        color: Colors.transparent,
        child: Container(
          color: Provider.of<ColorProvider>(context, listen: false).isDark
              ? Colors.transparent
              : Colors.transparent,
          margin: EdgeInsets.only(bottom: 150),
          child: Container(child: Center(child: widget)),
        ),
      );
    },
  );
  Future.delayed(Duration(milliseconds: delay)).then((value) {
    if (!isShown) return; //已经取消弹窗了
    isShown = false;
    Navigator.pop(context);
  });
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
      return Material(
        color: Colors.transparent,
        child: WillPopScope(
          //阻止用户返回
          onWillPop: () {
            return;
          },
          child: Container(
            color: Provider.of<ColorProvider>(context, listen: false).isDark
                ? Colors.transparent
                : Colors.transparent,
            margin: EdgeInsets.only(bottom: 150),
            child: Container(child: Center(child: widget)),
          ),
        ),
      );
    },
  );
  Future.delayed(Duration(milliseconds: delay)).then((value) {
    if (!isShown) return; //已经取消弹窗了
    isShown = false;
    Navigator.pop(context);
  });
}
