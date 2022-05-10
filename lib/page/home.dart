import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/page/explore/explore.dart';
import 'package:offer_show/page/me/me.dart';
import 'package:offer_show/page/msg/msg.dart';
import 'package:offer_show/page/home/myhome.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isNewMsg = false;
  List<int> loadIndex = [];

  List<Widget> homePages() {
    List<Widget> tmp = [];
    loadIndex.forEach((element) {
      tmp.add([
        MyHome(),
        Explore(),
        Msg(
          refresh: () {
            _getNewMsg();
          },
        ),
        Me(),
      ][element]);
    });
    return tmp;
  }

  _getNewMsg() async {
    var data = await Api().message_heart({});
    var count = 0;
    if (data != null && data["rs"] != 0 && data["body"] != null) {
      count += data["body"]["replyInfo"]["count"];
      count += data["body"]["atMeInfo"]["count"];
      count += data["body"]["systemInfo"]["count"];
      count += data["body"]["pmInfos"].length;
      data = data["body"];
      if (count != 0) {
        setState(() {
          _isNewMsg = true;
        });
      } else {
        setState(() {
          _isNewMsg = false;
        });
      }
    } else {
      setState(() {
        _isNewMsg = false;
      });
    }
  }

  _setTab() async {
    String txt = await getStorage(key: "showExplore", initData: "1");
    List<int> getListInt = txt == "" ? [0, 2, 3] : [0, 1, 2, 3];
    Provider.of<TabShowProvider>(context, listen: false).loadIndex = getListInt;
    setState(() {
      loadIndex = getListInt;
    });
  }

  _getBlackStatus() async {
    String black_info_txt = await getStorage(key: "black", initData: "[]");
    List black_info_map = jsonDecode(black_info_txt);
    Provider.of<BlackProvider>(context, listen: false).black = black_info_map;
  }

  @override
  void initState() {
    _setTab();
    _getNewMsg();
    _getBlackStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HomeRefrshProvider provider = Provider.of<HomeRefrshProvider>(context);
    TabShowProvider tabShowProvider = Provider.of<TabShowProvider>(context);
    os_width = MediaQuery.of(context).size.width;
    os_height = MediaQuery.of(context).size.height;
    os_padding = os_width * 0.025;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    double barHeight = 65;
    double barPadding = 10;

    List<Widget> _buildWidget(List<int> _loadIndex) {
      loadIndex = _loadIndex;
      List<Widget> tmp = [];
      List<IconData> select_icons = [];
      List<IconData> icons = [];
      loadIndex.forEach((element) {
        icons.add([
          Icons.home_outlined,
          Icons.explore_outlined,
          Icons.notifications_outlined,
          Icons.person_outlined
        ][element]);
        select_icons.add([
          Icons.home,
          Icons.explore,
          Icons.notifications,
          Icons.person
        ][element]);
      });
      for (int i = 0; i < icons.length; i++) {
        tmp.add(GestureDetector(
          onTapDown: tabShowProvider.index == i
              ? (e) {
                  _getNewMsg();
                }
              : (e) {
                  _getNewMsg();
                  if (_isNewMsg) {
                    Provider.of<MsgProvider>(context, listen: false).getMsg();
                  }
                  Vibrate.feedback(FeedbackType.impact);
                  setState(() {
                    tabShowProvider.index = i;
                  });
                },
          onDoubleTap: tabShowProvider.index == i
              ? () {
                  _getNewMsg();
                  Provider.of<HomeRefrshProvider>(context, listen: false)
                      .totop();
                  Vibrate.feedback(FeedbackType.impact);
                }
              : null,
          child: Container(
            width: MediaQuery.of(context).size.width / icons.length,
            height: barHeight,
            color: Color(0xFFFFFFFF),
            child: Badge(
              position: BadgePosition(
                end: 35,
                top: 20,
              ),
              showBadge: (i == 1 && _isNewMsg),
              child: Icon(
                tabShowProvider.index == i ? select_icons[i] : icons[i],
                size: 26,
                color: tabShowProvider.index == i
                    ? Color(0xFF222222)
                    : Color(0xFFa4a4a6),
              ),
            ),
          ),
        ));
      }
      return tmp;
    }

    return Scaffold(
      body: IndexedStack(
        children: homePages(),
        index: tabShowProvider.index,
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: barHeight + barPadding,
        padding: EdgeInsets.only(bottom: barPadding),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xFFEEEEEE),
            ),
          ),
          color: os_white,
          boxShadow: [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 10,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          // children: _buildWidget(tabShowProvider.loadIndex),
          children: _buildWidget([0, 2, 3]),
        ),
      ),
    );
  }
}
