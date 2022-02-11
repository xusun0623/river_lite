import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/time.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/page/topic/detail_cont.dart';
import 'package:offer_show/util/interface.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class TopicDetail extends StatefulWidget {
  int topicID;
  TopicDetail({Key key, this.topicID}) : super(key: key);

  @override
  _TopicDetailState createState() => _TopicDetailState();
}

class _TopicDetailState extends State<TopicDetail> {
  var data;
  var comment = [];
  var load_done = false;
  var loading = false;
  ScrollController _scrollController = new ScrollController();

  Future _getData() async {
    data = await Api().forum_postlist({
      "topicId": widget.topicID,
      "page": (comment.length / 10 + 1).floor(),
      "pageSize": 10,
    });
    comment.addAll(data["list"]);
    load_done = (data["list"].length != 10);
    setState(() {});
  }

  void _getComment() async {
    if (loading) return; //控制因为网络过慢反复请求问题
    loading = true;
    const nums = 10;
    var tmp = await Api().forum_postlist({
      "topicId": widget.topicID,
      "page": (comment.length / nums + 1).floor(),
      "pageSize": nums,
    });
    if (tmp["list"].length != 0 && comment.length % nums == 0)
      comment.addAll(tmp["list"]);
    load_done = (tmp["list"].length != nums);
    setState(() {});
    loading = false;
  }

  @override
  void initState() {
    _getData();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getComment();
      }
    });
  }

  _buildContBody() {
    List<Widget> tmp = [];
    data["topic"]["content"].forEach((e) {
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
      appBar: data == null
          ? AppBar(
              backgroundColor: os_white,
              foregroundColor: os_black,
              elevation: 0,
            )
          : AppBar(
              backgroundColor: os_white,
              foregroundColor: os_black,
              elevation: 0,
              title: Text(""),
              actions: [
                TopicDetailHead(data: data),
                TopicDetailMore(),
              ],
            ),
      body: data == null
          ? Container()
          : Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: os_white,
                  ),
                  child: ListView(
                    physics: ClampingScrollPhysics(),
                    controller: _scrollController,
                    children: [
                      TopicDetailTitle(data: data),
                      TopicDetailTime(data: data),
                      _buildContBody(),
                      TopicBottom(data: data),
                      Container(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Color(0xFFF6F6F6),
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                      Comments(data: comment),
                      load_done ? Container() : BottomLoading(),
                      Container(height: 60),
                    ],
                  ),
                ),
                DetailFixBottom()
              ],
            ),
    );
  }
}

class BottomLoading extends StatelessWidget {
  const BottomLoading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF6F6F6),
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Color(0xFFAAAAAA),
                strokeWidth: 2.5,
              ),
            ),
            Container(width: 10),
            Text("加载中…", style: TextStyle(color: os_deep_grey)),
          ],
        ),
      ),
    );
  }
}

class Comments extends StatefulWidget {
  var data;
  Comments({Key key, this.data}) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  var select = 0; //Tab标签
  var sort = 0; //0-按时间排序 1-按点赞排序
  Widget _buildComment() {
    List<Widget> t = [];
    for (var i = 0; i < widget.data.length; i++) {
      t.add(Comment(
        data: widget.data[i],
        is_last: i == widget.data.length - 1,
      ));
    }
    return Column(children: t);
  }

  @override
  Widget build(BuildContext context) {
    return StickyHeader(
      header: CommentTab(
        TapSelect: (idx) {
          setState(() {
            select = idx;
          });
        },
        TapSort: () {
          setState(() {
            sort = 1 - sort;
          });
        },
        select: select,
        sort: sort,
      ),
      content: _buildComment(),
    );

    //  Column(
    //   children: [
    //     CommentTab(
    //       TapSelect: (idx) {
    //         setState(() {
    //           select = idx;
    //         });
    //       },
    //       TapSort: () {
    //         setState(() {
    //           sort = 1 - sort;
    //         });
    //       },
    //       select: select,
    //       sort: sort,
    //     ),
    //     _buildComment(),
    //   ],
    // ),
  }
}

class CommentTab extends StatefulWidget {
  Function TapSelect;
  Function TapSort;
  var select;
  var sort;
  CommentTab({Key key, this.TapSelect, this.TapSort, this.select, this.sort})
      : super(key: key);

  @override
  _CommentTabState createState() => _CommentTabState();
}

class _CommentTabState extends State<CommentTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      color: os_white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  widget.TapSelect(0);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    Text(
                      "评论区",
                      style: TextStyle(
                        color: Color(0xFF454545),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(height: 3),
                    Container(
                      width: 18,
                      height: 3,
                      decoration: BoxDecoration(
                        color:
                            widget.select == 0 ? os_color : Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    )
                  ]),
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.TapSelect(1);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    Text(
                      "只看楼主",
                      style: TextStyle(
                        color: Color(0xFF454545),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(height: 3),
                    Container(
                      width: 18,
                      height: 3,
                      decoration: BoxDecoration(
                        color:
                            widget.select == 1 ? os_color : Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    )
                  ]),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              os_svg(
                path: "lib/img/detail_sort.svg",
                width: 15,
                height: 12,
              ),
              Container(width: 5),
              GestureDetector(
                onTap: () {
                  widget.TapSort();
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 2),
                  child: Text(
                    widget.sort == 0 ? "按时间排序" : "按点赞排序",
                    style: TextStyle(
                      color: os_color,
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class Comment extends StatefulWidget {
  var data;
  var is_last;
  Comment({Key key, this.data, this.is_last}) : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  _buildContBody(data) {
    List<Widget> tmp = [];
    data.forEach((e) {
      tmp.add(Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: DetailCont(data: e),
      ));
    });
    return Column(children: tmp);
  }

  @override
  Widget build(BuildContext context) {
    return myInkWell(
      color: Colors.transparent,
      widget: Padding(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              child: CachedNetworkImage(
                imageUrl: widget.data["icon"],
                placeholder: (context, url) =>
                    Container(color: os_grey, width: 35, height: 35),
                width: 35,
                height: 35,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 75,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.data["reply_name"],
                            style: TextStyle(
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Container(width: 8),
                          Container(
                            padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
                            decoration: BoxDecoration(
                              color: os_color_opa,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Text("楼主·沙发",
                                style: TextStyle(
                                  color: os_color,
                                  fontSize: 12,
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [Text("data")],
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 3, 0, 10),
                    width: MediaQuery.of(context).size.width - 75,
                    child: Text(
                      RelativeDateFormat.format(
                        DateTime.fromMillisecondsSinceEpoch(
                            int.parse(widget.data["posts_date"])),
                      ),
                      style: TextStyle(
                        color: Color(0xFF9F9F9F),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  _buildContBody(widget.data["reply_content"]),
                  widget.data["quote_content"] != ""
                      ? Container(
                          width: MediaQuery.of(context).size.width - 75,
                          padding: EdgeInsets.fromLTRB(16, 13, 16, 13),
                          margin: EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: Color(0x09000000),
                            borderRadius: BorderRadius.all(Radius.circular(13)),
                          ),
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(fontSize: 14),
                                children: [
                                  TextSpan(
                                    text: "回复@" +
                                        widget.data["quote_content"]
                                            .split(" 发表于")[0] +
                                        ": ",
                                    style: TextStyle(
                                      color: os_color,
                                    ),
                                  ),
                                  TextSpan(
                                    text: widget.data["quote_content"]
                                        .split("发表于")[1]
                                        .split("\n")[1],
                                    style: TextStyle(color: Color(0xFF464646)),
                                  ),
                                ]),
                          ),
                        )
                      : Container(),
                  widget.is_last
                      ? Container(
                          margin: EdgeInsets.only(top: 20),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width - 75,
                          height: 1,
                          margin: EdgeInsets.only(top: 20),
                          color: Color(0x07000000),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
      radius: 0,
    );
  }
}

class DetailFixBottom extends StatelessWidget {
  const DetailFixBottom({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: os_black_opa_opa,
              width: 1,
              style: BorderStyle.solid,
            ),
          ),
        ),
        height: 62,
        padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            myInkWell(
              radius: 10,
              color: os_white,
              widget: Container(
                width: MediaQuery.of(context).size.width - 76,
                height: 47,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 120,
                    child: Text(
                      "我一出口就是神回复",
                      style: TextStyle(color: os_deep_grey),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 62,
              height: 47,
              child: Center(
                child: myInkWell(
                    color: Colors.transparent,
                    widget: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite, color: Color(0xFFcccccc)),
                          Padding(padding: EdgeInsets.all(1)),
                          Text("3", style: TextStyle(color: Color(0xFFcccccc))),
                        ],
                      ),
                    ),
                    radius: 10),
              ),
            ),
          ],
        ),
      ),
      bottom: 0,
    );
  }
}

class TopicBottom extends StatefulWidget {
  TopicBottom({Key key, this.data}) : super(key: key);

  final data;

  @override
  _TopicBottomState createState() => _TopicBottomState();
}

class _TopicBottomState extends State<TopicBottom> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          myInkWell(
              color: os_color_opa,
              widget: Padding(
                padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
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
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        os_svg(
                            path: "lib/img/topic_water.svg",
                            width: 14,
                            height: 17),
                        Padding(
                            padding: EdgeInsets.all(
                                widget.data["topic"]["reward"] != null
                                    ? 2.5
                                    : 0)),
                        widget.data["topic"]["reward"] != null
                            ? Text(
                                widget.data["topic"]["reward"]["score"][0]
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
    );
  }
}

// 帖子浏览量和时间
class TopicDetailTime extends StatelessWidget {
  const TopicDetailTime({
    Key key,
    @required this.data,
  }) : super(key: key);

  final data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Text(
        RelativeDateFormat.format(DateTime.fromMillisecondsSinceEpoch(
                int.parse(data["topic"]["create_date"]))) +
            "·浏览量${data['topic']['hits'].toString()}",
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFFC4C4C4),
        ),
      ),
    );
  }
}

// 帖子标题
class TopicDetailTitle extends StatelessWidget {
  const TopicDetailTitle({
    Key key,
    @required this.data,
  }) : super(key: key);

  final data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Text(
        data["topic"]["title"],
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// 更多操作
class TopicDetailMore extends StatelessWidget {
  const TopicDetailMore({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return myInkWell(
      widget: Padding(
        padding: const EdgeInsets.all(10.0),
        child: os_svg(
          path: "lib/img/topic_detail_more.svg",
          width: 29,
          height: 29,
        ),
      ),
      radius: 100,
    );
  }
}

// 楼主名字头像
class TopicDetailHead extends StatelessWidget {
  const TopicDetailHead({
    Key key,
    @required this.data,
  }) : super(key: key);

  final data;

  @override
  Widget build(BuildContext context) {
    return myInkWell(
        color: Colors.transparent,
        widget: Container(
          margin: EdgeInsets.fromLTRB(5, 12, 5, 12),
          padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: os_white, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    width: 23,
                    height: 23,
                    imageUrl: data["topic"]["icon"],
                    placeholder: (context, url) => Container(color: os_grey),
                    errorWidget: (context, url, error) => Icon(Icons.error),
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
  }
}
