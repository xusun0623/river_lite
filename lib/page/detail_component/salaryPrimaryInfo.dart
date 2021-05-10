import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';

class SalaryPrimaryInfo extends StatefulWidget {
  final width;
  final color;
  final title;
  final cont;
  final isInfo;
  SalaryPrimaryInfo({
    Key key,
    @required this.width,
    @required this.color,
    @required this.title,
    @required this.cont,
    this.isInfo,
  }) : super(key: key);
  @override
  _SalaryPrimaryInfoState createState() => _SalaryPrimaryInfoState();
}

class _SalaryPrimaryInfoState extends State<SalaryPrimaryInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? os_width - 2 * os_padding,
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: widget.color ?? os_grey,
              borderRadius: BorderRadius.circular(100.0),
            ),
          ),
          Container(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title ?? "",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Container(width: 3),
                  (widget.isInfo == null
                      ? Container()
                      : os_svg(
                          path: "lib/img/detail-info.svg",
                          size: 14,
                        )),
                ],
              ),
              Container(
                height: 2,
              ),
              Container(
                // height: 80,
                width: widget.width - 60,
                child: Text(
                  widget.cont ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
