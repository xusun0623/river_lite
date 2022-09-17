import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/vibrate.dart';
import 'package:offer_show/components/loading.dart';
import 'package:offer_show/components/newNaviBar.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class PersonDetail extends StatefulWidget {
  var uid;
  PersonDetail({
    Key key,
    this.uid,
  }) : super(key: key);

  @override
  _PersonDetailState createState() => _PersonDetailState();
}

class _PersonDetailState extends State<PersonDetail> {
  Map data;
  String online_time = "";
  String last_come = "";
  String sign_time = "";
  String last_ip = "";
  String sign_ip = "";
  String come_count = "";
  _getData() async {
    data = await Api().user_userinfo({
      "userId": widget.uid,
    });
    _getUltraData();
  }

  _getUltraData() async {
    String html = (await XHttp().pureHttpWithCookie(
      url: base_url + "home.php?mod=space&uid=${widget.uid}&do=profile",
    ))
        .data
        .toString();
    try {
      online_time = html.split("在线时间</em>")[1].split("</li><li><em>")[0];
      last_come = html.split("上次活动时间</em>")[1].split("</li><li><em>")[0];
      sign_time = html.split("注册时间</em>")[1].split("</li>")[0];
      last_ip = html.split("上次访问 IP</em>").length == 1
          ? ""
          : html.split("上次访问 IP</em>")[1].split("</li>")[0];
      sign_ip = html.split("注册 IP</em>").length == 1
          ? ""
          : html.split("注册 IP</em>")[1].split("</li>")[0];
      come_count = html
          .split("空间访问量</em><strong class=")[1]
          .split("</strong></li>")[0]
          .split(">")[1];
    } catch (e) {}
    setState(() {});
  }

  List<Widget> _buildList() {
    List<Widget> tmp = [];
    List<List<String>> txt = [
      ["UID", "${widget.uid}"],
      ["用户状态", data["status"] == 2 ? "在线" : "离线"],
      ["性别", data["gender"] == 1 ? "男" : (data["gender"] == 2 ? "女" : "未知")],
      ["积分", "${data["score"]}"],
      ["用户头衔", "${data["userTitle"]}"],
      ["在线时间", "${online_time}"],
      ["上次访问", "${last_come}"],
      ["注册时间", "${sign_time}"],
      ["空间访问量", "${come_count}"],
      ["上次访问IP", "${last_ip}"],
      ["注册IP", "${sign_ip}"],
    ];
    for (int i = 0; i < txt.length; i++) {
      tmp.add(DetailListTitle(
        left: txt[i][0],
        right: txt[i][1],
      ));
    }
    return tmp;
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Baaaar(
      color:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.chevron_left_rounded),
          ),
          centerTitle: true,
          title: Text(
            "用户详情",
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : os_back,
          foregroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_white
              : os_black,
        ),
        backgroundColor:
            Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
        body: data == null
            ? Loading(
                backgroundColor: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_back
                    : os_back,
              )
            : Container(
                margin: EdgeInsets.only(
                  left: 12.5,
                  right: 12.5,
                  top: 10,
                  bottom: 10,
                ),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_light_dark_card
                      : os_white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                      offset: Offset(2, 2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: _buildList(),
                ),
              ),
      ),
    );
  }
}

class DetailListTitle extends StatefulWidget {
  String left;
  String right;
  DetailListTitle({
    Key key,
    this.left,
    this.right,
  }) : super(key: key);

  @override
  State<DetailListTitle> createState() => _DetailListTitleState();
}

class _DetailListTitleState extends State<DetailListTitle> {
  @override
  Widget build(BuildContext context) {
    return widget.right == ""
        ? Container()
        : ListTile(
            onLongPress: widget.left != "UID"
                ? null
                : () {
                    XSVibrate();
                    Clipboard.setData(ClipboardData(text: widget.right));
                    showToast(
                        context: context, type: XSToast.success, txt: "复制成功");
                  },
            textColor: Provider.of<ColorProvider>(context).isDark
                ? os_dark_white
                : os_black,
            title: Text(
              "${widget.left}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            trailing: Container(
              width: MediaQuery.of(context).size.width - 170,
              child: Text(
                "${widget.right}",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_white
                      : os_dark_back,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
  }
}
