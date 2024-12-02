import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/util/provider.dart';

class OSWebViewPage extends StatefulWidget {
  final String url;
  final String? title;

  OSWebViewPage({required this.url, this.title});

  @override
  _OSWebViewPageState createState() => _OSWebViewPageState();
}

class _OSWebViewPageState extends State<OSWebViewPage> {
  late WebViewController _controller;
  bool _isLoading = true;
  String? _pageTitle;

  @override
  void initState() {
    super.initState();
    // 初始化 WebViewController 并加载页面
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (url) async {
            // 获取网页标题
            String? title = await _controller.getTitle();
            setState(() {
              _isLoading = false;
              _pageTitle = title ?? '加载中...'; // 如果无法获取标题则显示“加载中...”
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ColorProvider>(context).isDark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? os_dark_back : os_white,
        title: Text(
          widget.title ?? _pageTitle ?? '加载中...', // 优先使用自定义标题，如果没有则使用网页标题
          style: TextStyle(
            color: isDark ? os_dark_white : Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left_rounded,
            color: isDark ? os_dark_dark_white : os_dark_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        iconTheme: IconThemeData(
          color: isDark ? os_dark_white : Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();
            },
          ),
        ],
      ),
      backgroundColor: isDark ? os_dark_back : os_back,
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          _isLoading
              ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? os_dark_white : Colors.blue,
              ),
            ),
          )
              : Container(),
        ],
      ),
    );
  }
}
