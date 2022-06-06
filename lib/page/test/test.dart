import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:offer_show/util/mid_request.dart';

class Test extends StatefulWidget {
  Test({Key key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  void _post_parm() async {
    Response response = await XHttp().pureHttpWithCookie(
      url: base_url + "forum.php?mod=viewthread&tid=1937853",
    );
    String html = response.data.toString();
    String post_param = html
        .split("post_params:")[1]
        .split("file_size_limit")[0]
        .trim()
        .substring(
            0,
            html
                    .split("post_params:")[1]
                    .split("file_size_limit")[0]
                    .trim()
                    .length -
                1);
    print("${jsonDecode(post_param)}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView(children: [
          ElevatedButton(
            onPressed: () {
              _post_parm();
            },
            child: Text("hola"),
          )
        ]),
      ),
    );
  }
}
