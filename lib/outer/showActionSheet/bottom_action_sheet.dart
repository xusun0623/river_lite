import 'dart:async';

import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

import 'action_item.dart';
import 'bottom_action_item.dart';
import 'choice_config.dart';
import 'choice_item.dart';
import 'top_action_item.dart';

Future<T?> showActionSheet<T>({
  required BuildContext context,
  List<ActionItem>? actions,
  Widget? content,
  ChoiceConfig? choiceConfig,
  TopActionItem? topActionItem,
  BottomActionItem? bottomActionItem,
  Color? barrierColor,
  Color? actionSheetColor,
  bool isScrollControlled = false,
  bool isDismissible = true,
  bool enableDrag = true,
}) async {
  assert(barrierColor != Colors.transparent,
      'The barrier color cannot be transparent.');
  // 当有头部并且有标题的时候, 设置顶部圆角
  final roundedRectangleBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
    topLeft: Radius.circular(10),
    topRight: Radius.circular(10),
  ));

  return showModalBottomSheet<T>(
      context: context,
      elevation: 0,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor:
          actionSheetColor ?? Theme.of(context).dialogBackgroundColor,
      barrierColor: barrierColor,
      shape: roundedRectangleBorder,
      builder: (ctx) {
        return _ActionSheet(
            actions: actions,
            content: content,
            choiceConfig: choiceConfig,
            topActionItem: topActionItem,
            bottomActionItem: bottomActionItem);
      });
}

/// 顶部组件
class _TopActionItemWidget extends StatelessWidget {
  final TopActionItem? topActionItem;
  final VoidCallback? onDonePress;

  const _TopActionItemWidget({required this.topActionItem, this.onDonePress});

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [];
    widgets.addAll([
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            topActionItem!.title!,
            style: const TextStyle()
                .merge(topActionItem!.titleTextStyle)
                .merge(TextStyle(
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_white
                      : os_black,
                )),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ]);

    if (topActionItem!.desc != null) {
      widgets.add(Expanded(
          child: Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                topActionItem!.desc!,
                style: const TextStyle(color: Colors.black45, fontSize: 12)
                    .merge(topActionItem!.titleTextStyle),
                textAlign: TextAlign.center,
              ))));
    }

    return Container(
        decoration: BoxDecoration(
            color: Provider.of<ColorProvider>(context).isDark
                ? os_dark_back
                : os_white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: widgets,
            ),
            if (topActionItem!.showBottomLine)
              const Divider(
                height: 0,
              )
            else
              const SizedBox(height: 0, width: 0)
          ],
        ));
  }
}

/// 底部组件
class _BottomActionItemWidget extends StatelessWidget {
  final BottomActionItem? bottomActionItem;

  const _BottomActionItemWidget(this.bottomActionItem);

  @override
  Widget build(BuildContext context) {
    if (bottomActionItem == null) {
      return const SizedBox(height: 0, width: 0);
    }
    return Container(
      decoration: BoxDecoration(
        color: Provider.of<ColorProvider>(context).isDark
            ? os_dark_back
            : os_white,
      ),
      child: Column(children: [
        Container(
          height: 10,
          color: Provider.of<ColorProvider>(context).isDark
              ? os_light_dark_card
              : const Color.fromRGBO(247, 248, 250, 1),
        ),
        InkWell(
          onTap:
              bottomActionItem!.onPressed ?? () => Navigator.of(context).pop(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                bottomActionItem!.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Provider.of<ColorProvider>(context).isDark
                      ? os_dark_white
                      : os_black,
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}

/// ActionSheet
class _ActionSheet extends StatefulWidget {
  final List<ActionItem>? actions;
  final Widget? content;
  final ChoiceConfig? choiceConfig;
  final TopActionItem? topActionItem;
  final BottomActionItem? bottomActionItem;

  @override
  _ActionSheetState createState() => _ActionSheetState();

  const _ActionSheet(
      {this.actions,
      this.content,
      this.choiceConfig,
      this.topActionItem,
      this.bottomActionItem});
}

class _ActionSheetState extends State<_ActionSheet> {
  List<Widget?> widgets = [];
  int? _groupValue;
  Set<int> _checkBoxValue = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (widget.choiceConfig != null) {
        final List<ChoiceItem> selectedItems = widget.choiceConfig!.items
            .where((element) => element.isSelected == true)
            .toList();
        final List<int> selectedItemsIndex = selectedItems
            .map((e) => widget.choiceConfig!.items.indexOf(e))
            .toList();

        if (widget.choiceConfig!.isCheckBox) {
          _checkBoxValue = selectedItemsIndex.toSet();
        } else {
          if (selectedItemsIndex.isNotEmpty) {
            _groupValue = selectedItemsIndex.first;
          }
        }
      }

      /// 添加中间操作按钮
      if (widget.actions != null) {
        widget.actions!.forEach((action) {
          final index = widget.actions!.indexOf(action);
          widgets.add(Container(
            width: double.infinity,
            color: Provider.of<ColorProvider>(context, listen: false).isDark
                ? os_dark_back
                : os_white,
            // splashColor: Colors.redAccent,
            // onTap: action.onPressed,
            child: InkWell(
              onTap: action.onPressed,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  action.title!,
                  style: TextStyle(
                    fontSize: 16,
                  ).merge(action.titleTextStyle).merge(TextStyle(
                        color:
                            Provider.of<ColorProvider>(context, listen: false)
                                    .isDark
                                ? os_dark_white
                                : os_black,
                      )),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ));
          if (index < widget.actions!.length - 1) {
            widgets.add(const Divider(
              height: 0,
            ));
          }
        });
      }

      if (widget.content != null) {
        widgets.add(widget.content);
      }

      setState(() {});
    });
  }

  List<Widget> _buildChoiceItems() {
    final List<Widget> choiceItems = [];
    if (widget.choiceConfig != null) {
      widget.choiceConfig!.items.forEach((item) {
        final index = widget.choiceConfig!.items.indexOf(item);

        choiceItems.add(__ChoiceItemWidget<int?>(
            value: index,
            groupValue: widget.choiceConfig!.isCheckBox
                ? (_checkBoxValue.contains(index) ? index : -1)
                : _groupValue,
            title: item.title,
            titleTextStyle: item.titleTextStyle,
            leftIcon: item.leftIcon,
            onPress: (dynamic idx) {
              if (widget.choiceConfig!.isCheckBox) {
                if (_checkBoxValue.contains(idx as int)) {
                  _checkBoxValue.remove(idx);
                } else {
                  _checkBoxValue.add(idx);
                }
              } else {
                _groupValue = idx as int;
              }

              setState(() {});
            }));
        if (index < widget.choiceConfig!.items.length - 1) {
          choiceItems.add(const Divider(
            height: 0,
          ));
        }
      });
    }
    return choiceItems;
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      color:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_white,
      child: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: screenHeight - (screenHeight / 10),
          ),
          child: AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: const Duration(milliseconds: 275),
            curve: Curves.easeOutQuad,
            child: Container(
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_dark_back
                  : os_white,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.topActionItem != null) ...{
                      _TopActionItemWidget(
                        topActionItem: widget.topActionItem,
                        onDonePress: () {
                          if (widget.topActionItem!.doneAction != null) {
                            if (widget.choiceConfig!.isCheckBox) {
                              widget.topActionItem!
                                  .doneAction!(_checkBoxValue.toList());
                            } else {
                              widget.topActionItem!.doneAction!([_groupValue]);
                            }
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    },
                    Flexible(
                      child: Theme(
                        data: ThemeData(
                          splashColor: Colors.white70,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ...widgets as Iterable<Widget>,
                              ..._buildChoiceItems(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (widget.bottomActionItem != null) ...{
                      _BottomActionItemWidget(widget.bottomActionItem)
                    }
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

/// 选择组件
class __ChoiceItemWidget<T> extends StatefulWidget {
  final T value;
  final T groupValue;
  final String? title;
  final TextStyle? titleTextStyle;
  final Widget? leftIcon;
  final Widget? selectedIcon;
  final Widget? unselectedIcon;
  final ValueChanged<dynamic> onPress;

  const __ChoiceItemWidget(
      {this.leftIcon,
      this.titleTextStyle,
      this.selectedIcon,
      this.unselectedIcon,
      required this.title,
      required this.onPress,
      required this.value,
      required this.groupValue});

  @override
  _ChoiceItemWidgetState createState() => _ChoiceItemWidgetState();
}

class _ChoiceItemWidgetState extends State<__ChoiceItemWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        widget.onPress(widget.value as int);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.leftIcon != null)
              widget.leftIcon!
            else
              const SizedBox(
                height: 0,
                width: 0,
              ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                widget.title!,
                style: const TextStyle(
                  fontSize: 12,
                ).merge(widget.titleTextStyle),
              ),
            )),
            if (widget.selectedIcon != null)
              widget.value == widget.groupValue
                  ? widget.selectedIcon!
                  : widget.unselectedIcon!
            else
              Icon(
                Icons.check_box,
                color: widget.value == widget.groupValue
                    ? Colors.blueAccent
                    : Colors.transparent,
              )
          ],
        ),
      ),
    );
  }
}
