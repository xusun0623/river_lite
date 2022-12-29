import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
// import 'package:offer_show/asset/size.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BilibiliPlayer extends StatefulWidget {
  String short_url;
  BilibiliPlayer({
    Key key,
    this.short_url,
  }) : super(key: key);

  @override
  State<BilibiliPlayer> createState() => _BilibiliPlayerState();
}

class _BilibiliPlayerState extends State<BilibiliPlayer> {
  String bvNumber = "";
  bool load_done = false;

  _getBvNumber() async {
    var response = (await Dio().get(widget.short_url)).toString();
    bvNumber =
        response.split("https://www.bilibili.com/video/")[1].split("/")[0];
    setState(() {});
  }

  @override
  void initState() {
    _getBvNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return bvNumber == ""
        ? Container()
        : Opacity(
            opacity: load_done ? 1 : 0.01,
            child: Container(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 400,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: (MediaQuery.of(context).size.width) / 16 * 9,
                    width: MediaQuery.of(context).size.width,
                    color: os_middle_grey,
                    child: WebView(
                      onPageFinished: (_) async {
                        await Future.delayed(Duration(milliseconds: 500));
                        setState(() {
                          load_done = true;
                        });
                      },
                      initialUrl:
                          "https://player.bilibili.com/player.html?bvid=${bvNumber}",
                      javascriptMode: JavascriptMode.unrestricted,
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
