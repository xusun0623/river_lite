import 'package:flutter/material.dart';

/// 小部件
///
/// [title] 文字
/// [titleTextStyle] 文字样式
/// [onPressed] 点击的回调
///
@immutable
class ActionItem {
  final String title;
  final TextStyle titleTextStyle;
  final VoidCallback onPressed;

  const ActionItem({@required this.title, this.titleTextStyle, this.onPressed});
}
