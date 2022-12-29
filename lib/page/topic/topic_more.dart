import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/black.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/myinfo.dart';
import 'package:offer_show/asset/showActionSheet.dart';
import 'package:offer_show/asset/showPop.dart';
import 'package:offer_show/asset/toWebUrl.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/outer/showActionSheet/action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_sheet.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/page/topic/topic_water.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class TopicDetailMore extends StatefulWidget {
  Map data;
  Function block;
  Function alterSend;
  TopicDetailMore({
    Key key,
    this.data,
    this.block,
    this.alterSend,
  }) : super(key: key);

  @override
  State<TopicDetailMore> createState() => _TopicDetailMoreState();
}

class _TopicDetailMoreState extends State<TopicDetailMore> {
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
        style: TextStyle(
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
            onChanged: (e) {
              txt = e;
            },
            style: TextStyle(
              color: Provider.of<ColorProvider>(context, listen: false).isDark
                  ? os_dark_white
                  : os_black,
            ),
            cursorColor: os_deep_blue,
            decoration: InputDecoration(
                hintText: "请输入",
                border: InputBorder.none,
                hintStyle: TextStyle(
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
                    style: TextStyle(
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
                  "idType": "thread",
                  "message": txt,
                  "id": widget.data["topic"]["topic_id"]
                });
                Navigator.pop(context);
                _feedbackSuccess();
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
    ]);
  }

  _toWaterColumn() async {
    //widget.alterSend();
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
        return ToWaterTip(
          confirm: () {
            widget.alterSend();
          },
        );
      },
    );
  }

  _showQrCode() async {
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
        return QrCode(
          url:
              "https://bbs.uestc.edu.cn/forum.php?mod=viewthread&tid=${widget.data["topic"]["topic_id"]}",
        );
      },
    );
  }

  _tapMore() async {
    showAction(
      context: context,
      options: [
        "展示二维码",
        "复制帖子链接",
        "举报反馈",
        "屏蔽此贴",
        ...(widget.data["topic"]["user_id"] == await getUid() ? ["编辑帖子"] : []),
        ...(widget.data["forumName"] == "水手之家" ? ["转帖到水区"] : []),
      ],
      icons: [
        Icons.qr_code,
        Icons.copy,
        Icons.feedback_outlined,
        Icons.block,
        ...(widget.data["topic"]["user_id"] == await getUid()
            ? [Icons.edit]
            : []),
        ...(widget.data["forumName"] == "水手之家"
            ? [Icons.move_down_rounded]
            : []),
      ],
      tap: (res) async {
        if (res == 0) {
          Navigator.pop(context);
          _showQrCode();
        }
        if (res == 1) {
          Clipboard.setData(
            ClipboardData(
              text: base_url +
                  "forum.php?mod=viewthread&tid=" +
                  widget.data["topic"]["topic_id"].toString(),
            ),
          );
          Navigator.pop(context);
          showToast(
            context: context,
            type: XSToast.success,
            txt: "复制成功！",
          );
        }
        if (res == 2) {
          Navigator.pop(context);
          _feedback();
        }
        if (res == 3) {
          Navigator.pop(context);
          setBlackWord(widget.data["topic"]["title"], context);
          widget.block();
        }
        if (res == 4) {
          if (widget.data["topic"]["user_id"] == await getUid()) {
            Navigator.pop(context);
            Navigator.pushNamed(context, "/topic_edit", arguments: {
              "tid": widget.data["topic"]["topic_id"],
              "pid": int.parse(widget.data["topic"]["extraPanel"][0]["action"]
                  .toString()
                  .split("&pid=")[1]
                  .split("&")[0]),
            });
          } else {
            Navigator.pop(context);
            _toWaterColumn();
          }
        }
        if (res == 5) {
          Navigator.pop(context);
          _toWaterColumn();
        }
      },
    );
  }

  Widget _buildIcon(IconData i) {
    //适配不同深色模式的icon
    return Icon(
      i,
      size: 20,
      color: Provider.of<ColorProvider>(context).isDark
          ? os_dark_white
          : Colors.black54,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isMacOS()
            ? IconButton(
                onPressed: () {
                  _showQrCode();
                },
                tooltip: "分享到手机",
                icon: _buildIcon(Icons.qr_code),
              )
            : Container(),
        isMacOS()
            ? IconButton(
                onPressed: () {
                  xsLanuch(
                    url: base_url +
                        "forum.php?mod=viewthread&tid=" +
                        widget.data["topic"]["topic_id"].toString(),
                    isExtern: true,
                  );
                },
                tooltip: "在浏览器中打开",
                icon: _buildIcon(Icons.explore_outlined),
              )
            : Container(),
        IconButton(
          onPressed: () {
            _tapMore();
          },
          icon: _buildIcon(Icons.more_horiz_rounded),
        ),
        Container(width: 5),
      ],
    );
  }
}

class QrCode extends StatefulWidget {
  String url;
  QrCode({
    Key key,
    this.url,
  }) : super(key: key);

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  getBriefId() {
    if (widget.url
        .contains("https://bbs.uestc.edu.cn/forum.php?mod=viewthread&tid=")) {
      return "t${widget.url.split("https://bbs.uestc.edu.cn/forum.php?mod=viewthread&tid=")[1].split("&")[0]}";
    } else if (widget.url
        .contains("https://bbs.uestc.edu.cn/home.php?mod=space&uid=")) {
      return "u${widget.url.split("https://bbs.uestc.edu.cn/home.php?mod=space&uid=")[1].split("&")[0]}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      child: Column(
        children: [
          Container(height: 30),
          //https://bbs.uestc.edu.cn/forum.php?mod=viewthread&tid=1951303
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: SelectableText(
              "请扫码或在河畔Lite App搜索框输入${getBriefId()}在手机上查看",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_dark_white
                    : os_black,
              ),
            ),
          ),
          Container(height: 20),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: os_white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            // padding: EdgeInsets.all(5),
            child: QrImage(
              data: widget.url ?? "https://bbs.uestc.edu.cn",
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
          Container(height: 30),
          Bounce(
            infinite: true,
            from: 30,
            child: Container(
              child: Icon(
                Icons.arrow_upward,
                size: 30,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_dark_white
                    : os_black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
