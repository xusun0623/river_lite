import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class SalaryComment extends StatefulWidget {
  final String commentId;
  final String content;
  final String time;
  final String isMine;
  final String isOwner;
  final int index;

  const SalaryComment({
    Key key,
    @required this.commentId,
    @required this.content,
    @required this.time,
    @required this.isMine,
    @required this.isOwner,
    @required this.index,
  }) : super(key: key);

  @override
  _SalaryCommentState createState() => _SalaryCommentState();
}

class _SalaryCommentState extends State<SalaryComment> {
  @override
  Widget build(BuildContext context) {
    KeyBoard provider = Provider.of<KeyBoard>(context);
    return Material(
      color: Colors.transparent,
      child: Ink(
        width: os_width,
        child: InkWell(
          onTap: () {
            provider.editingController.text =
                "@" + widget.index.toString() + "楼：";
            provider.open();
            provider.foucs(context);
            // provider.close();
          },
          child: Container(
            padding: EdgeInsets.only(
              left: os_padding * 1.5,
              right: os_padding * 1.5,
              top: 15.0,
              // bottom: 10.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          [
                            "用户留言",
                            "爆料者留言",
                            "我的留言",
                            "我的留言"
                          ][["00", "01", "10", "11"].indexOf(
                            (widget.isMine ?? "0") + (widget.isOwner ?? "0"),
                          )],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Container(width: 5),
                        Container(
                            padding: EdgeInsets.only(
                              top: 2,
                              bottom: 2,
                              left: 5,
                              right: 5,
                            ),
                            decoration: BoxDecoration(
                              color: os_color_opa,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Text(
                              (widget.index ?? 1).toString() + "楼",
                              style: TextStyle(
                                color: os_color,
                                fontSize: 14,
                                letterSpacing: 0.5,
                                // fontWeight: FontWeight.w200,
                              ),
                            )),
                      ],
                    ),
                    Container(
                      height: 25,
                      child: IconButton(
                        padding: EdgeInsets.all(3.0),
                        icon: os_svg(
                          path: "lib/img/salary-more.svg",
                          size: 24,
                        ),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 7,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.03),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(8),
                  width: os_width,
                  child: Text(
                    widget.content ?? "该留言已删除",
                    style: TextStyle(
                      fontSize: 16,
                      // color: os_deep_grey,
                    ),
                  ),
                ),
                Container(
                  width: os_width,
                  child: Text(
                    widget.time ?? "",
                    style: TextStyle(
                      fontSize: 12,
                      color: os_middle_grey,
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  width: os_width - 2 * os_padding,
                  color: Color(0xFFFAFAFA),
                  margin: EdgeInsets.only(top: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
