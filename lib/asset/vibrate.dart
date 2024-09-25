// import 'package:flutter_vibrate/flutter_vibrate.dart';

// import 'package:vibration/vibration.dart';

// XSVibrate({FeedbackType type = FeedbackType.impact}) {
//   Vibrate.feedback(type);
// }

import 'package:flutter/services.dart';

class XSVibrate {
  success() async {
    HapticFeedback.heavyImpact();
    await Future.delayed(Duration(milliseconds: 150));
    HapticFeedback.heavyImpact();
  }

  impact() async {
    HapticFeedback.mediumImpact();
  }

  light() async {
    HapticFeedback.lightImpact();
  }
}
