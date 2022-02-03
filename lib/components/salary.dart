import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/data.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/cartoon.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class OSSalary extends StatefulWidget {
  SalaryData data;
  OSSalary({Key key, this.data}) : super(key: key);
  @override
  _OSSalaryState createState() => _OSSalaryState();
}

class _OSSalaryState extends State<OSSalary> {
  @override
  Widget build(BuildContext context) {
    KeyBoard provider = Provider.of<KeyBoard>(context);
    return Container(
      margin: EdgeInsets.only(top: os_space),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: os_white,
          ),
          width: MediaQuery.of(context).size.width - 2 * os_padding,
          child: InkWell(
            onTap: () {
              print(widget.data.salaryId);
              provider.setNowSalaryId(widget.data.salaryId);
              Navigator.pushNamed(
                context,
                "/salary_detail",
                arguments: widget.data.salaryId,
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: SalaryCont(
              data: widget.data,
            ),
          ),
        ),
      ),
    );
  }
}

class SalaryCont extends StatefulWidget {
  SalaryData data;
  SalaryCont({Key key, this.data}) : super(key: key);
  @override
  _SalaryContState createState() => _SalaryContState();
}

class _SalaryContState extends State<SalaryCont> {
  String splitString(String t, int i) {
    if (t.length > i) {
      return t.substring(0, i) + "…";
    } else {
      return t;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                splitString(widget.data.company, 5),
                style: TextStyle(
                  color: os_black,
                  fontSize: 15,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: new EdgeInsets.only(
                      top: 2,
                      bottom: 2,
                      left: 5,
                      right: 5,
                    ),
                    decoration: BoxDecoration(
                        color: os_color_opa,
                        borderRadius: BorderRadius.circular(3)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        os_svg(
                          path: "lib/img/salary-location.svg",
                          size: 12,
                        ),
                        Container(
                          width: 2,
                        ),
                        Container(
                          child: Text(
                            splitString(widget.data.city, 4),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: os_color,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: new EdgeInsets.only(
                      top: 2,
                      bottom: 2,
                      left: 5,
                      right: 5,
                    ),
                    margin: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                        color: os_color_opa,
                        borderRadius: BorderRadius.circular(3)),
                    child: Text(
                      "可信度:" + splitString(widget.data.confidence, 4),
                      style: TextStyle(color: os_color, fontSize: 12),
                    ),
                  ),
                  Container(
                    padding: new EdgeInsets.only(
                      top: 2,
                      bottom: 2,
                      left: 5,
                      right: 5,
                    ),
                    margin: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                        color: os_color_opa,
                        borderRadius: BorderRadius.circular(3)),
                    child: Text(
                      splitString(widget.data.education, 5),
                      style: TextStyle(color: os_color, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                splitString(widget.data.money, 10),
                style: TextStyle(
                  color: os_red,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                splitString(widget.data.job, 6),
                style: TextStyle(
                  color: os_black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          Container(height: widget.data.remark.length == 0 ? 0 : 5),
          (widget.data.remark.length == 0
              ? Container()
              : Transform.scale(
                  scale: 1,
                  child: Container(
                    width: os_width,
                    padding:
                        EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.025),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      splitString(widget.data.remark, 25),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xFF4F4F4F),
                        fontSize: 12,
                      ),
                    ),
                  ),
                )),
          Container(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "浏览量:" + splitString(widget.data.look, 7),
                    style: TextStyle(color: Color(0xFFAFAFAF), fontSize: 13),
                  ),
                  Container(width: 10),
                  Text(
                    splitString(widget.data.time, 7),
                    style: TextStyle(color: Color(0xFFAFAFAF), fontSize: 13),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "查看详情",
                    style: TextStyle(color: os_color),
                  ),
                  os_svg(
                    size: 12,
                    path: "lib/img/salary-right.svg",
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
