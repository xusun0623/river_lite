import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/time.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/outer/cached_network_image/cached_image_widget.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';

class UserList extends StatefulWidget {
  Map data;
  UserList({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List data = [];
  bool load_done = false;
  ScrollController _controller = new ScrollController();

  _getData() async {
    var tmp = await Api().user_userlist({
      "page": 1,
      "pageSize": 10,
      "uid": widget.data["uid"],
      "type": ["followed", "follow"][widget.data["type"]],
    });
    if (tmp != null && tmp["list"] != null) {
      setState(() {
        data = tmp["list"];
        load_done = data.length % 10 != 0;
      });
    }
  }

  _getMore() async {
    if (load_done) return;
    var tmp = await Api().user_userlist({
      "page": (data.length / 10).ceil() + 1,
      "pageSize": 10,
      "uid": widget.data["uid"],
      "type": ["followed", "follow"][widget.data["type"]],
    });
    if (tmp != null && tmp["list"] != null) {
      setState(() {
        data.addAll(tmp["list"]);
        load_done = data.length % 10 != 0;
      });
    }
  }

  List<Widget> _buildCont() {
    List<Widget> tmp = [];
    data.forEach((element) {
      tmp.add(UserListCard(data: element));
    });
    if (!load_done) tmp.add(BottomLoading(color: Colors.transparent));
    return tmp;
  }

  @override
  void initState() {
    _getData();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        _getMore();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: os_back,
        foregroundColor: os_black,
        elevation: 0,
        title: Text(
          widget.data["type"] == 0 ? "粉丝" : "关注",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: os_back,
      body: RefreshIndicator(
        onRefresh: () async {
          return await _getData();
        },
        child: ListView(
          controller: _controller,
          physics: BouncingScrollPhysics(),
          children: _buildCont(),
        ),
      ),
    );
  }
}

class UserListCard extends StatefulWidget {
  Map data;
  UserListCard({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  State<UserListCard> createState() => _UserListCardState();
}

class _UserListCardState extends State<UserListCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: os_edge, vertical: 5),
      child: myInkWell(
        tap: () {
          Navigator.pushNamed(
            context,
            "/person_center",
            arguments: {"uid": widget.data["uid"], "isMe": false},
          );
        },
        widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: os_grey,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  imageUrl: widget.data["icon"],
                ),
              ),
              Container(width: 15),
              Container(
                width: MediaQuery.of(context).size.width - 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.data["name"],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(width: 5),
                        widget.data["userTitle"].toString().length < 6
                            ? Tag(
                                txt: widget.data["userTitle"],
                                color: os_white,
                                color_opa: os_wonderful_color[1],
                              )
                            : Container(),
                      ],
                    ),
                    Container(height: 5),
                    Text(
                      widget.data["signature"] == ""
                          ? "这位畔友很懒，什么也没写"
                          : widget.data["signature"],
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF9F9F9F),
                      ),
                    ),
                    Container(height: 5),
                    Text(
                      RelativeDateFormat.format(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(widget.data["lastLogin"]),
                            ),
                          ) +
                          "在线",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFBBBBBB),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        radius: 10,
      ),
    );
  }
}
