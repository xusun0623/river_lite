import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/outer/cached_network_image/cached_image_widget.dart';
import 'package:offer_show/util/interface.dart';
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
  bool _isNewMsg = false;

  _getData() async {
    var tmp = await Api().user_userinfo({});
    if (tmp != null && tmp["rs"] != 0 && tmp["body"] != null) {
      UserInfoProvider provider =
          Provider.of<UserInfoProvider>(context, listen: false);
      provider.data = tmp;
      provider.refresh();
    } else {
      UserInfoProvider provider =
          Provider.of<UserInfoProvider>(context, listen: false);
      var arr_txt = await getStorage(key: "myinfo", initData: "");
      if (arr_txt != "") {
        provider.data = jsonDecode(arr_txt);
        provider.refresh();
      }
    }
  }

  _getHeadUrl() async {
    String myinfo_txt = await getStorage(key: "myinfo", initData: "");
    Map myinfo_map = jsonDecode(myinfo_txt);
    head_url = myinfo_map["avatar"];
    name = myinfo_map["userName"];
    setState(() {});
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
    _getHeadUrl();
    _getData();
    _getNewMsg();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserInfoProvider provider = Provider.of<UserInfoProvider>(context);
    return Material(
      child: Container(
        width: 80,
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_light_dark_card
                  : os_grey,
            ),
          ),
          color: Provider.of<ColorProvider>(context).isDark
              ? Color(0xFF323232)
              : os_white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).padding.top,
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_back
                      : os_white,
                ),
                Container(height: 20),
                GestureDetector(
                  onTap: () async {
                    _getNewMsg();
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
                      child: Provider.of<TabShowProvider>(context).index == 3
                          ? Container(
                              color: Provider.of<ColorProvider>(context).isDark
                                  ? Color(0x33FFFFFF)
                                  : os_grey,
                              child: Center(
                                child: Text(
                                  (provider.data == null
                                          ? "X"
                                          : provider.data["name"] ??
                                              provider.data["userName"])[0]
                                      .toString(),
                                  style: TextStyle(
                                    color: Provider.of<ColorProvider>(context)
                                            .isDark
                                        ? os_white
                                        : os_dark_back,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: provider.data == null
                                  ? ""
                                  : (provider.data["icon"] ??
                                      provider.data["avatar"]),
                              placeholder: (BuildContext, String) {
                                return Container(
                                  color:
                                      Provider.of<ColorProvider>(context).isDark
                                          ? Color(0x33FFFFFF)
                                          : os_grey,
                                );
                              },
                            ),
                    ),
                  ),
                ),
                Container(height: 40),
                NaviBtn(
                  index: 0,
                  tap: () {
                    _getNewMsg();
                  },
                ),
                Container(height: 20),
                Container(
                  child: NaviBtn(
                    isNewMsg: _isNewMsg,
                    index: 1,
                    tap: () {
                      _getNewMsg();
                    },
                  ),
                ),
                Container(height: 20),
                Container(
                  child: NaviBtn(
                    isNewMsg: _isNewMsg,
                    index: 2,
                    tap: () {
                      _getNewMsg();
                    },
                  ),
                ),
                Container(height: 20),
              ],
            ),
            Column(
              children: [
                NaviBtn(
                  index: 3,
                  tap: () {
                    _getNewMsg();
                  },
                ),
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
  bool isNewMsg;
  Function tap;
  NaviBtn({
    Key key,
    this.index,
    this.isNewMsg,
    @required this.tap,
  }) : super(key: key);

  @override
  State<NaviBtn> createState() => _NaviBtnState();
}

class _NaviBtnState extends State<NaviBtn> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabShowProvider provider = Provider.of<TabShowProvider>(context);
    return Container(
      child: myInkWell(
        tap: () {
          provider.index = widget.index;
          provider.refresh();
          widget.tap();
        },
        color: provider.index == widget.index
            ? (Provider.of<ColorProvider>(context).isDark
                ? Color(0xFF464646)
                : Colors.transparent)
            : (Provider.of<ColorProvider>(context).isDark
                ? Color(0xFF323232)
                : Colors.transparent),
        radius: 7.5,
        widget: Container(
          padding: EdgeInsets.all(10),
          child: Badge(
            showBadge: (widget.isNewMsg ?? false) && widget.index == 2,
            child: Icon(
              [
                Icons.home_rounded,
                Icons.explore,
                Icons.notifications_rounded,
                Icons.settings
              ][widget.index],
              size: 30,
              color: provider.index == widget.index
                  ? (Provider.of<ColorProvider>(context).isDark
                      ? os_white
                      : os_deep_blue)
                  : (Provider.of<ColorProvider>(context).isDark
                      ? Color(0xFF919191)
                      : Color(0x55002266)),
            ),
          ),
        ),
      ),
    );
  }
}
