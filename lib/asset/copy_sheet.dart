import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/showPop.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

showOSCopySheet(BuildContext context, String cont) async {
  showPopWithHeight(context, [CopySheetWidget(cont: cont)], 600);
}

class CopySheetWidget extends StatefulWidget {
  String cont;
  CopySheetWidget({
    super.key,
    required this.cont,
  });

  @override
  State<CopySheetWidget> createState() => _CopySheetWidgetState();
}

class _CopySheetWidgetState extends State<CopySheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
        backgroundColor:
            Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Opacity(
                    opacity: 0.001,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.close,
                        size: 22,
                      ),
                    ),
                  ),
                  Text(
                    "选词复制",
                    style: TextStyle(
                      color: Provider.of<ColorProvider>(context).isDark
                          ? os_dark_white
                          : os_black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 26,
                      color: Provider.of<ColorProvider>(context).isDark
                          ? os_dark_white
                          : os_black,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 17.5),
                decoration: BoxDecoration(
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_white_opa
                      : os_white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 17.5),
                  children: [
                    SelectableText(
                      widget.cont,
                      style: TextStyle(
                        color: Provider.of<ColorProvider>(context).isDark
                            ? os_dark_white
                            : os_black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: myInkWell(
                      tap: () {
                        Navigator.of(context).pop();
                      },
                      color: Provider.of<ColorProvider>(context).isDark
                          ? os_white_opa
                          : os_color_opa,
                      radius: 100,
                      widget: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Center(
                          child: Text(
                            "取消",
                            style: TextStyle(
                              color: Provider.of<ColorProvider>(context).isDark
                                  ? os_dark_dark_white
                                  : os_color,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(width: 10),
                  Expanded(
                    child: myInkWell(
                      color: os_color,
                      tap: () {
                        Clipboard.setData(ClipboardData(text: widget.cont));
                        Fluttertoast.showToast(msg: "复制成功");
                        Navigator.of(context).pop();
                      },
                      radius: 100,
                      widget: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Center(
                            child: Text(
                          "全部复制",
                          style: TextStyle(
                            color: os_white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(child: Container()),
          ],
        ),
      ),
    );
  }
}
