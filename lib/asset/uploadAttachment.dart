import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/storage.dart';

String _uid = "";

  // void _post_parm() async {
  //   Response response = await XHttp().pureHttpWithCookie(
  //     url: "https://bbs.uestc.edu.cn/forum.php?mod=viewthread&tid=1937853",
  //   );
  //   String html = response.data.toString();
  //   String post_param = html
  //       .split("post_params:")[1]
  //       .split("file_size_limit")[0]
  //       .trim()
  //       .substring(
  //           0,
  //           html
  //                   .split("post_params:")[1]
  //                   .split("file_size_limit")[0]
  //                   .trim()
  //                   .length -
  //               1);
  //   print("${jsonDecode(post_param)}");
  // }

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
