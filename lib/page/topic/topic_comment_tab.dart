import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/xs_textstyle.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class CommentsTab extends StatefulWidget {
  var data;
  var topic_id;
  var host_id;
  var select;
  var sort;
  var total_num;
  Function? bindSelect;
  Function? bindSort;
  CommentsTab(
      {Key? key,
      this.data,
      this.topic_id,
      this.host_id,
      this.total_num,
      this.bindSelect,
      this.bindSort,
      this.select,
      this.sort})
      : super(key: key);

  @override
  _CommentsTabState createState() => _CommentsTabState();
}

class _CommentsTabState extends State<CommentsTab> {
  @override
  Widget build(BuildContext context) {
    return CommentTab(
      total_num: widget.total_num,
      TapSelect: (idx) {
        setState(() {
          widget.bindSelect!(idx);
        });
      },
      TapSort: (idx) {
        if (idx != widget.sort) {
          widget.bindSort!(idx);
        }
      },
      select: widget.select,
      sort: widget.sort,
    );
  }
}

class CommentTab extends StatefulWidget {
  Function? TapSelect;
  Function? TapSort;
  var select;
  var sort;
  var total_num;

  CommentTab({
    Key? key,
    this.TapSelect,
    this.TapSort,
    this.select,
    this.sort,
    this.total_num,
  }) : super(key: key);

  @override
  _CommentTabState createState() => _CommentTabState();
}

class _CommentTabState extends State<CommentTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      // color: Provider.of<ColorProvider>(context).isDark
      //     ? os_detail_back
      //     : os_white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  widget.TapSelect!(0);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    Text(
                      widget.total_num == 0 ? "评论" : "评论(${widget.total_num})",
                      style: XSTextStyle(
                        context: context,
                        color: Provider.of<ColorProvider>(context).isDark
                            ? os_dark_dark_white
                            : Color(0xFF454545),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(height: 3),
                    Container(
                      width: 20,
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
                  widget.TapSelect!(1);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    Text(
                      "楼主",
                      style: XSTextStyle(
                        context: context,
                        color: Provider.of<ColorProvider>(context).isDark
                            ? os_dark_dark_white
                            : Color(0xFF454545),
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
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_light_dark_card
                  : Color(0xFFEEEEEE),
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    widget.TapSort!(0);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 9, vertical: 2),
                    decoration: BoxDecoration(
                      color: widget.sort == 0
                          ? (Provider.of<ColorProvider>(context).isDark
                              ? Color(0x22FFFFFF)
                              : os_white)
                          : Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: Text(
                      "正序",
                      style: XSTextStyle(
                        context: context,
                        fontSize: 15,
                        color: widget.sort == 0
                            ? (Provider.of<ColorProvider>(context).isDark
                                ? os_dark_white
                                : os_black)
                            : os_deep_grey,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.TapSort!(1);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 9, vertical: 2),
                    decoration: BoxDecoration(
                      color: widget.sort == 1
                          ? (Provider.of<ColorProvider>(context).isDark
                              ? Color(0x22FFFFFF)
                              : os_white)
                          : Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: Text(
                      "倒序",
                      style: XSTextStyle(
                        context: context,
                        fontSize: 15,
                        color: widget.sort == 1
                            ? (Provider.of<ColorProvider>(context).isDark
                                ? os_dark_white
                                : os_black)
                            : os_deep_grey,
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
