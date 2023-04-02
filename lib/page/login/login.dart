import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/cookie.dart';
import 'package:offer_show/asset/home_desktop_mode.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/newNaviBar.dart';
import 'package:offer_show/outer/card_swiper/swiper.dart';
import 'package:offer_show/outer/card_swiper/swiper_controller.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  int index;
  Login({
    Key key,
    this.index,
  }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String username;
  String password;

  bool showSuccess = false;
  SwiperController _swiperController = new SwiperController();

  _login() async {
    if (username == "" ||
        password == "" ||
        username == null ||
        password == null) return;
    showToast(context: context, type: XSToast.loading, txt: "加载中…");
    var data = await Api().user_login({
      "type": "login",
      "username": username,
      "password": password,
    });
    hideToast();
    if (data != null) {
      if (data["rs"] == 0) {
        showToast(context: context, type: XSToast.none, txt: data["errcode"]);
      }
      if (data["rs"] == 1) {
        await getWebCookie(username: username, password: password);
        setStorage(key: "myinfo", value: jsonEncode(data));
        UserInfoProvider provider =
            Provider.of<UserInfoProvider>(context, listen: false);
        provider.data = data;
        provider.refresh();
        String quick_txt = await getStorage(key: "quick", initData: "[]");
        List quick_tmp = jsonDecode(quick_txt);
        bool isExist = false;
        quick_tmp.forEach(((element) {
          if (element["name"] == username) {
            isExist = true;
          }
        }));
        if (!isExist) {
          quick_tmp.add({"name": username, "password": password});
        }
        await setStorage(key: "quick", value: jsonEncode(quick_tmp));
        Provider.of<MsgProvider>(context, listen: false).getMsg();
        setState(() {
          showSuccess = true;
        });
      }
    }
  }

  @override
  void initState() {
    _swiperController.index = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode u_focus = new FocusNode();
    FocusNode p_focus = new FocusNode();

    return Baaaar(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_back
              : os_white,
          foregroundColor: Provider.of<ColorProvider>(context).isDark
              ? os_dark_white
              : os_black,
          elevation: 0,
        ),
        backgroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_back
            : os_white,
        body: showSuccess
            ? Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.done,
                      size: 50,
                      color: Provider.of<ColorProvider>(context).isDark
                          ? os_white
                          : os_deep_blue,
                    ),
                    Container(height: 10),
                    Text(
                      "登录成功",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Provider.of<ColorProvider>(context).isDark
                            ? os_dark_white
                            : os_black,
                      ),
                    ),
                    Container(height: 10),
                    Container(
                      width: 300,
                      child: Text(
                        "你已成功登录清水河畔，请敬请享受来自河畔的体验吧",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Provider.of<ColorProvider>(context).isDark
                              ? os_dark_dark_white
                              : os_black,
                        ),
                      ),
                    ),
                    Container(height: 300),
                    GestureDetector(
                      onTap: () {
                        if (Navigator.canPop(context)) Navigator.pop(context);
                      },
                      child: Container(
                        width: 200,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: Provider.of<ColorProvider>(context).isDark
                              ? os_light_dark_card
                              : Color.fromRGBO(0, 77, 255, 0.1),
                        ),
                        child: Center(
                          child: Text(
                            "确定",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Provider.of<ColorProvider>(context).isDark
                                  ? os_dark_dark_white
                                  : Color.fromRGBO(0, 77, 255, 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(height: 100),
                  ],
                ),
              )
            : Container(
                child: Swiper(
                  itemCount: 2,
                  loop: false,
                  // index: _swiperController.index,
                  controller: _swiperController,
                  itemBuilder: (BuildContext context, int index) {
                    return [
                      ListView(
                        //physics: BouncingScrollPhysics(),
                        children: [
                          LoginHead(),
                          Container(height: 200),
                          ResponsiveWidget(
                            child: LoginSubmit(
                              color: Provider.of<ColorProvider>(context).isDark
                                  ? os_light_dark_card
                                  : Color(0xFF222222),
                              tap: () {
                                _swiperController.next();
                              },
                            ),
                          ),
                          Container(height: 15),
                          ResponsiveWidget(
                            child: LoginSubmit(
                              txt: "注册账号",
                              color: Color.fromRGBO(34, 34, 34, 0.1),
                              fontColor:
                                  Provider.of<ColorProvider>(context).isDark
                                      ? os_dark_dark_white
                                      : os_black,
                              tap: () {
                                launch(
                                    "http://bbs.uestc.edu.cn/member.php?mod=register&mobile=no");
                              },
                            ),
                          ),
                          Container(height: 150),
                        ],
                      ),
                      ListView(
                        //physics: BouncingScrollPhysics(),
                        children: [
                          ResponsiveWidget(
                            child: LoginInput(
                              u_focus: u_focus,
                              p_focus: p_focus,
                              change: (uname, pword) {
                                username = uname;
                                password = pword;
                              },
                            ),
                          ),
                          Container(height: 50),
                          ResponsiveWidget(
                            child: LoginSubmit(
                              txt: "提交",
                              tap: () {
                                u_focus.unfocus();
                                p_focus.unfocus();
                                _login();
                              },
                            ),
                          ),
                          Container(height: 150),
                        ],
                      ),
                    ][index];
                  },
                ),
              ),
      ),
    );
  }
}

class LoginSubmit extends StatefulWidget {
  Function tap;
  Color color;
  Color fontColor;
  String txt;
  LoginSubmit({
    Key key,
    this.tap,
    this.txt,
    this.color,
    this.fontColor,
  }) : super(key: key);

  @override
  State<LoginSubmit> createState() => _LoginSubmitState();
}

class _LoginSubmitState extends State<LoginSubmit> {
  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: Duration(milliseconds: 80),
      onPressed: () {
        if (widget.tap != null) widget.tap();
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 4 * os_edge,
        margin: EdgeInsets.symmetric(horizontal: os_edge * 2),
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: widget.color ?? os_color,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Center(
          child: Text(
            widget.txt ?? "登录",
            style: TextStyle(
              color: widget.fontColor ?? os_white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class LoginHelp extends StatefulWidget {
  LoginHelp({Key key}) : super(key: key);

  @override
  State<LoginHelp> createState() => _LoginHelpState();
}

class _LoginHelpState extends State<LoginHelp> {
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        Navigator.pushNamed(context, "/login_helper");
      },
      padding: EdgeInsets.all(0),
      child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.symmetric(horizontal: os_edge * 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 2.5),
              child: Icon(
                Icons.info_outline,
                color: Color.fromARGB(255, 129, 129, 129),
                size: 18,
              ),
            ),
            Container(width: 3),
            Text(
              "无法登录？",
              style: TextStyle(
                color: Color.fromARGB(255, 129, 129, 129),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginInput extends StatefulWidget {
  Function change;
  FocusNode u_focus;
  FocusNode p_focus;
  LoginInput({
    Key key,
    this.change,
    this.p_focus,
    this.u_focus,
  }) : super(key: key);

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  bool isHide = true;
  TextEditingController u_controller = new TextEditingController();
  TextEditingController p_controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 4 * os_edge,
            margin:
                EdgeInsets.symmetric(horizontal: 2 * os_edge, vertical: 7.5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Provider.of<ColorProvider>(context).isDark
                    ? Color(0x11FFFFFF)
                    : os_white,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_light_dark_card
                  : Color.fromRGBO(0, 0, 0, 0.08),
            ),
            child: TextField(
              keyboardAppearance:
                  Provider.of<ColorProvider>(context, listen: false).isDark
                      ? Brightness.dark
                      : Brightness.light,
              controller: u_controller,
              focusNode: widget.u_focus,
              style: TextStyle(
                letterSpacing: 0.5,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_black,
              ),
              onChanged: (t) {
                widget.change(u_controller.text, p_controller.text);
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                hintText: "请输入用户名",
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 4 * os_edge,
            margin:
                EdgeInsets.symmetric(horizontal: 2 * os_edge, vertical: 7.5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Provider.of<ColorProvider>(context).isDark
                    ? Color(0x11FFFFFF)
                    : os_white,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_light_dark_card
                  : Color.fromRGBO(0, 0, 0, 0.08),
            ),
            child: TextField(
              keyboardAppearance:
                  Provider.of<ColorProvider>(context, listen: false).isDark
                      ? Brightness.dark
                      : Brightness.light,
              controller: p_controller,
              focusNode: widget.p_focus,
              obscureText: isHide,
              style: TextStyle(
                letterSpacing: 0.5,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_black,
              ),
              onChanged: (t) {
                widget.change(u_controller.text, p_controller.text);
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isHide = !isHide;
                      });
                    },
                    icon: Icon(
                      isHide ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                hintText: "请输入密码",
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
          ),
          LoginHelp(),
        ],
      ),
    );
  }
}

class LoginHead extends StatefulWidget {
  LoginHead({Key key}) : super(key: key);

  @override
  State<LoginHead> createState() => _LoginHeadState();
}

class _LoginHeadState extends State<LoginHead> {
  int time = 0; //0-早安 1-午安 2-晚安

  @override
  void initState() {
    DateTime dateTime = DateTime.now();
    setState(() {
      time = dateTime.hour < 12 ? 0 : (dateTime.hour < 18 ? 1 : 2);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveWidget(
            child: Text(
              ["早安", "午安", "晚安"][time],
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_white
                    : os_black,
              ),
            ),
          ),
          Container(height: 5),
          ResponsiveWidget(
            child: Text(
              "欢迎来到清水河畔",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF999999),
                letterSpacing: 2,
              ),
            ),
          ),
          Container(height: 40),
          Center(
            child: os_svg(
              path: "lib/img/login.svg",
              width: 322,
              height: 175,
            ),
          ),
        ],
      ),
    );
  }
}
