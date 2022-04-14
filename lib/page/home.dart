import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/page/me/me.dart';
import 'package:offer_show/page/msg/msg.dart';
import 'package:offer_show/page/home/myhome.dart';
import 'package:offer_show/page/new_reply/homeNewReply.dart';
import 'package:offer_show/util/interface.dart';

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
    if (data != null && data["body"] != null) {
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
    os_width = MediaQuery.of(context).size.width;
    os_height = MediaQuery.of(context).size.height;
    os_padding = os_width * 0.025;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      body: IndexedStack(
        children: homePages(),
        index: _tabBarIndex,
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          brightness: Brightness.light,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          elevation: 8,
          showUnselectedLabels: true,
          unselectedFontSize: 11,
          selectedFontSize: 11,
          selectedIconTheme: IconThemeData(size: 26),
          unselectedIconTheme: IconThemeData(size: 26),
          selectedItemColor: os_color,
          backgroundColor: os_white,
          type: BottomNavigationBarType.fixed,
          onTap: (index) async {
            Vibrate.feedback(FeedbackType.impact);
            _getNewMsg(); //获得新消息提醒
            setState(() {
              _tabBarIndex = index;
            });
          },
          currentIndex: _tabBarIndex,
          items: _buildNavItem(),
        ),
      ),
    );
  }
}
