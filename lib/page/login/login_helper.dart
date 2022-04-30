import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/components/niw.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginHelper extends StatefulWidget {
  LoginHelper({Key key}) : super(key: key);

  @override
  _LoginHelperState createState() => _LoginHelperState();
}

class _LoginHelperState extends State<LoginHelper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: os_white,
        foregroundColor: os_black,
        title: Text(
          "登录帮助",
          style: TextStyle(fontWeight: FontWeight.w100),
        ),
        elevation: 0,
      ),
      backgroundColor: os_white,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: os_edge * 2,
          vertical: os_edge,
        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Title(txt: "密码找回"),
            Tip(txt: "若不慎忘记密码，请使用密码重置功能通过注册时关联的学号以及对应的信息门户密码重置密码。"),
            Link(
              txt:
                  "https://bbs.uestc.edu.cn/plugin.php?id=rnreg:resetpassword&mobile=no",
            ),
            Title(txt: "账号注册"),
            Tip(
              txt:
                  "你拥有的清水河畔账号是永久有效的，一个学号最多可以注册三个id。请点击下面的链接在浏览器中打开进行注册，其中带红色*号的为必填。根据相关要求，高校论坛需要进行学号验证，请使用信息门户学号、密码进行验证。如果提示你的学号激活失败，可能你的学号未曾在信息门户登陆过，请看下一步进行修改默认密码。",
            ),
            Link(
              txt: "http://bbs.uestc.edu.cn/member.php?mod=register&mobile=no",
            ),
            Title(txt: "外网访问"),
            Tip(txt: "可以用校园VPN访问校园网。"),
            Link(txt: "https://vpn.uestc.edu.cn/"),
            Container(height: 200),
          ],
        ),
      ),
    );
  }
}

class Link extends StatefulWidget {
  String txt;
  Link({
    Key key,
    this.txt,
  }) : super(key: key);

  @override
  State<Link> createState() => _LinkState();
}

class _LinkState extends State<Link> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              myInkWell(
                tap: () {
                  showModal(
                    context: context,
                    title: "请确认",
                    cont: "即将调用外部浏览器打开此链接，河畔App不保证此链接的安全性",
                    confirmTxt: "立即前往",
                    cancelTxt: "取消",
                    confirm: () {
                      launch(widget.txt);
                    },
                  );
                },
                color: Color.fromRGBO(0, 146, 255, 0.05),
                radius: 5,
                widget: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.5, vertical: 10),
                  width: MediaQuery.of(context).size.width - 4 * os_edge,
                  decoration: BoxDecoration(),
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width -
                            4 * os_edge -
                            50,
                        child: Text(
                          widget.txt ?? "标题",
                          style: TextStyle(color: os_color),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_outlined,
                        size: 16,
                        color: os_color,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Tip extends StatefulWidget {
  String txt;
  Tip({
    Key key,
    this.txt,
  }) : super(key: key);

  @override
  State<Tip> createState() => _TipState();
}

class _TipState extends State<Tip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Text(
        widget.txt ?? "标题",
        style: TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }
}

class Title extends StatefulWidget {
  String txt;
  Title({
    Key key,
    this.txt,
  }) : super(key: key);

  @override
  State<Title> createState() => _TitleState();
}

class _TitleState extends State<Title> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, top: 10),
      child: Text(
        widget.txt ?? "标题",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}