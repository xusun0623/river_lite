# OfferShow客户端

* 查看一下版本号是否正确
```
flutter --version
```

* 运行以下命令查看是否需要安装其它依赖项来完成安装
```
flutter doctor
```

* 运行启动您的应用
```
flutter packages get 
flutter run
```

## 项目集成介绍

> 本项目可能精选了目前Flutter最实用的几个库，可大大提高开发的效率。

* [flutter_i18n(国际化插件)](https://marketplace.visualstudio.com/items?itemName=esskar.vscode-flutter-i18n-json)
* [auto_route(自动路由注册插件)](https://pub.dev/packages/auto_route)
* [cached_network_image (网络缓存图片)](https://pub.dev/packages/cached_network_image)
* [dio (非常好用的网络请求库)](https://pub.dev/packages/dio)
* [event_bus (事件工具)](https://pub.dev/packages/event_bus)
* [fluro (页面路由神器)](https://pub.dev/packages/fluro)
* [flutter_easyrefresh (刷新组件)](https://pub.dev/packages/flutter_easyrefresh)
* [flutter_webview_plugin (网页加载)](https://pub.dev/packages/flutter_webview_plugin)
* [flutter_spinkit (loading加载动画)](https://pub.dev/packages/flutter_spinkit)
* [flutter_swiper (轮播图组件)](https://pub.dev/packages/flutter_swiper)
* [flutter_xupdate (应用版本更新)](https://pub.dev/packages/flutter_xupdate)
* [oktoast](https://pub.dev/packages/oktoast)
* [path_provider (路径)](https://pub.dev/packages/path_provider)
* [package_info (应用包信息)](https://pub.dev/packages/url_launcher)
* [permission_handler 权限申请](https://pub.dev/packages/permission_handler)
* [provider (非常好用的数据共享工具)](https://pub.dev/packages/provider)
* [share (分享)](https://pub.dev/packages/share)
* [shared_preferences](https://pub.dev/packages/shared_preferences)
* [url_launcher (链接处理)](https://pub.dev/packages/url_launcher)

## 使用指南

2.修改项目名（文件夹名），并删除目录下的.git文件夹（隐藏文件）

3.使用AS或者VSCode打开项目，然后分别修改flutter、Android、ios项目的包名、应用ID以及应用名等信息。

最简单的替换方法就是进行全局替换,搜索关键字`flutter_template`,然后替换你想要的项目包名,如下图所示:

### Flutter目录修改

* 修改项目根目录`pubspec.yaml`文件, 修改项目名、描述、版本等信息。

【注意】这里修改完`pubspec.yaml`中的`name`属性后，flutter项目的包名将会修改，这里我推荐大家使用全局替换的方式修改比较快。例如我想要修改`name`为`flutter_app`,在VSCode中你可以选择`lib`文件夹之后右击，选择`在文件夹中寻找`, 进行全局替换:

* 修改`lib/core/http/http.dart`中的网络请求配置，包括：服务器地址、超时、拦截器等设置

* 修改`lib/core/utils/privacy.dart`中隐私服务政策地址

* 修改`lib/core/utils/xupdate.dart`中版本更新检查的地址


### Android目录修改

* 修改android目录下的包名。

在VSCode中你可以选择`android`文件夹之后右击，选择`在文件夹中寻找`, 进行全局替换。

【注意】修改包名之后，记住需要将存放`MainActivity.kt`类的文件夹名也一并修改，否则将会找不到类。

* 修改应用ID。修改`android/app/build.gradle`文件中的`applicationId`

* 修改应用名。修改`android/app/src/main/res/values/strings.xml`文件中的`app_name`


* 打包成APK
```
flutter build apk --obfuscate --split-debug-info=HLQ_Struggle --target-platform android-arm,android-arm64,android-x64 --split-per-abi
```

## 打包

cd '/Users/xusun/Desktop/Flutter/OfferShow/offer_show/build/app/outputs/flutter-apk' && adb -s 192.168.31.39:41791 install app-armeabi-v7a-release.apk 


## Provider

KeyBoard provider = Provider.of<KeyBoard>(context);


## Animation动画
```dart
void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(
        milliseconds: 1000,
      ),
      vsync: this,
    );
    animation = Tween(
      begin: (toRight ? Offset.zero : Offset(1, 0)),
      end: (toRight ? Offset(1, 0) : Offset.zero),
    ).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  _slide() {
    if (controller.status == AnimationStatus.completed) {
      controller.reverse();
    } else {
      controller.forward();
    }
  }
```