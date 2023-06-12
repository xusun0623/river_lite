import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/page/home.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  _navi() async {
    await Future.delayed(Duration(milliseconds: 500));

    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Home(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ));
  }

  _dark() async {
    String dark_mode_txt = await getStorage(key: "dark", initData: "");
    Provider.of<ColorProvider>(context, listen: false).isDark =
        dark_mode_txt != "";
    Provider.of<ColorProvider>(context, listen: false).refresh();
  }

  _pic() async {
    //获取首页是否展示图区
    String tmp = await getStorage(key: "pic", initData: "1");
    if (tmp != "") {
      Provider.of<ShowPicProvider>(context, listen: false).isShow = true;
      Provider.of<ShowPicProvider>(context, listen: false).refresh();
    }
  }

  Future<void> fetchAll() async {
    await FlutterDisplayMode.setHighRefreshRate();
  }

  _autoQuestion() async {
    //获取首页是自动答题
    String tmp = await getStorage(key: "auto", initData: "");
    if (tmp != "") {
      Provider.of<AutoQuestionProvider>(context, listen: false).isAuto = true;
      Provider.of<AutoQuestionProvider>(context, listen: false).refresh();
    }
  }

  @override
  void initState() {
    _navi();
    _dark();
    _pic();
    fetchAll();
    _autoQuestion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/body");
      },
      child: Scaffold(
        backgroundColor:
            Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
        body: Center(
          child: Opacity(
            opacity: Provider.of<ColorProvider>(context).isDark ? 0.8 : 1,
            child: Container(
              margin: EdgeInsets.only(bottom: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  os_svg(
                    path: "lib/img/start.svg",
                    width: 100,
                    height: 100,
                  ),
                  Container(height: 20),
                  Text(
                    "河畔Lite",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Provider.of<ColorProvider>(context).isDark
                          ? os_dark_white
                          : os_black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
