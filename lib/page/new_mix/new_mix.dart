import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/components/newNaviBar.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class PostNewMix extends StatefulWidget {
  int board_id;

  PostNewMix({
    Key key,
    this.board_id,
  }) : super(key: key);

  @override
  _PostNewMixState createState() => _PostNewMixState();
}

class _PostNewMixState extends State<PostNewMix> {
  @override
  Widget build(BuildContext context) {
    return Baaaar(
      color:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_white,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : os_white,
          elevation: 0,
          actions: [
            GestureDetector(child: SelectColumn()),
            GestureDetector(child: ConfirmPost()),
            Container(width: 5),
          ],
          leading: IconButton(
            icon: Icon(Icons.chevron_left_rounded,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_dark_white
                    : Color(0xFF2E2E2E)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          color: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : os_white,
          child: Stack(
            children: [
              ListView(
                children: [
                  MixTitileInput(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MixTitileInput extends StatelessWidget {
  const MixTitileInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      child: Container(
        height: 60,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          cursorColor: os_deep_blue,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: os_grey,
                width: 2,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: os_deep_blue,
                width: 2,
              ),
            ),
            hintText: "标题",
          ),
        ),
      ),
    );
  }
}

class ConfirmPost extends StatelessWidget {
  const ConfirmPost({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: os_deep_blue,
        border: Border.all(
          color: os_deep_blue,
          width: 2,
        ),
      ),
      child: Text(
        "发布",
        style: TextStyle(
          color: os_white,
        ),
      ),
    );
  }
}

class SelectColumn extends StatelessWidget {
  const SelectColumn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: os_deep_blue,
          width: 2,
        ),
      ),
      child: Text(
        "选择板块",
        style: TextStyle(
          color: os_deep_blue,
        ),
      ),
    );
  }
}
