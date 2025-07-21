import 'dart:convert';

import 'package:badges/badges.dart' as badgee;
import 'package:offer_show/components/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/xs_textstyle.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/page/home.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

///左侧导航栏宽度
final double LeftNaviWidth = 80;

class LeftNavi extends StatefulWidget {
  LeftNavi({Key? key}) : super(key: key);

  @override
  _LeftNaviState createState() => _LeftNaviState();
}

class _LeftNaviState extends State<LeftNavi> {
  String? head_url = "";
  String? name = "";
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
      count += int.parse(data["body"]["replyInfo"]["count"].toString());
      count += int.parse(data["body"]["atMeInfo"]["count"].toString());
      count += int.parse(data["body"]["systemInfo"]["count"].toString());
      count += int.parse(data["body"]["pmInfos"].length.toString());
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
    TabShowProvider tabShowProvider = Provider.of<TabShowProvider>(context);
    return Material(
      child: Container(
        width: LeftNaviWidth,
        decoration: BoxDecoration(
          color: Provider.of<ColorProvider>(context).isDark ||
                  tabShowProvider.desktopIndex == 2
              ? Color(0xFF323232)
              : os_white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: [
                  Container(height: MediaQuery.of(context).padding.top + 20),
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
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        child: Provider.of<TabShowProvider>(context)
                                    .desktopIndex ==
                                4
                            ? Container(
                                color: Provider.of<ColorProvider>(context)
                                            .isDark ||
                                        tabShowProvider.desktopIndex == 2
                                    ? Color(0x33FFFFFF)
                                    : os_grey,
                                child: Center(
                                  child: Text(
                                    (provider.data == null
                                            ? "X"
                                            : provider.data!["name"] ??
                                                provider.data!["userName"])[0]
                                        .toString(),
                                    style: XSTextStyle(
                                      context: context,
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
                                    : (provider.data!["icon"] ??
                                        provider.data!["avatar"]),
                                placeholder: (BuildContext, String) {
                                  return Container(
                                    color: Provider.of<ColorProvider>(context)
                                                .isDark ||
                                            tabShowProvider.desktopIndex == 2
                                        ? Color(0x33FFFFFF)
                                        : os_grey,
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                  Container(height: 20),
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
                  Container(
                    child: NaviBtn(
                      isNewMsg: _isNewMsg,
                      index: 3,
                      tap: () {
                        _getNewMsg();
                      },
                    ),
                  ),
                  // Container(height: 10),
                ],
              ),
            ),
            Column(
              children: [
                NaviBtn(
                  index: 4,
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
  bool? isNewMsg;
  Function tap;
  NaviBtn({
    Key? key,
    required this.index,
    this.isNewMsg,
    required this.tap,
  }) : super(key: key);

  @override
  State<NaviBtn> createState() => _NaviBtnState();
}

class _NaviBtnState extends State<NaviBtn> {
  List<String> icon_desc = [
    "主页",
    "板块",
    "图区",
    "消息",
    "我",
  ]; //主页、探索、图区特别版块、消息、我的;
  List<IconData> icons = [
    //首页左侧导航栏存放的图片，依次为主页、探索、图区特别版块、消息、我的
    Icons.home_rounded,
    Icons.explore,
    Icons.image,
    Icons.notifications_rounded,
    Icons.settings,
  ];

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
          provider.desktopIndex = widget.index;
          provider.refresh();
          widget.tap();
        },
        color: provider.desktopIndex == widget.index
            ? (Provider.of<ColorProvider>(context).isDark ||
                    provider.desktopIndex == 2
                ? Color(0xFF464646)
                : Colors.transparent)
            : (Provider.of<ColorProvider>(context).isDark ||
                    provider.desktopIndex == 2
                ? Color(0xFF323232)
                : Colors.transparent),
        radius: 7.5,
        widget: Container(
          padding: EdgeInsets.all(10),
          child: badgee.Badge(
            showBadge: (widget.isNewMsg ?? false) && widget.index == 3,
            child: Column(
              children: [
                Icon(
                  icons[widget.index],
                  size: 30,
                  color: provider.desktopIndex == widget.index
                      ? (Provider.of<ColorProvider>(context).isDark ||
                              provider.desktopIndex == 2
                          ? os_white
                          : os_deep_blue)
                      : (Provider.of<ColorProvider>(context).isDark ||
                              provider.desktopIndex == 2
                          ? Color(0xFF919191)
                          : Color(0x55002266)),
                ),
                Container(height: 5),
                Text(
                  icon_desc[widget.index],
                  style: XSTextStyle(
                    context: context,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: provider.desktopIndex == widget.index
                        ? (Provider.of<ColorProvider>(context).isDark ||
                                provider.desktopIndex == 2
                            ? os_white
                            : os_deep_blue)
                        : (Provider.of<ColorProvider>(context).isDark ||
                                provider.desktopIndex == 2
                            ? Color(0xFF919191)
                            : Color(0x55002266)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
