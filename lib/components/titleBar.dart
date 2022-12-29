import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class TitleWindowsBar extends StatelessWidget {
  const TitleWindowsBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: MoveWindow(child: Container(color: Colors.white)),
    );
  }
}
