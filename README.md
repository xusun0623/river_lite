# OfferShow客户端

## API文档  
https://github.com/UESTC-BBS/API-Docs/wiki/Mobcent-API

## 项目集成介绍
[cached_network_image (网络缓存图片)](https://pub.dev/packages/cached_network_image)  
[dio (非常好用的网络请求库)](https://pub.dev/packages/dio)  
[flutter_easyrefresh (刷新组件)](https://pub.dev/packages/flutter_easyrefresh)  
[flutter_webview_plugin (网页加载)](https://pub.dev/packages/flutter_webview_plugin)  
[flutter_spinkit (loading加载动画)](https://pub.dev/packages/flutter_spinkit)  
[flutter_swiper (轮播图组件)](https://pub.dev/packages/flutter_swiper)  
[oktoast (弹窗)](https://pub.dev/packages/oktoast)  
[path_provider (路径)](https://pub.dev/packages/path_provider)  
[permission_handler 权限申请](https://pub.dev/packages/permission_handler)  
[provider (非常好用的数据共享工具)](https://pub.dev/packages/provider)  
[shared_preferences (本地存储)](https://pub.dev/packages/shared_preferences)  

## 编译相关

#### 1.打包
> flutter build apk --obfuscate --split-debug-info=HLQ_Struggle --target-platform android-arm,android-arm64,android-x64 --split-per-abi

#### 2.命令行安装
> adb -s 192.168.28.39:42163 install app-armeabi-v7a-release.apk
> adb install build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk

#### 3.IOS打包
> flutter build ios --release  
> flutter run --no-null-safety

## 开发代码片段
#### 1.Provider
```dart
> main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (context) => MainProvider(),
    ),
  ]
)
```
```dart
> provider.dart
class MainProvider extends ChangeNotifier {
  int curNum = 0;
  add() {
    curNum++;
    notifyListeners();
  }
  minus() {
    curNum--;
    notifyListeners();
  }
}
```
```dart
> ele.dart
KeyBoard provider = Provider.of<KeyBoard>(context);  
```

#### 2.路由管理
```dart
> main.dart
MaterialApp(
  initialRoute: "/",
  onGenerateRoute: (settings) {
    final Function cotrollerFn = routers[settings.name];
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
```
```dart
> router.dart
final routers = {
  "/": () => Home(),
  "/broke": () => Broke(),
  "/me": () => Me(),
  "/search": () => OSSearch(),
  "/myhome": () => MyHome(),
  "/square": () => Square(),
  "/404": () => Page404(),
};
```
```dart
> ele.dart
Navigator.pushNamed(context, "/square");
```

#### 3.载入SVG
```dart
> pubspec.yaml
  assets:
    - lib/img/logo.svg
```
```dart
> svg.dart
SvgPicture.asset(
  'lib/img/logo.svg',
  width: 40,
  height: 40,
)
```

#### 4.水波纹效果
```dart
myInkWell(
  widget: GestureDetector(
    onTap: () {
      print("object");
    },
    child: Container(
      child: Text("水波纹"),
    ),
  ),
  color: os_black_opa,
  splashColor: os_black_opa,
  width: 100,
  height: 100,
  radius: 10,
)
```

#### 5.状态栏颜色
```dart
AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container()
)
```
```dart
if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
```

#### 6.屏幕宽度
```dart
MediaQuery.of(context).size.width
```

#### 7.帖子内容
```json
{
    "infor": "https://bbs.uestc.edu.cn/data/attachment/forum/202201/17/232224senjq9cjyiqqnyq6.jpg",
    "type": 1,// 0-纯文字 1-图片 4-链接 5-附件
    "url": "https://bbs.uestc.edu.cn/forum.php?mod=attachment&aid=MjEwNTQxOHw0OWY4ZDM5YnwxNjQ0MDcyNjY0fDIyMTc4OHwxOTE3OTc0",
    "desc": "(7.88 MB, 下载次数: 352)",
    "originalInfo": "https://bbs.uestc.edu.cn/data/attachment/forum/202201/17/232224senjq9cjyiqqnyq6.jpg",
    "aid": 2105419
}
```


### 8.上拉刷新
```dart
ScrollController _scrollController = new ScrollController();
_scrollController.addListener(() {
  if (_scrollController.position.pixels ==
      _scrollController.position.maxScrollExtent) {
    _getComment();
  }
});
```


### 9.震动
```dart
bool vibrate = false;
if (_scrollController.position.pixels < -100) {
  if (!vibrate) {
    vibrate = true; //不允许再震动
    Vibrate.feedback(FeedbackType.impact);
  }
}
if (_scrollController.position.pixels >= 0) {
  vibrate = false; //允许震动
}
```




