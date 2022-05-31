import 'dart:io';

import 'package:sizer/sizer.dart';

bool isDesktop() {
  return Platform.isMacOS ||
      Platform.isLinux ||
      Platform.isWindows ||
      SizerUtil.deviceType == DeviceType.tablet;
}
