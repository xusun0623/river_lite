import 'package:flutter/material.dart';
import 'package:offer_show/asset/logo.dart';
import 'package:offer_show/util/mid_request.dart';

class page1 extends StatefulWidget {
  final param;
  page1({this.param});
  @override
  _page1State createState() => _page1State();
}

class _page1State extends State<page1> with AutomaticKeepAliveClientMixin {
  int _index = 0;
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(),
        Text("$_index"),
        ElevatedButton(
          onPressed: () {
            XHttp().post();
          },
          child: Text("点我"),
        ),
        ElevatedButton(
            onPressed: () {
              setState(() {
                _index++;
              });
            },
            child: Text("+"))
      ],
    );
  }
}
