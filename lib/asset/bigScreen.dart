import 'dart:io';

import 'package:flutter/cupertino.dart';

bool isDesktop(BuildContext context) {
  return Platform.isMacOS || Platform.isLinux || Platform.isWindows;
}
