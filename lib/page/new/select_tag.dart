import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class SelectTag extends StatefulWidget {
  Map quick;
  Function tap;
  bool selected;
  SelectTag({
    Key key,
    @required this.quick,
    this.selected,
    this.tap,
  }) : super(key: key);

  @override
  State<SelectTag> createState() => _SelectTagState();
}

class _SelectTagState extends State<SelectTag> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.tap(widget.quick);
      },
      child: Container(
        height: 27,
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
          color: widget.selected ?? false
              ? (Provider.of<ColorProvider>(context).isDark
                  ? Color.fromRGBO(0, 146, 255, 0.2)
                  : os_color_opa)
              : (Provider.of<ColorProvider>(context).isDark
                  ? os_light_dark_card
                  : Color(0xFFF6F6F6)),
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
          border: Border.all(
            color: Colors.transparent,
          ),
        ),
        child: Center(
          child: Text(
            "#" + (widget.quick["board_name"] ?? "测试Tag"),
            style: TextStyle(
              color: widget.selected ?? false ? os_color : Color(0xFF9D9D9D),
            ),
          ),
        ),
      ),
    );
  }
}

class RightTopSend extends StatefulWidget {
  Function tap;
  RightTopSend({
    Key key,
    @required this.tap,
  }) : super(key: key);

  @override
  State<RightTopSend> createState() => _RightTopSendState();
}

class _RightTopSendState extends State<RightTopSend> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.tap();
      },
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 10, top: 14, bottom: 14),
        child: Container(
          width: 60,
          height: 25,
          decoration: BoxDecoration(
            color: os_color,
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: Center(
            child: Container(
              child: Text(
                "发布",
                style: TextStyle(
                  color: os_white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ColumnSpace extends StatelessWidget {
  const ColumnSpace({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      height: 1,
      margin: EdgeInsets.symmetric(vertical: 10),
      color: Provider.of<ColorProvider>(context).isDark
          ? Color.fromRGBO(255, 255, 255, 0.1)
          : Color(0xFFEFEFEF),
    );
  }
}

class SelectColumn extends StatelessWidget {
  const SelectColumn({
    Key key,
    @required this.select_section,
  }) : super(key: key);

  final String select_section;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 27,
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(100),
        ),
        border: Border.all(
          color: os_color,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 7.5),
          Text(
            select_section,
            style: TextStyle(
              fontSize: 14,
              color: os_color,
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: os_color,
          )
        ],
      ),
    );
  }
}
