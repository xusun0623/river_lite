import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/saveImg.dart';
import 'package:offer_show/asset/time.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/outer/cached_network_image/cached_image_widget.dart';
import 'package:offer_show/outer/showActionSheet/action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_sheet.dart';
import 'package:offer_show/page/photo_view/photo_view.dart';
import 'package:offer_show/util/interface.dart';
import 'package:url_launcher/url_launcher.dart';

Color theme = Color(0xFF4577f6);

class MsgDetail extends StatefulWidget {
  Map usrInfo;
  MsgDetail({
    Key key,
    this.usrInfo,
  }) : super(key: key);

  @override
  MsgDetailState createState() => MsgDetailState();
}

class MsgDetailState extends State<MsgDetail> {
  Map userInfo = {};
  List pmList = [];
  ScrollController _controller = new ScrollController();
  bool vibrate = false;

  _getCont() async {
    var data = await Api().message_pmlist({
      "pmlist": {
        "body": {
          "externInfo": {"onlyFromUid": 0},
          "pmInfos": [
            {
              "startTime": 0,
              "cacheCount": 20,
              "stopTime": 0,
              "fromUid": widget.usrInfo["uid"],
              "pmLimit": 20
            }
          ]
        }
      }.toString()
    });
    if (data != null &&
        data["body"] != null &&
        data["body"]["userInfo"] != null &&
        data["body"]["pmList"] != null) {
      setState(() {
        userInfo = data["body"]["userInfo"];
        pmList = data["body"]["pmList"];
      });
    } else {
      userInfo = {};
      pmList = [];
    }
  }

  _getMore() async {
    List msgList = pmList[0]["msgList"];
    if (msgList.length % 20 != 0) return;
    var data = await Api().message_pmlist({
      "pmlist": {
        "body": {
          "externInfo": {"onlyFromUid": 0},
          "pmInfos": [
            {
              "startTime": 0,
              "cacheCount": 20,
              "stopTime": msgList[msgList.length - 1]["time"],
              "fromUid": widget.usrInfo["uid"],
              "pmLimit": 20
            }
          ]
        }
      }.toString()
    });
    if (data != null &&
        data["body"] != null &&
        data["body"]["userInfo"] != null &&
        data["body"]["pmList"] != null) {
      data["body"]["pmList"][0]["msgList"].addAll(pmList[0]["msgList"]);
      setState(() {
        pmList[0]["msgList"] = data["body"]["pmList"][0]["msgList"];
      });
      // setState(() {
      //   pmList[0]["msgList"].addAll(data["body"]["pmList"][0]["msgList"]);
      // });
    }
  }

  List<Widget> _buildCont() {
    List<Widget> tmp = [];
    if (pmList.length != 0) {
      List msgList = pmList[0]["msgList"];
      msgList = msgList.reversed.toList();
      msgList.forEach((element) {
        tmp.add(MsgCont(
          fromInfo: {
            "fromUid": pmList[0]["fromUid"],
            "name": pmList[0]["name"],
            "avatar": pmList[0]["avatar"],
          },
          myInfo: {
            "fromUid": userInfo["uid"],
            "name": userInfo["name"],
            "avatar": userInfo["avatar"],
          },
          msg: element,
        ));
      });
    }
    if (tmp.length % 20 == 0 && pmList.length != 0) {
      tmp.add(Center(
        child: Container(
          width: 160,
          height: 36,
          margin: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            // color: Color.fromRGBO(69, 119, 246, 0.1),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                vibrate
                    ? Container()
                    : Icon(
                        Icons.arrow_downward_rounded,
                        color: theme,
                        size: 32,
                      ),
              ],
            ),
          ),
        ),
      ));
    }
    return tmp;
  }

  @override
  void initState() {
    _getCont();
    _controller.addListener(() {
      if (_controller.position.pixels - _controller.position.maxScrollExtent >
          100) {
        if (!vibrate) {
          vibrate = true; //不允许再震动
          Vibrate.feedback(FeedbackType.impact);
        }
      }
      if (_controller.position.pixels - _controller.position.maxScrollExtent <=
          0) {
        vibrate = false; //允许震动
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: os_white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: os_white,
        foregroundColor: os_black,
        elevation: 0,
        leading: BackButton(),
        centerTitle: true,
        actions: [
          LookRoom(uid: widget.usrInfo["uid"]),
          Container(width: 15),
        ],
        title: DetailHead(
          uid: widget.usrInfo["uid"],
          name: widget.usrInfo["name"],
        ),
      ),
      body: RefreshIndicator(
        color: theme,
        onRefresh: () async {
          await _getMore();
          return;
        },
        child: ListView(
          physics: BouncingScrollPhysics(),
          controller: _controller,
          shrinkWrap: true,
          reverse: true,
          children: _buildCont(),
        ),
      ),
    );
  }
}

class MsgCont extends StatefulWidget {
  Map fromInfo;
  Map myInfo;
  Map msg;
  MsgCont({
    Key key,
    this.fromInfo,
    this.myInfo,
    this.msg,
  }) : super(key: key);

  @override
  State<MsgCont> createState() => _MsgContState();
}

class _MsgContState extends State<MsgCont> {
  @override
  Widget build(BuildContext context) {
    return widget.fromInfo["fromUid"] == widget.msg["sender"]
        ? MsgContBodyWidget(
            index: 0,
            isImage: widget.msg["type"] == "image",
            cont: widget.msg["content"],
            avatar: widget.fromInfo["avatar"],
            time: int.parse(widget.msg["time"]),
          )
        : MsgContBodyWidget(
            index: 1,
            isImage: widget.msg["type"] == "image",
            cont: widget.msg["content"],
            avatar: widget.myInfo["avatar"],
            time: int.parse(widget.msg["time"]),
          );
  }
}

class MsgContBodyWidget extends StatefulWidget {
  int index;
  String cont;
  String avatar;
  int time;
  bool isImage;
  MsgContBodyWidget({
    Key key,
    this.index, //0-他 1-我
    this.cont,
    this.avatar,
    this.time,
    this.isImage,
  }) : super(key: key);

  @override
  State<MsgContBodyWidget> createState() => _MsgContBodyWidgetState();
}

class _MsgContBodyWidgetState extends State<MsgContBodyWidget> {
  List<InlineSpan> _getRichText(String t) {
    List<InlineSpan> ret = [];
    t = t.replaceAll("&nbsp;", " ");
    List<String> tmp = t.split("[mobcent_phiz=");
    ret.add(TextSpan(text: tmp[0]));
    for (var i = 1; i < tmp.length; i++) {
      var first_idx = tmp[i].indexOf(']');
      ret.add(WidgetSpan(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CachedNetworkImage(
            placeholder: (context, url) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: os_grey,
              ),
            ),
            imageUrl: tmp[i].substring(0, first_idx),
          ),
        ),
      ));
      ret.add(TextSpan(text: tmp[i].substring(first_idx + 1)));
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    Widget txt = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        myInkWell(
            longPress: () {
              if (widget.isImage) {
                saveImge(context, [widget.cont], 0);
              } else {
                Vibrate.feedback(FeedbackType.impact);
                showActionSheet(
                    context: context,
                    actions: [
                      ActionItem(
                          title: "复制文本",
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: widget.cont));
                            Navigator.pop(context);
                            showToast(
                              context: context,
                              type: XSToast.success,
                              txt: widget.isImage ? "复制链接成功" : "复制文本成功",
                            );
                          })
                    ],
                    bottomActionItem: BottomActionItem(title: "取消"));
              }
            },
            color: widget.index == 0 ? Color(0xFFEEEEEE) : Color(0xFF3179FF),
            splashColor:
                widget.index == 0 ? Color(0x44707070) : Color(0x44002873),
            highlightColor:
                widget.index == 0 ? Color(0x88C8C8C8) : Color(0x88135CE2),
            radius: 10,
            widget: widget.isImage ?? false
                ? Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 130,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PhotoPreview(
                                  galleryItems: [widget.cont],
                                  defaultImage: 0,
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: os_grey,
                                ),
                              ),
                              imageUrl: widget.cont,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2.5),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 0.20),
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                          ),
                          child: Text(
                            RelativeDateFormat.format(
                              DateTime.fromMillisecondsSinceEpoch(widget.time),
                            ),
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 0.9),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 130,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 3),
                            child: Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.6,
                                  color:
                                      widget.index == 0 ? os_black : os_white,
                                ),
                                children: _getRichText(widget.cont),
                              ),
                            ),
                          ),
                          // Container(height: 5),
                          Text(
                            RelativeDateFormat.format(
                              DateTime.fromMillisecondsSinceEpoch(widget.time),
                            ),
                            style: TextStyle(
                              color: widget.index == 0
                                  ? Color.fromRGBO(0, 0, 0, 0.3)
                                  : Color.fromRGBO(255, 255, 255, 0.6),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
      ],
    );
    Widget avatar = ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(100)),
      child: CachedNetworkImage(
        placeholder: (context, url) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: os_grey,
          ),
        ),
        imageUrl: widget.avatar,
        width: 36,
        height: 36,
      ),
    );
    Widget space = Container(width: 10);
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: widget.index == 0
              ? MainAxisAlignment.start
              : MainAxisAlignment.end,
          children:
              widget.index == 0 ? [avatar, space, txt] : [txt, space, avatar],
        ));
  }
}

class MsgImg extends StatefulWidget {
  String url;
  MsgImg({
    Key key,
    this.url,
  }) : super(key: key);

  @override
  State<MsgImg> createState() => _MsgImgState();
}

class _MsgImgState extends State<MsgImg> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(imageUrl: widget.url);
  }
}

class LookRoom extends StatefulWidget {
  int uid;
  LookRoom({Key key, this.uid}) : super(key: key);

  @override
  State<LookRoom> createState() => _LookRoomState();
}

class _LookRoomState extends State<LookRoom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: myInkWell(
        tap: () {
          print("前往个人空间，uid是${widget.uid ?? 0}");
          // Navigator.pushNamed(context, "/search", arguments: widget.uid ?? 0);
        },
        color: Color(0xFFEEEEEE),
        widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.5),
          child: Center(child: Text("查看空间")),
        ),
        radius: 100,
      ),
    );
  }
}

class DetailHead extends StatefulWidget {
  int uid;
  String name;
  DetailHead({
    Key key,
    this.uid,
    this.name,
  }) : super(key: key);

  @override
  State<DetailHead> createState() => _DetailHeadState();
}

class _DetailHeadState extends State<DetailHead> {
  Map data = {};
  _getStatus() async {
    var tmp = await Api().user_userinfo({
      "userId": widget.uid,
    });
    setState(() {
      data = tmp;
    });
  }

  @override
  void initState() {
    _getStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 7.5,
              height: 7.5,
              decoration: BoxDecoration(
                color: data["rs"] == null
                    ? Color.fromARGB(255, 186, 186, 186)
                    : (data["status"] == 0
                        ? Color.fromARGB(255, 186, 186, 186)
                        : Color(0xFF1AE316)),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            Container(width: 5),
            Text(
              data["rs"] == null
                  ? "该用户当前网页不在线"
                  : (data["status"] == 0 ? "该用户当前网页不在线" : "该用户当前在线"),
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFADADAD),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BackButton extends StatelessWidget {
  const BackButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.chevron_left_rounded, color: os_black),
    );
  }
}
