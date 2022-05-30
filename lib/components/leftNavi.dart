import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/outer/cached_network_image/cached_image_widget.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

class LeftNavi extends StatefulWidget {
  LeftNavi({Key key}) : super(key: key);

  @override
  _LeftNaviState createState() => _LeftNaviState();
}

class _LeftNaviState extends State<LeftNavi> {
  String head_url = "";
  String name = "";

  _getHeadUrl() async {
    String myinfo_txt = await getStorage(key: "myinfo", initData: "");
    Map myinfo_map = jsonDecode(myinfo_txt);
    head_url = myinfo_map["avatar"];
    name = myinfo_map["userName"];
    setState(() {});
  }

  _setIndex() {
    // Provider.of<TabShowProvider>(context).index = 0;
  }

  @override
  void initState() {
    _getHeadUrl();
    _setIndex();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: 80,
        decoration: BoxDecoration(
          color: Color(0xFF323232),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).padding.top,
                  color: os_white,
                ),
                Container(height: 20),
                GestureDetector(
                  onTap: () async {
                    String myinfo_txt =
                        await getStorage(key: "myinfo", initData: "");
                    Map myinfo = jsonDecode(myinfo_txt);
                    Navigator.pushNamed(
                      context,
                      "/person_center",
                      arguments: {"uid": myinfo["uid"], "isMe": true},
                    );
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      child: Provider.of<TabShowProvider>(context).index == 2
                          ? Container(
                              color: Color(0x33FFFFFF),
                              child: Center(
                                child: Text(
                                  name[0].toString(),
                                  style: TextStyle(
                                    color: os_white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: head_url,
                              placeholder: (BuildContext, String) {
                                return Container(
                                  color: Color(0x33FFFFFF),
                                );
                              },
                            ),
                    ),
                  ),
                ),
                Container(height: 40),
                NaviBtn(index: 0),
                Container(height: 20),
                NaviBtn(index: 1),
                Container(height: 20),
              ],
            ),
            Column(
              children: [
                NaviBtn(index: 2),
                Container(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NaviBtn extends StatefulWidget {
  int index;
  NaviBtn({
    Key key,
    this.index,
  }) : super(key: key);

  @override
  State<NaviBtn> createState() => _NaviBtnState();
}

class _NaviBtnState extends State<NaviBtn> {
  @override
  Widget build(BuildContext context) {
    TabShowProvider provider = Provider.of<TabShowProvider>(context);
    return Container(
      child: myInkWell(
        tap: () {
          provider.index = widget.index;
          provider.refresh();
        },
        color: provider.index == widget.index
            ? Color(0xFF464646)
            : Color(0xFF323232),
        radius: 10,
        widget: Container(
          padding: EdgeInsets.all(10),
          child: Icon(
            [
              Icons.home_rounded,
              Icons.notifications_rounded,
              Icons.settings
            ][widget.index],
            size: 30,
            color:
                provider.index == widget.index ? os_white : Color(0xFF919191),
          ),
        ),
      ),
    );
  }
}
