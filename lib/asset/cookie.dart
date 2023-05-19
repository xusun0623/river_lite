import 'package:dio/dio.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/storage.dart';

getWebCookie({
  String? username,
  String? password,
}) async {
  String name = await getStorage(key: "name", initData: "");
  String pwd = await getStorage(key: "pwd", initData: "");

  Response response = await XHttp().pureHttp(
    url: base_url + "member.php?mod=logging&action=login&loginsubmit=yes",
    param: {
      "username": name,
      "password": pwd,
    },
  );
  if (response.statusCode == 200) {
    await setStorage(
      key: "cookie",
      value: "${response.headers["set-cookie"]!.join(";")};",
    );
    // print("重新请求Token，用户名为${name}，密码是${pwd}");
  }
  return "${response.headers["set-cookie"]!.join(";")};";
}
