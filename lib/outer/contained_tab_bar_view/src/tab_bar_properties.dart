import 'package:flutter/material.dart';
import 'package:offer_show/outer/contained_tab_bar_view/src/enums.dart';

/// Properties which define the [TabBar]'s appearance.
class TabBarProperties {
  const TabBarProperties({
    this.width,
    this.height = kToolbarHeight,
    this.background,
    this.position = TabBarPosition.top,
    this.alignment = TabBarAlignment.center,
    this.padding = const EdgeInsets.all(0.0),
    this.margin = const EdgeInsets.all(0.0),
    this.indicator,
    this.indicatorColor,
    this.indicatorPadding = const EdgeInsets.all(0.0),
    this.indicatorSize,
    this.indicatorWeight = 2.0,
    this.isScrollable = false,
    this.labelColor,
    this.labelPadding = const EdgeInsets.all(0.0),
    this.labelStyle,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
  });

  /// The width of the [TabBar].
  ///
  /// If not set, it's full available width.
  final double? width;

  /// The height of the [TabBar].
  ///
  /// The [TabBarView] takes the available height minus this value.
  final double height;

  /// Container that is behind the tabs.
  final Container? background;

  /// Position of the [TabBar] in respect to it's [TabBarView].
  final TabBarPosition position;

  /// Alignment of the [TabBar] (if it's width is not full available)
  /// within [TabBar]-[TabBarView] flex.
  final TabBarAlignment alignment;

  /// The [TabBar]s padding.
  final EdgeInsetsGeometry padding;

  /// The [TabBar]s margin.
  final EdgeInsetsGeometry margin;

  /// Defines the appearance of the selected tab indicator.
  ///
  /// You can use [ContainerTabIndicator](https://pub.dev/packages/container_tab_indicator)
  /// for various customization.
  ///
  /// Also see [TabBar documentation](https://api.flutter.dev/flutter/material/TabBar/indicator.html).
  final Decoration? indicator;

  /// The color of the line that appears below the selected tab.
  ///
  /// See [TabBar documentation](https://api.flutter.dev/flutter/material/TabBar/indicatorColor.html).
  final Color? indicatorColor;

  /// Padding for indicator.
  ///
  /// See [TabBar documentation](https://api.flutter.dev/flutter/material/TabBar/indicatorPadding.html).
  final EdgeInsetsGeometry indicatorPadding;

  /// Defines how the selected tab indicator's size is computed.
  ///
  /// See [TabBar documentation](https://api.flutter.dev/flutter/material/TabBar/indicatorSize.html).
  final TabBarIndicatorSize? indicatorSize;

  /// The thickness of the line that appears below the selected tab.
  ///
  /// See [TabBar documentation](https://api.flutter.dev/flutter/material/TabBar/indicatorWeight.html).
  final double indicatorWeight;

  /// Whether this tab bar can be scrolled horizontally.
  ///
  /// See [TabBar documentation](https://api.flutter.dev/flutter/material/TabBar/isScrollable.html).
  final bool isScrollable;

  /// The color of selected tab labels.
  ///
  /// See [TabBar documentation](https://api.flutter.dev/flutter/material/TabBar/labelColor.html).
  final Color? labelColor;

  /// The padding added to each of the tab labels.
  ///
  /// See [TabBar documentation](https://api.flutter.dev/flutter/material/TabBar/labelPadding.html).
  final EdgeInsetsGeometry labelPadding;

  /// The text style of the selected tab labels.
  ///
  /// See [TabBar documentation](https://api.flutter.dev/flutter/material/TabBar/labelStyle.html).
  final TextStyle? labelStyle;

  /// The color of unselected tab labels.
  ///
  /// See [TabBar documentation](https://api.flutter.dev/flutter/material/TabBar/unselectedLabelColor.html).
  final Color? unselectedLabelColor;

  /// The text style of the unselected tab labels.
  ///
  /// See [TabBar documentation](https://api.flutter.dev/flutter/material/TabBar/unselectedLabelStyle.html).
  final TextStyle? unselectedLabelStyle;
}
