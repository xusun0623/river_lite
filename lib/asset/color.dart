import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final os_old_color = Color(0xFF4280E9);
final os_color = Color(0xFF3478F6); //主题蓝色
final os_color_opa = Color.fromRGBO(52, 120, 246, 0.1); //主题蓝色
final os_color_opa_opa = Color(0xFFF6F8FF);
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
final os_back = Color(0xFFF3F3F3); //浅灰

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

/// System overlays should be drawn with a dark color. Intended for
/// applications with a light background.
const SystemUiOverlayStyle dark = SystemUiOverlayStyle(
  systemNavigationBarColor: Color(0xFF000000),
  systemNavigationBarDividerColor: null,
  statusBarColor: null,
  systemNavigationBarIconBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
);
