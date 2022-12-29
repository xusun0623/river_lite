import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/showPop.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

class BlackList extends StatefulWidget {
  BlackList({Key key}) : super(key: key);

  @override
  _BlackListState createState() => _BlackListState();
}

class _BlackListState extends State<BlackList> {
  List data = [];

  List<int> select = [];
  String tmp_txt = "";

  _confirm() async {
    if (tmp_txt == "") {
      showToast(context: context, type: XSToast.none, txt: "关键词不能为空");
      return;
    }
    if (data.indexOf(tmp_txt) > -1) {
      showToast(context: context, type: XSToast.none, txt: "已有关键词");
      return;
    }
    setState(() {
      data.add(tmp_txt);
      tmp_txt = "";
    });
    _update();
    Navigator.pop(context);
  }

  _addNewWord() async {
    showPop(context, [
      Container(height: 30),
      Text(
        "请输入关键词",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Provider.of<ColorProvider>(context, listen: false).isDark
              ? os_dark_white
              : os_black,
        ),
      ),
      Container(height: 10),
      Container(
        height: 60,
        padding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Provider.of<ColorProvider>(context, listen: false).isDark
              ? os_white_opa
              : os_grey,
        ),
        child: Center(
          child: TextField(
            onChanged: (e) {
              tmp_txt = e;
            },
            onSubmitted: (e) {
              _confirm();
            },
            style: TextStyle(
              color: Provider.of<ColorProvider>(context, listen: false).isDark
                  ? os_dark_white
                  : os_black,
            ),
            cursorColor: os_deep_blue,
            decoration: InputDecoration(
                hintText: "请输入",
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color:
                      Provider.of<ColorProvider>(context, listen: false).isDark
                          ? os_dark_dark_white
                          : os_deep_grey,
                )),
          ),
        ),
      ),
      Container(height: 10),
      Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: myInkWell(
              tap: () {
                Navigator.pop(context);
              },
              color: Provider.of<ColorProvider>(context, listen: false).isDark
                  ? os_white_opa
                  : Color(0x16004DFF),
              widget: Container(
                width: (MediaQuery.of(context).size.width - 60) / 2 - 5,
                height: 40,
                child: Center(
                  child: Text(
                    "取消",
                    style: TextStyle(
                      color: Provider.of<ColorProvider>(context, listen: false)
                              .isDark
                          ? os_dark_dark_white
                          : os_deep_blue,
                    ),
                  ),
                ),
              ),
              radius: 12.5,
            ),
          ),
          Container(
            child: myInkWell(
              tap: () async {
                _confirm();
              },
              color: os_deep_blue,
              widget: Container(
                width: (MediaQuery.of(context).size.width - 60) / 2 - 5,
                height: 40,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.done, color: os_white, size: 18),
                      Container(width: 5),
                      Text(
                        "完成",
                        style: TextStyle(
                          color: os_white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              radius: 12.5,
            ),
          ),
        ],
      ),
    ]);
  }

  List<Widget> _buildWidget() {
    List<Widget> tmp = [];
    tmp.add(InfoTip());
    for (var i = 0; i < data.length; i++) {
      tmp.add(ListTile(
        onTap: () {
          if (select.indexOf(i) > -1) {
            select.remove(i);
          } else {
            select.add(i);
          }
          setState(() {});
        },
        title: Text(
          data[i],
          style: TextStyle(
            color: Provider.of<ColorProvider>(context, listen: false).isDark
                ? os_dark_white
                : os_black,
          ),
        ),
        trailing: Icon(
          select.indexOf(i) > -1
              ? Icons.radio_button_checked_rounded
              : Icons.radio_button_off_rounded,
          color: select.indexOf(i) > -1 ? os_color : os_deep_grey,
        ),
      ));
    }
    tmp.add(
      myInkWell(
          tap: () {
            _addNewWord();
          },
          color: Colors.transparent,
          widget: Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Icon(
              Icons.add,
              color: os_color,
            ),
          ),
          radius: 0),
    );
    return tmp;
  }

  _update() async {
    await setStorage(key: "black", value: jsonEncode(data));
    Provider.of<BlackProvider>(context, listen: false).black = data;
  }

  _log() async {
    data = jsonDecode(await getStorage(key: "black", initData: "[]"));
    setState(() {});
  }

  @override
  void initState() {
    _log();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
        elevation: 0,
        foregroundColor: Provider.of<ColorProvider>(context).isDark
            ? os_dark_white
            : os_black,
        title: Text(
          "黑名单关键词",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          isDesktop()
              ? Container()
              : IconButton(
                  icon: Text(select.length == data.length ? "取消" : "全选"),
                  onPressed: () {
                    if (select.length != data.length) {
                      select = [];
                      for (var i = 0; i < data.length; i++) {
                        select.add(i);
                      }
                    } else {
                      select = [];
                    }
                    setState(() {});
                  },
                ),
          IconButton(
            icon: Icon(Icons.delete_outline_rounded),
            onPressed: () {
              if (select.length != 0)
                showModal(
                    context: context,
                    title: "请确认",
                    cont: "是否删除选中的黑名单关键词？此操作不可逆",
                    confirm: () {
                      select.sort();
                      select = select.reversed.toList();
                      select.forEach((element) {
                        data.removeAt(element);
                      });
                      select = [];
                      _update();
                      setState(() {});
                    });
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor:
          Provider.of<ColorProvider>(context).isDark ? os_dark_back : os_back,
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: _buildWidget(),
      ),
    );
  }
}

class InfoTip extends StatelessWidget {
  const InfoTip({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(left: os_edge, right: os_edge, top: 20, bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: os_edge * 1.5, vertical: 20),
      decoration: BoxDecoration(
        color: Provider.of<ColorProvider>(context).isDark
            ? Color.fromRGBO(0, 146, 255, 0.2)
            : os_color_opa,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          Icon(Icons.info, color: os_color),
          Container(width: 5),
          Text(
            "你可以在此添加/删除黑名单关键词",
            style: TextStyle(
              color: os_color,
            ),
          ),
        ],
      ),
    );
  }
}
