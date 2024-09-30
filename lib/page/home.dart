import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:badges/badges.dart' as badgee;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:offer_show/asset/autoQuestion.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/vibrate.dart';
import 'package:offer_show/asset/xs_textstyle.dart';
import 'package:offer_show/components/leftNavi.dart';
import 'package:offer_show/components/newNaviBar.dart';
import 'package:offer_show/page/PicSquare/pic_square.dart';
import 'package:offer_show/page/me/me.dart';
import 'package:offer_show/page/msg/msg.dart';
import 'package:offer_show/page/home/myhome.dart';
import 'package:offer_show/page/square/squareHome.dart';
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
  bool _firstBack = false;
  List<int> loadIndex = [];

  List<Widget> homePages() {
    return isDesktop()
        ? [
            MyHome(),
            SquareHome(),
            PicSquare(),
            Msg(
              refresh: () {
                _getNewMsg();
              },
            ),
            Me(),
          ]
        : [
            MyHome(),
            Msg(
              refresh: () {
                _getNewMsg();
              },
            ),
            Me(),
          ];
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

  _getBlackStatus() async {
    String black_info_txt = await getStorage(key: "black", initData: "[]");
    List? black_info_map = jsonDecode(black_info_txt);
    Provider.of<BlackProvider>(context, listen: false).black = black_info_map;
  }

  _getDarkMode() async {
    String dark_mode_txt = await getStorage(key: "dark", initData: "");
    Provider.of<ColorProvider>(context, listen: false).isDark =
        dark_mode_txt != "";
    Provider.of<ColorProvider>(context, listen: false).refresh();
  }

  _nowMode(BuildContext context) async {
    // _getDarkMode();
    if (window.platformBrightness == Brightness.dark &&
        !Provider.of<ColorProvider>(context, listen: false).isDark) {
      Provider.of<ColorProvider>(context, listen: false).isDark = true;
      Provider.of<ColorProvider>(context, listen: false).switchMode();
      Provider.of<ColorProvider>(context, listen: false).refresh();
    }
    if (window.platformBrightness == Brightness.light &&
        Provider.of<ColorProvider>(context, listen: false).isDark) {
      Provider.of<ColorProvider>(context, listen: false).isDark = false;
      Provider.of<ColorProvider>(context, listen: false).switchMode();
      Provider.of<ColorProvider>(context, listen: false).refresh();
    }
  }

  // 弹出评价框
  popReviewDialog() async {
    if (Platform.isIOS) {
      print("评价评价评价");
      int startCount = int.parse(
        await getStorage(key: "startCount", initData: "3"), //启动5次App之后才能弹窗
      );
      bool isRated = (await getStorage(key: "isRated")).isNotEmpty;
      if (!isRated) {
        if (startCount < 0) {
          showModal(
            context: context,
            title: "给个好评吧~",
            cont: "河畔Lite App在不断优化您的体验和使用流程，您的鼓励对它很重要！",
            confirmTxt: "好的！",
            cancelTxt: "残忍拒绝~",
            confirm: () {
              final InAppReview inAppReview = InAppReview.instance;
              inAppReview.openStoreListing(
                appStoreId: '1620829749',
              );
            },
          );
          setStorage(key: "isRated", value: "1");
        } else {
          startCount--;
          setStorage(key: "startCount", value: startCount.toString());
        }
      }
    }
  }

  _getFontFrac() async {
    Provider.of<FontSizeProvider>(context, listen: false).getFontScaleFrac();
  }

  @override
  void initState() {
    // _getPath();
    _firstBack = true;
    _getFontFrac();
    _getNewMsg();
    _getDarkMode();
    _getBlackStatus();
    popReviewDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _nowMode(context);
    TabShowProvider tabShowProvider = Provider.of<TabShowProvider>(context);
    os_width = MediaQuery.of(context).size.width;
    os_height = MediaQuery.of(context).size.height;
    os_padding = os_width * 0.025;
    double barHeight = 55;
    double barPadding = 10;

    List<Widget> _buildWidget(List<int> _loadIndex) {
      loadIndex = _loadIndex;
      List<Widget> tmp = [];
      List<IconData> select_icons = [];
      List<IconData> icons = [];
      loadIndex.forEach((element) {
        icons.add([
          Icons.home_outlined,
          Icons.image_outlined,
          Icons.notifications_outlined,
          Icons.person_outlined
        ][element]);
        select_icons.add([
          Icons.home_rounded,
          Icons.image_rounded,
          Icons.notifications_rounded,
          Icons.person_rounded
        ][element]);
      });
      for (int i = 0; i < icons.length; i++) {
        tmp.add(GestureDetector(
          onTap: tabShowProvider.index == i
              ? () {
                  _getNewMsg();
                }
              : () {
                  _getNewMsg();
                  if (_isNewMsg) {
                    Provider.of<MsgProvider>(context, listen: false).getMsg();
                  }
                  if (Platform.isIOS) XSVibrate().impact();
                  setState(() {
                    tabShowProvider.index = i;
                  });
                },
          child: Container(
            width: MediaQuery.of(context).size.width / icons.length,
            height: barHeight,
            color: Color(0x01FFFFFF),
            child: badgee.Badge(
              position: badgee.BadgePosition.topEnd(
                end: 35,
                top: 20,
              ),
              showBadge: (i ==
                      (!Provider.of<ShowPicProvider>(context).isShow ? 1 : 2) &&
                  _isNewMsg),
              child: Icon(
                tabShowProvider.index == i ? select_icons[i] : icons[i],
                size: 26,
                color: tabShowProvider.index == i
                    ? (Provider.of<ColorProvider>(context).isDark ||
                            (Provider.of<ShowPicProvider>(context).isShow &&
                                tabShowProvider.index == 1)
                        ? os_dark_white
                        : Color(0xFF222222))
                    : (Provider.of<ColorProvider>(context).isDark ||
                            (Provider.of<ShowPicProvider>(context).isShow &&
                                tabShowProvider.index == 1)
                        ? os_deep_grey
                        : Color(0xFFa4a4a6)),
              ),
            ),
          ),
        ));
      }
      return tmp;
    }

    return isDesktop()
        ? Baaaar(
            child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (_, __) async {
                if (_firstBack) {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                } else {
                  showToast(
                    context: context,
                    type: XSToast.none,
                    txt: "再次返回",
                  );
                }
              },
              child: Scaffold(
                //桌面端的UI布局
                backgroundColor: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_back
                    : os_back,
                body: Row(
                  children: [
                    LeftNavi(),
                    Expanded(
                      flex: 1,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(),
                        child: IndexedStack(
                          children: homePages(),
                          index: Provider.of<TabShowProvider>(context)
                              .desktopIndex,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            //移动端的UI布局
            backgroundColor: Provider.of<ColorProvider>(context).isDark
                ? os_dark_back
                : os_back,
            body: PopScope(
              canPop: false,
              onPopInvokedWithResult: (_, __) async {
                if (_firstBack) {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                } else {
                  showToast(
                    context: context,
                    type: XSToast.none,
                    txt: "再次返回",
                  );
                }
              },
              child: IndexedStack(
                children: homePages(),
                index: tabShowProvider.index,
              ),
            ),
            bottomNavigationBar: Platform.isAndroid
                ? MaterialBottomNavigationBar()
                : IosBottomNavigatorBar(
                    barHeight: barHeight,
                    barPadding: barPadding,
                  ),
          );
  }
}

class IosBottomNavigatorBar extends StatefulWidget {
  double barHeight;
  double barPadding;

  IosBottomNavigatorBar({
    Key? key,
    required this.barHeight,
    required this.barPadding,
  }) : super(key: key);

  @override
  State<IosBottomNavigatorBar> createState() => _IosBottomNavigatorBarState();
}

class _IosBottomNavigatorBarState extends State<IosBottomNavigatorBar> {
  bool _isNewMsg = false;
  List<int> loadIndex = [];

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

  List<Widget> _buildWidget(List<int> _loadIndex) {
    TabShowProvider tabShowProvider = Provider.of<TabShowProvider>(context);

    loadIndex = _loadIndex;
    List<Widget> tmp = [];
    List<IconData> select_icons = [];
    List<IconData> icons = [];
    loadIndex.forEach((element) {
      icons.add([
        Icons.home_rounded,
        Icons.image_rounded,
        Icons.notifications_rounded,
        Icons.person_rounded
      ][element]);
      select_icons.add([
        Icons.home_rounded,
        Icons.image_rounded,
        Icons.notifications_rounded,
        Icons.person_rounded
      ][element]);
    });
    for (int i = 0; i < icons.length; i++) {
      tmp.add(GestureDetector(
        onTap: tabShowProvider.index == i
            ? () {
                _getNewMsg();
              }
            : () {
                _getNewMsg();
                if (_isNewMsg) {
                  Provider.of<MsgProvider>(context, listen: false).getMsg();
                }
                if (Platform.isIOS) XSVibrate().impact();
                setState(() {
                  tabShowProvider.index = i;
                  tabShowProvider.changeIndex(i);
                });
              },
        child: Container(
          width: MediaQuery.of(context).size.width / icons.length,
          height: widget.barHeight,
          color: Color(0x01FFFFFF),
          child: badgee.Badge(
            position: badgee.BadgePosition.topEnd(
              end: 35,
              top: 20,
            ),
            showBadge:
                (i == (!Provider.of<ShowPicProvider>(context).isShow ? 1 : 2) &&
                    _isNewMsg),
            child: Center(
              child: Icon(
                tabShowProvider.index == i ? select_icons[i] : icons[i],
                size: 26,
                color: tabShowProvider.index == i
                    ? (Provider.of<ColorProvider>(context).isDark ||
                            (tabShowProvider.index == 1)
                        ? os_dark_white
                        : Color(0xFF222222))
                    : (Provider.of<ColorProvider>(context).isDark ||
                            (tabShowProvider.index == 1)
                        ? os_deep_grey
                        : Color(0xFFa4a4a6)),
              ),
            ),
          ),
        ),
      ));
    }
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    TabShowProvider tabShowProvider = Provider.of<TabShowProvider>(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: widget.barHeight + widget.barPadding,
      padding: EdgeInsets.only(bottom: widget.barPadding),
      decoration: BoxDecoration(
        color: Provider.of<ColorProvider>(context).isDark ||
                (Provider.of<ShowPicProvider>(context).isShow &&
                    tabShowProvider.index == 1)
            ? os_dark_back
            : os_white,
        boxShadow: [
          BoxShadow(
            color: Provider.of<ColorProvider>(context).isDark ||
                    (Provider.of<ShowPicProvider>(context).isShow &&
                        tabShowProvider.index == 1)
                ? Color(0x55000000)
                : Color(0x22000000),
            blurRadius: 10,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: -2.5,
            top: 0,
            child: QueationProgress(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildWidget(
              !Provider.of<ShowPicProvider>(context).isShow
                  ? [0, 2, 3]
                  : [0, 1, 2, 3],
            ),
          ),
        ],
      ),
    );
  }
}

class MaterialBottomNavigationBar extends StatefulWidget {
  MaterialBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<MaterialBottomNavigationBar> createState() =>
      _MaterialBottomNavigationBarState();
}

class _MaterialBottomNavigationBarState
    extends State<MaterialBottomNavigationBar> {
  bool _isNewMsg = false;

  _getNewMsg() async {
    var data = await Api().message_heart({});
    int count = 0;
    if (data != null && data["rs"] != 0 && data["body"] != null) {
      count += int.parse(data["body"]["replyInfo"]["count"].toString());
      count += int.parse(data["body"]["atMeInfo"]["count"].toString());
      count += int.parse(data["body"]["systemInfo"]["count"].toString());
      count += int.parse(data["body"]["pmInfos"].length);
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
    if (_isNewMsg) {
      Provider.of<MsgProvider>(context, listen: false).getMsg();
    }
  }

  List<BottomNavigationBarItem> bottomBar() {
    return [
      BottomNavigationBarItem(
        label: "首页",
        icon: Icon(Icons.home_rounded),
      ),
      BottomNavigationBarItem(
        label: "消息",
        icon: badgee.Badge(
          showBadge: _isNewMsg,
          child: Icon(Icons.notifications),
        ),
      ),
      BottomNavigationBarItem(
        label: "我",
        icon: Icon(Icons.person),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    TabShowProvider tabShowProvider = Provider.of<TabShowProvider>(context);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      enableFeedback: false,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      iconSize: 24,
      selectedItemColor: Provider.of<ColorProvider>(context).isDark
          ? os_dark_white
          : os_deep_blue,
      unselectedItemColor: os_deep_grey,
      backgroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_white,
      unselectedLabelStyle: XSTextStyle(
        context: context,
        fontWeight: FontWeight.bold,
      ),
      selectedLabelStyle: XSTextStyle(
        context: context,
        fontWeight: FontWeight.bold,
      ),
      onTap: (value) {
        _getNewMsg();
        tabShowProvider.changeIndex(value);
      },
      currentIndex: tabShowProvider.index,
      items: bottomBar(),
    );
  }
}

class QueationProgress extends StatefulWidget {
  const QueationProgress({Key? key}) : super(key: key);

  @override
  State<QueationProgress> createState() => _QueationProgressState();
}

class _QueationProgressState extends State<QueationProgress> {
  int progress = -1;

  auto() async {
    String auto_txt = await getStorage(key: "auto", initData: "");
    print("是否自动答题: $auto_txt");
    if (auto_txt != "") {
      autoQuestion((val) {
        setState(() {
          // progress = val;
        });
      });
    }
  }

  @override
  void initState() {
    auto();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: progress == -1
          ? 0
          : (progress.toDouble() / 7) *
              (isDesktop() ? 60 : MediaQuery.of(context).size.width),
      height: 5,
      decoration: BoxDecoration(
        color: os_deep_blue,
        borderRadius: BorderRadius.circular(100),
      ),
      curve: Curves.ease,
      duration: Duration(milliseconds: 200),
    );
  }
}
