# 河畔Lite客户端

## API文档  
https://github.com/UESTC-BBS/API-Docs/wiki/Mobcent-API

## 编译相关

#### 1.打包
> flutter build apk --obfuscate --split-debug-info=HLQ_Struggle --target-platform android-arm,android-arm64,android-x64 --split-per-abi  

> git fetch  

> flutter build apk --obfuscate --split-debug-info=HLQ_Struggle --target-platform android-arm,android-arm64,android-x64 --split-per-abi  

> adb install build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk  

#### 2.命令行安装
> adb -s 192.168.28.39:42163 install app-armeabi-v7a-release.apk  
> adb install build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk  

#### 3.IOS打包
> flutter build ios --release  
> flutter run --no-null-safety

#### 4.MacOS打包
> flutter build macOS --release  
> https://zhuanlan.zhihu.com/p/56864296  

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

### 10.动画
```dart
AnimationController controller; //动画控制器
Animation<double> animation;
double _right = -200;
@override
void initState() {
  super.initState();
  widget.controller.addListener(() {
    if (widget.show) {
      controller.forward();
    } else {
      controller.reverse();
    }
  });
  controller = new AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 400),
  )..addListener(() {
      setState(() {});
    });
  final CurvedAnimation curve = CurvedAnimation(
    parent: controller,
    curve: Curves.easeInOut,
  );
  animation = Tween(begin: -200.0, end: 20.0).animate(curve)
    ..addListener(() {
      setState(() {
        _right = animation.value;
      });
    });
}
```

### 11.下拉刷新
```dart
RefreshIndicator(
  color: os_color,
  onRefresh: () async {
    var data = await _getInitData();
    vibrate = false;
    return data;
  },
  child: _buildComponents(),
);
```

### 12.回顶
```dart
bool showBackToTop = false;
ScrollController _controller = new ScrollController();
if (_controller.position.pixels > 1000 && !showBackToTop) {
  setState(() {
    showBackToTop = true;
  });
}
if (_controller.position.pixels < 1000 && showBackToTop) {
  setState(() {
    showBackToTop = false;
  });
}
```

https://bbs.uestc.edu.cn/forum.php?mod=post&action=edit&tid=1943353&pid=34122687