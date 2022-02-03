# OfferShow客户端

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


## 打包成APK

```
flutter build apk --obfuscate --split-debug-info=HLQ_Struggle --target-platform android-arm,android-arm64,android-x64 --split-per-abi
```

## 安装

```
adb -s 192.168.28.39:42163 install app-armeabi-v7a-release.apk
```

## Provider

KeyBoard provider = Provider.of<KeyBoard>(context);

flutter build ios --release

flutter run --no-null-safety