import 'package:flutter/material.dart';
import 'package:offer_show/outer/contained_tab_bar_view/src/enums.dart';
import 'dart:math' as math;

import 'tab_bar_properties.dart';
import 'tab_bar_view_properties.dart';

/// ContainedTabBarView encapsulates [TabController], [TabBar] and [TabBarView]
/// into a single, easy to use Widget.
///
/// It lets you customize its appearance without worrying
/// about internal workings of "TabBar ecosystem".
class ContainedTabBarView extends StatefulWidget {
  const ContainedTabBarView({
    Key key,
    @required this.tabs,
    this.tabBarProperties = const TabBarProperties(),
    @required this.views,
    this.tabBarViewProperties = const TabBarViewProperties(),
    this.initialIndex = 0,
    this.onChange,
    this.callOnChangeWhileIndexIsChanging = false,
  })  : assert(
          tabs.length == views.length,
          'There has to be an equal amount of tabs (${tabs.length}) and views (${views.length}).',
        ),
        super(key: key);

  /// Typically a list of two or more widgets which are used as tab buttons.
  ///
  /// The length of the list has to match the length of the [views] list.
  final List<Widget> tabs;

  /// A [TabBarProperties] object which is used for customizing
  /// the [TabBar]'s appearance.
  final TabBarProperties tabBarProperties;

  /// Typically a list of two or more widgets which are used as tab views.
  ///
  /// The length of the list has to match the length of the [tabs] list.
  final List<Widget> views;

  /// A [TabBarViewProperties] object which is used for customizing
  /// the [TabBarView]'s appearance.
  final TabBarViewProperties tabBarViewProperties;

  /// The initial tab index.
  final int initialIndex;

  /// Everytime the tab index changed, this method is called.
  ///
  /// If [callOnChangeWhileIndexIsChanging] is true this method is
  /// also called while we're animating from previousIndex to index
  /// as a consequence of calling animateTo.
  final void Function(int) onChange;

  /// Whether [onChange] should also get called while we're animating
  /// from previousIndex to index as a consequence of calling animateTo.
  final bool callOnChangeWhileIndexIsChanging;

  @override
  State<StatefulWidget> createState() => ContainedTabBarViewState();
}

class ContainedTabBarViewState extends State<ContainedTabBarView>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    )..addListener(() {
        if (widget.callOnChangeWhileIndexIsChanging ||
            (!widget.callOnChangeWhileIndexIsChanging &&
                !_controller.indexIsChanging)) {
          widget.onChange?.call(_controller.index);
        }
      });
  }

  /// True while we're animating from previousIndex to index
  /// as a consequence of calling animateTo.
  bool get indexIsChanging => _controller.indexIsChanging;

  /// Animates to the tab with the given index.
  void animateTo(
    int value, {
    Duration duration = kTabScrollDuration,
    Curve curve = Curves.ease,
  }) =>
      _controller.animateTo(value, duration: duration, curve: curve);

  /// Animates to the next tab.
  void next({
    Duration duration = kTabScrollDuration,
    Curve curve = Curves.ease,
  }) {
    if (_controller.index == _controller.length - 1) return;

    animateTo(_controller.index + 1);
  }

  /// Animates to the previous tab.
  void previous({
    Duration duration = kTabScrollDuration,
    Curve curve = Curves.ease,
  }) {
    if (_controller.index == 0) return;

    animateTo(_controller.index - 1);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          _buildFlex(constraints),
    );
  }

  Widget _buildFlex(BoxConstraints constraints) {
    return widget.tabBarProperties.position == TabBarPosition.left ||
            widget.tabBarProperties.position == TabBarPosition.right
        ? Row(
            crossAxisAlignment:
                _decideAlignment(widget.tabBarProperties.alignment),
            children: _buildChildren(constraints),
          )
        : Column(
            crossAxisAlignment:
                _decideAlignment(widget.tabBarProperties.alignment),
            children: _buildChildren(constraints),
          );
  }

  List<Widget> _buildChildren(BoxConstraints constraints) {
    List<Widget> children = [
      Padding(
        padding: widget.tabBarProperties.margin,
        child: _buildTabBar(),
      ),
      _buildTabBarView(constraints),
    ];

    return widget.tabBarProperties.position == TabBarPosition.bottom ||
            widget.tabBarProperties.position == TabBarPosition.right
        ? children.reversed.toList()
        : children;
  }

  Widget _buildTabBar() {
    final List<Widget> backgroundStackChildren = [];
    if (widget.tabBarProperties.background != null) {
      backgroundStackChildren.add(widget.tabBarProperties.background);
    }
    backgroundStackChildren.add(
      Positioned.fill(
        child: Padding(
          padding: widget.tabBarProperties.padding,
          child: TabBar(
            controller: _controller,
            tabs: widget.tabs,
            indicator: widget.tabBarProperties.indicator,
            indicatorColor: widget.tabBarProperties.indicatorColor,
            indicatorPadding: widget.tabBarProperties.indicatorPadding,
            indicatorSize: widget.tabBarProperties.indicatorSize,
            indicatorWeight: widget.tabBarProperties.indicatorWeight,
            isScrollable: widget.tabBarProperties.isScrollable,
            labelColor: widget.tabBarProperties.labelColor,
            labelPadding: widget.tabBarProperties.labelPadding,
            labelStyle: widget.tabBarProperties.labelStyle,
            unselectedLabelColor: widget.tabBarProperties.unselectedLabelColor,
            unselectedLabelStyle: widget.tabBarProperties.unselectedLabelStyle,
          ),
        ),
      ),
    );

    final Widget tabBar = SizedBox(
      width: widget.tabBarProperties.width,
      height: widget.tabBarProperties.height,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: backgroundStackChildren,
      ),
    );

    switch (widget.tabBarProperties.position) {
      case TabBarPosition.left:
        return Expanded(
          child: Transform.rotate(
            angle: -math.pi / 2,
            child: tabBar,
          ),
        );
      case TabBarPosition.right:
        return Expanded(
          child: Transform.rotate(
            angle: math.pi / 2,
            child: tabBar,
          ),
        );
      default:
        return tabBar;
    }
  }

  Widget _buildTabBarView(BoxConstraints constraints) {
    final EdgeInsets margin =
        widget.tabBarProperties.margin.resolve(TextDirection.ltr);

    return widget.tabBarProperties.position == TabBarPosition.left ||
            widget.tabBarProperties.position == TabBarPosition.right
        ? Container(
            width: constraints.maxWidth -
                widget.tabBarProperties.height -
                margin.top -
                margin.bottom,
            child: TabBarView(
              controller: _controller,
              children: widget.views,
              dragStartBehavior: widget.tabBarViewProperties.dragStartBehavior,
              physics: widget.tabBarViewProperties.physics,
            ),
          )
        : Container(
            height: constraints.maxHeight -
                widget.tabBarProperties.height -
                margin.top -
                margin.bottom,
            child: TabBarView(
              controller: _controller,
              children: widget.views,
              dragStartBehavior: widget.tabBarViewProperties.dragStartBehavior,
              physics: widget.tabBarViewProperties.physics,
            ),
          );
  }

  CrossAxisAlignment _decideAlignment(TabBarAlignment alignment) {
    switch (alignment) {
      case TabBarAlignment.start:
        return CrossAxisAlignment.start;
      case TabBarAlignment.center:
        return CrossAxisAlignment.center;
      case TabBarAlignment.end:
        return CrossAxisAlignment.end;
      default:
        return CrossAxisAlignment.center;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
