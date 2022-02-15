import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/time.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Topic extends StatefulWidget {
  Map data;

  Topic({Key key, this.data}) : super(key: key);

  @override
  _TopicState createState() => _TopicState();
}

class _TopicState extends State<Topic> {
  var _isRated = false;

  void _getLikeStatus() async {
    String tmp = await getStorage(
      key: "topic_like",
    );
    List<String> ids = tmp.split(",");
    if (ids.indexOf(widget.data["source_id"].toString()) > -1) {
      setState(() {
        _isRated = true;
      });
    }
  }

  void _tapLike() async {
    if (_isRated == true) return;
    _isRated = true;
    await Api().forum_support({
      "tid": widget.data["source_id"],
      "type": "thread",
      "action": "support",
      "accessToken": "e9f49ac6acace2b9f6582800f32ff",
      "accessSecret": "8aef222107fcd2cedcc5f60b4edd1",
    });
    String tmp = await getStorage(
      key: "topic_like",
    );
    tmp += ",${widget.data['source_id']}";
    setStorage(key: "topic_like", value: tmp);
  }

  @override
  void initState() {
    _getLikeStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: myInkWell(
        tap: () {
          Navigator.pushNamed(
            context,
            "/topic_detail",
            // arguments: widget.data["source_id"],
            arguments: 1903247,
          );
        },
        widget: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 16, 15, 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            width: 30,
                            height: 30,
                            imageUrl: widget.data["userAvatar"],
                            placeholder: (context, url) =>
                                Container(color: os_grey),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(4)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.data["user_nick_name"],
                              style: TextStyle(
                                color: Color(0xFF636363),
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              RelativeDateFormat.format(
                                  DateTime.fromMillisecondsSinceEpoch(int.parse(
                                      widget.data["last_reply_date"]))),
                              style: TextStyle(
                                color: Color(0xFFC4C4C4),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        myInkWell(
                          color: Colors.transparent,
                          widget: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 5,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  (widget.data["recommendAdd"] +
                                          (_isRated ? 1 : 0))
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        _isRated ? os_color : Color(0xFFB1B1B1),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.all(2)),
                                os_svg(
                                  path: _isRated
                                      ? "lib/img/detail_like_blue.svg"
                                      : "lib/img/detail_like.svg",
                                  width: 24,
                                  height: 24,
                                ),
                              ],
                            ),
                          ),
                          radius: 100,
                          tap: () {
                            setState(() {
                              _tapLike();
                            });
                          },
                        ),
                        myInkWell(
                          color: Colors.transparent,
                          widget: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: os_svg(
                              path: "lib/img/more.svg",
                              width: 14,
                              height: 14,
                            ),
                          ),
                          radius: 100,
                          tap: () {},
                        )
                      ],
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.all(1)),
                Container(
                  width: MediaQuery.of(context).size.width - 60,
                  child: Text(
                    widget.data["title"],
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(2)),
                Container(
                  width: MediaQuery.of(context).size.width - 60,
                  child: Text(
                    widget.data["summary"],
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFA3A3A3),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(7)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        os_svg(
                          path: "lib/img/comment.svg",
                          width: 12.8,
                          height: 12.8,
                        ),
                        Padding(padding: EdgeInsets.all(2)),
                        Text(
                          "评论 ${widget.data['replies']} · 浏览量 ${widget.data['hits']}",
                          style: TextStyle(
                            color: Color(0xFFC5C5C5),
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                    myInkWell(
                      tap: () {},
                      color: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      widget: Row(
                        children: [
                          Text(
                            "#${widget.data['board_name']}",
                            style: TextStyle(
                              color: os_color,
                              fontSize: 14,
                            ),
                          ),
                          Padding(padding: EdgeInsets.all(3)),
                          os_svg(
                            path: "lib/img/right_arrow.svg",
                            width: 4.66,
                            height: 8.37,
                          ),
                        ],
                      ),
                      radius: 5,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // width: width,
        // height: height,
        radius: 10,
      ),
    );
  }
}
