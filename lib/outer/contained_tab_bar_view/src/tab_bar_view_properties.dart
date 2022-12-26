import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Properties for customizing the [TabBarView].
class TabBarViewProperties {
  const TabBarViewProperties({
    this.physics,
    this.dragStartBehavior = DragStartBehavior.start,
  });

  /// How the page view should respond to user input.
  ///
  /// See [TabBarView documentation](https://api.flutter.dev/flutter/material/TabBarView/physics.html).
  final ScrollPhysics? physics;

  /// Determines the way that drag start behavior is handled.
  ///
  /// See [TabBarView documentation](https://api.flutter.dev/flutter/material/TabBarView/dragStartBehavior.html).
  final DragStartBehavior dragStartBehavior;
}
