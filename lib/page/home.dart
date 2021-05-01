import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/logo.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/components/cartoon.dart';
import 'package:offer_show/page/404.dart';
import 'package:offer_show/page/broke.dart';
import 'package:offer_show/page/me.dart';
import 'package:offer_show/page/page1.dart';
import 'package:offer_show/page/page2.dart';
import 'package:offer_show/router/tabbar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final homePages = [
    page1(),
    page2(),
    Me(),
    Page404(),
  ];
  var _tabBarIndex = 0;
  @override
  Widget build(BuildContext context) {
    os_width = MediaQuery.of(context).size.width;
    os_height = MediaQuery.of(context).size.height;
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
              print("$_tabBarIndex");
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

class OfferShowDraw extends StatelessWidget {
  const OfferShowDraw({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        appBar: AppBar(
          // leading: null,
          backgroundColor: os_white,
          centerTitle: true,
          title: Row(
            children: [
              os_logo(
                size: 30,
              ),
              Container(
                width: 10,
              ),
              Text(
                "OfferShow",
                style: TextStyle(color: os_color),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            ListTile(
              title: Row(
                children: [
                  FlutterLogo(),
                  Container(
                    width: 10,
                  ),
                  Text("选项一"),
                ],
              ),
              trailing: Text("备注"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
