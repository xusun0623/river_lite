import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';

_upload() async {
  var dio = new Dio();
  var formData = FormData();
  formData.files.addAll([
    MapEntry(
      'uploadFile[]',
      MultipartFile.fromFileSync(
        './test.png',
        filename: 'test.png',
        /* 一定要写！！！！！！！！！！！！！！！！！！！！！！！*/
        contentType: MediaType("image", "png"), //"image/png",
      ),
    ),
  ]);
  var response = await dio.post(
    'https://bbs.uestc.edu.cn/mobcent/app/web/index.php?r=forum/sendattachmentex&type=image&module=forum&accessToken=e9f49ac6acace2b9f6582800f32ff&accessSecret=8aef222107fcd2cedcc5f60b4edd1',
    options: Options(headers: {
      "Content-Type": "multipart/form-data;",
    }),
    data: formData,
  );
  print(response.data);
}

void main(List<String> args) {
  _upload();
}
