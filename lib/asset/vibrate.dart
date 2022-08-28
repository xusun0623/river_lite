import 'package:flutter_vibrate/flutter_vibrate.dart';

XSVibrate({FeedbackType type = FeedbackType.impact}) {
  Vibrate.feedback(type);
}
