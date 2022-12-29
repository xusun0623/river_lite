import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/showPop.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

Widget _optionBar(String txt, IconData icon, BuildContext context) {
  return Container(
    height: 50,
    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
    padding: EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: Provider.of<ColorProvider>(context, listen: false).isDark
          ? os_light_dark_card
          : os_white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon == null
            ? Container()
            : Icon(
                icon,
                color: Provider.of<ColorProvider>(context, listen: false).isDark
                    ? os_dark_dark_white
                    : os_black,
              ),
        icon == null ? Container() : Container(width: 15),
        txt == null
            ? Container()
            : Text(txt,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color:
                      Provider.of<ColorProvider>(context, listen: false).isDark
                          ? os_dark_dark_white
                          : os_black,
                )),
      ],
    ),
  );
}

showAction({
  List<String> options,
  List<IconData> icons,
  Function tap,
  BuildContext context,
}) {
  assert(((options ?? []).length == (icons ?? []).length) || icons.length == 0);
  List<Widget> _buildOptions() {
    List<Widget> tmp = [];
    if (icons.length != 0) {
      for (var i = 0; i < options.length; i++) {
        String option = options[i];
        IconData icon = icons[i];
        tmp.add(
          GestureDetector(
            onTap: () {
              if (tap != null) tap(i);
            },
            child: _optionBar(option, icon, context),
          ),
        );
      }
    } else {
      for (var i = 0; i < options.length; i++) {
        String option = options[i];
        tmp.add(
          GestureDetector(
            onTap: () {
              if (tap != null) tap(i);
            },
            child: _optionBar(option, null, context),
          ),
        );
      }
    }
    return tmp;
  }

  showPopWithHeight(
    context,
    [
      Center(
        child: Container(
          width: 30,
          height: 5,
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Provider.of<ColorProvider>(context, listen: false).isDark
                ? Color(0x22ffffff)
                : os_middle_grey,
          ),
        ),
      ),
      ..._buildOptions(),
      Container(
        height: 1,
        width: MediaQuery.of(context).size.width,
        color: Provider.of<ColorProvider>(context, listen: false).isDark
            ? os_light_dark_card
            : os_grey,
        margin: EdgeInsets.symmetric(vertical: 10),
      ),
      GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: _optionBar("取消", null, context)),
    ],
    (70 + (options.length + 1) * 60).toDouble(),
  );
}
