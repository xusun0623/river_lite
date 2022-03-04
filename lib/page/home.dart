import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/page/404.dart';
import 'package:offer_show/page/broke.dart';
import 'package:offer_show/page/me.dart';
import 'package:offer_show/page/myhome.dart';
import 'package:offer_show/util/interface.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final homePages = [
    MyHome(),
    Broke(),
    Page404(),
    Me(),
  ];
  var _tabBarIndex = 0;
  final List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(
      backgroundColor: Colors.blue,
      icon: Icon(Icons.home_outlined),
      label: "首页",
      tooltip: "",
    ),
    BottomNavigationBarItem(
      backgroundColor: Colors.blue,
      icon: Icon(Icons.sort),
      label: "广场",
      tooltip: "",
    ),
    BottomNavigationBarItem(
      backgroundColor: Colors.blue,
      icon: Icon(Icons.notifications_active_outlined),
      label: "消息",
      tooltip: "",
    ),
    BottomNavigationBarItem(
      backgroundColor: Colors.red,
      icon: Icon(Icons.person_outline),
      label: "我",
      tooltip: "",
    ),
  ];

  @override
  void initState() {
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
        children: homePages,
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
          onTap: (index) {
            setState(() {
              _tabBarIndex = index;
            });
          },
          currentIndex: _tabBarIndex,
          items: bottomNavItems,
        ),
      ),
    );
  }
}
