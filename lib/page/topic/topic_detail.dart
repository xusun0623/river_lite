import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/time.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/page/topic/detail_cont.dart';
import 'package:offer_show/util/interface.dart';

class TopicDetail extends StatefulWidget {
  int topicID;
  TopicDetail({Key key, this.topicID}) : super(key: key);

  @override
  _TopicDetailState createState() => _TopicDetailState();
}

class _TopicDetailState extends State<TopicDetail> {
  var data;
  var comments = [];

  Future _getData() async {
    data = await Api().forum_postlist({
      "topicId": widget.topicID,
      "page": comments.length / 10 + 1,
      "pageSize": 10,
    });
    Clipboard.setData(ClipboardData(text: data.toString()));
  }

  @override
  void initState() {
    super.initState();
  }

  _buildContBody() {
    List<Widget> tmp = [];
    data["topic"]["content"].forEach((e) {
      // print("隐隐约约隐隐约约一样${e}");
      tmp.add(Container(
        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: DetailCont(data: e),
      ));
    });
    return Column(children: tmp);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: os_white,
              foregroundColor: os_black,
              elevation: 0,
              title: Text(""),
              actions: [
                myInkWell(
                    color: Colors.transparent,
                    widget: Container(
                      margin: EdgeInsets.fromLTRB(5, 12, 5, 12),
                      padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                      decoration: BoxDecoration(
                        // color: Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: os_white, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                width: 23,
                                height: 23,
                                imageUrl: data["topic"]["icon"],
                                placeholder: (context, url) =>
                                    Container(color: os_grey),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(3)),
                          Text(
                            data["topic"]["user_nick_name"],
                            style: TextStyle(
                              color: Color(0xFF6D6D6D),
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(3)),
                          os_svg(
                            path: "lib/img/right_arrow_grey.svg",
                            width: 5,
                            height: 9,
                          ),
                          Padding(padding: EdgeInsets.all(3)),
                        ],
                      ),
                    ),
                    radius: 100),
                myInkWell(
                  widget: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: os_svg(
                      path: "lib/img/topic_detail_more.svg",
                      width: 29,
                      height: 29,
                    ),
                  ),
                  radius: 100,
                ),
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                color: os_white,
              ),
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: Text(
                      data["topic"]["title"],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 2, 15, 2),
                    child: Text(
                      RelativeDateFormat.format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(data["topic"]["create_date"]))) +
                          "·浏览量${data['topic']['hits'].toString()}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFC4C4C4),
                      ),
                    ),
                  ),
                  _buildContBody(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        myInkWell(
                            widget: Padding(
                              padding: EdgeInsets.fromLTRB(3, 8, 3, 8),
                              child: Text(
                                "收录自专辑: 撸猫日记 >",
                                style: TextStyle(color: os_color),
                              ),
                            ),
                            radius: 10),
                        Container(),
                        Row(children: [
                          myInkWell(
                              widget: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: [
                                  os_svg(
                                      path: "lib/img/topic_water.svg",
                                      width: 14,
                                      height: 17),
                                  Padding(padding: EdgeInsets.all(2.5)),
                                  data["topic"]["reward"] != null
                                      ? Text(
                                          data["topic"]["reward"]["score"][0]
                                                  ["value"]
                                              .toString(),
                                          style: TextStyle(color: os_deep_grey),
                                        )
                                      : Container()
                                ]),
                              ),
                              radius: 10),
                          myInkWell(
                              widget: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: [
                                  os_svg(
                                      path: "lib/img/topic_collect.svg",
                                      width: 14,
                                      height: 17),
                                ]),
                              ),
                              radius: 10),
                        ])
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Scaffold();
        }
      },
    );
  }
}
