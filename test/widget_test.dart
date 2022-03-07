import 'package:http/http.dart' as http;

void main(List<String> args) async {
  var headers = {
    'Cookie':
        'v3hW_2132_lastact=1646632538%09index.php%09; v3hW_2132_lastvisit=1646628120; v3hW_2132_saltkey=wie3O7E4; v3hW_2132_sid=RCmsyd'
  };
  var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://bbs.uestc.edu.cn/mobcent/app/web/index.php?r=forum/sendattachmentex&type=image&module=forum&accessToken=e9f49ac6acace2b9f6582800f32ff&accessSecret=8aef222107fcd2cedcc5f60b4edd1'));
  request.files
      .add(await http.MultipartFile.fromPath('uploadFile[]', './test.png'));
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}
