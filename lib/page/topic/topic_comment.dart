import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/myinfo.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/time.dart';
import 'package:offer_show/asset/to_user.dart';
import 'package:offer_show/asset/topic_formhash.dart';
import 'package:offer_show/asset/vibrate.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/outer/cached_network_image/cached_image_widget.dart';
import 'package:offer_show/outer/showActionSheet/action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_sheet.dart';
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
  Function add_1;
  int index;
  Function tap;
  Function fresh;

  Comment(
      {Key key,
      this.data,
      this.is_last,
      this.topic_id,
      this.fid,
      this.host_id,
      this.tap,
      this.add_1,
      this.fresh,
      this.index})
      : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  var liked = 0;
  bool is_me = false;

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

  void _tapLike() async {
    if (liked == 1) return;
    liked = 1;
    widget.data["extraPanel"][0]["extParams"]["recommendAdd"]++;
    setState(() {});
    await Api().forum_support({
      "tid": widget.topic_id,
      "pid": widget.data["reply_posts_id"],
      "type": "post",
      "action": "support",
    });
    String tmp = await getStorage(
      key: "comment_like",
    );
    tmp += ",${widget.data["reply_posts_id"]}";
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
      if (imgLists.length > 2 &&
          e["type"] == 1 &&
          i < data.length - 1 &&
          data[i + 1]["type"] == 1) {
        List<Widget> renderImg = [];
        while (e["type"] == 1 && i + img_count < data.length && true) {
          renderImg.add(DetailCont(
            data: data[i + img_count],
            imgLists: imgLists,
            isComment: true,
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
          ),
        ));
      }
    }
    return Column(children: tmp);
  }

  void stickyForm() async {
    showToast(context: context, type: XSToast.loading, txt: "请稍后…");
    String formhash = await getTopicFormHash(widget.topic_id);
    String fid = widget.fid.toString();
    String tid = widget.topic_id.toString();
    String page = ((widget.index / 20) + 1).toString();
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
      Navigator.pop(context);
      showToast(context: context, type: XSToast.success, txt: "操作成功");
      widget.fresh();
    } else {
      print(response.reasonPhrase);
    }
  }

  void _showMore() async {
    XSVibrate();
    List<ActionItem> _buildAction() {
      List<ActionItem> tmp = [];
      String copy_txt = "";
      widget.data["reply_content"].forEach((e) {
        if (e["type"] == 0) {
          copy_txt += e["infor"].toString();
        }
      });
      tmp.add(
        ActionItem(
            title: "复制文本内容",
            onPressed: () {
              Clipboard.setData(
                ClipboardData(text: copy_txt),
              );
              Navigator.pop(context);
              showToast(context: context, type: XSToast.success, txt: "复制成功！");
            }),
      );
      // tmp.add(
      //   ActionItem(
      //       title: "回复+1",
      //       onPressed: () {
      //         if (widget.add_1 != null) widget.add_1();
      //       }),
      // );
      if (is_me)
        tmp.add(ActionItem(
          title: widget.data["poststick"] == 1 ? "取消置顶评论" : "置顶评论",
          onPressed: () {
            stickyForm();
          },
        ));
      return tmp;
    }

    showActionSheet(
      context: context,
      actions: _buildAction(),
      bottomActionItem: BottomActionItem(title: "取消"),
    );
  }

  _getIsMeTopic() async {
    //该帖子是不是这个用户的，用户方便用户置顶他人/自己评论
    int uid = await getUid();
    setState(() {
      is_me = widget.host_id == uid;
    });
  }

  @override
  void initState() {
    super.initState();
    _getIsMeTopic();
    _getLikedStatus();
  }

  _buildPureCont() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
      child: Stack(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.data["reply_name"] != "匿名")
                      toUserSpace(
                        context,
                        int.parse(widget.data["icon"]
                            .toString()
                            .split("uid=")[1]
                            .split("&size=")[0]),
                      );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    child: Opacity(
                      opacity:
                          Provider.of<ColorProvider>(context).isDark ? 0.8 : 1,
                      child: CachedNetworkImage(
                        imageUrl: widget.data["icon"],
                        placeholder: (context, url) => Container(
                          color: Provider.of<ColorProvider>(context).isDark
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
                Container(
                  width: MediaQuery.of(context).size.width -
                      (MediaQuery.of(context).size.width > BigWidthScreen
                          ? (MediaQuery.of(context).size.width - BigWidthScreen)
                          : 0) -
                      75,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.data["reply_name"],
                                style: TextStyle(
                                  color:
                                      Provider.of<ColorProvider>(context).isDark
                                          ? os_dark_white
                                          : Color(0xFF333333),
                                  fontWeight:
                                      Provider.of<ColorProvider>(context).isDark
                                          ? FontWeight.normal
                                          : FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Container(width: 8),
                              widget.data["userTitle"] == null ||
                                      widget.data["userTitle"].length == 0
                                  ? Container()
                                  : Tag(
                                      txt: widget.data["poststick"] == 1
                                          ? "置顶"
                                          : "" + widget.data["userTitle"],
                                      color: widget.data["userTitle"]
                                                  .toString()
                                                  .length <
                                              7
                                          ? Color(0xFFFE6F61)
                                          : (widget.data["poststick"] == 1
                                              ? os_white
                                              : Color(0xFF0092FF)),
                                      color_opa: widget.data["userTitle"]
                                                  .toString()
                                                  .length <
                                              7
                                          ? Color(0x10FE6F61)
                                          : (widget.data["poststick"] == 1
                                              ? os_wonderful_color[3]
                                              : Color(0x100092FF)),
                                    ),
                              Container(width: 5),
                              widget.data["reply_id"] == widget.host_id &&
                                      widget.data["reply_name"] != "匿名"
                                  ? Opacity(
                                      opacity:
                                          Provider.of<ColorProvider>(context)
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
                          Row(
                            children: [
                              myInkWell(
                                tap: () {
                                  _tapLike();
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
                                          widget.data["extraPanel"][0]
                                                  ["extParams"]["recommendAdd"]
                                              .toString(),
                                          style: TextStyle(
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
                                    path: "lib/img/detail_comment_more.svg",
                                    width: 17,
                                    height: 17,
                                  ),
                                ),
                                radius: 7.5,
                              )
                            ],
                          ),
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
                                    int.parse(widget.data["posts_date"])),
                              ) +
                              " · " +
                              (widget.data["mobileSign"] == ""
                                  ? "网页版"
                                  : (widget.data["mobileSign"]
                                          .toString()
                                          .contains("安卓")
                                      ? "安卓客户端"
                                      : (widget.data["mobileSign"]
                                              .toString()
                                              .contains("苹果")
                                          ? "iPhone客户端"
                                          : widget.data["mobileSign"]))) +
                              " · #${widget.index + 1}楼",
                          style: TextStyle(
                            color: Color(0xFF9F9F9F),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      widget.data["quote_content"] != ""
                          ? Transform.translate(
                              offset: Offset(-7, 0),
                              child: Container(
                                width: MediaQuery.of(context).size.width -
                                    (MediaQuery.of(context).size.width >
                                            BigWidthScreen
                                        ? (MediaQuery.of(context).size.width -
                                            BigWidthScreen)
                                        : 0) -
                                    75,
                                padding: EdgeInsets.fromLTRB(15, 13, 15, 13),
                                margin: EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  color:
                                      Provider.of<ColorProvider>(context).isDark
                                          ? Color(0x11FFFFFF)
                                          : Color(0x09000000),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(13)),
                                ),
                                child: RichText(
                                  text: TextSpan(
                                      style: TextStyle(fontSize: 14),
                                      children: [
                                        TextSpan(
                                          text: "回复@" +
                                              widget.data["quote_content"]
                                                  .split(" 发表于")[0] +
                                              ": ",
                                          style: TextStyle(
                                            color: Provider.of<ColorProvider>(
                                                        context)
                                                    .isDark
                                                ? Color(0xFF64BDFF)
                                                : os_color,
                                          ),
                                        ),
                                        TextSpan(
                                          text: widget.data["quote_content"]
                                              .split("发表于")[1]
                                              .split("\n")[1],
                                          style: TextStyle(
                                              color: Provider.of<ColorProvider>(
                                                          context)
                                                      .isDark
                                                  ? os_dark_white
                                                  : Color(0xFF464646)),
                                        ),
                                      ]),
                                ),
                              ),
                            )
                          : Container(),
                      _buildContBody(widget.data["reply_content"]),
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
          widget.data["extraPanel"][0]["extParams"]["recommendAdd"] < 5
              ? Container()
              : Positioned(
                  right: 4,
                  top: 40,
                  child: Icon(
                    Icons.thumb_up,
                    size: 50,
                    color: Provider.of<ColorProvider>(context).isDark
                        ? Color(0x22FFFFFF)
                        : Color(0x11FF0000),
                  ),
                ),
        ],
      ),
    );
  }

  _tap() {
    widget.tap(widget.data["reply_posts_id"], widget.data["reply_name"]);
  }

  _longPress() {
    _showMore();
  }

  @override
  Widget build(BuildContext context) {
    return isDesktop()
        ? myInkWell(
            //适配大屏模式
            longPress: () => _longPress(),
            tap: () => _tap(),
            color: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            widget: _buildPureCont(),
            radius: 0,
          )
        : myInkWell(
            longPress: () => _longPress(),
            tap: () => _tap(),
            color: Colors.transparent,
            widget: _buildPureCont(),
            radius: 0,
          );
  }
}
