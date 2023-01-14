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
  String select_section;
  int secret_see;
  FocusNode tip_focus;
  RightRowBtn({
    Key key,
    @required this.show_vote,
    @required this.changeVoteStatus,
    @required this.changePopStatus,
    @required this.select_section,
    @required this.changeSecretSee,
    @required this.secret_see,
    @required this.tip_focus,
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
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
