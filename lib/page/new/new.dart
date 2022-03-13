import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/niw.dart';

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
  String select_section = "板块";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: os_back,
        elevation: 0,
        title: Text(
          "发帖",
          style: TextStyle(fontSize: 16, color: Color(0xFF2E2E2E)),
        ),
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded, color: Color(0xFF2E2E2E)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          RightTopSend(
            tap: () {
              print("tap");
            },
          )
        ],
      ),
      body: Container(
        color: os_back,
        child: Stack(
          children: [
            Positioned(
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      style: TextStyle(fontSize: 17),
                      cursorColor: Color(0xFF004DFF),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Color(0xFF004DFF),
                            style: BorderStyle.solid,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Color(0xFFE0E0E0),
                            style: BorderStyle.solid,
                          ),
                        ),
                        hintStyle: TextStyle(
                          fontSize: 17,
                          color: Color(0xFFA3A3A3),
                        ),
                        hintText: "请输入帖子的标题",
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 0),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      cursorColor: Color(0xFF004DFF),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Color(0xFFA3A3A3),
                        ),
                        hintText: "说点什么吧…",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: os_white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7),
                    topRight: Radius.circular(7),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 27,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                            border: Border.all(
                              color: os_deep_blue,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(width: 7.5),
                              Text(
                                select_section,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: os_deep_blue,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                size: 18,
                                color: os_deep_blue,
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width -
                              select_section.length * 14 -
                              70,
                          height: 30,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              SelectTag(),
                              SelectTag(),
                              SelectTag(),
                              SelectTag(),
                              SelectTag(),
                              SelectTag(),
                              SelectTag(),
                              SelectTag(),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 30,
                      height: 1,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      color: Color(0xFFEFEFEF),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          //左边按键区
                          children: [
                            myInkWell(
                              widget: Container(
                                padding: EdgeInsets.all(2.5),
                                child: os_svg(
                                  path: "lib/img/topic_emoji_black.svg",
                                  width: 22,
                                  height: 22,
                                ),
                              ),
                              radius: 10,
                              width: 30,
                              height: 29,
                            ),
                            Container(width: 15),
                            myInkWell(
                              widget: Container(
                                padding: EdgeInsets.all(2.5),
                                child: os_svg(
                                  path: "lib/img/topic_@_black.svg",
                                  width: 22,
                                  height: 22,
                                ),
                              ),
                              radius: 10,
                              width: 30,
                              height: 29,
                            ),
                            Container(width: 15),
                            myInkWell(
                              widget: Container(
                                padding: EdgeInsets.all(2.5),
                                child: os_svg(
                                  path: "lib/img/topic_line_image.svg",
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              radius: 10,
                              width: 30,
                              height: 29,
                            ),
                          ],
                        ),
                        Row(
                          //右边功能区
                          children: [
                            Container(
                              height: 25,
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              margin: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: os_white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                border: Border.all(
                                  color: Color(0xFF9D9D9D),
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 12,
                                      color: Color(0xFF9D9D9D),
                                    ),
                                    Text(
                                      "插入投票",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF9D9D9D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 25,
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              margin: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: os_white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                border: Border.all(
                                  color: Color(0xFF9D9D9D),
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Text(
                                      "所有人可见",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF9D9D9D),
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_up_rounded,
                                      size: 12,
                                      color: Color(0xFF9D9D9D),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SelectTag extends StatefulWidget {
  SelectTag({Key key}) : super(key: key);

  @override
  State<SelectTag> createState() => _SelectTagState();
}

class _SelectTagState extends State<SelectTag> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 27,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
        color: Color(0xFFF6F6F6),
        borderRadius: BorderRadius.all(
          Radius.circular(100),
        ),
        border: Border.all(
          color: Colors.transparent,
        ),
      ),
      child: Center(
        child: Text(
          "#水手之家",
          style: TextStyle(
            color: Color(0xFF9D9D9D),
          ),
        ),
      ),
    );
  }
}

class RightTopSend extends StatefulWidget {
  Function tap;
  RightTopSend({
    Key key,
    @required this.tap,
  }) : super(key: key);

  @override
  State<RightTopSend> createState() => _RightTopSendState();
}

class _RightTopSendState extends State<RightTopSend> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.tap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Container(
          width: 60,
          height: 25,
          decoration: BoxDecoration(
            color: Color(0xFF004DFF),
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: Center(
            child: Container(
              child: Text("发布"),
            ),
          ),
        ),
      ),
    );
  }
}
