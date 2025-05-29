import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/mouse_speed.dart';
import 'package:offer_show/asset/xs_textstyle.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/page/topic/emoji.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class YourEmoji extends StatefulWidget {
  Function tap;
  Color? backgroundColor;
  double? size;
  YourEmoji({
    Key? key,
    required this.tap,
    this.backgroundColor,
    this.size,
  }) : super(key: key);

  @override
  State<YourEmoji> createState() => _YourEmojiState();
}

class _YourEmojiState extends State<YourEmoji> {
  List<String> emoji = [
    "😋😎🥰🥳🤩😘🤪😍😉😏😂🤔✋😶😓😭🤨😅🤮😒😓😤👨👩🙏👆👇💪✋👌👍👎✊👊👋👏👀",
  ];

  List<Widget> _buildRiver1() {
    List<Widget> tmp = [];
    emoji1.forEach((element) {
      tmp.add(myInkWell(
        radius: 5,
        color: Colors.transparent,
        tap: () {
          widget.tap("[a:${element}]");
        },
        widget: Padding(
          padding: const EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12.5)),
            child: Container(
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_white
                  : Colors.transparent,
              width: widget.size ?? 37,
              height: widget.size ?? 37,
              child: Image.asset(
                "lib/emoji/1/a_${element}.gif",
                width: widget.size ?? 37,
                height: widget.size ?? 37,
              ),
            ),
          ),
        ),
      ));
    });
    return tmp;
  }

  List<Widget> _buildRiver2() {
    List<Widget> tmp = [];
    emoji2.forEach((element) {
      tmp.add(myInkWell(
        radius: 5,
        color: Colors.transparent,
        tap: () {
          widget.tap("[s:${element}]");
        },
        widget: Padding(
          padding: EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12.5)),
            child: Container(
              color: os_white,
              width: widget.size ?? 37,
              height: widget.size ?? 37,
              child: Image.asset(
                "lib/emoji/2/s_${element}.gif",
              ),
            ),
          ),
        ),
      ));
    });
    return tmp;
  }

  List<Widget> _buildRiver3() {
    List<Widget> tmp = [];
    emoji3.forEach((element) {
      tmp.add(myInkWell(
        radius: 5,
        color: Colors.transparent,
        tap: () {
          widget.tap("[s:${element}]");
        },
        widget: Padding(
          padding: EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12.5)),
            child: Container(
              color: os_white,
              width: widget.size ?? 37,
              height: widget.size ?? 37,
              child: Image.asset(
                "lib/emoji/3/s_${element}.gif",
              ),
            ),
          ),
        ),
      ));
    });
    return tmp;
  }

  List<Widget> _buildRiver4() {
    List<Widget> tmp = [];
    emoji4.forEach((element) {
      tmp.add(myInkWell(
        radius: 5,
        color: Colors.transparent,
        tap: () {
          widget.tap("[s:${element}]");
        },
        widget: Padding(
          padding: EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12.5)),
            child: Container(
              color: os_white,
              width: widget.size ?? 37,
              height: widget.size ?? 37,
              child: Image.asset(
                "lib/emoji/4/s_${element}.gif",
              ),
            ),
          ),
        ),
      ));
    });
    return tmp;
  }

  List<Widget> _buildRiver5() {
    List<Widget> tmp = [];
    emoji5.forEach((element) {
      tmp.add(myInkWell(
        radius: 5,
        color: Colors.transparent,
        tap: () {
          widget.tap("[s:${element}]");
        },
        widget: Padding(
          padding: EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12.5)),
            child: Container(
              color: os_white,
              width: widget.size ?? 37,
              height: widget.size ?? 37,
              child: Image.asset(
                "lib/emoji/5/s_${element}.gif",
              ),
            ),
          ),
        ),
      ));
    });
    return tmp;
  }

  List<Widget> _buildEmoji(int index) {
    List<Widget> tmp = [];
    for (var i = 0; i < emoji[index].characters.length; i++) {
      tmp.add(myInkWell(
        radius: 5,
        color: Colors.transparent,
        tap: () {
          widget.tap(emoji[index].characters.elementAt(i));
        },
        widget: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            emoji[index].characters.elementAt(i),
            style: XSTextStyle(
              context: context,
              fontSize: widget.size == null ? 30 : widget.size! - 5,
            ),
          ),
        ),
      ));
    }
    return tmp;
  }

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    speedUp(_scrollController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: widget.backgroundColor ??
            (Provider.of<ColorProvider>(context).isDark
                ? os_dark_card
                : os_grey),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ListView(
        controller: _scrollController,
        //physics: BouncingScrollPhysics(),
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
            child: Text(
              "阿鲁",
              style: XSTextStyle(
                context: context,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: Wrap(
              children: _buildRiver1(),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
            child: Text(
              "兔斯基",
              style: XSTextStyle(
                context: context,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: Wrap(
              children: _buildRiver2(),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
            child: Text(
              "黄豆",
              style: XSTextStyle(
                context: context,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: Wrap(
              children: _buildRiver3(),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
            child: Text(
              "贱驴",
              style: XSTextStyle(
                context: context,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: Wrap(
              children: _buildRiver4(),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
            child: Text(
              "洋葱头",
              style: XSTextStyle(
                context: context,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: Wrap(
              children: _buildRiver5(),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
            child: Text(
              "Emoji",
              style: XSTextStyle(
                context: context,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: Wrap(
              children: _buildEmoji(0),
            ),
          ),
        ],
      ),
    );
  }
}
