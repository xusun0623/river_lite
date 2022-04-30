import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final os_color = Color(0xFF0092FF); //主题蓝色
final os_deep_blue = Color(0xFF004DFF);
final os_color_opa = Color.fromRGBO(0, 146, 255, 0.1); //主题蓝色
final os_black = Color(0xFF000000); //纯黑色
final os_black_opa = Color.fromRGBO(0, 0, 0, 0.1); //透黑色
final os_black_opa_opa = Color.fromRGBO(0, 0, 0, 0.05); //主题蓝色
final os_white = Color(0xFFFFFFFF); //纯白色
final os_red = Color(0xFFFF1F1F); //红色
final os_grey = Color(0xFFEEEEEE); //浅灰
final os_subtitle = Color(0xFFB8B8B8); //浅灰
final os_light_grey = Color(0xFFFAFAFA); //浅灰
final os_deep_grey = Color(0xFF8B8B8B); //浅灰
final os_middle_grey = Color(0xFFD3D3D3); //浅灰

final os_back = Color(0xFFF1F4F8); //浅灰

final os_wonderful_color = [
  Color(0xFFFE6F61),
  Color(0xFF50B9FE),
  Color(0xFF40D69C),
  Color(0xFFFF773F),
  Color(0xFFFF8D46),
  Color(0xFF96A4FE),
  Color(0xFF0092FF),
];
final os_wonderful_color_opa = [
  Color.fromRGBO(254, 111, 97, 0.1),
  Color.fromRGBO(80, 185, 254, 0.1),
  Color.fromRGBO(64, 214, 156, 0.1),
  Color.fromRGBO(255, 119, 63, 0.1),
  Color.fromRGBO(255, 141, 70, 0.1),
  Color.fromRGBO(150, 164, 254, 0.1),
  Color.fromRGBO(0, 146, 255, 0.1),
];

/// System overlays should be drawn with a light color. Intended for
/// applications with a dark background.
const SystemUiOverlayStyle light = SystemUiOverlayStyle(
  systemNavigationBarColor: Color(0xFF000000),
  systemNavigationBarDividerColor: null,
  statusBarColor: null,
  systemNavigationBarIconBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
);

const SystemUiOverlayStyle dark = SystemUiOverlayStyle(
  systemNavigationBarColor: Color(0xFF000000),
  systemNavigationBarDividerColor: null,
  statusBarColor: null,
  systemNavigationBarIconBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
);
