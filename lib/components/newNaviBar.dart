import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class Baaaar extends StatefulWidget {
  bool isDark;
  Widget child;
  Color color;
  Baaaar({
    Key key,
    this.isDark,
    this.color,
    @required this.child,
  }) : super(key: key);

  @override
  State<Baaaar> createState() => _BaaaarState();
}

class _BaaaarState extends State<Baaaar> {
  @override
  Widget build(BuildContext context) {
    TabShowProvider tabShowProvider = Provider.of<TabShowProvider>(context);
    return Column(
      children: [
        !Platform.isWindows
            ? Container()
            : SizedBox(
                height: 40,
                child: WindowTitleBarBox(
                  child: MoveWindow(
                    child: Material(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 2.5),
                        decoration: BoxDecoration(
                          color: widget.color ??
                              (Provider.of<ColorProvider>(context).isDark ||
                                      tabShowProvider.index == 2 ||
                                      (widget.isDark ?? false)
                                  ? os_light_dark_card
                                  : Colors.white),
                          border: Border(
                            bottom: BorderSide(
                              color:
                                  Provider.of<ColorProvider>(context).isDark ||
                                          tabShowProvider.index == 2 ||
                                          (widget.isDark ?? false)
                                      ? Color(0x11FFFFFF)
                                      : Color(0x11000000),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Hero(
                              tag: "unique_topbar_logo",
                              child: Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Opacity(
                                  opacity: Provider.of<ColorProvider>(context)
                                              .isDark ||
                                          tabShowProvider.index == 2 ||
                                          (widget.isDark ?? false)
                                      ? 0
                                      : 1,
                                  child: Image.asset(
                                    "lib/img/logo.png",
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ),
                            ),
                            Hero(
                              tag: "unique_topbar_func",
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  MinimizeWindowButton(
                                    colors: WindowButtonColors(
                                      iconNormal:
                                          Provider.of<ColorProvider>(context)
                                                      .isDark ||
                                                  tabShowProvider.index == 2 ||
                                                  (widget.isDark ?? false)
                                              ? os_dark_dark_white
                                              : os_dark_card,
                                    ),
                                  ),
                                  MaximizeWindowButton(
                                    colors: WindowButtonColors(
                                      iconNormal:
                                          Provider.of<ColorProvider>(context)
                                                      .isDark ||
                                                  tabShowProvider.index == 2 ||
                                                  (widget.isDark ?? false)
                                              ? os_dark_dark_white
                                              : os_dark_card,
                                    ),
                                  ),
                                  CloseWindowButton(
                                    colors: WindowButtonColors(
                                      iconNormal:
                                          Provider.of<ColorProvider>(context)
                                                      .isDark ||
                                                  tabShowProvider.index == 2 ||
                                                  (widget.isDark ?? false)
                                              ? os_dark_dark_white
                                              : os_dark_card,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        Expanded(child: widget.child),
      ],
    );
  }
}
