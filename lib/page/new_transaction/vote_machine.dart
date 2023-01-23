import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class VoteMachine extends StatefulWidget {
  Function confirm; //返回投票选项的List<String>数组即可
  Function tap;
  Function focus;
  Function editVote;
  VoteMachine({
    Key key,
    this.confirm,
    this.tap,
    this.focus,
    this.editVote,
  }) : super(key: key);

  @override
  State<VoteMachine> createState() => _VoteMachineState();
}

class _VoteMachineState extends State<VoteMachine> {
  List<Map> options = [
    {"index": 0, "txt": ""},
    {"index": 1, "txt": ""},
  ];
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 115),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: Provider.of<ColorProvider>(context).isDark
              ? os_dark_card
              : os_white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            Container(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    os_svg(path: "lib/img/vote.svg", width: 22, height: 22),
                    Container(width: 2),
                    Text(
                      "投票",
                      style: TextStyle(
                        fontSize: 15,
                        color: Provider.of<ColorProvider>(context).isDark
                            ? os_dark_white
                            : os_black,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.tap != null) widget.tap();
                    options.add({
                      "index": options.length - 1,
                      "txt": "",
                    });
                    for (var i = 0; i < options.length; i++) {
                      options[i]["index"] = i;
                    }
                    setState(() {});
                  },
                  child: Text(
                    "+新增选项",
                    style: TextStyle(fontSize: 15, color: Color(0xFFB9B9B9)),
                  ),
                ),
              ],
            ),
            Container(height: 10),
            Column(
              children: options.map((e) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_light_dark_card
                        : Color(0xFFF1F4F8),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width -
                            MinusSpace(context) -
                            105,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 45,
                        child: TextField(
                          keyboardAppearance:
                              Provider.of<ColorProvider>(context, listen: false)
                                      .isDark
                                  ? Brightness.dark
                                  : Brightness.light,
                          onTap: () {
                            widget.focus();
                          },
                          style: TextStyle(
                            color: Provider.of<ColorProvider>(context).isDark
                                ? os_dark_white
                                : os_black,
                          ),
                          onChanged: (value) {
                            options[e["index"]]["txt"] = value;
                            print("${options}");
                            widget.editVote(options);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "请输入选项",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Provider.of<ColorProvider>(context).isDark
                                  ? os_dark_dark_white
                                  : os_deep_grey,
                            ),
                          ),
                        ),
                      ),
                      e["index"] != options.length - 1
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                options.removeAt(e["index"]);
                                for (var i = 0; i < options.length; i++) {
                                  options[i]["index"] = i;
                                }
                                setState(() {});
                              },
                              child: Text(
                                "删除",
                                style: TextStyle(
                                  color: os_color,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
