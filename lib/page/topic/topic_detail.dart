import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:html/parser.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/mouse_speed.dart';
import 'package:offer_show/asset/nowMode.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/toWebUrl.dart';
import 'package:offer_show/asset/to_user.dart';
import 'package:offer_show/components/collection.dart';
import 'package:offer_show/components/empty.dart';
import 'package:offer_show/components/loading.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/components/nomore.dart';
import 'package:offer_show/components/totop.dart';
import 'package:offer_show/page/topic/detail_cont.dart';
import 'package:offer_show/page/topic/topic_RichInput.dart';
import 'package:offer_show/page/topic/topic_comment.dart';
import 'package:offer_show/page/topic/topic_comment_tab.dart';
import 'package:offer_show/page/topic/topic_detailBottom.dart';
import 'package:offer_show/page/topic/topic_detail_time.dart';
import 'package:offer_show/page/topic/topic_more.dart';
import 'package:offer_show/page/topic/topic_vote.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

import '../../outer/cached_network_image/cached_image_widget.dart';

class TopicDetail extends StatefulWidget {
  int topicID;
  TopicDetail({Key key, this.topicID}) : super(key: key);

  @override
  _TopicDetailState createState() => _TopicDetailState();
}

class _TopicDetailState extends State<TopicDetail> {
  var data;
  var comment = [];
  var load_done = false;
  var loading = false;
  var _select = 0; //0-???????????? 1-????????????
  var _sort = 0; //0-??????????????? 1-???????????????
  var showBackToTop = false;
  var uploadImgList = [];
  var total_num = 0; //????????????
  String uploadFileAid = "";
  var replyId = 0;
  int stick_num = 0;
  double bottom_safeArea = 10;
  bool editing = false; //????????????????????????
  bool isBlack = false;
  bool isInvalid = false; //??????????????????
  bool isNoAccess = false; //??????????????????????????????
  String placeholder =
      (isMacOS() ? "??????????????????????????????control???+????????????????????????????????????" : "?????????????????????");
  List<Map> atUser = [];
  List<int> listID = []; //??????ID
  List listData = []; //????????????

  String blackKeyWord = "";
  ScrollController _scrollController = new ScrollController();
  TextEditingController _txtController = new TextEditingController();
  FocusNode _focusNode = new FocusNode();

  var dislike_count = 0;

  //????????????
  _alterSend() async {
    // showToast(context: context, type: XSToast.loading, txt: "????????????");
    var contents = data["topic"]["content"];
    for (var i = 0; i < contents.length; i++) {
      var cont_i = contents[i];
      if (cont_i["type"] == 4) {
        contents[i]["infor"] = cont_i["url"];
      }
      if (cont_i["type"] == 0) {
        var original_tmp = "";
        if (cont_i["infor"].toString().contains("[mobcent_phiz=")) {
          //???????????????
          var tmp_str = cont_i["infor"].toString().split("[mobcent_phiz=");
          original_tmp = tmp_str[0];
          for (int j = 1; j < tmp_str.length; j++) {
            original_tmp += tmp_str[j].split("]")[1];
          }
          contents[i]["infor"] = original_tmp;
        }
      }
    }
    print("${contents}");
    List cont_head_tmp = [
      {
        "infor": "?????????Lite App????????????\n",
        "type": 0, // 0????????????1????????????3????????????4:?????????5?????????
      },
      {
        "infor":
            "https://bbs.uestc.edu.cn/forum.php?mod=viewthread&tid=1942769",
        "type": 0, // 0????????????1????????????3????????????4:?????????5?????????
      },
      {
        "infor": "??????????????????\n",
        "type": 0, // 0????????????1????????????3????????????4:?????????5?????????
      },
      {
        "infor": "https://bbs.uestc.edu.cn/forum.php?mod=viewthread&tid=" +
            widget.topicID.toString(),
        "type": 0, // 0????????????1????????????3????????????4:?????????5?????????
      }
    ];
    cont_head_tmp.addAll(contents);
    Map poll = {
      "expiration": 3,
      "options": data["topic"]["poll_info"] == null
          ? []
          : (data["topic"]["poll_info"]["poll_item_list"]
              .map((e) => e["name"])),
      "maxChoices": 1,
      "visibleAfterVote": false,
      "showVoters": false,
    };
    Map json = {
      "body": {
        "json": {
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "typeId": "",
          "aid": "",
          "fid": 25,
          "isQuote": 0, //"?????????????????????????????????
          "title": "????????????" + data["topic"]["title"],
          "content": jsonEncode(cont_head_tmp),
          "poll": data["topic"]["poll_info"] == null ? "" : poll,
        }
      }
    };
    print("${cont_head_tmp}");
    // return;
    var ret_tip = await Api().forum_topicadmin(
      {
        "act": "new",
        "json": jsonEncode(json),
      },
    );
    hideToast();
    if (ret_tip != null && ret_tip["rs"] == 1) {
      var tid = ret_tip["body"]["tid"];
      Navigator.pushNamed(context, "/alter_sent");
    }
  }

  Future<Map> _getCardData(int ctid) async {
    //??????ctid??????????????????
    Map tmp = {
      "name": "??????????????????", //???????????????
      "desc": "???????????????????????????????????????????????????????????????????????????????????????????????????????????????", //???????????????
      "user": "xusun000", //????????????????????????
      "head": "", //????????????????????????
      "user_id": 240329, //??????????????????ID
      "list_id": 240329, //??????ID
      "subs_num": 56, //???????????????
      "subs_txt": "??????", //??????????????????
      "tags": ["??????", "??????", "??????", "??????", "????????????"], //???????????????
      "type": 2, //0-??? 1-??? 2-???
      "isShadow": false, //true-?????? false-?????????
    };
    String d_tmp = (await XHttp().pureHttpWithCookie(
      url: base_url + "forum.php?mod=collection&action=view&ctid=${ctid}",
    ))
        .data
        .toString();
    var document = parse(d_tmp);
    try {
      tmp["name"] = document
          .getElementsByClassName("mn")
          .first
          .getElementsByTagName("a")
          .first
          .innerHtml;
      tmp["desc"] = document
          .getElementsByClassName("mn")
          .first
          .getElementsByClassName("bm_c")
          .first
          .getElementsByTagName("div")
          .last
          .innerHtml;
      document.getElementsByTagName("p").forEach((p) {
        if (p.innerHtml.contains("???????????????")) {
          tmp["user"] = p.getElementsByTagName("a").first.innerHtml;
          tmp["head"] = "https://bbs.uestc.edu.cn/uc_server/avatar.php?uid=" +
              p
                  .getElementsByTagName("a")
                  .first
                  .attributes["href"]
                  .split("&uid=")[1];
          tmp["user_id"] = int.parse(p
              .getElementsByTagName("a")
              .first
              .attributes["href"]
              .split("&uid=")[1]);
        }
      });
      tmp["list_id"] = ctid;
      tmp["subs_num"] = int.parse(document
          .getElementsByClassName("clct_flw")
          .first
          .getElementsByTagName("strong")
          .first
          .innerHtml);
      tmp["subs_txt"] = "?????????";
      document.getElementsByClassName("mbn").forEach((mbn) {
        if (mbn.innerHtml.contains("????????????")) {
          List tmp_tag = [];
          mbn.getElementsByTagName("a").forEach((a) {
            tmp_tag.add(a.innerHtml);
          });
          tmp["tags"] = tmp_tag;
        }
      });
      tmp["type"] = 2; //0-??? 1-??? 2-???
      tmp["isShadow"] = false;
      return tmp;
    } catch (e) {
      print("${e}");
      return tmp;
    }
  }

  getListArr() async {
    List tmp = [];
    for (var i = 0; i < listID.length; i++) {
      var element = listID[i];
      Map tmp_data = await _getCardData(element);
      tmp.add(tmp_data);
    }
    setState(() {
      listData = tmp;
    });
  }

  void _getLikeCount() async {
    var document = parse((await XHttp().pureHttpWithCookie(
      url: base_url + "forum.php?mod=viewthread&tid=${widget.topicID}",
    ))
        .data
        .toString());
    try {
      var dislike_txt = document.getElementById("recommendv_sub_digg");
      dislike_count = int.parse(dislike_txt.innerHtml);
      var listArray = document.getElementsByClassName("cm");
      listArray.forEach((cm) {
        if (cm.innerHtml.contains("??????????????????????????????")) {
          listID = [];
          cm.getElementsByTagName("li").forEach((li) {
            listID.add(int.parse(li
                .getElementsByTagName("a")
                .first
                .attributes["href"]
                .split("ctid=")[1]));
          });
        }
      });
      setState(() {});
    } catch (e) {}
    getListArr();
  }

  bool _isBlack() {
    bool flag = false;
    Provider.of<BlackProvider>(context, listen: false).black.forEach((element) {
      if (data["topic"]["title"].toString().contains(element) ||
          data["topic"]["user_nick_name"].toString().contains(element)) {
        flag = true;
        blackKeyWord = element;
      }
    });
    return flag;
  }

  Future _getData() async {
    var tmp = await Api().forum_postlist({
      "topicId": widget.topicID,
      "authorId": _select == 0 ? 0 : data["topic"]["user_id"],
      "order": _sort,
      "page": 1,
      "pageSize": 20,
    });
    if (tmp.toString().contains("??????????????????????????????")) {
      setState(() {
        isNoAccess = true;
      });
      return;
    }
    if (tmp.toString().contains("?????????????????????????????????????????????????????????")) {
      setState(() {
        isInvalid = true;
      });
      return;
    }
    try {
      if (tmp["rs"] != 0) {
        comment = tmp["list"];
        data = tmp;
        load_done = ((tmp["list"] ?? []).length < 20);
        if (total_num == 0) {
          setState(() {
            total_num = data["total_num"];
            stick_num = comment.length - 20; //?????????????????????
          });
        }
      } else {
        load_done = true;
        data = null;
      }
    } catch (e) {}
    if (data == null || data["topic"] == null) {
      xsLanuch(
        url:
            "https://bbs.uestc.edu.cn/forum.php?mod=viewthread&tid=${widget.topicID}",
        isExtern: false,
      );
    }
    setState(() {});
    return;
  }

  void _getComment() async {
    if (loading || load_done) return; //??????????????????????????????????????????
    loading = true;
    const nums = 20;
    var tmp = await Api().forum_postlist({
      "topicId": widget.topicID,
      "authorId": _select == 0 ? 0 : data["topic"]["user_id"],
      "order": _sort,
      "page": ((comment.length - stick_num) / nums + 1).floor(),
      "pageSize": nums,
    });
    if (tmp["list"] != null && tmp["list"].length != 0) {
      comment.addAll(tmp["list"]);
    }
    load_done = ((tmp["list"] ?? []).length < nums);
    setState(() {});
    loading = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool vibrate = false;

  @override
  void initState() {
    _getData();
    _getLikeCount();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < -100) {
        if (!vibrate) {
          vibrate = true; //??????????????????
          Vibrate.feedback(FeedbackType.impact);
        }
      }
      if (_scrollController.position.pixels >= 0) {
        vibrate = false; //????????????
      }
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getComment();
      }
      if (_scrollController.position.pixels > 1000 && !showBackToTop) {
        setState(() {
          showBackToTop = true;
        });
      }
      if (_scrollController.position.pixels < 1000 && showBackToTop) {
        setState(() {
          showBackToTop = false;
        });
      }
    });
    speedUp(_scrollController);
  }

  _buildContBody() {
    //???????????????????????????
    List<Widget> tmp = [];
    bool isAlter = false; //?????????????????????
    String s_tmp = "";
    var imgLists = [];
    data["topic"]["content"].forEach((e) {
      //????????????List???????????????
      if (e["type"] == 1) {
        imgLists.add(e["infor"]);
      }
      if (e["type"] == 0) {
        s_tmp += e["infor"] + "\n";
      }
    });
    for (var i = 0; i < data["topic"]["content"].length; i++) {
      var e = data["topic"]["content"][i];
      if (e["type"] == 5 &&
          e["originalInfo"] != null &&
          e["originalInfo"].toString().indexOf(".jpg") > -1) {
        //???????????????????????????
        data["topic"]["content"].removeAt(i);
      }
    }
    for (var i = 0; i < data["topic"]["content"].length; i++) {
      var e = data["topic"]["content"][i];
      int img_count = 0;
      if (imgLists.length > (isDesktop() ? 0 : 3) &&
          e["type"] == 1 &&
          i < data["topic"]["content"].length - 1 &&
          data["topic"]["content"][i + 1]["type"] == 1) {
        List<Widget> renderImg = [];
        while (e["type"] == 1 &&
            i + img_count < data["topic"]["content"].length &&
            true) {
          renderImg.add(DetailCont(
            data: data["topic"]["content"][i + img_count],
            title: data["topic"]["title"],
            desc: s_tmp,
            imgLists: imgLists,
          ));
          img_count++; //????????????????????????
        }
        tmp.add(Wrap(
          children: renderImg,
          spacing: 6,
          runSpacing: 6,
          alignment: WrapAlignment.start,
        ));
        i += img_count - 1; //????????????
      } else {
        if (e["type"] == 0 && e["infor"] == "?????????Lite App????????????") {
          isAlter = true;
          tmp.add(Bounce(
            duration: Duration(milliseconds: 100),
            onPressed: () {
              Navigator.pushNamed(
                context,
                "/topic_detail",
                arguments: Platform.isIOS ? 1943353 : 1942769,
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              padding: EdgeInsets.symmetric(vertical: 25),
              decoration: BoxDecoration(
                color: os_color_opa,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                  color: os_color,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.near_me_outlined,
                    color: os_color,
                    size: 27,
                  ),
                  Text(
                    "?????????Lite App????????????",
                    style: TextStyle(
                      color: os_color,
                      fontSize: 16,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: os_color,
                    size: 19,
                  ),
                ],
              ),
            ),
          ));
        } else if (e["type"] == 4 &&
            (e["infor"] ==
                    "https://bbs.uestc.edu.cn/forum.php?mod=viewthread&tid=1939629" ||
                e["infor"] ==
                    "https://bbs.uestc.edu.cn/forum.php?mod=viewthread&tid=1942769") &&
            isAlter) {
          tmp.add(Container());
        } else {
          tmp.add(GestureDetector(
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: s_tmp));
              Vibrate.feedback(FeedbackType.impact);
              showToast(
                context: context,
                type: XSToast.success,
                txt: "??????????????????",
              );
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: DetailCont(
                data: e,
                imgLists: imgLists,
                title: data["topic"]["title"],
                desc: s_tmp,
              ),
            ),
          ));
        }
      }
    }
    return Column(children: tmp);
  }

  List<Widget> _buildListCard() {
    List<Widget> tmp = [];
    listData.forEach((element) {
      tmp.add(
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "/list", arguments: element);
          },
          child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Color(0x16000000),
                  blurRadius: 15,
                  offset: Offset(6, 6),
                ),
              ]),
              child: Collection(data: element)),
        ),
      );
    });
    tmp.add(Padding(padding: EdgeInsets.all(5)));
    return tmp;
  }

  _getEssenceCont() {
    //???????????????????????????Banner
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: os_edge, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: os_color_opa,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.gpp_good_sharp,
              color: os_color,
            ),
            Container(width: 5),
            Text(
              "?????????????????????????????????????????????",
              style: TextStyle(
                color: os_color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getSecondBuy() {
    //???????????????????????????Banner
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: os_edge, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: os_wonderful_color_opa[2],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_emotions,
              color: os_wonderful_color[2],
            ),
            Container(width: 5),
            Text(
              "???????????????????????????",
              style: TextStyle(
                color: os_wonderful_color[2],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _reply_comment(int i) async {
    //?????????????????????
    Map json = {
      "body": {
        "json": {
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "typeId": "",
          "aid": "",
          "fid": "",
          "replyId": "",
          "tid": widget.topicID, // ?????????????????????
          "isQuote": 0, //"?????????????????????????????????
          "title": "",
          "content": jsonEncode(comment[i]["reply_content"]),
        }
      }
    };
    showToast(
      context: context,
      type: XSToast.loading,
      txt: "????????????",
    );
    await Api().forum_topicadmin(
      {
        "act": "reply",
        "json": jsonEncode(json),
      },
    );
    await _getData();
    Navigator.pop(context);
    hideToast();
  }

  _buildTotal() {
    //???????????????????????????????????????
    List<Widget> tmp = [];
    tmp = [
      TopicDetailTitle(data: data),
      data["topic"]["essence"] == 0 ? Container() : _getEssenceCont(),
      data["boardId"] != 61 ? Container() : _getSecondBuy(), //????????????
      TopicDetailTime(
        data: data,
        refresh: () async {
          //????????????????????????????????????
          _getData();
          await Future.delayed(Duration(milliseconds: 500));
          showToast(context: context, type: XSToast.success, txt: "???????????????");
        },
      ),
      _buildContBody(),
      data["topic"]["poll_info"] != null
          ? TopicVote(
              topic_id: data["topic"]["topic_id"],
              poll_info: data["topic"]["poll_info"],
            )
          : Container(),
      listData.length == 0
          ? Container()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "- ?????????????????????????????? -",
                  style: TextStyle(color: os_deep_grey),
                ),
              ),
            ),
      ..._buildListCard(),
      TopicBottom(
        data: data,
      ),
      Container(height: 10),
      Divider(context: context),
      CommentsTab(
        select: _select,
        sort: _sort,
        bindSelect: (select) async {
          _select = select;
          showToast(context: context, type: XSToast.loading);
          await _getData();
          hideToast();
        },
        bindSort: (sort) async {
          _sort = sort;
          await Future.delayed(Duration(milliseconds: 30));
          showToast(
            context: context,
            type: XSToast.loading,
            txt: "??????????????????",
          );
          await _getData();
          hideToast();
        },
        host_id: data["topic"]["user_id"],
        data: [],
        total_num: total_num,
        topic_id: data["topic"]["topic_id"],
      ),
    ];
    tmp.add(comment.length == 0
        ? Empty(txt: _select == 0 ? "????????????, ??????????????????~" : "????????????????????????~")
        : Container());
    for (var i = 0; i < comment.length; i++) {
      tmp.add(Comment(
        fid: data["boardId"],
        fresh: () async {
          await _getData();
          vibrate = false;
          return;
        },
        add_1: () async {
          _reply_comment(i);
        },
        index: i,
        tap: (reply_id, reply_name) {
          //????????????
          replyId = reply_id;
          editing = true;
          _focusNode.requestFocus();
          placeholder = "??????@${reply_name}???";
          // print("????????????${placeholder}${replyId}");
          setState(() {});
        },
        host_id: data["topic"]["user_id"],
        topic_id: data["topic"]["topic_id"],
        data: comment[i],
        is_last: i == (comment.length - 1),
      ));
    }
    tmp.addAll([
      load_done
          ? NoMore()
          : BottomLoading(
              color: Colors.transparent,
              txt: "????????????${total_num - comment.length}????????????",
            ),
      load_done
          ? Container()
          : Container(
              height: 30,
            ),
      Container(height: editing ? 250 : 60 + bottom_safeArea)
    ]);
    //????????????????????????
    for (var i = 0; i < tmp.length; i++) {
      tmp[i] = ResponsiveWidget(child: tmp[i]);
    }
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    nowMode(context);
    return Scaffold(
      appBar: data == null || data["topic"] == null
          ? AppBar(
              backgroundColor: Provider.of<ColorProvider>(context).isDark
                  ? os_light_dark_card
                  : os_white,
              foregroundColor: os_black,
              leading: IconButton(
                icon: Icon(Icons.chevron_left_rounded),
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_dark_card,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              elevation: 0,
            )
          : AppBar(
              backgroundColor: Provider.of<ColorProvider>(context).isDark
                  ? os_detail_back
                  : os_white,
              foregroundColor: os_black,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.chevron_left_rounded),
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_dark_card,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(""),
              actions: _isBlack() || isBlack
                  ? []
                  : [
                      TopicDetailHead(data: data),
                      TopicDetailMore(
                          data: data,
                          alterSend: () {
                            _alterSend();
                          },
                          block: () {
                            setState(() {
                              isBlack = true;
                            });
                          }),
                    ],
            ),
      backgroundColor: Provider.of<ColorProvider>(context).isDark
          ? os_detail_back
          : os_white,
      body: data == null || data["topic"] == null
          ? ((isInvalid || isNoAccess)
              ? Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 150),
                    child: Text(
                      isInvalid ? "??????????????????????????????????????????????????????????????????" : "???????????????????????????????????????",
                      style: TextStyle(
                        color: Provider.of<ColorProvider>(context).isDark
                            ? os_dark_white
                            : os_black,
                      ),
                    ),
                  ),
                )
              : Loading(
                  showError: load_done,
                  msg: "??????Lite???????????????????????????????????????????????????????????????????????????????????????",
                  tapTxt: "???????????????>",
                  tap: () async {
                    xsLanuch(
                        url: base_url +
                            "forum.php?mod=viewthread&tid=" +
                            widget.topicID.toString() +
                            (isDesktop() ? "" : "&mobile=2"),
                        isExtern: false);
                  },
                ))
          : _isBlack() || isBlack
              ? Container(
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_detail_back
                      : os_white,
                  padding: EdgeInsets.only(bottom: 150),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80),
                    child: Center(
                      child: Text(
                        "???????????????????????????????????????????????????????????????" + blackKeyWord,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Provider.of<ColorProvider>(context).isDark
                              ? os_dark_white
                              : os_black,
                        ),
                      ),
                    ),
                  ))
              : Container(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Provider.of<ColorProvider>(context).isDark
                              ? os_detail_back
                              : os_white,
                        ),
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await _getData();
                            vibrate = false;
                            return;
                          },
                          child: BackToTop(
                            bottom: 115,
                            show: showBackToTop,
                            animation: true,
                            controller: _scrollController,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(),
                              child: ListView(
                                physics: BouncingScrollPhysics(),
                                controller: _scrollController,
                                children: _buildTotal(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      editing //???????????????
                          ? RichInput(
                              fid: data["topic"]["boardId"],
                              tid: widget.topicID,
                              uploadFile: (aid) {
                                uploadFileAid = aid;
                              },
                              uploadImg: (img_urls) {
                                if (img_urls != null && img_urls.length != 0) {
                                  uploadImgList = [];
                                  for (var i = 0; i < img_urls.length; i++) {
                                    uploadImgList.add(img_urls[i]);
                                  }
                                }
                              },
                              atUser: (List<Map> map) {
                                atUser = map;
                              },
                              placeholder: placeholder,
                              controller: _txtController,
                              focusNode: _focusNode,
                              cancel: () {
                                _focusNode.unfocus();
                                _txtController.clear();
                                placeholder = (isMacOS()
                                    ? "??????????????????????????????control???+????????????????????????????????????"
                                    : "?????????????????????");
                                uploadFileAid = "";
                                uploadImgList = [];
                                editing = false;
                                setState(() {});
                              },
                              send: () async {
                                var contents = [
                                  {
                                    "type": 0, // 0??????????????????????????????1????????????3?????????;4:??????;5?????????
                                    "infor": uploadFileAid == ""
                                        ? _txtController.text
                                        : (_txtController.text == ""
                                            ? "????????????"
                                            : _txtController.text),
                                  },
                                ];
                                for (var i = 0; i < uploadImgList.length; i++) {
                                  contents.add({
                                    "type": 1, // 0??????????????????????????????1????????????3?????????;4:??????;5?????????
                                    "infor": uploadImgList[i]["urlName"],
                                  });
                                }
                                var aids = uploadImgList
                                    .map((attachment) => attachment["id"]);
                                if (uploadFileAid != "") {
                                  aids = aids.followedBy([uploadFileAid]);
                                }
                                Map json = {
                                  "body": {
                                    "json": {
                                      "isAnonymous": 0,
                                      "isOnlyAuthor": 0,
                                      "typeId": "",
                                      "aid": aids.join(","),
                                      "fid": "",
                                      "replyId": replyId,
                                      "tid": widget.topicID, // ?????????????????????
                                      "isQuote": placeholder ==
                                              (isMacOS()
                                                  ? "??????????????????????????????control???+????????????????????????????????????"
                                                  : "?????????????????????")
                                          ? 0
                                          : 1, //"?????????????????????????????????
                                      "title": "",
                                      "content": jsonEncode(contents),
                                    }
                                  }
                                };
                                //????????????
                                showToast(
                                  context: context,
                                  type: XSToast.loading,
                                  txt: "????????????",
                                  duration: 100000,
                                );
                                await Api().forum_topicadmin(
                                  {
                                    "act": "reply",
                                    "json": jsonEncode(json),
                                  },
                                );
                                hideToast();
                                showToast(
                                  context: context,
                                  type: XSToast.success,
                                  duration: 200,
                                  txt: "????????????!",
                                );
                                //??????????????????
                                setState(() {
                                  uploadImgList = [];
                                  uploadFileAid = "";
                                  editing = false;
                                  _focusNode.unfocus();
                                  _txtController.clear();
                                  placeholder = (isMacOS()
                                      ? "??????????????????????????????control???+????????????????????????????????????"
                                      : "?????????????????????");
                                });
                                await Future.delayed(
                                    Duration(milliseconds: 30));
                                await _getData();
                              },
                            )
                          : DetailFixBottom(
                              dislike_count: dislike_count,
                              bottom: bottom_safeArea,
                              tapEdit: () {
                                _focusNode.requestFocus();
                                editing = true;
                                setState(() {});
                              },
                              topic_id: data["topic"]["topic_id"],
                              count: data["topic"]["extraPanel"][1]["extParams"]
                                  ["recommendAdd"],
                            )
                    ],
                  ),
                ),
    );
  }
}

class Divider extends StatelessWidget {
  const Divider({
    Key key,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 15,
      decoration: BoxDecoration(
        color: Provider.of<ColorProvider>(context).isDark
            ? Color(0xFF222222)
            : Color(0xFFF6F6F6),
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );
  }
}

//????????????
class BottomLoading extends StatefulWidget {
  Color color;
  String txt;
  BottomLoading({
    Key key,
    this.color,
    this.txt,
  }) : super(key: key);

  @override
  _BottomLoadingState createState() => _BottomLoadingState();
}

class _BottomLoadingState extends State<BottomLoading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color ?? Colors.transparent,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Color(0xFFAAAAAA),
                strokeWidth: 2.5,
              ),
            ),
            Container(width: 10),
            Text(widget.txt ?? "????????????", style: TextStyle(color: os_deep_grey)),
          ],
        ),
      ),
    );
  }
}

class Tag extends StatefulWidget {
  var txt;
  var color;
  var color_opa;
  Tag({
    Key key,
    this.txt,
    this.color,
    this.color_opa,
  }) : super(key: key);

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
      decoration: BoxDecoration(
        color: widget.color_opa,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Text(widget.txt,
          style: TextStyle(
            color: widget.color,
            fontSize: 12,
          )),
    );
  }
}

class TopicBottom extends StatefulWidget {
  TopicBottom({Key key, this.data}) : super(key: key);

  final data;

  @override
  _TopicBottomState createState() => _TopicBottomState();
}

class _TopicBottomState extends State<TopicBottom> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Bounce(
            duration: Duration(milliseconds: 100),
            onPressed: () {
              Navigator.pushNamed(context, "/column",
                  arguments: widget.data['boardId']);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 7.5, vertical: 3),
              decoration: BoxDecoration(
                color: os_color_opa,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Text(
                "???????????????: " + widget.data["forumName"] + " >",
                style: TextStyle(color: os_color),
              ),
            ),
          ),
          Container(),
        ],
      ),
    );
  }
}

// ????????????
class TopicDetailTitle extends StatelessWidget {
  const TopicDetailTitle({
    Key key,
    @required this.data,
  }) : super(key: key);

  final data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Text(
        data["topic"]["title"].replaceAll("&nbsp1", " "),
        style: TextStyle(
          fontSize: 18,
          fontWeight: Provider.of<ColorProvider>(context).isDark
              ? FontWeight.normal
              : FontWeight.bold,
          color: Provider.of<ColorProvider>(context).isDark
              ? os_dark_white
              : os_black,
        ),
      ),
    );
  }
}

// ??????????????????
class TopicDetailHead extends StatelessWidget {
  const TopicDetailHead({
    Key key,
    @required this.data,
  }) : super(key: key);

  final data;

  @override
  Widget build(BuildContext context) {
    return myInkWell(
        tap: () {
          if (data["topic"]["user_nick_name"] != "??????")
            toUserSpace(context, data["topic"]["user_id"]);
        },
        color: Colors.transparent,
        widget: Container(
          margin: EdgeInsets.fromLTRB(5, 12, 5, 12),
          padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Provider.of<ColorProvider>(context).isDark
                          ? os_dark_card
                          : os_white,
                      width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: 23,
                    height: 23,
                    imageUrl: data["topic"]["icon"],
                    placeholder: (context, url) => Container(color: os_grey),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(3)),
              Text(
                data["topic"]["user_nick_name"],
                style: TextStyle(
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_white
                      : Color(0xFF6D6D6D),
                ),
              ),
              Padding(padding: EdgeInsets.all(3)),
              os_svg(
                path: "lib/img/right_arrow_grey.svg",
                width: 5,
                height: 9,
              ),
              Padding(padding: EdgeInsets.all(3)),
            ],
          ),
        ),
        radius: 100);
  }
}
