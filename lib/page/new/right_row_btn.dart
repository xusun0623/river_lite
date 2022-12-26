import 'package:flutter/material.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/outer/showActionSheet/action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_item.dart';
import 'package:offer_show/outer/showActionSheet/bottom_action_sheet.dart';
import 'package:offer_show/outer/showActionSheet/top_action_item.dart';

class RightRowBtn extends StatefulWidget {
  bool show_vote;
  Function changeVoteStatus;
  Function changePopStatus;
  Function changeSecretSee;
  String? select_section;
  int secret_see;
  FocusNode tip_focus;
  RightRowBtn({
    Key? key,
    required this.show_vote,
    required this.changeVoteStatus,
    required this.changePopStatus,
    required this.select_section,
    required this.changeSecretSee,
    required this.secret_see,
    required this.tip_focus,
  }) : super(key: key);

  @override
  State<RightRowBtn> createState() => _RightRowBtnState();
}

class _RightRowBtnState extends State<RightRowBtn> {
  @override
  Widget build(BuildContext context) {
    return Row(
      //右边功能区
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 25,
            padding: EdgeInsets.symmetric(horizontal: 7),
            margin: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(
                Radius.circular(100),
              ),
              border: Border.all(
                color: widget.show_vote ? Colors.red : Color(0xFF9D9D9D),
              ),
            ),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  widget.changePopStatus(false);
                  if (widget.show_vote) {
                    showModal(
                      context: context,
                      title: "请确认",
                      cont: "是否要删除此投票，请谨慎操作",
                      confirm: () {
                        widget.changeVoteStatus(false);
                      },
                    );
                  } else {
                    widget.changeVoteStatus(true);
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      widget.show_vote ? Icons.no_sim_outlined : Icons.add,
                      size: 12,
                      color: widget.show_vote ? Colors.red : Color(0xFF9D9D9D),
                    ),
                    widget.show_vote
                        ? Text(
                            "删除投票",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          )
                        : Text(
                            "插入投票",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9D9D9D),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
        widget.select_section != "密语"
            ? Container()
            : GestureDetector(
                onTap: () {
                  showActionSheet(
                    context: context,
                    topActionItem: TopActionItem(
                      title: "评论有哪些人可以👀",
                      titleTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    actions: [
                      ActionItem(
                        title: "评论所有人可见",
                        onPressed: () {
                          Navigator.pop(context);
                          widget.changeSecretSee(0);
                        },
                      ),
                      ActionItem(
                        title: "评论仅作者可见",
                        onPressed: () {
                          Navigator.pop(context);
                          widget.changeSecretSee(1);
                        },
                      ),
                    ],
                    bottomActionItem: BottomActionItem(title: "取消"),
                  );
                },
                child: Container(
                  height: 25,
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: os_white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                    border: Border.all(
                      color: Color(0xFF9D9D9D),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Text(
                          widget.secret_see == 0 ? "所有人可见" : "仅作者可见",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9D9D9D),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_up_rounded,
                          size: 12,
                          color: Color(0xFF9D9D9D),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        !widget.tip_focus.hasFocus || isDesktop()
            ? Container()
            : GestureDetector(
                onTap: () {
                  widget.tip_focus.unfocus();
                },
                child: Container(
                  height: 25,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: os_color,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: os_white,
                        ),
                        // Text(
                        //   "完成",
                        //   style: TextStyle(
                        //     fontSize: 12,
                        //     color: os_white,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
