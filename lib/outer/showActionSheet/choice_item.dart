import 'package:flutter/material.dart';

import 'action_item.dart';

/// 单选与多选
/// [title] 文字
/// [titleTextStyle] 文字样式
/// [onPressed] 无效
/// [isSelected] 是否选中
/// [leftIcon] 左侧图标
///
@immutable
class ChoiceItem extends ActionItem {
  final bool isSelected;
  final Widget leftIcon;

  const ChoiceItem(
      {@required String title,
      TextStyle titleTextStyle,
      this.isSelected = false,
      this.leftIcon})
      : super(title: title, titleTextStyle: titleTextStyle);
}
