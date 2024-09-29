import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/mouse_speed.dart';
import 'package:offer_show/asset/myinfo.dart';
import 'package:offer_show/asset/nowMode.dart';
import 'package:offer_show/asset/processUrl.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/time.dart';
import 'package:offer_show/asset/to_user.dart';
import 'package:offer_show/asset/vibrate.dart';
import 'package:offer_show/components/empty.dart';
import 'package:offer_show/components/newNaviBar.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/components/nomore.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  int? type; //0:帖子 1:用户
  Search({
    Key? key,
    this.type,
  }) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  int? select = 0; //选择的类型 0:帖子 1:用户
  var data = [];
  bool loading = false;
  bool load_done = false;
  FocusNode _commentFocus = FocusNode();
  ScrollController _scrollController = new ScrollController();
  TextEditingController _controller = new TextEditingController();
  _getData() async {
    if (specialUrl(_controller.text)) {
      processUrl(_controller.text, context);
      return;
    } else {
      int tid = 0;
      int uid = 0;
      try {
        if (_controller.text.startsWith("t")) {
          tid = int.parse(_controller.text.split("t")[1]);
          showToast(context: context, type: XSToast.loading);
          var pre_search = await Api().forum_postlist({
            "topicId": tid,
            "authorId": 0,
            "order": 0,
            "page": 1,
            "pageSize": 0,
          });
          hideToast();
          if (pre_search.toString().contains("指定的主题不存在或已被删除或正在被审核")) {
            showToast(
              context: context,
              type: XSToast.none,
              txt: "指定的主题不存在或已被删除或正在被审核",
              duration: 300,
            );
          } else if (pre_search.toString().contains("您没有权限访问该版块")) {
            showToast(
              context: context,
              type: XSToast.none,
              txt: "您没有权限访问该版块",
              duration: 300,
            );
          } else {
            Navigator.pushNamed(context, "/topic_detail", arguments: tid);
          }
          return;
        }
        if (_controller.text.startsWith("u")) {
          uid = int.parse(_controller.text.split("u")[1]);
          showToast(context: context, type: XSToast.loading);
          var pre_search = await Api().user_userinfo({
            "userId": uid,
          });
          hideToast();
          if (pre_search.toString().contains("您指定的用户空间不存在")) {
            showToast(
              context: context,
              type: XSToast.none,
              txt: "您指定的用户空间不存在",
              duration: 300,
            );
          } else {
            toUserSpace(context, uid);
          }
          return;
        }
      } catch (e) {}

      setState(() {
        loading = true;
      });
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      var tmp = await Api().forum_search(select!, {
        "keyword": _controller.text ?? "",
        "page": 1,
        "pageSize": 20,
      });
      if (select == 0 && tmp["rs"] != 0 && tmp != null && tmp["list"] != null) {
        data = tmp["list"] ?? [];
      }
      if (select == 1 &&
          tmp["rs"] != 0 &&
          tmp != null &&
          tmp["body"] != null &&
          tmp["body"]["list"] != null) {
        data = tmp["body"]["list"] ?? [];
      }
      load_done = data.length < 20;
      loading = false;
      String tmp_history = await getStorage(
        key: "search-history",
        initData: "[]",
      );
      List tmp_arr_history = jsonDecode(tmp_history);
      if (tmp_arr_history.indexOf(_controller.text) > -1) {
        tmp_arr_history.remove(_controller.text);
      }
      List tmp_tmp = [_controller.text];
      tmp_tmp.addAll(tmp_arr_history);
      setStorage(key: "search-history", value: jsonEncode(tmp_tmp));
      _commentFocus.unfocus();
      setState(() {});
    }
  }

  _getMore() async {
    if (loading) return;
    loading = true;
    var tmp = await Api().forum_search(select!, {
      "keyword": _controller.text,
      "page": (data.length / 20 + 1).ceil(),
      "pageSize": 20,
    });

    if (select == 0 && tmp != null && tmp["list"] != null) {
      data.addAll(tmp["list"]);
    }
    if (select == 1 &&
        tmp != null &&
        tmp["body"] != null &&
        tmp["body"]["list"] != null) {
      data.addAll(tmp["body"]["list"]);
    }

    load_done = data.length % 20 != 0;
    setState(() {});
    loading = false;
  }

  List<Widget> _buildTopic() {
    print("${data}");
    List<Widget> tmp = [];
    if (data.length == 0) {
      tmp.add(
        History(
          confirm: (String txt) {
            _commentFocus.unfocus();
            if (txt != "") {
              _controller.text = txt;
              setState(() {
                _getData();
              });
            }
          },
        ),
      );
    }
    tmp.add(loading
        ? BottomLoading(
            color: Colors.transparent,
            txt: "加载中…",
          )
        : NoMore());
    tmp.add(loading ? Container(height: 15) : Container());
    tmp.add(data.length == 0 && load_done
        ? Container(
            width: MediaQuery.of(context).size.width - 30,
            margin: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_dark_card
                  : os_white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Empty(
              txt: "没有搜索结果",
            ),
          )
        : Container());
    if (data.length > 0) {
      for (int i = 0; i < data.length; i++) {
        tmp.add(select == 1
            ? UserListCard(
                data: data[i],
              )
            : SearchTopicCard(
                tap: () {
                  _commentFocus.unfocus();
                },
                index: i,
                data: data[i],
              ));
      }
    }
    tmp.add(
      load_done || data.length == 0
          ? NoMore()
          : BottomLoading(
              color: Colors.transparent,
            ),
    );
    tmp.add(Container(
      height: 15,
    ));
    return tmp;
  }

  @override
  void initState() {
    _commentFocus.requestFocus();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMore();
      }
    });
    speedUp(_scrollController);
    setState(() {
      if (widget.type != null) {
        select = widget.type;
      }
      print("搜索的类型为${select}");
    });
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
          // toolbarHeight: 80,
          systemOverlayStyle: Provider.of<ColorProvider>(context).isDark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          backgroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : os_back,
          foregroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_white
              : os_black,
          elevation: 0,
          actions: [
            SearchBtn(
              search: () {
                _getData();
                _commentFocus.unfocus();
              },
            )
          ],
          // leadingWidth: 30,
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left_rounded,
              size: 28,
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_deep_grey
                  : os_black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: SearchLeft(
            confirm: () {
              _getData();
              _commentFocus.unfocus();
            },
            focus: () async {
              await _scrollController.animateTo(
                0,
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              );
              setState(() {
                data = [];
                load_done = false;
              });
            },
            commentFocus: _commentFocus,
            controller: _controller,
            select: (idx) {
              // setState(() {
              //   data = [];
              //   load_done = false;
              //   select = idx;
              // });
            },
            select_idx: select,
          ),
        ),
        backgroundColor:
            Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
        body: Container(
          color: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : os_back,
          child: DismissiblePage(
            backgroundColor: Provider.of<ColorProvider>(context).isDark
                ? os_dark_back
                : os_back,
            direction: DismissiblePageDismissDirection.startToEnd,
            onDismissed: () {
              Navigator.of(context).pop();
            },
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_back
                    : os_back,
                child: ListView(
                  controller: _scrollController,
                  //physics: BouncingScrollPhysics(),
                  children: [
                    Container(height: 10),
                    SwitchTypeTab(
                      index: select,
                      select: (idx) {
                        XSVibrate().impact();
                        setState(() {
                          data = [];
                          load_done = false;
                          select = idx;
                        });
                      },
                    ),
                    ..._buildTopic(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SwitchTypeTab extends StatefulWidget {
  int? index;
  Function? select;
  SwitchTypeTab({
    Key? key,
    this.index,
    this.select,
  }) : super(key: key);

  @override
  State<SwitchTypeTab> createState() => _SwitchTypeTabState();
}

class _SwitchTypeTabState extends State<SwitchTypeTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(3.5),
            decoration: BoxDecoration(
              // color: os_white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.select != null) {
                      widget.select!(0);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: widget.index == 0
                          ? (Provider.of<ColorProvider>(context).isDark
                              ? os_light_dark_card
                              : os_white)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      "搜帖子",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: widget.index == 0
                            ? (Provider.of<ColorProvider>(context).isDark
                                ? os_dark_white
                                : os_color)
                            : Color(0xFF777777),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.select != null) {
                      widget.select!(1);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: widget.index == 1
                          ? (Provider.of<ColorProvider>(context).isDark
                              ? os_light_dark_card
                              : os_white)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      "搜用户",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: widget.index == 1
                            ? (Provider.of<ColorProvider>(context).isDark
                                ? os_dark_white
                                : os_color)
                            : Color(0xFF777777),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Text("哈哈哈哈说${widget.index}"),
        ],
      ),
    );
  }
}

class History extends StatefulWidget {
  Function? confirm;
  History({
    Key? key,
    this.confirm,
  }) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List? data = [];
  List<Widget> _buildCont() {
    List<Widget> tmp = [];
    if (data!.length != 0) {
      for (int i = 0; i < data!.length; i++) {
        tmp.add(HistoryTag(
          refresh: () {
            widget.confirm!("");
            _getData();
          },
          tap: (txt) {
            if (widget.confirm != null) {
              widget.confirm!(txt);
            }
          },
          txt: data![i],
        ));
      }
      tmp.add(Container(height: 10));
    }
    return tmp;
  }

  _getData() async {
    String tmp = await getStorage(key: "search-history", initData: "[]");
    List? tmp_arr = jsonDecode(tmp);
    setState(() {
      data = tmp_arr;
    });
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return data!.length == 0
        ? Container()
        : Container(
            margin: EdgeInsets.symmetric(horizontal: os_edge),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              // color: os_white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "搜索历史",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFBBBBBB),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.confirm!("");
                        showModal(
                          context: context,
                          title: "请确认",
                          cont: "是否要删除所有历史记录，该操作不可逆",
                          confirm: () {
                            setStorage(key: "search-history", value: "[]");
                            setState(() {
                              data = [];
                            });
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.clear,
                            color: Color(0xFFBBBBBB),
                            size: 20,
                          ),
                          Text(
                            "清除全部",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFBBBBBB),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(height: 15),
                Wrap(
                  children: _buildCont(),
                ),
              ],
            ),
          );
  }
}

class HistoryTag extends StatefulWidget {
  Function? tap;
  Function? refresh;
  String? txt;
  HistoryTag({
    Key? key,
    this.tap,
    this.txt,
    this.refresh,
  }) : super(key: key);

  @override
  State<HistoryTag> createState() => _HistoryTagState();
}

class _HistoryTagState extends State<HistoryTag> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 7.5, bottom: 7.5),
      child: myInkWell(
        radius: 15,
        longPress: () {
          XSVibrate().impact();
          showModal(
              context: context,
              title: "请确认",
              cont: "是否要删除此条搜索记录，该操作不可被撤销",
              confirm: () async {
                var tmp_string = await getStorage(
                  key: "search-history",
                  initData: "[]",
                );
                List tmp_arr = jsonDecode(tmp_string);
                tmp_arr.remove(widget.txt);
                await setStorage(
                  key: "search-history",
                  value: jsonEncode(tmp_arr),
                );
                widget.refresh!();
              });
        },
        tap: () {
          if (widget.tap != null) {
            widget.tap!(widget.txt);
          }
        },
        color: Provider.of<ColorProvider>(context).isDark
            ? os_light_dark_card
            : os_white,
        widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
          child: Text(
            widget.txt ?? "历史记录",
            style: TextStyle(
              fontSize: 14,
              color: os_deep_grey,
            ),
          ),
        ),
      ),
    );
  }
}

class UserListCard extends StatefulWidget {
  Map? data;
  UserListCard({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  State<UserListCard> createState() => _UserListCardState();
}

class _UserListCardState extends State<UserListCard> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: os_edge, vertical: 5),
        child: myInkWell(
          color: Provider.of<ColorProvider>(context).isDark
              ? os_light_dark_card
              : os_white,
          tap: () async {
            int? uid = await getUid();
            Navigator.pushNamed(
              context,
              "/person_center",
              arguments: {
                "uid": widget.data!["uid"],
                "isMe": uid == widget.data!["uid"],
              },
            );
          },
          widget: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Provider.of<ColorProvider>(context).isDark
                            ? os_deep_grey
                            : os_grey,
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                    ),
                    width: 35,
                    height: 35,
                    fit: BoxFit.cover,
                    imageUrl: widget.data!["icon"],
                  ),
                ),
                Container(width: 15),
                Container(
                  width: MediaQuery.of(context).size.width -
                      MinusSpace(context) -
                      160,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.data!["name"],
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    Provider.of<ColorProvider>(context).isDark
                                        ? os_dark_white
                                        : os_black),
                          ),
                          Container(width: 5),
                          widget.data!["userTitle"].toString().length < 6
                              ? Tag(
                                  txt: widget.data!["userTitle"],
                                  color: os_white,
                                  color_opa: os_wonderful_color[1],
                                )
                              : Container(),
                        ],
                      ),
                      Container(height: 5),
                      Text(
                        widget.data!["signture"] == ""
                            ? "这位畔友很懒，什么也没写"
                            : widget.data!["signture"],
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9F9F9F),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 40,
                  child: IconButton(
                    icon: Icon(
                      Icons.person_add_rounded,
                      color: Provider.of<ColorProvider>(context).isDark
                          ? os_dark_dark_white
                          : os_deep_grey,
                    ),
                    onPressed: () async {
                      var tmp = await Api().user_useradmin({
                        "type": "follow",
                        "uid": widget.data!["uid"],
                      });
                      showToast(
                        context: context,
                        txt: tmp["errcode"],
                        duration: 500,
                        type: XSToast.none,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          radius: 10,
        ),
      ),
    );
  }
}

class SearchBtn extends StatefulWidget {
  Function search;
  SearchBtn({Key? key, required this.search}) : super(key: key);

  @override
  _SearchBtnState createState() => _SearchBtnState();
}

class _SearchBtnState extends State<SearchBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 15),
      child: myInkWell(
        tap: () {
          widget.search();
        },
        color: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        widget: Center(
          child: os_svg(
            path: Provider.of<ColorProvider>(context).isDark
                ? "lib/img/search_white.svg"
                : "lib/img/search.svg",
            width: 24,
            height: 24,
          ),
        ),
        radius: 100,
      ),
    );
  }
}

class SearchLeft extends StatefulWidget {
  Function select;
  Function confirm;
  TextEditingController? controller;
  FocusNode commentFocus;
  Function? focus;
  int? select_idx;
  SearchLeft({
    Key? key,
    required this.select,
    this.controller,
    this.focus,
    required this.select_idx,
    required this.commentFocus,
    required this.confirm,
  }) : super(key: key);

  @override
  _SearchLeftState createState() => _SearchLeftState();
}

class _SearchLeftState extends State<SearchLeft> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 105,
      padding: EdgeInsets.only(left: 15),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Provider.of<ColorProvider>(context).isDark
            ? os_light_dark_card
            : os_white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 145,
            child: TextField(
              keyboardAppearance:
                  Provider.of<ColorProvider>(context, listen: false).isDark
                      ? Brightness.dark
                      : Brightness.light,
              onSubmitted: (context) {
                widget.confirm();
              },
              onTap: () {
                if (widget.focus != null) widget.focus!();
              },
              controller: widget.controller,
              cursorColor: Provider.of<ColorProvider>(context).isDark
                  ? os_dark_dark_white
                  : os_black,
              cursorWidth: 1.5,
              focusNode: widget.commentFocus,
              style: TextStyle(
                fontSize: 16,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_dark_white
                    : os_black,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(right: 15),
                hintStyle: TextStyle(
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_deep_grey
                      : os_middle_grey,
                ),
                hintText:
                    isMacOS() ? "搜索帖子/用户，按住control键+空格键以切换中英文输入法" : "搜索帖子/用户",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchTopicCard extends StatefulWidget {
  Map? data;
  int? index;
  Function tap;

  SearchTopicCard({Key? key, this.data, this.index, required this.tap})
      : super(key: key);

  @override
  _SearchTopicCardState createState() => _SearchTopicCardState();
}

class _SearchTopicCardState extends State<SearchTopicCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
        child: myInkWell(
          color: Provider.of<ColorProvider>(context).isDark
              ? os_light_dark_card
              : os_white,
          tap: () {
            widget.tap();
            Navigator.pushNamed(
              context,
              "/topic_detail",
              arguments: widget.data!["topic_id"],
            );
          },
          widget: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 16, 15, 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 35,
                              height: 35,
                              color: Provider.of<ColorProvider>(context).isDark
                                  ? Color(0x19FFFFFF)
                                  : os_wonderful_color_opa[widget.index! % 7],
                              child: Center(
                                child: Text(
                                  widget.data!["user_nick_name"].length == 0
                                      ? "X"
                                      : widget.data!["user_nick_name"][0],
                                  style: TextStyle(
                                    color: Provider.of<ColorProvider>(context)
                                            .isDark
                                        ? os_dark_white
                                        : os_wonderful_color[widget.index! % 7],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(4)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.data!["user_nick_name"],
                                style: TextStyle(
                                  color:
                                      Provider.of<ColorProvider>(context).isDark
                                          ? os_dark_white
                                          : Color(0xFF636363),
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                RelativeDateFormat.format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(widget.data!["last_reply_date"]),
                                  ),
                                ),
                                style: TextStyle(
                                  color:
                                      Provider.of<ColorProvider>(context).isDark
                                          ? os_deep_grey
                                          : Color(0xFFC4C4C4),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(1)),
                  Container(
                    width: MediaQuery.of(context).size.width - 60,
                    child: Text(
                      widget.data!["title"].replaceAll("&nbsp1", " "),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Provider.of<ColorProvider>(context).isDark
                            ? os_dark_white
                            : os_black,
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(2)),
                  Container(
                    width: MediaQuery.of(context).size.width - 60,
                    child: Text(
                      (widget.data!["summary"] ?? widget.data!["subject"]) ??
                          "",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Provider.of<ColorProvider>(context).isDark
                            ? os_deep_grey
                            : Color(0xFFA3A3A3),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(7)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          os_svg(
                            path: "lib/img/comment.svg",
                            width: 12.8,
                            height: 12.8,
                          ),
                          Padding(padding: EdgeInsets.all(2)),
                          Text(
                            "评论 ${widget.data!['replies']} · 浏览量 ${widget.data!['hits']}",
                            style: TextStyle(
                              color: Color(0xFFC5C5C5),
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // width: width,
          // height: height,
          radius: 10,
        ),
      ),
    );
  }
}
