import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/page/me/me.dart';
import 'package:offer_show/page/msg/msg.dart';
import 'package:offer_show/page/home/myhome.dart';
import 'package:offer_show/page/new_reply/homeNewReply.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isNewMsg = false;
  var _tabBarIndex = 0;

  List<Widget> homePages() {
    return [
      MyHome(),
      HomeNewReply(),
      Msg(
        refresh: () {
          _getNewMsg();
        },
      ),
      Me(),
    ];
  }

  List<BottomNavigationBarItem> _buildNavItem() {
    return [
      BottomNavigationBarItem(
        backgroundColor: Colors.blue,
        icon: Icon(Icons.explore_outlined),
        label: "首页",
        tooltip: "",
      ),
      BottomNavigationBarItem(
        backgroundColor: Colors.blue,
        icon: Icon(Icons.lightbulb_outline_sharp),
        label: "最近回复",
        tooltip: "",
      ),
      BottomNavigationBarItem(
        backgroundColor: Colors.blue,
        icon: Badge(
          showBadge: _isNewMsg,
          position: BadgePosition.topEnd(top: 0, end: 0),
          child: Icon(Icons.messenger_outline_rounded),
        ),
        label: "消息",
        tooltip: "",
      ),
      BottomNavigationBarItem(
        backgroundColor: Colors.red,
        icon: Icon(Icons.circle_outlined),
        label: "我",
        tooltip: "",
      ),
    ];
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

  @override
  void initState() {
    _getNewMsg();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HomeRefrshProvider provider = Provider.of<HomeRefrshProvider>(context);
    os_width = MediaQuery.of(context).size.width;
    os_height = MediaQuery.of(context).size.height;
    os_padding = os_width * 0.025;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    double barHeight = 55;

    List<Widget> _buildWidget() {
      List<Widget> tmp = [];
      List<IconData> select_icons = [
        Icons.home,
        Icons.explore,
        Icons.notifications,
        Icons.person
      ];
      List<IconData> icons = [
        Icons.home_outlined,
        Icons.explore_outlined,
        Icons.notifications_outlined,
        Icons.person_outlined
      ];
      for (int i = 0; i < icons.length; i++) {
        tmp.add(GestureDetector(
          onTapDown: (e) {
            Vibrate.feedback(FeedbackType.impact);
            setState(() {
              _tabBarIndex = i;
            });
          },
          onDoubleTap: _tabBarIndex == i
              ? () {
                  provider.invoke(i);
                }
              : null,
          child: Container(
            width: MediaQuery.of(context).size.width / icons.length,
            height: barHeight,
            color: Color(0xFFFFFFFF),
            child: Icon(
              _tabBarIndex == i ? select_icons[i] : icons[i],
              size: 26,
              color: _tabBarIndex == i ? Color(0xFF222222) : Color(0xFFa4a4a6),
            ),
          ),
        ));
      }
      return tmp;
    }

    return Scaffold(
      body: IndexedStack(
        children: homePages(),
        index: _tabBarIndex,
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: barHeight + 5,
        padding: EdgeInsets.only(bottom: 5),
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
          children: _buildWidget(),
        ),
      ),
    );
  }
}
