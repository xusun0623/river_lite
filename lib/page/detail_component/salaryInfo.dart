import 'package:flutter/material.dart';
import 'package:offer_show/asset/data.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/dividender.dart';
import 'package:offer_show/components/occu.dart';
import 'package:offer_show/components/title.dart';
import 'package:offer_show/page/detail_component/salaryInfoCard.dart';
import 'package:offer_show/page/detail_component/salaryPrimaryInfo.dart';

class SalaryInfo extends StatefulWidget {
  SalaryData salaryData;
  SalaryInfo({Key key, @required this.salaryData}) : super(key: key);
  @override
  _SalaryInfoState createState() => _SalaryInfoState();
}

class _SalaryInfoState extends State<SalaryInfo> {
  @override
  Widget build(BuildContext context) {
    final salaryData = widget.salaryData;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: os_padding,
            right: os_padding,
          ),
          child: Column(
            children: [
              occu(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SalaryInfoCard(
                    title: "公司",
                    cont: salaryData.company,
                    icon: os_svg(
                      path: "lib/img/detail-company.svg",
                      size: 16,
                    ),
                  ),
                  SalaryInfoCard(
                    title: "职位",
                    cont: salaryData.job,
                    icon: os_svg(
                      path: "lib/img/detail-job.svg",
                      size: 16,
                    ),
                  ),
                  SalaryInfoCard(
                    title: "地点",
                    cont: salaryData.city,
                    icon: os_svg(
                      path: "lib/img/detail-city.svg",
                      size: 16,
                    ),
                  ),
                ],
              ),
              occu(height: 20.0),
              Container(
                margin: EdgeInsets.only(
                  left: os_padding,
                  right: os_padding,
                ),
                child: SalaryPrimaryInfo(
                  width: os_width - 2 * os_padding,
                  color: Color(0xFFFF5B5A),
                  isInfo: true,
                  title: "薪资",
                  cont: salaryData.money ?? "",
                ),
              ),
              occu(height: 30.0),
              Container(
                margin: EdgeInsets.only(
                  left: os_padding,
                  right: os_padding,
                ),
                child: Row(
                  children: [
                    SalaryPrimaryInfo(
                      width: os_width * 0.5,
                      color: Color(0xFF03BBFF),
                      title: "行业",
                      cont: salaryData.industry ?? "",
                    ),
                    SalaryPrimaryInfo(
                      width: os_width * 0.4,
                      color: Color(0xFF00DE97),
                      title: "学历",
                      cont: salaryData.education ?? "",
                    ),
                  ],
                ),
              ),
              occu(height: 30.0),
              Container(
                margin: EdgeInsets.only(
                  left: os_padding,
                  right: os_padding,
                ),
                child: Row(
                  children: [
                    SalaryPrimaryInfo(
                      width: os_width * 0.5,
                      color: Color(0xFFFF6629),
                      title: "发布时间",
                      cont: salaryData.time ?? "",
                    ),
                    SalaryPrimaryInfo(
                      width: os_width * 0.4,
                      color: Color(0xFFFF822F),
                      title: "浏览量",
                      cont: salaryData.look ?? "",
                    ),
                  ],
                ),
              ),
              occu(height: 30.0),
              (salaryData.remark == null || salaryData.remark.length == 0)
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(
                        left: os_padding,
                        right: os_padding,
                      ),
                      child: SalaryPrimaryInfo(
                        width: os_width - 2 * os_padding,
                        color: Color(0xFF93A0FF),
                        title: "备注",
                        cont: salaryData.remark ?? "",
                      ),
                    ),
            ],
          ),
        ),
        occu(
          height: 10.0,
        ),
        OSDividender(
          margin: 10.0,
        ),
        occu(
          height: 10.0,
        ),
        OSTitle(title: "评论区", tip: "友善评论，请不要中伤他人"),
        occu(
          height: 10.0,
        ),
      ],
    );
  }
}
