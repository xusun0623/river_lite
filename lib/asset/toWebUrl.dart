import 'dart:io';

import 'package:url_launcher/url_launcher_string.dart';

xsLanuch({String url, bool isExtern}) {
  //跳转到网页，IOS内置浏览器，安卓跳转到系统浏览器
  launchUrlString(
    Uri.encodeFull(url),
    mode: (isExtern == null) //默认
        ? (Platform.isIOS
            ? LaunchMode.inAppWebView
            : LaunchMode.externalApplication)
        : (isExtern ? LaunchMode.externalApplication : LaunchMode.inAppWebView),
  );
}
