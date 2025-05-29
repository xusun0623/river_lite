import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/black.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/copy_sheet.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/myinfo.dart';
import 'package:offer_show/asset/showActionSheet.dart';
import 'package:offer_show/asset/showPop.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/time.dart';
import 'package:offer_show/asset/to_user.dart';
import 'package:offer_show/asset/topic_formhash.dart';
import 'package:offer_show/asset/vibrate.dart';
import 'package:offer_show/asset/xs_textstyle.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/page/topic/detail_cont.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Comment extends StatefulWidget {
  var data;
  var is_last;
  var topic_id;
  var host_id;
  var fid;
  Function? add_1;
  int? index;
  Function? tap;
  Function? fresh;
  bool? isListView;

  Comment(
      {Key? key,
      this.data,
      this.is_last,
      this.topic_id,
      this.fid,
      this.host_id,
      this.tap,
      this.add_1,
      this.fresh,
      this.isListView,
      this.index})
      : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  var liked = 0;
  bool is_me = false;
  bool is_my_comment = false;
  String? blackKeyWord;
  bool is_tid_block = false;

  _getLikedStatus() async {
    String tmp = await getStorage(
      key: "comment_like",
    );
    List<String> ids = tmp.split(",");
    if (ids.indexOf(widget.data["reply_posts_id"].toString()) > -1) {
      setState(() {
        liked = 1;
      });
    }
  }

  _tapLike(reply_data) async {
    // Vibrate.feedback(FeedbackType.impact);
    XSVibrate().impact();
    if (liked == 1) return;
    liked = 1;
    reply_data["extraPanel"][0]["extParams"]["recommendAdd"]++;
    setState(() {});
    var ans = await Api().forum_support({
      "tid": widget.topic_id,
      "pid": reply_data["reply_posts_id"],
      "type": "post",
      "action": "support",
    });
    var ans_errcode = ans["errcode"]!;
    if (ans_errcode == "赞 +1") {
      showToast(
        context: context,
        type: XSToast.success,
        txt: "点赞成功",
      );
    } else if (ans_errcode.contains("投过票了")) {
      showToast(
        context: context,
        type: XSToast.success,
        txt: "你已经点过赞了",
      );
    }
    String tmp = await getStorage(
      key: "comment_like",
    );
    tmp += ",${reply_data["reply_posts_id"]}";
    setStorage(key: "comment_like", value: tmp);
  }

  _buildContBody(data) {
    List<Widget> tmp = [];
    var imgLists = [];
    data.forEach((e) {
      if (e["type"] == 1) {
        imgLists.add(e["infor"]);
      }
    });
    for (var i = 0; i < data.length; i++) {
      var e = data[i];
      if (e["type"] == 5 &&
          e["originalInfo"] != null &&
          e["originalInfo"].toString().indexOf(".jpg") > -1) {
        //图片附件不允许下载
        data.removeAt(i);
      }
    }
    for (var i = 0; i < data.length; i++) {
      var e = data[i];
      int img_count = 0;
      if ((imgLists.length >
              ((isDesktop() || (widget.isListView ?? false)) ? 0 : 2) &&
          e["type"] == 1 &&
          i < data.length - 1 &&
          data[i + 1]["type"] == 1)) {
        List<Widget> renderImg = [];
        while (e["type"] == 1 && i + img_count < data.length && true) {
          renderImg.add(DetailCont(
            data: data[i + img_count],
            imgLists: imgLists,
            isComment: true,
            fade: widget.isListView,
          ));
          img_count++; //有多少张图片连续
        }
        tmp.add(Wrap(
          children: renderImg,
          spacing: 6,
          runSpacing: 6,
          alignment: WrapAlignment.start,
        ));
        i += img_count - 1; //跳过渲染
      } else {
        tmp.add(Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: DetailCont(
            data: e,
            removeSelectable: true,
            imgLists: imgLists,
            fade: widget.isListView,
          ),
        ));
      }
    }
    return Column(children: tmp);
  }

  deleteComment() async {
    // print("删除");
    // return;
    showToast(
      context: context,
      type: XSToast.loading,
      txt: "需要较长时间",
      duration: 5000,
    );
    String formhash = await getTopicFormHash(widget.topic_id);
    // String fid = widget.fid.toString();
    String tid = widget.topic_id.toString();
    Response tmp = await XHttp().pureHttpWithCookie(
      hadCookie: true,
      url:
          "https://bbs.uestc.edu.cn/home.php?mod=magic&action=mybox&infloat=yes&inajax=1",
      param: {
        "formhash": formhash,
        "handlekey": "a_repent_" + widget.data["reply_posts_id"].toString(),
        "operation": "use",
        "magicid": 20,
        "pid": widget.data["reply_posts_id"],
        "ptid": tid,
        "usesubmit": "yes",
        "idtype": "pid",
        "id": widget.data["reply_posts_id"].toString() + ":" + tid.toString(),
      },
    );
    String tmp_txt = tmp.data.toString();
    hideToast();
    if (tmp_txt.contains("抱歉，您选择的道具不存在")) {
      Fluttertoast.showToast(
        msg: "抱歉，您选择的道具不存在，你可以联系版主或者站长删除",
        gravity: ToastGravity.CENTER,
      );
    } else if (tmp_txt.contains("已删除")) {
      Fluttertoast.showToast(
        msg: "你操作的评论已删除，请手动刷新页面",
        gravity: ToastGravity.CENTER,
      );
    } else if (tmp_txt.contains("24 小时内您只能使用 3 次本道具")) {
      Fluttertoast.showToast(
        msg: "24 小时内您只能使用 3 次本道具，你可以联系版主或者站长删除",
        gravity: ToastGravity.CENTER,
      );
    } else {
      Fluttertoast.showToast(
        msg: "出错了，你可以尝试在网页端删除此评论，或者联系版主或者站长删除",
        gravity: ToastGravity.CENTER,
      );
    }
    print("${tmp.data.toString()}");
  }

  stickyForm() async {
    showToast(context: context, type: XSToast.loading, txt: "请稍后…");
    String formhash = await getTopicFormHash(widget.topic_id);
    String fid = widget.fid.toString();
    String tid = widget.topic_id.toString();
    String page = ((widget.index! / 20) + 1).toString();
    String handlekey = "mods";
    String topiclist = widget.data["reply_posts_id"].toString(); //需要加一个[]
    String stickreply = widget.data["poststick"] == 1 ? "0" : "1";
    String modsubmit = "true";
    var headers = {
      'Cookie': (await getStorage(key: "cookie", initData: "")).toString()
    };
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        base_url +
            'forum.php?mod=topicadmin&action=stickreply&modsubmit=yes&infloat=yes&modclick=yes&inajax=1',
      ),
    );
    request.fields.addAll({
      'formhash': formhash,
      'fid': fid,
      'tid': tid,
      'page': page,
      'handlekey': handlekey,
      'topiclist[]': topiclist,
      'stickreply': stickreply,
      'modsubmit': modsubmit
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      hideToast();
      // Navigator.pop(context);
      showToast(context: context, type: XSToast.success, txt: "操作成功");
      widget.fresh!();
    } else {
      print(response.reasonPhrase);
    }
  }

  _feedbackSuccess() async {
    showToast(
      context: context,
      type: XSToast.success,
      txt: "已举报",
    );
  }

  _feedback() async {
    String txt = "";
    showPop(context, [
      Container(height: 30),
      Text(
        "请输入举报内容",
        style: XSTextStyle(
          context: context,
          listenProvider: false,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Provider.of<ColorProvider>(context, listen: false).isDark
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
          color: Provider.of<ColorProvider>(context, listen: false).isDark
              ? os_white_opa
              : os_grey,
        ),
        child: Center(
          child: TextField(
            keyboardAppearance:
                Provider.of<ColorProvider>(context, listen: false).isDark
                    ? Brightness.dark
                    : Brightness.light,
            onChanged: (e) {
              txt = e;
            },
            style: XSTextStyle(
              context: context,
              listenProvider: false,
              color: Provider.of<ColorProvider>(context, listen: false).isDark
                  ? os_dark_white
                  : os_black,
            ),
            cursorColor: os_deep_blue,
            decoration: InputDecoration(
                hintText: "请输入",
                border: InputBorder.none,
                hintStyle: XSTextStyle(
                  context: context,
                  fontSize: 15,
                  listenProvider: false,
                  color:
                      Provider.of<ColorProvider>(context, listen: false).isDark
                          ? os_dark_dark_white
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
              color: Provider.of<ColorProvider>(context, listen: false).isDark
                  ? os_white_opa
                  : Color(0x16004DFF),
              widget: Container(
                width: (MediaQuery.of(context).size.width -
                            MinusSpace(context) -
                            60) /
                        2 -
                    5,
                height: 40,
                child: Center(
                  child: Text(
                    "取消",
                    style: XSTextStyle(
                      context: context,
                      listenProvider: false,
                      color: Provider.of<ColorProvider>(context, listen: false)
                              .isDark
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
                await Api().user_report({
                  "idType": "post",
                  "message": txt,
                  "id": widget.data["reply_posts_id"]
                });
                Navigator.pop(context);
                _feedbackSuccess();
              },
              color: os_deep_blue,
              widget: Container(
                width: (MediaQuery.of(context).size.width -
                            MinusSpace(context) -
                            60) /
                        2 -
                    5,
                height: 40,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.done, color: os_white, size: 18),
                      Container(width: 5),
                      Text(
                        "完成",
                        style: XSTextStyle(
                          context: context,
                          listenProvider: false,
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
    ]);
  }

  _blackTid() async {
    if (_getBlack() && is_tid_block) {
      await removeBlackWord(widget.data["reply_id"].toString(), context);
      is_tid_block = false;
    } else if (!is_tid_block) {
      await setBlackWord(widget.data["reply_id"].toString(), context);
      is_tid_block = true;
    }
    setState(() {});
    widget.fresh!();
  }

  _showMore() async {
    String copy_txt = "";
    widget.data["reply_content"].forEach((e) {
      if (e["type"] == 0) {
        copy_txt += e["infor"].toString();
      }
    });
    XSVibrate().impact();
    showAction(
      context: context,
      options: [
        "复制文本内容",
        "举报反馈",
        is_tid_block ? "取消屏蔽此帖子" : "屏蔽此贴的ID",
        "屏蔽此人",
        ...(is_my_comment ? ["追加内容"] : []),
        ...(is_me ? [widget.data["poststick"] == 1 ? "取消置顶评论" : "置顶评论"] : []),
        ...(is_my_comment ? ["删除评论"] : []),
      ],
      icons: [
        Icons.copy,
        Icons.feedback_outlined,
        is_tid_block ? Icons.remove_circle_outline_rounded : Icons.block,
        Icons.person_off_outlined,
        ...(is_my_comment ? [Icons.edit] : []),
        ...(is_me
            ? [
                widget.data["poststick"] == 1
                    ? Icons.cancel_presentation
                    : Icons.vertical_align_top
              ]
            : []),
        ...(is_my_comment ? [Icons.delete_outline_rounded] : []),
      ],
      tap: (res) async {
        Navigator.pop(context);
        if (res == "复制文本内容") {
          showOSCopySheet(
            context,
            copy_txt,
          );
        }
        if (res == "举报反馈") {
          _feedback();
        }
        if (res == "取消屏蔽此帖子" || res == "屏蔽此贴的ID") {
          _blackTid();
        }
        if (res == "屏蔽此人") {
          // print("屏蔽此人");
          // print(widget.data["reply_name"]);
          await setBlackWord(widget.data["reply_name"].toString(), context);
          setState(() {});
          widget.fresh!();
        }
        if (res == "追加内容") {
          _append_cont();
        }
        if (res == "取消置顶评论" || res == "置顶评论") {
          stickyForm();
        }
        if (res == "删除评论") {
          showModal(
            context: context,
            title: "请确认",
            cont: "删除此回复需要一张【悔悟卡】道具，你可以在道具商店购买；24小时内最多可以删除3次",
            confirm: () {
              deleteComment();
            },
          );
        }
      },
    );
  }

  _append_cont() {
    String txt = "";
    showPop(context, [
      Container(height: 30),
      Text(
        "请输入补充内容",
        style: XSTextStyle(
          context: context,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Provider.of<ColorProvider>(context, listen: false).isDark
              ? os_dark_dark_white
              : os_black,
        ),
      ),
      Container(height: 10),
      Text(
        "补充内容显示在客户端可能有延时，可以尝试稍后刷新一下或者在网页端查看",
        style: XSTextStyle(
          context: context,
          fontSize: 14,
          color: Provider.of<ColorProvider>(context, listen: false).isDark
              ? os_dark_dark_white
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
          color: Provider.of<ColorProvider>(context, listen: false).isDark
              ? os_white_opa
              : os_grey,
        ),
        child: Center(
          child: TextField(
            keyboardAppearance:
                Provider.of<ColorProvider>(context, listen: false).isDark
                    ? Brightness.dark
                    : Brightness.light,
            onChanged: (e) {
              txt = e;
            },
            style: XSTextStyle(
              context: context,
              color: Provider.of<ColorProvider>(context, listen: false).isDark
                  ? os_dark_white
                  : os_black,
            ),
            cursorColor: os_deep_blue,
            decoration: InputDecoration(
                hintText: "请输入",
                border: InputBorder.none,
                hintStyle: XSTextStyle(
                  context: context,
                  fontSize: 15,
                  color:
                      Provider.of<ColorProvider>(context, listen: false).isDark
                          ? os_dark_dark_white
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
              color: Provider.of<ColorProvider>(context, listen: false).isDark
                  ? os_white_opa
                  : Color(0x16004DFF),
              widget: Container(
                width: (MediaQuery.of(context).size.width - 60) / 2 - 5,
                height: 40,
                child: Center(
                  child: Text(
                    "取消",
                    style: XSTextStyle(
                      context: context,
                      color: Provider.of<ColorProvider>(context, listen: false)
                              .isDark
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
                await Api().post_append(
                  tid: widget.topic_id,
                  pid: widget.data["reply_posts_id"],
                  message: txt,
                );
                if (widget.fresh != null) {
                  widget.fresh!();
                }
                Navigator.pop(context); //水水
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
                        style: XSTextStyle(
                          context: context,
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
    ]);
  }

  _getIsMeTopic() async {
    //该帖子是不是这个用户的，用户方便用户置顶他人/自己评论
    int? uid = await getUid();
    setState(() {
      is_me = widget.host_id == uid;
      is_my_comment = widget.data["reply_id"] == uid;
    });
  }

  bool _getBlack() {
    bool flag = false;
    Provider.of<BlackProvider>(context, listen: false)
        .black!
        .forEach((element) {
      if (widget.data["reply_id"].toString().contains(element) ||
          widget.data["reply_name"].toString().contains(element)) {
        flag = true;
        blackKeyWord = element;
      }
      if (widget.data["reply_id"].toString().contains(element)) {
        is_tid_block = true;
      }
    });
    return flag;
  }

  @override
  void initState() {
    super.initState();
    _getBlack();
    _getIsMeTopic();
    _getLikedStatus();
  }

  _buildPureCont(Map reply_data, bool isquote) {
    //isquote 这条回复是否是被嵌套的引用
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
      child: Stack(
        children: [
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if (reply_data["reply_name"] != "匿名")
                      toUserSpace(
                        context,
                        int.parse(reply_data["icon"]
                            .toString()
                            .split("uid=")[1]
                            .split("&size=")[0]),
                      );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    child: Opacity(
                      opacity:
                          Provider.of<ColorProvider>(context, listen: false)
                                  .isDark
                              ? 0.8
                              : 1,
                      child: CachedNetworkImage(
                        imageUrl: reply_data["icon"],
                        placeholder: (context, url) => Container(
                          color:
                              Provider.of<ColorProvider>(context, listen: false)
                                      .isDark
                                  ? Color(0x22FFFFFF)
                                  : os_grey,
                          width: 35,
                          height: 35,
                        ),
                        width: 35,
                        height: 35,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                Text(
                                  reply_data["reply_name"],
                                  style: XSTextStyle(
                                    listenProvider: false,
                                    context: context,
                                    color: Provider.of<ColorProvider>(context,
                                                listen: false)
                                            .isDark
                                        ? os_dark_white
                                        : Color(0xFF333333),
                                    fontWeight: Provider.of<ColorProvider>(
                                                context,
                                                listen: false)
                                            .isDark
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                reply_data["userTitle"] == null ||
                                        reply_data["userTitle"].length == 0
                                    ? Container()
                                    : Tag(
                                        txt: reply_data["poststick"] == 1
                                            ? "置顶"
                                            : "" + reply_data["userTitle"],
                                        color: reply_data["userTitle"]
                                                    .toString() ==
                                                "成电校友"
                                            ? Color(0xFF0092FF)
                                            : reply_data["userTitle"]
                                                        .toString()
                                                        .length <
                                                    7
                                                ? Color(0xFFFE6F61)
                                                : (reply_data["poststick"] == 1
                                                    ? os_white
                                                    : Color(0xFF0092FF)),
                                        color_opa: reply_data["userTitle"]
                                                    .toString() ==
                                                "成电校友"
                                            ? Color(0x100092FF)
                                            : reply_data["userTitle"]
                                                        .toString()
                                                        .length <
                                                    7
                                                ? Color(0x10FE6F61)
                                                : (reply_data["poststick"] == 1
                                                    ? os_wonderful_color[3]
                                                    : Color(0x100092FF)),
                                      ),
                                Container(width: 5),
                                reply_data["reply_id"] == widget.host_id &&
                                        reply_data["reply_name"] != "匿名"
                                    ? Opacity(
                                        opacity: Provider.of<ColorProvider>(
                                                    context,
                                                    listen: false)
                                                .isDark
                                            ? 0.8
                                            : 1,
                                        child: Tag(
                                          txt: "楼主",
                                          color: os_white,
                                          color_opa: Color(0xFF2EA6FF),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          !isquote
                              ? Transform.translate(
                                  offset: Offset(0, -2),
                                  child: Row(
                                    children: [
                                      myInkWell(
                                        tap: () {
                                          _tapLike(reply_data);
                                        },
                                        color: Colors.transparent,
                                        widget: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 2,
                                            horizontal: 5,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(top: 4),
                                                child: Text(
                                                  reply_data["extraPanel"][0]
                                                              ["extParams"]
                                                          ["recommendAdd"]
                                                      .toString(),
                                                  style: XSTextStyle(
                                                    listenProvider: false,
                                                    context: context,
                                                    fontSize: 12,
                                                    color: liked == 1
                                                        ? os_color
                                                        : Color(0xFFB1B1B1),
                                                  ),
                                                ),
                                              ),
                                              Container(width: 3),
                                              os_svg(
                                                path: liked == 1
                                                    ? "lib/img/detail_like_blue.svg"
                                                    : "lib/img/detail_like.svg",
                                                width: 24,
                                                height: 24,
                                              ),
                                            ],
                                          ),
                                        ),
                                        radius: 7.5,
                                      ),
                                      myInkWell(
                                        tap: () {
                                          _showMore();
                                        },
                                        color: Colors.transparent,
                                        widget: Container(
                                          padding: EdgeInsets.all(5),
                                          child: os_svg(
                                            path:
                                                "lib/img/detail_comment_more.svg",
                                            width: 17,
                                            height: 17,
                                          ),
                                        ),
                                        radius: 7.5,
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 3, 0, 10),
                        width: MediaQuery.of(context).size.width -
                            (MediaQuery.of(context).size.width > BigWidthScreen
                                ? (MediaQuery.of(context).size.width -
                                    BigWidthScreen)
                                : 0) -
                            75,
                        child: Text(
                          RelativeDateFormat.format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(reply_data["posts_date"])),
                              ) +
                              " · " +
                              (reply_data["mobileSign"] == ""
                                  ? "网页版"
                                  : (reply_data["mobileSign"]
                                          .toString()
                                          .contains("安卓")
                                      ? "安卓客户端"
                                      : (reply_data["mobileSign"]
                                              .toString()
                                              .contains("苹果")
                                          ? "iPhone客户端"
                                          : reply_data["mobileSign"]))) +
                              " · #${reply_data['position']!}楼",
                          style: XSTextStyle(
                            listenProvider: false,
                            context: context,
                            color: Color(0xFF9F9F9F),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      reply_data["quote_content"] != ""
                          ? Transform.translate(
                              offset: Offset(-7, 0),
                              child: Container(
                                child: myInkWell(
                                  color: Colors.transparent,
                                  tap: () {
                                    List<Widget> listwidgt = [];
                                    var inside_quote_content_all =
                                        reply_data["quote_content_all"];
                                    Widget quote_padding = _buildPureCont(
                                      inside_quote_content_all,
                                      true,
                                    );
                                    listwidgt.add(quote_padding);

                                    //高度是bbb Padding的高度
                                    showPopWithHeight2(
                                      context,
                                      [
                                        Container(height: 15),
                                        ...listwidgt,
                                        Container(height: 15),
                                      ],
                                      MediaQuery.of(context).size.height * 0.5,
                                    );
                                  },
                                  radius: 0,
                                  widget: Container(
                                    width: MediaQuery.of(context).size.width -
                                        (MediaQuery.of(context).size.width >
                                                BigWidthScreen
                                            ? (MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                BigWidthScreen)
                                            : 0) -
                                        75,
                                    padding:
                                        EdgeInsets.fromLTRB(15, 13, 15, 13),
                                    margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                      color: Provider.of<ColorProvider>(context,
                                                  listen: false)
                                              .isDark
                                          ? Color(0x11FFFFFF)
                                          : Color(0x09000000),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(13)),
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                          style: XSTextStyle(
                                              listenProvider: false,
                                              context: context,
                                              fontSize: 14),
                                          children: [
                                            TextSpan(
                                              text: "回复@" +
                                                  reply_data[
                                                      "quote_user_name"] +
                                                  ":",
                                              style: XSTextStyle(
                                                listenProvider: false,
                                                context: context,
                                                color:
                                                    Provider.of<ColorProvider>(
                                                                context,
                                                                listen: false)
                                                            .isDark
                                                        ? Color(0xFF64BDFF)
                                                        : os_color,
                                              ),
                                            ),
                                            TextSpan(
                                              text: reply_data["quote_content"],
                                              style: XSTextStyle(
                                                  listenProvider: false,
                                                  context: context,
                                                  color:
                                                      Provider.of<ColorProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .isDark
                                                          ? os_dark_white
                                                          : Color(0xFF464646)),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      _getBlack()
                          ? _buildContBody([
                              {"infor": "此回复已被你屏蔽", "type": 0}
                            ])
                          : Container(
                              width: MediaQuery.of(context).size.width -
                                  (MediaQuery.of(context).size.width >
                                          BigWidthScreen
                                      ? (MediaQuery.of(context).size.width -
                                          BigWidthScreen)
                                      : 0) -
                                  75,
                              child:
                                  _buildContBody(reply_data["reply_content"])),
                      widget.is_last
                          ? Container(
                              margin: EdgeInsets.only(top: 20),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width -
                                  (MediaQuery.of(context).size.width >
                                          BigWidthScreen
                                      ? (MediaQuery.of(context).size.width -
                                          BigWidthScreen)
                                      : 0) -
                                  75,
                              height: 1,
                              margin: EdgeInsets.only(top: 20),
                              color: Color(0x00000000),
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
          reply_data["extraPanel"][0]["extParams"]["recommendAdd"] < 5
              ? Container()
              : Positioned(
                  right: 4,
                  top: 40,
                  child: Icon(
                    Icons.thumb_up,
                    size: 50,
                    color: Provider.of<ColorProvider>(context, listen: false)
                            .isDark
                        ? Color(0x22FFFFFF)
                        : Color(0x11FF0000),
                  ),
                ),
        ],
      ),
    );
  }

  _tap() {
    widget.tap!(widget.data["reply_posts_id"], widget.data["reply_name"]);
  }

  _longPress() {
    _showMore();
  }

  @override
  Widget build(BuildContext context) {
    return isDesktop()
        ? myInkWell(
            longPress: () => _longPress(),
            tap: () => _tap(),
            color: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            widget: _buildPureCont(widget.data, false),
            radius: 0,
          )
        : myInkWell(
            longPress: () => _longPress(),
            tap: () => _tap(),
            color: Colors.transparent,
            widget: _buildPureCont(widget.data, false),
            radius: 0,
          );
  }
}
