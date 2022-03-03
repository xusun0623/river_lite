import 'package:flutter/material.dart';

import 'choice_item.dart';

@immutable
class ChoiceConfig {
  final bool isCheckBox;
  final Widget selectedWidget;
  final Widget unselectedWidget;

  final List<ChoiceItem> items;

  const ChoiceConfig(
      {this.isCheckBox = false,
      this.selectedWidget,
      this.unselectedWidget,
      @required this.items})
      : assert(items != null);
}
