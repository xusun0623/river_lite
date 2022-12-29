import 'package:flutter/material.dart';

import 'action_item.dart';

/// 头部组件
///
/// [title] 标题
/// [desc] 描述
/// [titleTextStyle] TextStyle 标题样式
/// [descTextStyle] TextStyle 描述样式
/// [showBottomLine] 是否显示底部的横线
/// [cancelAction] 左侧取消按钮回调
/// [doneAction] 右侧完成回调
///
@immutable
class TopActionItem extends ActionItem {
  final String desc;
  final TextStyle descTextStyle;
  final bool showBottomLine;
  final VoidCallback cancelAction;
  final ValueChanged<List<int>> doneAction;

  const TopActionItem(
      {@required String title,
      this.desc,
      TextStyle titleTextStyle,
      this.descTextStyle,
      this.showBottomLine = true,
      this.cancelAction,
      this.doneAction})
      : super(title: title, titleTextStyle: titleTextStyle);
}
