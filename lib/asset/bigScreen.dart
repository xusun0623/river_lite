import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

bool isDesktop(BuildContext context) {
  return Platform.isMacOS ||
      Platform.isLinux ||
      Platform.isWindows ||
      SizerUtil.deviceType == DeviceType.tablet;
}
