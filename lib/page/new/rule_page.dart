import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/xs_textstyle.dart';
import 'package:offer_show/page/new/rules.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class RulePage extends StatefulWidget {
  String? name;
  RulePage({
    Key? key,
    this.name,
  }) : super(key: key);

  @override
  State<RulePage> createState() => _RulePageState();
}

class _RulePageState extends State<RulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))],
        centerTitle: true,
        backgroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_back
            : os_white,
        foregroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_dark_white
            : os_black,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left_rounded,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          (widget.name ?? "") + "版规",
          style: XSTextStyle(
            context: context,
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_white,
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: SelectableText(
              rules[widget.name ?? "none"] ?? "无",
              style: XSTextStyle(
                context: context,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_white
                    : os_black,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
