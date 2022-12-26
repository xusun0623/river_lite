import 'package:flutter/material.dart';

/// 底部（取消按钮）组件
///
/// [title] 标题
/// [titleTextStyle] 标题样式
/// [onPressed] 点击回调(默认为关闭)，如果有指定回调
/// 需要使用 `Navigator.pop(context);` 关闭
///
@immutable
class BottomActionItem {
  final String title;
  final TextStyle? titleTextStyle;
  final VoidCallback? onPressed;

  const BottomActionItem(
      {required this.title, this.titleTextStyle, this.onPressed});
}
