import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';

class PostNew extends StatefulWidget {
  var board;
  PostNew({
    Key key,
    this.board,
  }) : super(key: key);

  @override
  _PostNewState createState() => _PostNewState();
}

class _PostNewState extends State<PostNew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: os_color,
        elevation: 0,
        title: Text("新帖", style: TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.send, size: 18))
        ],
      ),
      body: Container(
        color: os_color,
      ),
    );
  }
}
