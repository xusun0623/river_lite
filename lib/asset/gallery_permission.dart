import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> checkAndRequestCameraPermissions() async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt <= 32) {
      if ((await Permission.storage.status).isDenied) {
        await Permission.storage.request();
        return true;
      } else {
        return false;
      }
    } else {
      if ((await Permission.photos.status).isDenied) {
        await Permission.photos.request();
        return true;
      } else {
        return false;
      }
    }
  } else {
    return true;
  }
}
