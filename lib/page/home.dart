import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/logo.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/components/cartoon.dart';
import 'package:offer_show/database/db_manager.dart';
import 'package:offer_show/page/404.dart';
import 'package:offer_show/page/broke.dart';
import 'package:offer_show/page/home_component/HomeDrawer.dart';
import 'package:offer_show/page/me.dart';
import 'package:offer_show/page/myhome.dart';
import 'package:offer_show/page/page1.dart';
import 'package:offer_show/page/page2.dart';
import 'package:offer_show/router/tabbar.dart';
import 'package:offer_show/page/me.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final homePages = [
    MyHome(),
    Page404(),
    Me(),
  ];
  var _tabBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    os_width = MediaQuery.of(context).size.width;
    os_height = MediaQuery.of(context).size.height;
    os_padding = os_width * 0.025;
    return Scaffold(
      drawer: OfferShowDraw(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: os_color,
        onPressed: () {
          // Navigator.push(context, CustomRouteSlide(Broke()));
          Navigator.pushNamed(context, "/broke");
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: IndexedStack(
        children: homePages,
        index: _tabBarIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedFontSize: 12,
        selectedFontSize: 12,
        onTap: (index) {
          if (index == 1) {
            // Navigator.pushNamed(context, "/broke");
          } else {
            setState(() {
              _tabBarIndex = index;
            });
          }
        },
        currentIndex: _tabBarIndex,
        type: BottomNavigationBarType.fixed,
        items: bottomNavItems,
      ),
      appBar: null,
    );
  }
}
