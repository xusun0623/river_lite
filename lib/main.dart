/*
 * @Author: xusun000「xusun000@foxmail.com」 
 * @Date: 2022-08-03 10:38:17 
 * @Last Modified by:   xusun000 
 * @Last Modified time: 2022-08-03 10:38:17 
 */
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/router/router.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:window_manager/window_manager.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      size: Size(1080, 720),
      center: true,
      alwaysOnTop: false,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // 请求 Android 通知权限
  if (Platform.isAndroid) {
    await requestNotificationPermission();
  }

  runApp(MyApp());
}

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ColorProvider()),
        ChangeNotifierProvider(create: (context) => AdShowProvider()),
        ChangeNotifierProvider(create: (context) => UserInfoProvider()),
        ChangeNotifierProvider(create: (context) => TabShowProvider()),
        ChangeNotifierProvider(create: (context) => HomeRefrshProvider()),
        ChangeNotifierProvider(create: (context) => MsgProvider()),
        ChangeNotifierProvider(create: (context) => BlackProvider()),
        ChangeNotifierProvider(create: (context) => ShowPicProvider()),
        ChangeNotifierProvider(create: (context) => AutoQuestionProvider()),
        ChangeNotifierProvider(create: (context) => FontSizeProvider()),
      ],
      child: Sizer(builder: (context, orientation, deviceType) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Provider.of<ColorProvider>(context).isDark
                ? os_dark_back
                : os_white,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: "/",
            theme: ThemeData(
              fontFamily: '微软雅黑',
              appBarTheme: AppBarTheme(
                surfaceTintColor: Colors.transparent,
                scrolledUnderElevation: 0,
              ),
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.blue,
                backgroundColor: Provider.of<ColorProvider>(context).isDark
                    ? os_dark_back
                    : Colors.white,
              ),
              useMaterial3: true,
            ),
            onGenerateRoute: (settings) {
              final String? routersname = settings.name;
              final Function? cotrollerFn = routers[routersname];
              //判断访问不存在的路由地址
              if (cotrollerFn == null) {
                return CupertinoPageRoute(
                  builder: (context) => routers['/404']!(),
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
                builder: (context) => routers["/404"]!(),
              );
            },
          ),
        );
      }),
    );
  }
}
