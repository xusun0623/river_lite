import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:offer_show/asset/color.dart';
import 'package:url_launcher/url_launcher.dart';

class RiverWebView extends StatefulWidget {
  var url;
  RiverWebView({Key key, this.url}) : super(key: key);

  @override
  _RiverWebViewState createState() => _RiverWebViewState();
}

class _RiverWebViewState extends State<RiverWebView> {
  var webViewTitle = "加载中...";
  @override
  void initState() {
    super.initState();
    FlutterWebviewPlugin().onUrlChanged.listen((String url) async {
      if (!(url.startsWith("http:") || url.startsWith("https:"))) {
        await FlutterWebviewPlugin().stopLoading();
        await FlutterWebviewPlugin().goBack();
        await launch(url);
      }
    });
    FlutterWebviewPlugin()
        .onStateChanged
        .listen((WebViewStateChanged st) async {
      String title =
          await FlutterWebviewPlugin().evalJavascript("window.document.title");
      title = title.replaceAll("\"", "");
      if (!(title == "")) {
        setState(() {
          webViewTitle = title;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: os_white,
        foregroundColor: os_black,
        title: Text(webViewTitle),
      ),
      body: WebviewScaffold(
        url: widget.url,
        withZoom: true,
        withLocalStorage: true,
      ),
    );
  }
}
