import 'package:dio/dio.dart';
import 'package:offer_show/util/mid_request.dart';

getTopicFormHash(int tid) async {
  Response response = await XHttp().pureHttpWithCookie(
    url: base_url + "forum.php?mod=viewthread&tid=${tid}",
  );
  String html = response.data.toString();
  String formhash = html
      .split("formhash=")[1]
      .split(">退出")[0]
      .substring(0, html.split("formhash=")[1].split(">退出")[0].length - 1);
  return formhash;
}
