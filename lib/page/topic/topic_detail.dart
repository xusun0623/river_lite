import 'dart:async';
import 'dart:ffi';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/asset/time.dart';
import 'package:offer_show/components/empty.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/components/nomore.dart';
import 'package:offer_show/components/totop.dart';
import 'package:offer_show/page/topic/detail_cont.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

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
  var _select = 0; //0-全部回复 1-只看楼主
  var _sort = 0; //0-按时间正序 1-按时间倒序
  var showBackToTop = false;
  var uploadImgUrls = [];
  var replyId = 0;
  bool editing = false; //是否处于编辑状态
  String placeholder = "请在此编辑回复";
  List<Map> atUser = [];
  ScrollController _scrollController = new ScrollController();

  TextEditingController _txtController = new TextEditingController();
  FocusNode _focusNode = new FocusNode();

  Future _getData() async {
    data = await Api().forum_postlist({
      "topicId": widget.topicID,
      "authorId": _select == 0 ? 0 : data["topic"]["user_id"],
      "order": _sort,
      "page": 1,
      "pageSize": 20,
    });
    comment = data["list"];
    load_done = ((data["list"] ?? []).length < 20);
    setState(() {});
    return;
  }

  void _getComment() async {
    if (loading || load_done) return; //控制因为网络过慢反复请求问题
    loading = true;
    const nums = 10;
    var tmp = await Api().forum_postlist({
      "topicId": widget.topicID,
      "authorId": _select == 0 ? 0 : data["topic"]["user_id"],
      "order": _sort,
      "page": (comment.length / nums + 1).floor(),
      "pageSize": nums,
    });
    if (tmp["list"] != null && tmp["list"].length != 0) {
      comment.addAll(tmp["list"]);
    }
    load_done = ((tmp["list"] ?? []).length < nums);
    setState(() {});
    loading = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool vibrate = false;

  @override
  void initState() {
    _getData();
    super.initState();
    _scrollController.addListener(() {
      // print("${_scrollController.position.pixels}");
      if (_scrollController.position.pixels < -100) {
        if (!vibrate) {
          vibrate = true; //不允许再震动
          Vibrate.feedback(FeedbackType.impact);
        }
      }
      if (_scrollController.position.pixels >= 0) {
        vibrate = false; //允许震动
      }
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getComment();
      }
      if (_scrollController.position.pixels > 1000 && !showBackToTop) {
        setState(() {
          showBackToTop = true;
        });
      }
      if (_scrollController.position.pixels < 1000 && showBackToTop) {
        setState(() {
          showBackToTop = false;
        });
      }
    });
  }

  _buildContBody() {
    List<Widget> tmp = [];
    var imgLists = [];
    String s_tmp = "";
    data["topic"]["content"].forEach((e) {
      if (e["type"] == 1) {
        imgLists.add(e["infor"]);
      }
      if (e["type"] == 0) {
        s_tmp += e["infor"] + "\n";
      }
    });
    data["topic"]["content"].forEach((e) {
      tmp.add(GestureDetector(
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: s_tmp));
          Vibrate.feedback(FeedbackType.impact);
          showToast(
            context: context,
            type: XSToast.success,
            txt: "复制文本成功",
          );
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
          child: DetailCont(data: e, imgLists: imgLists),
        ),
      ));
    });
    return Column(children: tmp);
  }

  _buildTotal() {
    List<Widget> tmp = [];
    tmp = [
      TopicDetailTitle(data: data),
      TopicDetailTime(data: data),
      _buildContBody(),
      data["topic"]["poll_info"] != null
          ? TopicVote(
              topic_id: data["topic"]["topic_id"],
              poll_info: data["topic"]["poll_info"],
            )
          : Container(),
      TopicBottom(
        data: data,
      ),
      Container(height: 10),
      Divider(context: context),
      CommentsTab(
        select: _select,
        sort: _sort,
        bindSelect: (select) async {
          _select = select;
          showToast(context: context, type: XSToast.loading);
          await _getData();
          hideToast();
        },
        bindSort: (sort) async {
          _sort = sort;
          await Future.delayed(Duration(milliseconds: 30));
          showToast(
            context: context,
            type: XSToast.loading,
            txt: "切换排序中…",
          );
          await _getData();
          hideToast();
        },
        host_id: data["topic"]["user_id"],
        data: [],
        topic_id: data["topic"]["topic_id"],
      ),
    ];
    tmp.add(comment.length == 0
        ? Empty(txt: _select == 0 ? "暂无评论, 快去抢沙发吧~" : "楼主没有发表评论~")
        : Container());
    for (var i = 0; i < comment.length; i++) {
      tmp.add(Comment(
        index: i,
        tap: (reply_id, reply_name) {
          //回复别人
          replyId = reply_id;
          editing = true;
          _focusNode.requestFocus();
          placeholder = "回复@${reply_name}：";
          print("回复信息${placeholder}${replyId}");
          setState(() {});
        },
        host_id: data["topic"]["user_id"],
        topic_id: data["topic"]["topic_id"],
        data: comment[i],
        is_last: i == (comment.length - 1),
      ));
    }
    tmp.addAll([
      load_done
          ? NoMore()
          : BottomLoading(
              color: Colors.transparent,
            ),
      load_done
          ? Container()
          : Container(
              height: 30,
            ),
      Container(height: editing ? 250 : 60)
    ]);
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: data == null || data["topic"] == null
          ? AppBar(
              backgroundColor: os_white,
              foregroundColor: os_black,
              leading: IconButton(
                icon: Icon(Icons.chevron_left_rounded),
                color: os_black,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              elevation: 0,
            )
          : AppBar(
              backgroundColor: os_white,
              foregroundColor: os_black,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.chevron_left_rounded),
                color: os_black,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(""),
              actions: [
                TopicDetailHead(data: data),
                TopicDetailMore(),
              ],
            ),
      body: data == null || data["topic"] == null
          ? Container()
          : Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: os_white,
                  ),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await _getData();
                      vibrate = false;
                      return;
                    },
                    child: BackToTop(
                      bottom: 100,
                      show: showBackToTop,
                      animation: true,
                      controller: _scrollController,
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        controller: _scrollController,
                        children: _buildTotal(),
                      ),
                    ),
                  ),
                ),
                editing //编辑回复框
                    ? RichInput(
                        uploadImg: (img_urls) {
                          if (img_urls != null && img_urls.length != 0) {
                            uploadImgUrls = [];
                            for (var i = 0; i < img_urls.length; i++) {
                              uploadImgUrls.add(img_urls[i]["urlName"]);
                            }
                          }
                        },
                        atUser: (List<Map> map) {
                          atUser = map;
                        },
                        placeholder: placeholder,
                        controller: _txtController,
                        focusNode: _focusNode,
                        cancel: () {
                          _focusNode.unfocus();
                          _txtController.clear();
                          placeholder = "请在此编辑回复";
                          uploadImgUrls = [];
                          editing = false;
                          setState(() {});
                        },
                        send: () async {
                          var contents = [
                            {
                              "type": 0, // 0：文本（解析链接）；1：图片；3：音频;4:链接;5：附件
                              "infor": _txtController.text,
                            },
                          ];
                          for (var i = 0; i < uploadImgUrls.length; i++) {
                            contents.add({
                              "type": 1, // 0：文本（解析链接）；1：图片；3：音频;4:链接;5：附件
                              "infor": uploadImgUrls[i],
                            });
                          }
                          Map json = {
                            "body": {
                              "json": {
                                "isAnonymous": 0,
                                "isOnlyAuthor": 0,
                                "typeId": "",
                                "aid": "",
                                "fid": "",
                                "replyId": replyId,
                                "tid": widget.topicID, // 回复时指定帖子
                                "isQuote": placeholder == "请在此编辑回复"
                                    ? 0
                                    : 1, //"是否引用之前回复的内容
                                // "replyId": 123456, //回复 ID（pid）
                                // "aid": "1,2,3", // 附件 ID，逗号隔开
                                "title": "",
                                "content": jsonEncode(contents),
                              }
                            }
                          };
                          showToast(
                            context: context,
                            type: XSToast.loading,
                            txt: "发表中…",
                          );
                          await Api().forum_topicadmin(
                            {
                              "act": "reply",
                              "json": jsonEncode(json),
                            },
                          );
                          hideToast();
                          _focusNode.unfocus();
                          _txtController.clear();
                          placeholder = "请在此编辑回复";
                          uploadImgUrls = [];
                          editing = false;
                          setState(() {});
                          await Future.delayed(Duration(milliseconds: 30));
                          await _getData();
                          showToast(
                            context: context,
                            type: XSToast.success,
                            duration: 200,
                            txt: "发表成功!",
                          );
                        },
                      )
                    : DetailFixBottom(
                        tapEdit: () {
                          _focusNode.requestFocus();
                          editing = true;
                          setState(() {});
                        },
                        topic_id: data["topic"]["topic_id"],
                        count: data["topic"]["extraPanel"][1]["extParams"]
                            ["recommendAdd"],
                      )
              ],
            ),
    );
  }
}

class RichInput extends StatefulWidget {
  double bottom;
  TextEditingController controller;
  FocusNode focusNode;
  Function cancel;
  Function send;
  Function uploadImg;
  String placeholder;
  Function atUser;
  RichInput({
    Key key,
    this.bottom,
    @required this.controller,
    @required this.focusNode,
    @required this.cancel,
    @required this.send,
    @required this.uploadImg,
    @required this.atUser,
    @required this.placeholder,
  }) : super(key: key);

  @override
  _RichInputState createState() => _RichInputState();
}

class _RichInputState extends State<RichInput> with TickerProviderStateMixin {
  List<XFile> image = [];
  List<PlatformFile> files = [];
  bool popSection = false;

  AnimationController controller; //动画控制器
  Animation<double> animation;
  double popHeight = 0;

  _foldPop() async {
    controller.reverse();
    setState(() {
      popSection = false;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        _foldPop();
      }
    });
    controller = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animation = Tween(begin: 0.0, end: 200.0).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {
          popHeight = animation.value;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    List<Map> at_user = [];
    return Positioned(
      bottom: widget.bottom ?? 0,
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 250,
            decoration: BoxDecoration(
                color: os_white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 7,
                    offset: Offset(1, -2),
                  )
                ]),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          SendFunc(
                            path: "lib/img/topic_emoji.svg",
                            tap: () {},
                          ),
                          SendFunc(
                            path: "lib/img/topic_@.svg",
                            tap: () async {
                              widget.focusNode.unfocus();
                              popSection = true;
                              controller.forward();
                              setState(() {});
                            },
                          ),
                          SendFunc(
                            nums: image.length == 0 ? null : image.length,
                            path: "lib/img/topic_picture.svg",
                            tap: () async {
                              final ImagePicker _picker = ImagePicker();
                              //选好了图片
                              image = await _picker.pickMultiImage(
                                    imageQuality: 50,
                                  ) ??
                                  [];
                              var img_urls =
                                  await Api().uploadImage(image) ?? [];
                              widget.uploadImg(img_urls);
                              setState(() {});
                            },
                          ),
                          //上传附件，暂时不支持
                          // SendFunc(
                          //   path: "lib/img/topic_attach.svg",
                          // ),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        height: 185,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          focusNode: widget.focusNode,
                          controller: widget.controller,
                          style: TextStyle(
                            height: 1.8,
                          ),
                          cursorColor: Color(0xFF004DFF),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: widget.placeholder ?? "请在此编辑回复",
                            hintStyle: TextStyle(
                              height: 1.8,
                              color: Color(0xFFBBBBBB),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    myInkWell(
                      tap: () {
                        widget.cancel();
                      },
                      widget: Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: 60,
                        child: Center(
                          child: Text(
                            "取消",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF656565),
                            ),
                          ),
                        ),
                      ),
                      radius: 15,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 15),
                      child: myInkWell(
                        tap: () {
                          widget.send();
                        },
                        color: Color(0xFF004DFF),
                        widget: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: 100,
                          child: Center(
                            child: Text(
                              "发\n送",
                              style: TextStyle(
                                color: os_white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        radius: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          popSection
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  color: os_white,
                  height: popHeight,
                  child: AtSomeone(
                    tap: (uid, name) {
                      at_user.add({uid: uid, name: name});
                      widget.atUser(at_user);
                      widget.controller.text =
                          widget.controller.text + " @${name} ";
                      setState(() {});
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class AtSomeone extends StatefulWidget {
  Function tap;
  AtSomeone({Key key, @required this.tap}) : super(key: key);

  @override
  State<AtSomeone> createState() => _AtSomeoneState();
}

class _AtSomeoneState extends State<AtSomeone> {
  var list = [];
  bool load_done = false;
  bool load_finish = false;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    _getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getData();
      }
    });
    super.initState();
  }

  _getData() async {
    var pageSize = 20;
    var data = await Api().forum_atuserlist({
      "page": (list.length / pageSize + 1).toInt(),
      "pageSize": pageSize,
    });
    if (data != null && data["list"] != null && data["list"].length != 0) {
      list.addAll(data["list"]);
      load_finish = data["list"].length < pageSize;
    }
    load_done = true;
    setState(() {});
  }

  List<Widget> _buildCont() {
    List<Widget> tmp = [];
    if (list.length != 0) {
      tmp.add(Container(
        margin: EdgeInsets.only(left: 5, top: 10, right: 5),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            "可以@的人",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ));
    }
    list.forEach((element) {
      tmp.add(Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        child: myInkWell(
          color: Colors.transparent,
          tap: () {
            widget.tap(element["uid"], element["name"]);
          },
          widget: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Icon(Icons.person, color: os_color),
                Container(width: 10),
                Text(
                  element["name"],
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          radius: 5,
        ),
      ));
    });
    if (list.length != 0 && !load_finish) {
      tmp.add(Container(
        padding: EdgeInsets.only(top: 15, bottom: 25),
        child: Center(
          child: Text("加载中…", style: TextStyle(color: os_deep_grey)),
        ),
      ));
    }
    if (list.length == 0 && load_done) {
      tmp.add(Container(
        height: 180,
        child: Center(
          child: Text(
            "暂无可以@的人,你可以通过关注/好友增加人数",
            style: TextStyle(
              fontSize: 14,
              color: os_deep_grey,
            ),
          ),
        ),
      ));
    }
    if (list.length == 0 && load_done == false) {
      tmp.add(Container(
        height: 180,
        child: Center(
          child: Text(
            "加载中…",
            style: TextStyle(
              fontSize: 14,
              color: os_deep_grey,
            ),
          ),
        ),
      ));
    }
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: os_grey,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ListView(
        controller: _scrollController,
        children: _buildCont(),
      ),
    );
  }
}

class SendFunc extends StatefulWidget {
  String path;
  Function tap;
  int nums;
  SendFunc({
    Key key,
    @required this.path,
    @required this.tap,
    this.nums,
  }) : super(key: key);

  @override
  _SendFuncState createState() => _SendFuncState();
}

class _SendFuncState extends State<SendFunc> {
  @override
  Widget build(BuildContext context) {
    return myInkWell(
      tap: () {
        widget.tap();
      },
      widget: Stack(
        children: [
          widget.nums == null
              ? Container()
              : Positioned(
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Color(0x22004DFF),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: Text(
                        widget.nums.toString(),
                        style: TextStyle(
                          color: Color(0xFF004DFF),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  right: 5,
                  top: 5,
                ),
          Container(
            padding: EdgeInsets.all(15),
            child: os_svg(
              path: widget.path,
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
      radius: 100,
    );
  }
}

class Divider extends StatelessWidget {
  const Divider({
    Key key,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 15,
      decoration: BoxDecoration(
        color: Color(0xFFF6F6F6),
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );
  }
}

class BottomLoading extends StatefulWidget {
  Color color;
  String txt;
  BottomLoading({
    Key key,
    this.color,
    this.txt,
  }) : super(key: key);

  @override
  _BottomLoadingState createState() => _BottomLoadingState();
}

class _BottomLoadingState extends State<BottomLoading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color ?? Color(0xFFF6F6F6),
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
            Text(widget.txt ?? "加载中…", style: TextStyle(color: os_deep_grey)),
          ],
        ),
      ),
    );
  }
}

class TopicVote extends StatefulWidget {
  var poll_info;
  var topic_id;
  TopicVote({Key key, this.poll_info, this.topic_id}) : super(key: key);

  @override
  _TopicVoteState createState() => _TopicVoteState();
}

class _TopicVoteState extends State<TopicVote> {
  int select = -1;
  bool selected = false;

  @override
  void initState() {
    _getStatus();
    super.initState();
  }

  void _getStatus() async {
    String data = await getStorage(
      key: "vote_side",
      initData: "",
    );
    var poll_item_ids = data.split(",");
    var poll_item_list = widget.poll_info["poll_item_list"];
    poll_item_ids.forEach((element) {
      for (var i = 0; i < poll_item_list.length; i++) {
        if (element == "${poll_item_list[i]['poll_item_id']}") {
          selected = true;
          select = i;
        }
      }
    });
    setState(() {});
  }

  void _vote(int side) async {
    if (selected) return;
    var poll_item_id = widget.poll_info["poll_item_list"][side]["poll_item_id"];
    await Api().forum_vote({
      "tid": widget.topic_id,
      "options": poll_item_id,
    });
    widget.poll_info["voters"]++;
    widget.poll_info["poll_item_list"][side]["total_num"]++;
    var vote_status = await getStorage(
      key: "vote_side",
      initData: "",
    );
    vote_status += "${poll_item_id},";
    await setStorage(key: "vote_side", value: vote_status);
    select = side;
    selected = true;
    setState(() {});
  }

  List<Widget> _buildVote() {
    List<Widget> tmp = [];
    widget.poll_info["poll_item_list"].forEach((element) {
      int ele_idx = widget.poll_info["poll_item_list"].indexOf(element);
      tmp.add(GestureDetector(
        onTap: () {
          _vote(ele_idx);
        },
        child: Container(
          width: MediaQuery.of(context).size.width - 50,
          margin: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: os_white,
            borderRadius: BorderRadius.all(Radius.circular(7.5)),
            border: Border.all(color: selected ? os_color : Color(0xFFCCCCCC)),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 50,
                padding: EdgeInsets.symmetric(vertical: 7.5, horizontal: 12),
                child: Center(
                  child: Text(
                    (selected && select == (ele_idx) ? "【已选】" : "") +
                        (element["name"].length > 12
                            ? element["name"].toString().substring(0, 12) + "…"
                            : element["name"].toString()),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selected ? os_color : os_black,
                    ),
                  ),
                ),
              ),
              selected
                  ? Positioned(
                      left: 0.5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: os_color_opa,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            bottomLeft: Radius.circular(6),
                          ),
                        ),
                        width: (MediaQuery.of(context).size.width - 50) *
                            (element["total_num"] / widget.poll_info["voters"]),
                        height: 34.5,
                      ),
                    )
                  : Container(),
              Positioned(
                child: Text(
                  selected
                      ? (element["total_num"] /
                                  widget.poll_info["voters"] *
                                  100)
                              .toStringAsFixed(2) +
                          "%"
                      : "投票",
                  style: TextStyle(
                    color: selected ? os_color : os_black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                right: 10,
              ),
            ],
          ),
        ),
      ));
    });
    tmp.add(Container(
      width: MediaQuery.of(context).size.width - 50,
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Text(
        " 已有 ${widget.poll_info['voters']} 人参与投票",
        style: TextStyle(
          color: os_deep_grey,
          fontSize: 12,
        ),
      ),
    ));
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return widget.poll_info == nullptr
        ? Container()
        : Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFFF6F6F6),
              borderRadius: BorderRadius.all(Radius.circular(7.5)),
            ),
            child: Column(
              children: _buildVote(),
            ),
          );
  }
}

class CommentsTab extends StatefulWidget {
  var data;
  var topic_id;
  var host_id;
  var select;
  var sort;
  Function bindSelect;
  Function bindSort;
  CommentsTab(
      {Key key,
      this.data,
      this.topic_id,
      this.host_id,
      this.bindSelect,
      this.bindSort,
      this.select,
      this.sort})
      : super(key: key);

  @override
  _CommentsTabState createState() => _CommentsTabState();
}

class _CommentsTabState extends State<CommentsTab> {
  Widget _buildComment() {
    List<Widget> t = [];
    for (var i = 0; i < widget.data.length; i++) {
      t.add(Comment(
        host_id: widget.host_id,
        topic_id: widget.topic_id,
        data: widget.data[i],
        is_last: i == widget.data.length - 1,
      ));
    }
    return Column(children: t);
  }

  @override
  Widget build(BuildContext context) {
    return CommentTab(
      TapSelect: (idx) {
        setState(() {
          widget.bindSelect(idx);
        });
      },
      TapSort: (idx) {
        if (idx != widget.sort) {
          widget.bindSort(idx);
        }
        // showMidActionSheet(
        //     context: context,
        //     list: ["按时间正序", "按时间倒序"],
        //     title: "排序方式",
        //     select: (idx) {
        //       widget.bindSort(idx);
        //     });
      },
      select: widget.select,
      sort: widget.sort,
    );
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
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Color(0xFFF3F3F3),
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.TapSort(0);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 9, vertical: 2),
                    decoration: BoxDecoration(
                      color: widget.sort == 0 ? os_white : Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: Text(
                      "正序",
                      style: TextStyle(
                        color: widget.sort == 0 ? os_black : os_deep_grey,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.TapSort(1);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 9, vertical: 2),
                    decoration: BoxDecoration(
                      color: widget.sort == 1 ? os_white : Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: Text(
                      "倒序",
                      style: TextStyle(
                        color: widget.sort == 1 ? os_black : os_deep_grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatefulWidget {
  var data;
  var is_last;
  var topic_id;
  var host_id;
  int index;
  Function tap;
  Comment(
      {Key key,
      this.data,
      this.is_last,
      this.topic_id,
      this.host_id,
      this.tap,
      this.index})
      : super(key: key);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  var liked = 0;
  _getLikedStatus() async {
    String tmp = await getStorage(
      key: "comment_like",
    );
    List<String> ids = tmp.split(",");
    if (ids.indexOf(widget.data["reply_posts_id"].toString()) > -1) {
      setState(() {
        liked = 1;
      });
    }
  }

  void _tapLike() async {
    if (liked == 1) return;
    liked = 1;
    widget.data["extraPanel"][0]["extParams"]["recommendAdd"]++;
    setState(() {});
    await Api().forum_support({
      "tid": widget.topic_id,
      "pid": widget.data["reply_posts_id"],
      "type": "post",
      "action": "support",
    });
    String tmp = await getStorage(
      key: "comment_like",
    );
    tmp += ",${widget.data["reply_posts_id"]}";
    setStorage(key: "comment_like", value: tmp);
  }

  _buildContBody(data) {
    List<Widget> tmp = [];
    var imgLists = [];
    data.forEach((e) {
      if (e["type"] == 1) {
        imgLists.add(e["infor"]);
      }
    });
    data.forEach((e) {
      tmp.add(Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: DetailCont(
          data: e,
          imgLists: imgLists,
        ),
      ));
    });
    return Column(children: tmp);
  }

  @override
  void initState() {
    super.initState();
    _getLikedStatus();
  }

  @override
  Widget build(BuildContext context) {
    return myInkWell(
      tap: () {
        widget.tap(widget.data["reply_posts_id"], widget.data["reply_name"]);
      },
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
                          widget.data["userTitle"] == null ||
                                  widget.data["userTitle"].length == 0
                              ? Container()
                              : Tag(
                                  txt: widget.data["userTitle"],
                                  color: widget.data["userTitle"]
                                              .toString()
                                              .length <
                                          7
                                      ? Color(0xFFFE6F61)
                                      : Color(0xFF0092FF),
                                  color_opa: widget.data["userTitle"]
                                              .toString()
                                              .length <
                                          7
                                      ? Color(0x10FE6F61)
                                      : Color(0x100092FF),
                                ),
                          Container(width: 5),
                          widget.data["reply_id"] == widget.host_id &&
                                  widget.data["reply_name"] != "匿名"
                              ? Tag(
                                  txt: "楼主",
                                  color: os_white,
                                  color_opa: Color(0xFF2EA6FF),
                                )
                              : Container(),
                        ],
                      ),
                      Row(
                        children: [
                          myInkWell(
                            tap: () {
                              _tapLike();
                            },
                            color: Colors.transparent,
                            widget: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 5,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 4),
                                    child: Text(
                                      widget.data["extraPanel"][0]["extParams"]
                                              ["recommendAdd"]
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: liked == 1
                                            ? os_color
                                            : Color(0xFFB1B1B1),
                                      ),
                                    ),
                                  ),
                                  Container(width: 3),
                                  os_svg(
                                    path: liked == 1
                                        ? "lib/img/detail_like_blue.svg"
                                        : "lib/img/detail_like.svg",
                                    width: 24,
                                    height: 24,
                                  ),
                                ],
                              ),
                            ),
                            radius: 7.5,
                          ),
                          myInkWell(
                            tap: () {
                              showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                context: context,
                                builder: (context) {
                                  return ConstrainedBox(
                                    constraints: BoxConstraints(maxHeight: 300),
                                    child: Container(
                                      child: Center(
                                        child: Text("哈哈哈"),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            color: Colors.transparent,
                            widget: Container(
                              padding: EdgeInsets.all(5),
                              child: os_svg(
                                path: "lib/img/detail_comment_more.svg",
                                width: 17,
                                height: 17,
                              ),
                            ),
                            radius: 7.5,
                          )
                        ],
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
                          color: Color(0x00000000),
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

class Tag extends StatefulWidget {
  var txt;
  var color;
  var color_opa;
  Tag({
    Key key,
    this.txt,
    this.color,
    this.color_opa,
  }) : super(key: key);

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
      decoration: BoxDecoration(
        color: widget.color_opa,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Text(widget.txt,
          style: TextStyle(
            color: widget.color,
            fontSize: 12,
          )),
    );
  }
}

class DetailFixBottom extends StatefulWidget {
  var topic_id;
  var count;
  Function tapEdit;
  DetailFixBottom({
    Key key,
    this.topic_id,
    this.count,
    this.tapEdit,
  }) : super(key: key);

  @override
  _DetailFixBottomState createState() => _DetailFixBottomState();
}

class _DetailFixBottomState extends State<DetailFixBottom> {
  var liked = 0;

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
              tap: () {
                widget.tapEdit();
              },
              radius: 10,
              color: os_white,
              widget: Container(
                width: MediaQuery.of(context).size.width - 76,
                height: 47,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 120,
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
            Container(
              width: 62,
              height: 47,
              child: Center(
                child: myInkWell(
                    tap: () {
                      _tapLike();
                    },
                    color: Colors.transparent,
                    widget: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon(
                          //   Icons.favorite,
                          //   color: liked == 1 ? os_color : Color(0xFFcccccc),
                          // ),
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
                              color: liked == 1 ? os_color : Color(0xFFB1B1B1),
                            ),
                          ),
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
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/column",
                  arguments: widget.data['boardId']);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
              decoration: BoxDecoration(
                  // color: os_color_opa,
                  // borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
              child: Text(
                "收录自专栏: " + widget.data["forumName"] + " >",
                style: TextStyle(color: os_color),
              ),
            ),
          ),
          Container(),
        ],
      ),
    );
  }
}

// 帖子浏览量和时间
class TopicDetailTime extends StatefulWidget {
  var data;
  TopicDetailTime({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  State<TopicDetailTime> createState() => _TopicDetailTimeState();
}

class _TopicDetailTimeState extends State<TopicDetailTime> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            RelativeDateFormat.format(DateTime.fromMillisecondsSinceEpoch(
                    int.parse(widget.data["topic"]["create_date"]))) +
                " · 浏览量${widget.data['topic']['hits'].toString()}",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFAAAAAA),
            ),
          ),
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
        data["topic"]["title"].replaceAll("&nbsp1", " "),
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
                    fit: BoxFit.cover,
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
