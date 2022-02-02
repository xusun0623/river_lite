import 'package:flutter/material.dart';
import 'package:offer_show/asset/data.dart';
import 'package:offer_show/components/byxusun.dart';
import 'package:offer_show/components/empty.dart';
import 'package:offer_show/components/occu.dart';
import 'package:offer_show/components/scaffold.dart';
import 'package:offer_show/components/title.dart';
import 'package:offer_show/page/detail_component/commentInfo.dart';
import 'package:offer_show/page/detail_component/fixedBottom.dart';
import 'package:offer_show/page/detail_component/salaryInfo.dart';
import 'package:offer_show/page/detail_component/skelon.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class SalaryDetail extends StatefulWidget {
  String salaryId;
  SalaryDetail({Key key, this.salaryId}) : super(key: key);
  @override
  _SalaryDetailState createState() => _SalaryDetailState();
}

class _SalaryDetailState extends State<SalaryDetail> {
  String salaryId;
  SalaryData salaryData = new SalaryData();
  List<CommentData> commentData = [];
  bool _getDone = false;
  bool _getCommentDoneFlag = false;
  bool _showFieldText = false;

  void _getCommentData() async {
    if (_getCommentDoneFlag) return;
    final res = await Api().webapi_v2_job_comment_list(
      param: {
        "offer_id": salaryId,
        "limit": 20,
        "offset": commentData.length,
      },
    );
    final info = toLocalComment(res['content']);
    if (info.length != 20) _getCommentDoneFlag = true;
    info.forEach((element) {
      commentData.add(new CommentData(
        commentId: element["commentId"].toString(),
        content: element["content"].toString(),
        time: element["time"].toString(),
        isMine: element["isMine"].toString(),
        isOwner: element["isOwner"].toString(),
      ));
    });
    setState(() {
      _getDone = true;
    });
  }

  void _getData() async {
    final res = await Api().webapi_v2_offer_detail(
      param: {"id": salaryId},
    );
    final info = toLocalSalary([res['info']])[0];
    salaryData = new SalaryData(
      company: info["company"].toString(),
      city: info["city"].toString(),
      confidence: info["confidence"].toString(),
      education: info["education"].toString(),
      money: info["money"].toString(),
      job: info["job"].toString(),
      remark: info["remark"].toString(),
      look: info["look"].toString(),
      time: info["time"].toString(),
      industry: info["industry"].toString(),
      type: info["type"].toString(),
      salaryId: info["salaryId"].toString(),
    );
    setState(() {
      _getDone = true;
    });
  }

  void _test() {
    _getCommentDoneFlag = false;
    _getCommentData();
  }

  @override
  void initState() {
    super.initState();
    salaryId = widget.salaryId;
    _getData();
    _getCommentData();
  }

  @override
  Widget build(BuildContext context) {
    final _keyBoardBottom = MediaQuery.of(context).viewInsets.bottom;
    KeyBoard provider = Provider.of<KeyBoard>(context);
    provider.editingController.addListener(() {
      final tmp = provider.editingController.text;
      print("$tmp");
    });

    return OSScaffold(
      fixedBottomBottom: _keyBoardBottom,
      fixedBottom: fixedBottom(
        sent: () {
          _test();
        },
        showText: _showFieldText,
        tapLeave: () {
          setState(() {
            _showFieldText = true;
          });
        },
      ),
      fixedBottomHeight: 60,
      onLoad: _getCommentDoneFlag
          ? null
          : () async {
              return await _getCommentData();
            },
      headTxt: "薪资详情",
      body: Column(
        children: [
          Skelon(show: _getDone),
          occu(height: 15.0),
          OSTitle(title: "校招薪资", tip: "以下所有数据均为爆料者自行爆料，仅供参考"),
          SalaryInfo(salaryData: salaryData),
          CommentsInfo(commentData: commentData),
          OSEmpty(
            show: commentData.length == 0,
            txt: "没有留言数据",
          ),
          occu(height: commentData.length == 0 ? 50.0 : 0.0),
          byxusun(
            show: _getCommentDoneFlag && commentData.length != 0,
            txt: "没有更多了~",
          ),
        ],
      ),
    );
  }
}
