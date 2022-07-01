import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

class DetailFixBottom extends StatefulWidget {
  var topic_id;
  var count;
  var dislike_count;
  double bottom;
  Function tapEdit;
  DetailFixBottom({
    Key key,
    this.topic_id,
    this.count,
    this.dislike_count,
    this.tapEdit,
    this.bottom,
  }) : super(key: key);

  @override
  _DetailFixBottomState createState() => _DetailFixBottomState();
}

class _DetailFixBottomState extends State<DetailFixBottom> {
  var liked = 0;
  var disliked = 0;

  void _getLikeStatus() async {
    String tmp = await getStorage(
      key: "topic_like",
    );
    List<String> ids = tmp.split(",");
    if (ids.indexOf(widget.topic_id.toString()) > -1) {
      setState(() {
        liked = 1;
      });
    }
    String tmp1 = await getStorage(
      key: "topic_dis_like",
    );
    List<String> ids1 = tmp1.split(",");
    if (ids1.indexOf(widget.topic_id.toString()) > -1) {
      setState(() {
        disliked = 1;
      });
    }
  }

  void _tapLike() async {
    if (liked == 1) return;
    liked = 1;
    setState(() {
      widget.count++;
    });
    await Api().forum_support({
      "tid": widget.topic_id,
      "type": "thread",
      "action": "support",
    });
    String tmp = await getStorage(
      key: "topic_like",
    );
    tmp += ",${widget.topic_id}";
    setStorage(key: "topic_like", value: tmp);
  }

  void _tapDisLike() async {
    if (disliked == 1) return;
    disliked = 1;
    setState(() {
      widget.dislike_count++;
    });
    await Api().forum_support({
      "tid": widget.topic_id,
      "type": "thread",
      "action": "against",
    });
    String tmp = await getStorage(key: "topic_dis_like", initData: "");
    tmp += ",${widget.topic_id}";
    setStorage(key: "topic_dis_like", value: tmp);
  }

  @override
  void initState() {
    _getLikeStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Container(
        decoration: BoxDecoration(
          color: Provider.of<ColorProvider>(context).isDark
              ? Color(0xFF222222)
              : Colors.white,
          border: Border(
            top: BorderSide(
              color: os_black_opa_opa,
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
        ),
        height: 62 + widget.bottom ?? 0,
        padding: EdgeInsets.fromLTRB(7, 7, 7, 7 + widget.bottom ?? 0),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            myInkWell(
              tap: () {
                widget.tapEdit();
              },
              radius: 10,
              color: Colors.transparent,
              widget: Container(
                width: MediaQuery.of(context).size.width - 156,
                height: 47,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 200,
                    child: Row(
                      children: [
                        Icon(
                          Icons.mode_edit,
                          color: Color(0xFFBBBBBB),
                          size: 18,
                        ),
                        Container(width: 5),
                        Text(
                          "我一出口就是神回复",
                          style: TextStyle(color: os_deep_grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  height: 47,
                  child: Center(
                    child: myInkWell(
                        tap: () {
                          if (liked == 1 || disliked == 1) return;
                          _tapDisLike();
                        },
                        color: Colors.transparent,
                        widget: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(width: 5),
                              Transform.rotate(
                                angle: 3.14,
                                child: os_svg(
                                  path: disliked == 1
                                      ? "lib/img/detail_like_blue.svg"
                                      : "lib/img/detail_like.svg",
                                  width: 25,
                                  height: 25,
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(1)),
                              Text(
                                widget.dislike_count.toString() == "0"
                                    ? ""
                                    : widget.dislike_count.toString(),
                                style: TextStyle(
                                  color: disliked == 1
                                      ? os_color
                                      : Color(0xFFB1B1B1),
                                ),
                              ),
                              Container(width: 5),
                            ],
                          ),
                        ),
                        radius: 10),
                  ),
                ),
                Container(
                  height: 47,
                  child: Center(
                    child: myInkWell(
                        tap: () {
                          if (liked == 1 || disliked == 1) return;
                          _tapLike();
                        },
                        color: Colors.transparent,
                        widget: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(width: 5),
                              os_svg(
                                path: liked == 1
                                    ? "lib/img/detail_like_blue.svg"
                                    : "lib/img/detail_like.svg",
                                width: 25,
                                height: 25,
                              ),
                              Padding(padding: EdgeInsets.all(1)),
                              Text(
                                (widget.count ?? 0).toString(),
                                style: TextStyle(
                                  color:
                                      liked == 1 ? os_color : Color(0xFFB1B1B1),
                                ),
                              ),
                              Container(width: 5),
                            ],
                          ),
                        ),
                        radius: 10),
                  ),
                ),
                Container(width: 5),
              ],
            ),
          ],
        ),
      ),
      bottom: 0,
    );
  }
}
