import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/data.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/components/occu.dart';
import 'package:offer_show/components/tip.dart';
import 'package:offer_show/page/broke_component/brokeButton.dart';
import 'package:offer_show/page/broke_component/brokeDeclare.dart';
import 'package:offer_show/page/broke_component/brokeDoubleInput.dart';
import 'package:offer_show/page/broke_component/brokeDoubleSelect.dart';
import 'package:offer_show/page/broke_component/brokeInput.dart';
import 'package:offer_show/page/broke_component/brokeSelect.dart';
import 'package:offer_show/page/broke_component/brokeTitle.dart';
import 'package:offer_show/util/interface.dart';

class BrokeBody extends StatefulWidget {
  @override
  _BrokeBodyState createState() => _BrokeBodyState();
}

class _BrokeBodyState extends State<BrokeBody> {
  SalaryData _brokeSalaryData = new SalaryData();
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 10; i++) {
      _controllers.add(new TextEditingController());
    }
  }

  Widget _insertWidget({
    @required Widget widget,
    @required String txt,
    @required String path,
  }) {
    return Column(
      children: [
        occu(height: 15.0),
        BrokeTitle(
          txt: txt,
          path: path,
        ),
        occu(height: 10.0),
        widget,
      ],
    );
  }

  Widget _getCommonWidget({
    @required String txt,
    @required String path,
    @required String hint,
    @required bool enable,
    @required int index,
    int lines,
  }) {
    return Column(
      children: [
        occu(height: 15.0),
        BrokeTitle(
          txt: txt,
          path: path,
        ),
        occu(height: 10.0),
        BrokeInput(
          lines: lines ?? 1,
          enable: enable,
          controller: _controllers[index],
          hint: hint,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _getCommonWidget(
            txt: "公司",
            path: "lib/img/broke-company.svg",
            hint: "公司名称",
            enable: true,
            index: 0,
          ),
          _getCommonWidget(
            txt: "岗位",
            path: "lib/img/broke-job.svg",
            hint: "岗位名称",
            enable: true,
            index: 1,
          ),
          _getCommonWidget(
            txt: "城市",
            path: "lib/img/broke-city.svg",
            hint: "公司所在城市",
            enable: true,
            index: 2,
          ),
          _insertWidget(
            widget: BrokeSelectInput(
              index: 0,
              elements: [
                "IT|互联网|通信",
                "销售|客服|市场",
                "财务|人力资源|行政",
                "项目质量|高级管理",
                "房产建筑|物业管理",
                "金融",
                "采购|贸易|交通|物流",
                "生产|制造",
                "传媒|印刷|艺术|设计",
                "咨询|法律|教育|翻译",
                "服务业",
                "能源环保|农业科研",
                "其他行业",
                "兼职|实习|社工|其他",
              ],
              controller: _controllers[8],
            ),
            txt: "行业",
            path: "lib/img/broke-industry.svg",
          ),
          _insertWidget(
            widget: BrokeSelectInput(
              index: 5,
              elements: [
                "博士985",
                "博士211",
                "博士海归",
                "博士其他",
                "硕士985",
                "硕士211",
                "硕士海归",
                "本科985",
                "本科211",
                "本科海归",
                "本科其他",
                "大专",
                "其他",
              ],
              controller: _controllers[7],
            ),
            txt: "学历",
            path: "lib/img/broke-education.svg",
          ),
          _insertWidget(
            widget: BrokeDoubleSelect(
              controller: _controllers[6],
            ),
            txt: "类型",
            path: "lib/img/broke-type.svg",
          ),
          _getCommonWidget(
            txt: "薪资描述",
            path: "lib/img/broke-money.svg",
            hint: "薪资描述，如18*14",
            enable: true,
            index: 3,
          ),
          _insertWidget(
            path: "lib/img/broke-cal.svg",
            txt: "年薪范围换算",
            widget: BrokeInputDouble(
              hint1: "年薪下限",
              hint2: "年薪上限",
              controller1: _controllers[4],
              controller2: _controllers[5],
              enable: true,
            ),
          ),
          tip(
            left: os_padding * 1.5,
            size: 12,
            top: 10.0,
            txt: "注意：年薪以万为单位，年薪上限包含各类福利和年终奖",
          ),
          _getCommonWidget(
            txt: "备注",
            path: "lib/img/broke-remark.svg",
            hint: "备注请填写offer相关的其他信息，比如是否SP offer、是否有签字费、各类福利补贴、是否有落户名额等",
            enable: true,
            index: 9,
            lines: 10,
          ),
          occu(height: 15.0),
          BrokeButton(
            tap: () async {
              Map<String, dynamic> param = {
                "company": _controllers[0].text,
                "position": _controllers[1].text,
                "city": _controllers[2].text,
                "salary": _controllers[3].text,
                "remark": _controllers[9].text,
                "xueli": _controllers[7].text,
                "hangye": _controllers[8].text,
                "salarytype": _controllers[6].text,
                "salary_upper": _controllers[4].text,
                "salary_lower": _controllers[5].text,
              };
              bool flag = false;
              final map = [0, 1, 2, 3, 7, 8, 6];
              map.forEach((element) {
                if (_controllers[element].text == "") {
                  flag = true;
                }
              });
              if (flag) {
                Fluttertoast.showToast(
                  msg: "请填写完整信息哦～",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: os_red,
                  textColor: os_white,
                  fontSize: 16.0,
                );
              } else {
                final res = await Api().webapi_jobrecord(
                  param: {
                    "company": _controllers[0].text,
                    "position": _controllers[1].text,
                    "city": _controllers[2].text,
                    "salary": _controllers[3].text,
                    "remark": _controllers[9].text,
                    "xueli": _controllers[7].text,
                    "hangye": _controllers[8].text,
                    "salarytype": _controllers[6].text,
                    "salary_upper": _controllers[4].text,
                    "salary_lower": _controllers[5].text,
                  },
                );
                if (res['r'] != 0) {
                  Fluttertoast.showToast(
                    msg: res['msg'],
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 1,
                    backgroundColor: os_color,
                    textColor: os_white,
                    fontSize: 16.0,
                  );
                  new Future.delayed(Duration(microseconds: 300), () {
                    Fluttertoast.cancel();
                    Navigator.pop(context);
                  });
                } else {
                  Fluttertoast.showToast(
                    msg: res['msg'],
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 1,
                    backgroundColor: os_red,
                    textColor: os_white,
                    fontSize: 16.0,
                  );
                }
              }
            },
          ),
          occu(height: 15.0),
          BrokeDeclare(),
          occu(height: 30.0),
        ],
      ),
    );
  }
}
