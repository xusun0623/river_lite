import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/mouse_speed.dart';
import 'package:offer_show/asset/nowMode.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/vibrate.dart';
import 'package:offer_show/components/empty.dart';
import 'package:offer_show/components/loading.dart';
import 'package:offer_show/components/newNaviBar.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/components/topic.dart';
import 'package:offer_show/components/totop.dart';
import 'package:offer_show/outer/cached_network_image/cached_image_widget.dart';
import 'package:offer_show/outer/showActionSheet/action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_sheet.dart';
import 'package:offer_show/outer/showActionSheet/top_action_item.dart';
import 'package:offer_show/page/photo_view/photo_view.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

Color boy_color = os_deep_blue;
Color girl_color = Color(0xFFFF6B3D);

class PersonCenter extends StatefulWidget {
  Map param;
  PersonCenter({
    Key key,
    this.param,
  }) : super(key: key);

  @override
  _PersonCenterState createState() => _PersonCenterState();
}

class _PersonCenterState extends State<PersonCenter> {
  int index = 0;
  List data = [];
  Map userInfo;

  int sendNum = 0;
  int replyNum = 0;

  bool loading = false;
  bool load_done = false;
  bool showBackToTop = false;
  bool showTopTitle = false;
  bool isNotAvail = false; //用户是否存在

  ScrollController _controller = new ScrollController();

  bool _isBlack() {
    bool flag = false;
    Provider.of<BlackProvider>(context, listen: false).black.forEach((element) {
      if (userInfo["name"].toString().contains(element)) {
        flag = true;
      }
    });
    return flag;
  }

  _getInfo() async {
    var data = await Api().user_userinfo({
      "userId": widget.param["uid"],
    });
    if (data.toString().contains("您指定的用户空间不存在")) {
      setState(() {
        isNotAvail = true;
      });
    }
    if (data != null && data["body"] != null) {
      setState(() {
        userInfo = data;
      });
    }
  }

  _getData() async {
    if (loading) return;
    loading = true;
    var tmp = await Api().user_topiclist({
      "type": ["topic", "reply", "favorite"][index],
      "uid": widget.param["uid"],
      "page": 1,
      "pageSize": 10,
    });
    if (tmp != null &&
        tmp["rs"] != 0 &&
        tmp["list"] != null &&
        tmp["list"].length != 0) {
      data = tmp["list"];
      load_done = data.length % 10 != 0;
      sendNum = index == 0 ? tmp["total_num"] : sendNum;
      replyNum = index == 1 ? tmp["total_num"] : replyNum;
      setState(() {});
    } else {
      load_done = true;
      setState(() {});
    }
    loading = false;
  }

  _getMore() async {
    if (loading) return;
    loading = true;
    var tmp = await Api().user_topiclist({
      "type": ["topic", "reply", "favorite"][index],
      "uid": widget.param["uid"],
      "page": (data.length / 10).ceil() + 1,
      "pageSize": 10,
    });
    if (tmp != null && tmp["list"] != null && tmp["list"].length != 0) {
      data.addAll(tmp["list"]);
      load_done = data.length % 10 != 0;
      setState(() {});
    }
    loading = false;
  }

  List<Widget> _buildCont() {
    List<Widget> tmp = [
      ResponsiveWidget(
        child: PersonCard(
          isMe: widget.param["isMe"],
          data: userInfo,
        ),
      ),
      ResponsiveWidget(
        child: PersonIndex(
          index: index,
          sendNum: userInfo["topic_num"],
          replyNum: userInfo["reply_posts_num"],
          isMe: widget.param["isMe"],
          tapIndex: (idx) {
            if (idx == index) return;
            setState(() {
              index = idx;
              data = [];
              load_done = false;
            });
            _getData();
          },
        ),
      ),
    ];
    if (data.length == 0 && load_done) {
      tmp.add(Empty());
    }
    data.forEach((element) {
      tmp.add(ResponsiveWidget(
        child: Topic(
          data: element,
          top: 0,
          bottom: 10,
        ),
      ));
    });
    if (!load_done) {
      tmp.add(BottomLoading(color: Colors.transparent));
    }
    tmp.add(Container(height: 20));
    return tmp;
  }

  @override
  void initState() {
    _getData();
    _getInfo();
    _controller.addListener(() {
      if (_controller.position.pixels > 120) {
        setState(() {
          showTopTitle = true;
        });
      } else {
        setState(() {
          showTopTitle = false;
        });
      }
      if (_controller.position.pixels > 1000 && !showBackToTop) {
        setState(() {
          showBackToTop = true;
        });
      }
      if (_controller.position.pixels < 1000 && showBackToTop) {
        setState(() {
          showBackToTop = false;
        });
      }
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _getMore();
      }
    });
    speedUp(_controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    nowMode(context);
    return Baaaar(
      color:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_white
              : os_black,
          title: Text(
            showTopTitle ? userInfo["name"] : "",
            style: TextStyle(
                fontSize: 16,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_black),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.chevron_left_rounded),
          ),
          actions: userInfo == null || isNotAvail
              ? []
              : _isBlack()
                  ? []
                  : widget.param["isMe"]
                      ? [
                          // IconButton(
                          //   onPressed: () async {
                          //     Clipboard.setData(
                          //       ClipboardData(
                          //         text:
                          //             "https://bbs.uestc.edu.cn/home.php?mod=space&uid=${widget.param["uid"]}",
                          //       ),
                          //     );
                          //     showToast(
                          //       context: context,
                          //       type: XSToast.success,
                          //       txt: "复制链接成功",
                          //     );
                          //   },
                          //   icon: Icon(
                          //     Icons.copy,
                          //     color: Color(0xFFAAAAAA),
                          //   ),
                          // ),
                        ]
                      : [
                          // IconButton(
                          //   onPressed: () async {
                          //     Clipboard.setData(
                          //       ClipboardData(
                          //         text:
                          //             "https://bbs.uestc.edu.cn/home.php?mod=space&uid=${widget.param["uid"]}",
                          //       ),
                          //     );
                          //     showToast(
                          //       context: context,
                          //       type: XSToast.success,
                          //       txt: "复制链接成功",
                          //     );
                          //   },
                          //   icon: Icon(
                          //     Icons.copy,
                          //     color: Color(0xFFAAAAAA),
                          //   ),
                          // ),
                          IconButton(
                            onPressed: () async {
                              await Api().user_useradmin({
                                "type": userInfo["is_follow"] == 0
                                    ? "follow"
                                    : "unfollow",
                                "uid": widget.param["uid"],
                              });
                              setState(() {
                                userInfo["is_follow"] =
                                    1 - userInfo["is_follow"];
                              });
                            },
                            icon: Icon(
                              Icons.person_add_rounded,
                              color: userInfo["is_follow"] == 0
                                  ? Color(0xFFAAAAAA)
                                  : os_color,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/msg_detail",
                                  arguments: {
                                    "uid": widget.param["uid"],
                                    "name": userInfo["name"],
                                  });
                            },
                            icon: Icon(
                              Icons.mail,
                              color: Color(0xFFAAAAAA),
                            ),
                          )
                        ],
          backgroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : os_back,
        ),
        backgroundColor:
            Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
        body: userInfo == null
            ? Loading(
                backgroundColor: Color(0xFFF3F3F3),
              )
            : _isBlack()
                ? Container(
                    margin: EdgeInsets.only(bottom: 150),
                    child: Center(
                      child: Text(
                        "该用户已被你拉黑",
                        style: TextStyle(
                          color: Provider.of<ColorProvider>(context).isDark
                              ? os_dark_dark_white
                              : os_black,
                        ),
                      ),
                    ),
                  )
                : (isNotAvail
                    ? Center(
                        child: Container(
                        margin: EdgeInsets.only(bottom: 100),
                        child: Text(
                          "抱歉，您指定的用户空间不存在",
                          style: TextStyle(
                            color: Provider.of<ColorProvider>(context).isDark
                                ? os_dark_white
                                : os_black,
                          ),
                        ),
                      ))
                    : BackToTop(
                        show: showBackToTop,
                        controller: _controller,
                        bottom: 100,
                        child: RefreshIndicator(
                          color: os_deep_blue,
                          onRefresh: () async {
                            return await _getInfo();
                          },
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            controller: _controller,
                            children: _buildCont(),
                          ),
                        ),
                      )),
      ),
    );
  }
}

class ActionButton extends StatefulWidget {
  Function tap;
  String txt;
  Color color;
  Color backgroundColor;
  ActionButton({
    Key key,
    this.tap,
    this.txt,
    this.color,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: myInkWell(
        tap: () {
          if (widget.tap != null) widget.tap();
        },
        color: widget.backgroundColor ?? Color(0xFFEEEEEE),
        widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
              child: Text(
            widget.txt ?? "私信",
            style: TextStyle(
              color: widget.color ?? os_black,
            ),
          )),
        ),
        radius: 100,
      ),
    );
  }
}

class PersonIndex extends StatefulWidget {
  int index;
  bool isMe;
  Function tapIndex;
  int sendNum;
  int replyNum;

  PersonIndex({
    Key key,
    this.index = 0,
    this.tapIndex,
    this.isMe,
    this.replyNum,
    this.sendNum,
  }) : super(key: key);

  @override
  State<PersonIndex> createState() => _PersonIndexState();
}

class _PersonIndexState extends State<PersonIndex> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width -
          (isDesktop() ? MinusSpace(context) : 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PersonIndexTab(
            tap: (idx) {
              widget.tapIndex(0);
            },
            countNum: widget.sendNum,
            isMe: widget.isMe,
            select: widget.index == 0,
            index: 0,
          ),
          PersonIndexTab(
            tap: (idx) {
              widget.tapIndex(1);
            },
            countNum: widget.replyNum,
            isMe: widget.isMe,
            select: widget.index == 1,
            index: 1,
          ),
          PersonIndexTab(
            tap: (idx) {
              widget.tapIndex(2);
            },
            countNum: widget.replyNum,
            isMe: widget.isMe,
            select: widget.index == 2,
            index: 2,
          ),
        ],
      ),
    );
  }
}

class PersonIndexTab extends StatefulWidget {
  Function tap;
  int index;
  int countNum;
  bool select;
  bool isMe;

  PersonIndexTab({
    Key key,
    this.tap,
    this.index,
    this.select,
    this.isMe,
    this.countNum,
  }) : super(key: key);

  @override
  State<PersonIndexTab> createState() => _PersonIndexTabState();
}

class _PersonIndexTabState extends State<PersonIndexTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: myInkWell(
        tap: () {
          widget.tap(widget.index);
        },
        color: Colors.transparent,
        radius: 25,
        widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
          width: (MediaQuery.of(context).size.width -
                  (isDesktop() ? MinusSpace(context) : 0) -
                  90) /
              3,
          child: Column(
            children: [
              Text(
                ["发表", "回复", "收藏"][widget.index] +
                    (widget.countNum == 0 || widget.index == 2
                        ? ""
                        : "(${widget.countNum})"),
                style: TextStyle(
                  color: widget.select
                      ? (Provider.of<ColorProvider>(context).isDark
                          ? os_dark_white
                          : os_black)
                      : Color(0xFF7B7B7B),
                  fontSize: 15,
                ),
              ),
              Container(height: 5),
              Container(
                width: 13,
                height: 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: widget.select ? os_deep_blue : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonCard extends StatefulWidget {
  Map data;
  bool isMe;
  PersonCard({
    Key key,
    this.data,
    this.isMe,
  }) : super(key: key);

  @override
  State<PersonCard> createState() => _PersonCardState();
}

class _PersonCardState extends State<PersonCard> {
  int gender = 2;
  TextEditingController _sign_controller = new TextEditingController();

  BoxDecoration _getBoxDecoration() {
    return BoxDecoration(
        color: Provider.of<ColorProvider>(context).isDark
            ? os_light_dark_card
            : os_white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: Provider.of<ColorProvider>(context).isDark
              ? Color(0x11FFFFFF)
              : os_white,
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            offset: Offset(2, 2),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ]);
  }

  _editSign() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Provider.of<ColorProvider>(context, listen: false).isDark
          ? os_light_dark_card
          : os_white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: 30,
          ),
          height: MediaQuery.of(context).size.height - 100,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 30),
              Text(
                "请输入新的签名",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_white
                      : os_black,
                ),
              ),
              Container(height: 10),
              Container(
                height: 60,
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color:
                      Provider.of<ColorProvider>(context, listen: false).isDark
                          ? os_white_opa
                          : os_grey,
                ),
                child: Center(
                  child: TextField(
                    controller: _sign_controller,
                    cursorColor: os_deep_blue,
                    style: TextStyle(
                      color: Provider.of<ColorProvider>(context, listen: false)
                              .isDark
                          ? os_dark_white
                          : os_black,
                    ),
                    decoration: InputDecoration(
                        hintText: "请输入",
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color:
                              Provider.of<ColorProvider>(context, listen: false)
                                      .isDark
                                  ? os_dark_white
                                  : os_deep_grey,
                        )),
                  ),
                ),
              ),
              Container(height: 10),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: myInkWell(
                      tap: () {
                        Navigator.pop(context);
                      },
                      color: Provider.of<ColorProvider>(context, listen: false)
                              .isDark
                          ? os_white_opa
                          : Color(0x16004DFF),
                      widget: Container(
                        width: (MediaQuery.of(context).size.width - 60) / 2 - 5,
                        height: 40,
                        child: Center(
                          child: Text(
                            "取消",
                            style: TextStyle(
                              color: Provider.of<ColorProvider>(context).isDark
                                  ? os_dark_dark_white
                                  : os_deep_blue,
                            ),
                          ),
                        ),
                      ),
                      radius: 12.5,
                    ),
                  ),
                  Container(
                    child: myInkWell(
                      tap: () async {
                        String tmp = _sign_controller.text;
                        await Api().user_updateuserinfo({
                          "type": "info",
                          "gender": widget.data["gender"],
                          "sign": tmp,
                        });
                        widget.data["sign"] = tmp;
                        setState(() {});
                        Navigator.pop(context);
                      },
                      color: os_deep_blue,
                      widget: Container(
                        width: (MediaQuery.of(context).size.width - 60) / 2 - 5,
                        height: 40,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.done, color: os_white, size: 18),
                              Container(width: 5),
                              Text(
                                "完成",
                                style: TextStyle(
                                  color: os_white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      radius: 12.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Column(
            children: [
              Container(height: 60),
              Container(
                margin: EdgeInsets.only(left: os_edge, right: os_edge),
                padding: EdgeInsets.only(left: 25, right: 25, top: 40),
                width: MediaQuery.of(context).size.width - 2 * os_edge,
                decoration: _getBoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PersonName(
                      name: widget.data["name"],
                      isMe: widget.isMe,
                    ),
                    Container(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.water_drop_rounded,
                          size: 16,
                          color: os_deep_grey,
                        ),
                        Text(
                          "水滴 " +
                              widget.data["body"]["creditShowList"][1]["data"]
                                  .toString(),
                          style: TextStyle(color: os_deep_grey),
                        ),
                      ],
                    ),
                    widget.isMe
                        ? Sign(
                            data: widget.data,
                            tap: () {
                              _sign_controller.text = widget.data["sign"];
                              _editSign();
                            },
                          )
                        : (widget.data["sign"].toString().trim() == ""
                            ? Container()
                            : Sign(data: widget.data)),
                    Container(height: 10),
                    PersonScore(
                      score: widget.data["score"],
                      gender: widget.data["gender"] == 0
                          ? 1
                          : widget.data["gender"],
                      water: widget.data["body"]["creditShowList"][1]["data"],
                    ),
                    PersonRow(
                      uid: int.parse(widget.data["icon"]
                          .toString()
                          .split("uid=")[1]
                          .split("&size")[0]),
                      follow: widget.data["follow_num"],
                      friend: widget.data["friend_num"],
                      score: widget.data["score"],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 20,
            child: GestureDetector(
              onTap: () {
                if (widget.isMe) {
                  showActionSheet(
                    context: context,
                    topActionItem: TopActionItem(title: "请选择你的性别"),
                    actions: [
                      ActionItem(
                        title: "男生",
                        onPressed: () async {
                          showToast(
                            context: context,
                            type: XSToast.loading,
                            txt: "请稍后…",
                          );
                          await Api().user_updateuserinfo({
                            "type": "info",
                            "gender": 1,
                            "sign": widget.data["sign"],
                          });
                          hideToast();
                          widget.data["gender"] = 1;
                          setState(() {});
                          Navigator.pop(context);
                        },
                      ),
                      ActionItem(
                        title: "女生",
                        onPressed: () async {
                          showToast(
                            context: context,
                            type: XSToast.loading,
                            txt: "请稍后…",
                          );
                          await Api().user_updateuserinfo({
                            "type": "info",
                            "gender": 2,
                            "sign": widget.data["sign"],
                          });
                          hideToast();
                          widget.data["gender"] = 2;
                          setState(() {});
                          Navigator.pop(context);
                        },
                      ),
                    ],
                    bottomActionItem: BottomActionItem(title: "取消"),
                  );
                }
              },
              child: Opacity(
                opacity: Provider.of<ColorProvider>(context).isDark ? 0.8 : 1,
                child: os_svg(
                  path:
                      "lib/img/person/${widget.data["gender"] == 0 ? 1 : widget.data["gender"]}.svg",
                  width: 143,
                  height: 166,
                ),
              ),
            ),
          ),
          Positioned(
            left: 32,
            top: 20,
            child: GestureDetector(
              onTap: () {
                if (widget.isMe) {
                  showActionSheet(
                    context: context,
                    bottomActionItem: BottomActionItem(title: "取消"),
                    actions: [
                      ActionItem(
                        title: "查看头像",
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PhotoPreview(
                                galleryItems: [widget.data["icon"]],
                                defaultImage: 0,
                              ),
                            ),
                          );
                        },
                      ),
                      ActionItem(
                        title: "上传新头像",
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, "/crop");
                        },
                      ),
                    ],
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PhotoPreview(
                        galleryItems: [widget.data["icon"]],
                        defaultImage: 0,
                      ),
                    ),
                  );
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                child: GestureDetector(
                  onLongPress: () {
                    XSVibrate();
                    CachedNetworkImage.evictFromCache("url");
                    int uid = int.parse(widget.data["icon"]
                        .toString()
                        .split("uid=")[1]
                        .split("&size")[0]);
                    CachedNetworkImage.evictFromCache(
                      //清除原有头像缓存
                      base_url + "uc_server/avatar.php?uid=${uid}&size=big",
                    );
                    CachedNetworkImage.evictFromCache(
                      base_url + "uc_server/avatar.php?uid=${uid}&size=middle",
                    );
                    CachedNetworkImage.evictFromCache(
                      base_url + "uc_server/avatar.php?uid=${uid}&size=small",
                    );
                    showToast(
                        context: context, type: XSToast.success, txt: "清除缓存成功");
                  },
                  child: CachedNetworkImage(
                    imageUrl: widget.data["icon"],
                    width: 66,
                    height: 66,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: os_grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Sign extends StatefulWidget {
  var data;
  Function tap;
  Sign({
    Key key,
    this.data,
    this.tap,
  }) : super(key: key);

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: myInkWell(
        tap: () {
          if (widget.tap != null) widget.tap();
        },
        radius: 10,
        color: Provider.of<ColorProvider>(context).isDark
            ? Color(0x11FFFFFF)
            : os_grey,
        widget: Container(
          width: MediaQuery.of(context).size.width - 60,
          padding: EdgeInsets.symmetric(
            horizontal: 12.5,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.edit_calendar_outlined,
                size: 15,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : Color(0xFF666666),
              ),
              Container(width: 5),
              Container(
                width: MediaQuery.of(context).size.width -
                    (isDesktop() ? MinusSpace(context) : 0) -
                    120,
                child: Text(
                  widget.data["sign"].toString().trim() == ""
                      ? "点我编辑签名"
                      : widget.data["sign"],
                  style: TextStyle(
                    fontSize: 13,
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_dark_white
                        : Color(0xFF666666),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonRow extends StatefulWidget {
  int follow;
  int friend;
  int score;
  int uid;
  PersonRow({
    Key key,
    this.follow,
    this.friend,
    this.score,
    this.uid,
  }) : super(key: key);

  @override
  State<PersonRow> createState() => _PersonRowState();
}

class _PersonRowState extends State<PersonRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PersonColumn(
          uid: widget.uid,
          index: 0,
          count: widget.follow,
        ),
        Container(
            width: 1,
            height: 27,
            color: Provider.of<ColorProvider>(context).isDark
                ? Color(0x11FFFFFF)
                : Color(0xFFF1F1F1)),
        PersonColumn(
          uid: widget.uid,
          index: 1,
          count: widget.friend,
        ),
        Container(
            width: 1,
            height: 27,
            color: Provider.of<ColorProvider>(context).isDark
                ? Color(0x11FFFFFF)
                : Color(0xFFF1F1F1)),
        PersonColumn(
          uid: widget.uid,
          index: 2,
          count: widget.score,
        ),
      ],
    );
  }
}

class PersonColumn extends StatefulWidget {
  int index;
  int count;
  int uid;
  PersonColumn({
    Key key,
    this.index,
    this.count,
    this.uid,
  }) : super(key: key);

  @override
  State<PersonColumn> createState() => _PersonColumnState();
}

class _PersonColumnState extends State<PersonColumn> {
  int _getScoreLevel(int score) {
    if (score > 10000) {
      return 5;
    }
    if (score > 1000) {
      return 4;
    }
    if (score > 500) {
      return 3;
    }
    if (score > 100) {
      return 2;
    }
    if (score > 50) {
      return 1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.index == 0 || widget.index == 1) {
          Navigator.pushNamed(context, "/user_list", arguments: {
            "type": widget.index,
            "uid": widget.uid,
          });
        }
        if (widget.index == 2) {
          Navigator.pushNamed(context, "/person_detail", arguments: widget.uid);
        }
      },
      child: Container(
        width: (MediaQuery.of(context).size.width -
                (isDesktop() ? MinusSpace(context) : 0) -
                100) /
            3,
        height: 90,
        color: Provider.of<ColorProvider>(context).isDark
            ? os_light_dark_card
            : os_white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              ["粉丝", "关注", "积分"][widget.index],
              style: TextStyle(
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : Color(0xFF939393),
                fontSize: 12,
              ),
            ),
            Container(height: 7.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.index == 2 && !Provider.of<ColorProvider>(context).isDark
                    ? Icon(
                        Icons.gpp_good_rounded,
                        size: 16,
                        color: [
                          Color(0xFF888888),
                          Color(0xFF3E8B1B),
                          Color(0xFF468ef0),
                          Color(0xFF0d28f5),
                          Color(0xFFFF5E00),
                          Color(0xFFe93625),
                        ][_getScoreLevel(widget.count)],
                      )
                    : Container(),
                Text(
                  (widget.count ?? 0).toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_dark_white
                        : os_black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PersonScore extends StatefulWidget {
  int score;
  int gender;
  int water;
  PersonScore({
    Key key,
    @required this.score,
    this.gender,
    this.water,
  }) : super(key: key);

  @override
  State<PersonScore> createState() => PersonScoreState();
}

class PersonScoreState extends State<PersonScore> {
  List map_tmp = [
    0,
    30,
    100,
    500,
    800,
    1200,
    2000,
    3000,
    4500,
    7000,
    10000,
    15000,
    30000,
  ];
  int now_score_total = 0;

  _getLevel() {
    var score = widget.score;
    for (int i = 0; i < map_tmp.length; i++) {
      if (map_tmp[i] > score) {
        return i;
      }
    }
    return "??";
  }

  _getRate() {
    var score = widget.score;
    for (int i = 0; i < map_tmp.length; i++) {
      if (map_tmp[i] > score) {
        setState(() {
          now_score_total = map_tmp[i];
        });
        return score / map_tmp[i];
      }
    }
    return 0.999;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              Text("Lv.${_getLevel()}",
                  style: TextStyle(color: Color(0xFF707070))),
              Container(width: 5),
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width -
                        (isDesktop() ? MinusSpace(context) : 0) -
                        220,
                    height: 7,
                    decoration: BoxDecoration(
                      color: Color(0xFFE3E3E3),
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      width: (MediaQuery.of(context).size.width -
                              (isDesktop() ? MinusSpace(context) : 0) -
                              220) *
                          _getRate(),
                      height: 7,
                      decoration: BoxDecoration(
                        color: widget.gender == 1 ? os_deep_blue : girl_color,
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                    ),
                  ),
                ],
              ),
              Container(width: 10),
              Text(
                "${widget.score}/${now_score_total}",
                style: TextStyle(
                  fontSize: 12,
                  color: os_deep_grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PersonName extends StatefulWidget {
  String name;
  bool isMe;
  PersonName({
    Key key,
    this.name,
    this.isMe,
  }) : super(key: key);

  @override
  State<PersonName> createState() => _PersonNameState();
}

class _PersonNameState extends State<PersonName> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(
            widget.name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_dark_white
                  : os_black,
            ),
          ),
        ],
      ),
    );
  }
}
