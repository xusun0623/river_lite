import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/router/router.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MainProvider(),
        ),
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
