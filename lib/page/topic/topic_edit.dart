import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/cookie.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class TopicEdit extends StatefulWidget {
  int tid;
  int pid;
  TopicEdit({
    Key key,
    this.tid,
    this.pid,
  }) : super(key: key);

  @override
  State<TopicEdit> createState() => _TopicEditState();
}

class _TopicEditState extends State<TopicEdit> {
  /// "formhash": "",
  /// "posttime": "",
  /// "fid": "",
  /// "tid": "",
  /// "pid": "",
  /// "page": "",
  /// "editsubmit": "yes",
  /// "subject": "", //就是标题
  /// "typeid": 755,
  /// "message": "", //就是内容
  Map ret_param = {
    "formhash": "",
    "posttime": "",
    "fid": 0,
    "tid": 0,
    "pid": 0,
    "page": "",
    "editsubmit": "yes",
    "subject": "", //就是标题
    "typeid": 0,
    "message": "", //就是内容
  };

  String title = "";
  String tip = "";
  TextEditingController _titleTextEditingController =
      new TextEditingController();
  TextEditingController _tipTextEditingController = new TextEditingController();
  FocusNode _titleFocusNode = new FocusNode();
  FocusNode _tipFocusNode = new FocusNode();
  bool showDone = false; //是否展示顶部右上角的完成按钮
  bool denyEdit = false; //是否拒绝编辑

  _getData() async {
    Map param = {
      "tid": widget.tid,
      "pid": widget.pid,
    };
    print("${param}");
    Response tmp = await XHttp().pureHttpWithCookie(
      url: base_url +
          "forum.php?mod=post&action=edit&tid=${widget.tid}&pid=${widget.pid}",
      hadCookie: true,
    );
    String html_txt = tmp.data.toString();
    if (html_txt.contains("管理员设置了本版块最后回复于") || html_txt.contains("抱歉")) {
      setState(() {
        denyEdit = true;
      });
      return;
    }
    dom.Document document = parse(html_txt);

    //获取帖子的各项上传参数
    document
        .getElementById("typeid")
        .getElementsByTagName("option")
        .forEach((element) {
      if (element.attributes["selected"] != null &&
          element.attributes["selected"] == "selected") {
        ret_param["typeid"] = int.parse(element.attributes["value"]);
      }
    });
    var ct2_a_r = document.getElementsByClassName("ct2_a_r").first;
    ret_param["formhash"] =
        ct2_a_r.getElementsByTagName("input")[0].attributes["value"];
    ret_param["posttime"] =
        int.parse(ct2_a_r.getElementsByTagName("input")[1].attributes["value"]);
    ret_param["fid"] =
        int.parse(ct2_a_r.getElementsByTagName("input")[4].attributes["value"]);
    ret_param["tid"] =
        int.parse(ct2_a_r.getElementsByTagName("input")[5].attributes["value"]);
    ret_param["pid"] =
        int.parse(ct2_a_r.getElementsByTagName("input")[6].attributes["value"]);

    //获取帖子的标题和内容
    var postbox = document.getElementById("postbox");
    _titleTextEditingController.text =
        postbox.getElementsByTagName("input").first.attributes["value"];
    _tipTextEditingController.text =
        postbox.getElementsByTagName("textarea").first.innerHtml;
    setState(() {});
  }

  _submit() async {
    print("${ret_param}");
    return;
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        base_url +
            'forum.php?mod=post&action=edit&extra=&editsubmit=yes&mobile=2&geoloc=&handlekey=postform&inajax=1',
      ),
    );
    request.fields.addAll(ret_param);
    request.headers.addAll({'Cookie': await getStorage(key: "cookie")});

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    _getData();
    _tipFocusNode.addListener(() {
      setState(() {
        showDone = _tipFocusNode.hasFocus;
      });
    });
    _titleTextEditingController.addListener(() {
      ret_param["subject"] = _titleTextEditingController.text;
    });
    _tipTextEditingController.addListener(() {
      ret_param["message"] = _tipTextEditingController.text;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
        foregroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_white
            : os_black,
        actions: denyEdit
            ? []
            : [
                !showDone
                    ? Container()
                    : GestureDetector(
                        onTap: () {
                          _tipFocusNode.unfocus();
                          setState(() {});
                        },
                        child: EditDoneBtn(),
                      ),
                Container(width: 7.5),
                GestureDetector(
                    onTap: () {
                      _submit();
                    },
                    child: EditSendBtn()),
                Container(width: 10),
              ],
      ),
      backgroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: denyEdit
            ? [
                Center(child: Text("1.水区的帖子不允许编辑")),
                Center(child: Text("2.15天前的帖子不允许编辑")),
              ]
            : [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: os_white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: TextField(
                    controller: _titleTextEditingController,
                    focusNode: _titleFocusNode,
                    decoration: InputDecoration(
                      fillColor: os_white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          width: 2,
                          color: Provider.of<ColorProvider>(context).isDark
                              ? os_dark_dark_white
                              : os_color,
                          style: BorderStyle.solid,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.transparent,
                          style: BorderStyle.solid,
                        ),
                      ),
                      hintText: "请输入帖子的标题",
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  height: 300,
                  decoration: BoxDecoration(
                    color: os_white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: TextField(
                    controller: _tipTextEditingController,
                    focusNode: _tipFocusNode,
                    maxLines: null,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.5,
                        vertical: 15,
                      ),
                      fillColor: os_white,
                      border: InputBorder.none,
                      hintText: "请输入帖子的内容",
                    ),
                  ),
                ),
                Container(child: Text(title)),
                Container(child: Text(tip)),
              ],
      ),
    );
  }
}

class EditDoneBtn extends StatelessWidget {
  const EditDoneBtn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 146, 255, 0.15),
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        child: Center(
          child: Container(
            child: Text(
              "完成",
              style: TextStyle(
                color: os_color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EditSendBtn extends StatelessWidget {
  const EditSendBtn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Provider.of<ColorProvider>(context).isDark
              ? Color.fromRGBO(0, 146, 255, 1)
              : os_color,
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        child: Center(
          child: Container(
            child: Text(
              "发送",
              style: TextStyle(
                color: os_white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
