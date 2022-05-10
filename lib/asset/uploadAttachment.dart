import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/storage.dart';

getUploadAid(int tid) async {
  // String myinfo_txt = await getStorage(key: "myinfo", initData: "");
  String cookie = await getStorage(key: "cookie", initData: "");
  if (cookie != "") {
    String web_frame = await XHttp().pureHttp(
        url: "https://bbs.uestc.edu.cn/forum.php?mod=viewthread&tid=${tid}");
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path);
    } else {
      // User canceled the picker
    }
  }
}
