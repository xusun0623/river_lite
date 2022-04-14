import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/empty.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/components/topic.dart';
import 'package:offer_show/components/totop.dart';
import 'package:offer_show/outer/cached_network_image/cached_image_widget.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/interface.dart';

class PersonCenter extends StatefulWidget {
  Map param;
  //{"uid": 221788, "isMe": true},
  PersonCenter({
    Key key,
    this.param,
  }) : super(key: key);

  @override
  _PersonCenterState createState() => _PersonCenterState();
}

class _PersonCenterState extends State<PersonCenter> {
  int index = 0;
  List data = [];

  int sendNum = 0;
  int replyNum = 0;

  bool loading = false;
  bool load_done = false;
  bool showBackToTop = false;

  ScrollController _controller = new ScrollController();

  _getData() async {
    if (loading) return;
    loading = true;
    var tmp = await Api().user_topiclist({
      "type": ["topic", "reply"][index],
      "uid": widget.param["uid"],
      "page": 1,
      "pageSize": 10,
    });
    if (tmp != null && tmp["list"] != null && tmp["list"].length != 0) {
      data = tmp["list"];
      load_done = data.length % 10 != 0;
      sendNum = index == 0 ? tmp["total_num"] : sendNum;
      replyNum = index == 1 ? tmp["total_num"] : replyNum;
      setState(() {});
    }
    loading = false;
  }

  _getMore() async {
    if (loading) return;
    loading = true;
    var tmp = await Api().user_topiclist({
      "type": ["topic", "reply"][index],
      "uid": widget.param["uid"],
      "page": (data.length / 10).ceil() + 1,
      "pageSize": 10,
    });
    if (tmp != null && tmp["list"] != null && tmp["list"].length != 0) {
      data.addAll(tmp["list"]);
      load_done = data.length % 10 != 0;
      setState(() {});
    }
    loading = false;
  }

  List<Widget> _buildCont() {
    List<Widget> tmp = [
      PersonCard(),
      PersonIndex(
        index: index,
        sendNum: sendNum,
        replyNum: replyNum,
        isMe: widget.param["isMe"],
        tapIndex: (idx) {
          setState(() {
            index = idx;
            data = [];
            load_done = false;
          });
          _getData();
        },
      ),
    ];
    if (data.length == 0 && load_done) {
      tmp.add(Empty());
    }
    data.forEach((element) {
      tmp.add(Topic(
        backgroundColor: Colors.white54,
        data: element,
        top: 0,
        bottom: 10,
      ));
    });
    if (!load_done) {
      tmp.add(BottomLoading(color: Colors.transparent));
    }
    tmp.add(Container(height: 20));
    return tmp;
  }

  @override
  void initState() {
    // TODO: implement initState
    _getData();
    _controller.addListener(() {
      if (_controller.position.pixels > 1000 && !showBackToTop) {
        setState(() {
          showBackToTop = true;
        });
      }
      if (_controller.position.pixels < 1000 && showBackToTop) {
        setState(() {
          showBackToTop = false;
        });
      }
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
        elevation: 0,
        foregroundColor: os_black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left_rounded),
        ),
        backgroundColor: Color(0xFFF3F3F3),
      ),
      backgroundColor: Color(0xFFF3F3F3),
      body: BackToTop(
        show: showBackToTop,
        controller: _controller,
        bottom: 100,
        child: ListView(
          physics: BouncingScrollPhysics(),
          controller: _controller,
          children: _buildCont(),
        ),
      ),
    );
  }
}

class PersonIndex extends StatefulWidget {
  int index;
  bool isMe;
  Function tapIndex;
  int sendNum;
  int replyNum;

  PersonIndex({
    Key key,
    this.index = 0,
    this.tapIndex,
    this.isMe,
    this.replyNum,
    this.sendNum,
  }) : super(key: key);

  @override
  State<PersonIndex> createState() => _PersonIndexState();
}

class _PersonIndexState extends State<PersonIndex> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PersonIndexTab(
            tap: (idx) {
              widget.tapIndex(0);
            },
            countNum: widget.sendNum,
            isMe: widget.isMe,
            select: widget.index == 0,
            index: 0,
          ),
          PersonIndexTab(
            tap: (idx) {
              widget.tapIndex(1);
            },
            countNum: widget.replyNum,
            isMe: widget.isMe,
            select: widget.index == 1,
            index: 1,
          ),
        ],
      ),
    );
  }
}

class PersonIndexTab extends StatefulWidget {
  Function tap;
  int index;
  int countNum;
  bool select;
  bool isMe;

  PersonIndexTab({
    Key key,
    this.tap,
    this.index,
    this.select,
    this.isMe,
    this.countNum,
  }) : super(key: key);

  @override
  State<PersonIndexTab> createState() => _PersonIndexTabState();
}

class _PersonIndexTabState extends State<PersonIndexTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: myInkWell(
        tap: () {
          widget.tap(widget.index);
        },
        color: Colors.transparent,
        radius: 25,
        widget: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          width: (MediaQuery.of(context).size.width - 90) / 2,
          child: Column(
            children: [
              Text(
                [
                      widget.isMe ? "我的发表" : "ta的发表",
                      widget.isMe ? "我的回复" : "ta的回复"
                    ][widget.index] +
                    (widget.countNum == 0 ? "" : "(${widget.countNum})"),
                style: TextStyle(
                  color: widget.select ? os_black : Color(0xFF7B7B7B),
                ),
              ),
              Container(height: 5),
              Container(
                width: 13,
                height: 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: widget.select ? os_deep_blue : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonCard extends StatefulWidget {
  PersonCard({Key key}) : super(key: key);

  @override
  State<PersonCard> createState() => _PersonCardState();
}

class _PersonCardState extends State<PersonCard> {
  int gender = 1;
  BoxDecoration _getBoxDecoration() {
    return BoxDecoration(
        color: os_white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            offset: Offset(2, 2),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Column(
            children: [
              Container(height: 60),
              Container(
                margin: EdgeInsets.only(left: os_edge, right: os_edge),
                padding:
                    EdgeInsets.only(left: 25, right: 25, top: 40, bottom: 30),
                width: MediaQuery.of(context).size.width - 2 * os_edge,
                decoration: _getBoxDecoration(),
                child: Column(
                  children: [
                    PersonName(name: "xusun000"),
                    Container(height: 10),
                    PersonScore(score: 388, gender: gender),
                    Container(height: 30),
                    PersonRow(),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 20,
            child: os_svg(
              path: "lib/img/person/${gender}.svg",
              width: 143,
              height: 166,
            ),
          ),
          Positioned(
            left: 32,
            top: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              child: CachedNetworkImage(
                imageUrl:
                    "https://bbs.uestc.edu.cn/uc_server/avatar.php?uid=221788&size=middle",
                width: 66,
                height: 66,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: os_grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PersonRow extends StatefulWidget {
  PersonRow({Key key}) : super(key: key);

  @override
  State<PersonRow> createState() => _PersonRowState();
}

class _PersonRowState extends State<PersonRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PersonColumn(index: 0),
        Container(width: 1, height: 27, color: Color(0xFFF1F1F1)),
        PersonColumn(index: 1),
        Container(width: 1, height: 27, color: Color(0xFFF1F1F1)),
        PersonColumn(index: 2),
      ],
    );
  }
}

class PersonColumn extends StatefulWidget {
  int index;
  PersonColumn({
    Key key,
    this.index,
  }) : super(key: key);

  @override
  State<PersonColumn> createState() => _PersonColumnState();
}

class _PersonColumnState extends State<PersonColumn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 100) / 3,
      child: Column(
        children: [
          Text(
            ["粉丝", "关注", "好友"][widget.index],
            style: TextStyle(
              color: Color(0xFF939393),
              fontSize: 12,
            ),
          ),
          Container(height: 7.5),
          Text(
            ["1", "0", "0"][widget.index],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class PersonScore extends StatefulWidget {
  int score;
  int gender;
  PersonScore({
    Key key,
    @required this.score,
    this.gender,
  }) : super(key: key);

  @override
  State<PersonScore> createState() => PersonScoreState();
}

class PersonScoreState extends State<PersonScore> {
  List map_tmp = [
    0,
    30,
    100,
    500,
    800,
    1200,
    2000,
    3000,
    4500,
    7000,
    10000,
    15000,
    30000,
  ];

  _getLevel() {
    var score = widget.score;
    for (int i = 0; i < map_tmp.length; i++) {
      if (map_tmp[i] > score) {
        return i;
      }
    }
    return "??";
  }

  _getRate() {
    var score = widget.score;
    for (int i = 0; i < map_tmp.length; i++) {
      if (map_tmp[i] > score) {
        return score / map_tmp[i];
      }
    }
    return 0.999;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("Lv.${_getLevel()}", style: TextStyle(color: Color(0xFF707070))),
        Container(width: 5),
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 220,
              height: 7,
              decoration: BoxDecoration(
                color: Color(0xFFE3E3E3),
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
            ),
            Positioned(
              child: Container(
                width: (MediaQuery.of(context).size.width - 220) * _getRate(),
                height: 7,
                decoration: BoxDecoration(
                  color: widget.gender == 1 ? os_deep_blue : Color(0xFFFF6B3D),
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PersonName extends StatelessWidget {
  String name;
  PersonName({
    Key key,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Container(width: 5),
          Icon(
            Icons.edit_note_sharp,
            color: Color(0xFFBABABA),
            size: 20,
          ),
        ],
      ),
    );
  }
}
