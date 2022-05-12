import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/components/occu_loading.dart';
import 'package:offer_show/components/topic.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/storage.dart';

class Hot extends StatefulWidget {
  @override
  _HotState createState() => _HotState();
}

class _HotState extends State<Hot> with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = new ScrollController();
  var list = [];
  bool vibrate = false;

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    _getTmpData();
    _getData();
    _scrollController.addListener(() {
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
          _scrollController.position.maxScrollExtent) {}
    });
  }

  _getTmpData() async {
    var tmp_data = await getStorage(key: "home_hot_lists", initData: "[]");
    list = jsonDecode(tmp_data);
    setState(() {});
  }

  _getData() async {
    var tmp = await Api().portal_newslist();
    if (tmp != null &&
        tmp["rs"] != 0 &&
        tmp["list"] != null &&
        tmp["list"].length != 0) {
      await setStorage(key: "home_hot_lists", value: jsonEncode(tmp["list"]));
      list = tmp["list"];
    }
    setState(() {});
  }

  List<Widget> _buildComponents() {
    List<Widget> t = [];
    for (var i in list) {
      t.add(Topic(data: i));
    }
    if (list.length == 0) {
      t.add(Container(
        height: MediaQuery.of(context).size.height - 100,
      ));
    }
    t.add(Padding(padding: EdgeInsets.all(7.5)));
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: os_back,
        foregroundColor: os_black,
        title: Text("十大热门", style: TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: list.length == 0
          ? OccuLoading()
          : Container(
              color: os_back,
              child: RefreshIndicator(
                color: os_color,
                onRefresh: () async {
                  var data = await _getData();
                  return data;
                },
                child: ListView(
                  controller: _scrollController,
                  physics: BouncingScrollPhysics(),
                  children: _buildComponents(),
                ),
              ),
            ),
    );
  }
}
