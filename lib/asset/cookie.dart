import 'package:dio/dio.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/storage.dart';

getWebCookie({
  String username,
  String password,
}) async {
  Response response = await XHttp().pureHttp(
      url:
          "https://bbs.uestc.edu.cn/member.php?mod=logging&action=login&loginsubmit=yes",
      param: {
        "username": username,
        "password": password,
      });
  if (response.statusCode == 200) {
    await setStorage(
        key: "cookie", value: "${response.headers["set-cookie"].join(";")};");
  }
  return;
}
