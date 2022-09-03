import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/loading.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class Square extends StatefulWidget {
  const Square({Key key}) : super(key: key);

  @override
  _SquareState createState() => _SquareState();
}

class _SquareState extends State<Square> {
  FocusNode _focusNode = new FocusNode();
  TextEditingController _controller = new TextEditingController();
  bool showCancel = false;
  bool get_done = false;
  var data = [];

  _getData() async {
    var tmp = await Api().forum_forumlist({});
    if (tmp != null && tmp["rs"] != 0 && tmp["list"] != null) {
      data = tmp["list"];
    }
    setState(() {
      get_done = true;
    });
  }

  List<Widget> _buildCont() {
    List<Widget> tmp = [];
    tmp.add(ResponsiveWidget(child: SpecialSquareCard()));
    if (data != null && data.length != 0) {
      for (var i = 0; i < data.length; i++) {
        tmp.add(
            ResponsiveWidget(child: SquareCard(data: data[i], index: i + 1)));
      }
    }
    return tmp;
  }

  bool match(String a, String b) {
    bool flag = false;
    for (var i = 0; i < a.length; i++) {
      for (var j = 0; j < b.length; j++) {
        if (a[i] == b[j]) flag = true;
      }
    }
    return flag;
  }

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {
        showCancel = _controller.text.length > 0;
      });
    });
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      appBar: AppBar(
        systemOverlayStyle: Provider.of<ColorProvider>(context).isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        backgroundColor:
            Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
        foregroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_white
            : os_black,
        title: Text("全部板块", style: TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: !get_done
          ? Loading(backgroundColor: os_back)
          : ListView(
              physics: BouncingScrollPhysics(),
              children: _buildCont(),
            ),
    );
  }

  @override
  void dispose() {
    _focusNode.unfocus();
    super.dispose();
  }
}

class SpecialSquareCard extends StatefulWidget {
  const SpecialSquareCard({Key key}) : super(key: key);

  @override
  State<SpecialSquareCard> createState() => _SpecialSquareCardState();
}

class _SpecialSquareCardState extends State<SpecialSquareCard> {
  @override
  Widget build(BuildContext context) {
    return SquareCard(
      data: {
        "board_category_id": 203,
        "board_category_name": "特别版块",
        "board_list": [
          {
            "board_id": 45,
            "board_name": "情感专区",
          },
          {
            "board_id": 371,
            "board_name": "密语",
          },
        ]
      },
      index: 0,
    );
  }
}

class SquareCard extends StatefulWidget {
  var data;
  int index;
  SquareCard({
    Key key,
    @required this.data,
    @required this.index,
  }) : super(key: key);

  @override
  State<SquareCard> createState() => _SquareCardState();
}

class _SquareCardState extends State<SquareCard> {
  List<Widget> _buildWrapWidget() {
    List<Widget> tmp = [];
    widget.data["board_list"].forEach((e) {
      tmp.add(
        Container(
          margin: EdgeInsets.only(right: 10, bottom: 10),
          child: myInkWell(
            tap: () {
              Navigator.pushNamed(context, "/column", arguments: e["board_id"]);
            },
            color: Provider.of<ColorProvider>(context).isDark
                ? os_white_opa
                : os_white,
            widget: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                borderRadius: BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                  color: Provider.of<ColorProvider>(context).isDark
                      ? Color(0x11FFFFFF)
                      : os_white,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 17),
              child: Text(
                e["board_name"],
                style: TextStyle(
                  fontSize: 14,
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_white
                      : os_black,
                ),
              ),
            ),
            radius: 15,
          ),
        ),
      );
    });
    return tmp;
  }

  Widget _getIcon(IconData iconData) {
    return Icon(
      iconData,
      color:
          Provider.of<ColorProvider>(context).isDark ? os_dark_white : os_black,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: Provider.of<ColorProvider>(context).isDark
            ? os_light_dark_card
            : os_white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: widget.data["board_category_name"] == "站务管理"
                    ? _getIcon(Icons.sms_outlined)
                    : Container(
                        child: [
                          _getIcon(Icons.fiber_smart_record_outlined),
                          _getIcon(Icons.trending_up_outlined),
                          _getIcon(Icons.map_outlined),
                          _getIcon(Icons.school_outlined),
                          _getIcon(Icons.local_cafe_outlined),
                          _getIcon(Icons.directions_bike_outlined),
                          _getIcon(Icons.sms_outlined),
                        ][widget.index],
                      ),
              ),
              Container(width: 3),
              Text(
                widget.data["board_category_name"],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_white
                      : os_black,
                ),
              ),
            ],
          ),
          Container(height: 7.5),
          Container(
            width: MediaQuery.of(context).size.width - 40,
            child: Wrap(
              alignment: WrapAlignment.start,
              children: _buildWrapWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
