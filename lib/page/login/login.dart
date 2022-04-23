import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String username;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: os_white,
        foregroundColor: os_black,
        elevation: 0,
      ),
      backgroundColor: os_white,
      body: Container(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            LoginHead(),
            LoginInput(
              change: (uname, pword) {
                username = uname;
                password = pword;
              },
            ),
            Container(height: 50),
            LiginSubmit(),
          ],
        ),
      ),
    );
  }
}

class LiginSubmit extends StatefulWidget {
  Function tap;
  LiginSubmit({
    Key key,
    this.tap,
  }) : super(key: key);

  @override
  State<LiginSubmit> createState() => _LiginSubmitState();
}

class _LiginSubmitState extends State<LiginSubmit> {
  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: Duration(milliseconds: 80),
      onPressed: () {},
      child: Container(
        width: MediaQuery.of(context).size.width - 4 * os_edge,
        margin: EdgeInsets.symmetric(horizontal: os_edge * 2),
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: os_color,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Center(
          child: Text(
            "登录",
            style: TextStyle(
              color: os_white,
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
      onPressed: () {},
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
                color: Color(0xFFB7B7B7),
                size: 18,
              ),
            ),
            Container(width: 3),
            Text(
              "无法登录？",
              style: TextStyle(
                color: Color(0xFFB7B7B7),
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
  LoginInput({
    Key key,
    this.change,
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
      margin: EdgeInsets.symmetric(vertical: 42.5),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 4 * os_edge,
            margin:
                EdgeInsets.symmetric(horizontal: 2 * os_edge, vertical: 7.5),
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Color.fromRGBO(0, 0, 0, 0.05),
            ),
            child: TextField(
              controller: u_controller,
              style: TextStyle(
                letterSpacing: 0.5,
              ),
              onChanged: (t) {
                widget.change(u_controller.text, p_controller.text);
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 18,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                hintText: "请输入用户名",
                hintStyle: TextStyle(color: Colors.grey),
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
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Color.fromRGBO(0, 0, 0, 0.05),
            ),
            child: TextField(
              controller: p_controller,
              obscureText: isHide,
              style: TextStyle(
                letterSpacing: 0.5,
              ),
              onChanged: (t) {
                widget.change(u_controller.text, p_controller.text);
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 18,
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
                hintStyle: TextStyle(color: Colors.grey),
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "早安",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: os_black,
            ),
          ),
          Container(height: 5),
          Text(
            "欢迎来到清水河畔",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF999999),
              letterSpacing: 2,
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
