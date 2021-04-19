import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/router/router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          return MaterialPageRoute(
            builder: (context) => routers['/404'](),
          );
        }
        if (settings.arguments == null) {
          return MaterialPageRoute(
            builder: (context) => cotrollerFn(),
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => cotrollerFn(settings.arguments),
          );
        }
      },
      onUnknownRoute: (setting) {
        return MaterialPageRoute(
          builder: (context) => routers["/404"](),
        );
      },
    );
  }
}
