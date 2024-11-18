import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/toWebUrl.dart';
import 'package:offer_show/asset/xs_textstyle.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';
// import 'package:offer_show/asset/size.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BilibiliPlayer extends StatefulWidget {
  String? short_url;
  BilibiliPlayer({
    Key? key,
    this.short_url,
  }) : super(key: key);

  @override
  State<BilibiliPlayer> createState() => _BilibiliPlayerState();
}

class _BilibiliPlayerState extends State<BilibiliPlayer> {
  String bvNumber = "";
  bool load_done = false;
  WebViewController controller = new WebViewController();

  _getBvNumber() async {
    var response = (await Dio().get(widget.short_url!)).toString();
    bvNumber = response
        .split(
          "https://www.bilibili.com/video/",
        )[1]
        .split("/")[0];
    print("$bvNumber");
    initWebViewController();
    setState(() {});
  }

  initWebViewController() async {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            print("$progress");
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            setState(() {
              load_done = true;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse("https://player.bilibili.com/player.html?bvid=${bvNumber}"),
      );
  }

  @override
  void initState() {
    _getBvNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        bvNumber == ""
            ? Container(
                child: CircularProgressIndicator(
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_dark_white
                      : os_dark_back,
                ),
              )
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
                        child: WebViewWidget(controller: controller),
                      ),
                    ),
                  ),
                ),
              ),
        Container(height: 5),
        Row(
          children: [
            myInkWell(
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_light_dark_card
                  : os_white,
              tap: () {
                xsLanuch(url: widget.short_url!, isExtern: true);
              },
              radius: 5,
              widget: Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "在浏览器中打开",
                  style: XSTextStyle(
                    context: context,
                    color: Provider.of<ColorProvider>(context).isDark
                        ? os_dark_dark_white
                        : os_color,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
