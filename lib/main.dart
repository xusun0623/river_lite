import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/router/router.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

void main() {
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  }
  runApp(MyApp());
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle =
          SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserInfoProvider()),
        ChangeNotifierProvider(create: (context) => HomeRefrshProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        theme: ThemeData(
          primaryColor: os_color,
        ),
        onGenerateRoute: (settings) {
          final String routersname = settings.name;
          final Function cotrollerFn = routers[routersname];
          //判断访问不存在的路由地址
          if (cotrollerFn == null) {
            return CupertinoPageRoute(
              builder: (context) => routers['/404'](),
            );
          }
          if (settings.arguments == null) {
            return CupertinoPageRoute(
              builder: (context) => cotrollerFn(),
            );
          } else {
            return CupertinoPageRoute(
              builder: (context) => cotrollerFn(settings.arguments),
            );
          }
        },
        onUnknownRoute: (setting) {
          return CupertinoPageRoute(
            builder: (context) => routers["/404"](),
          );
        },
      ),
    );
  }
}
