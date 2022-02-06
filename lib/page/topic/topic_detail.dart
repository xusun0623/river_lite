import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/time.dart';
import 'package:offer_show/components/niw.dart';
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
    print("${data["icon"]}");
    // print("$data");
  }

  @override
  void initState() {
    _getData();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: os_white,
        foregroundColor: os_black,
        elevation: 0,
        title: Text(""),
        actions: [
          FutureBuilder(
            future: _getData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (data["topic"] == null) return Center(child: Text(""));
                return myInkWell(
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
                    radius: 100);
              } else
                return Container();
            },
          ),
          IconButton(
            onPressed: () {},
            icon: Container(
              width: 32,
              height: 32,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: os_grey,
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              child: os_svg(
                path: "lib/img/topic_detail_more.svg",
                width: 16,
                height: 4,
              ),
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: os_white,
        ),
        child: FutureBuilder(
            future: _getData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (data["topic"] == null) return Center(child: Text("加载失败:("));
                return ListView(
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
                  ],
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}

class DetailCont extends StatefulWidget {
  var data;
  DetailCont({Key key, this.data}) : super(key: key);

  @override
  _DetailContState createState() => _DetailContState();
}

class _DetailContState extends State<DetailCont> {
  @override
  void initState() {
    print("啧啧啧啧啧啧${widget.data["type"]}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.data["type"]) {
      case 0:
        return Container(
          width: MediaQuery.of(context).size.width - 30,
          child: Text(widget.data["infor"], style: TextStyle(fontSize: 16)),
        );
        break;
      case 1:
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(
            decoration: BoxDecoration(
              color: os_grey,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: CachedNetworkImage(
              imageUrl: widget.data["infor"],
              fadeInDuration: Duration(milliseconds: 200),
              placeholder: (context, url) => Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(color: os_deep_grey),
              ),
            ),
          ),
        );
        break;
      case 2:
        return Container();
        break;
      case 3:
        return Container();
        break;
      case 4:
        return GestureDetector(
          onTap: () {
            print("跳转链接${widget.data['url']}");
          },
          child: Container(
            width: MediaQuery.of(context).size.width - 30,
            child: Text(
              widget.data["infor"],
              style: TextStyle(color: os_color, fontSize: 16),
            ),
          ),
        );
        break;
      case 5:
        return myInkWell(
          color: Color(0xFFF6F6F6),
          tap: () {},
          radius: 10,
          widget: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            width: MediaQuery.of(context).size.width - 30,
            padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "附件" + widget.data["desc"],
                  style: TextStyle(color: os_deep_grey),
                ),
                Text(
                  "点击下载",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: os_color,
                  ),
                ),
              ],
            ),
          ),
        );
        break;
      default:
    }
  }
}
