import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:provider/provider.dart';

class TopicVote extends StatefulWidget {
  var poll_info;
  var topic_id;
  TopicVote({Key key, this.poll_info, this.topic_id}) : super(key: key);

  @override
  _TopicVoteState createState() => _TopicVoteState();
}

class _TopicVoteState extends State<TopicVote> {
  int select = -1;
  bool selected = false;

  @override
  void initState() {
    _getStatus();
    super.initState();
  }

  void _getStatus() async {
    String data = await getStorage(
      key: "vote_side",
      initData: "",
    );
    var poll_item_ids = data.split(",");
    var poll_item_list = widget.poll_info["poll_item_list"];
    poll_item_ids.forEach((element) {
      for (var i = 0; i < poll_item_list.length; i++) {
        if (element == "${poll_item_list[i]['poll_item_id']}") {
          selected = true;
          select = i;
        }
      }
    });
    setState(() {});
  }

  void _vote(int side) async {
    if (selected) return;
    var poll_item_id = widget.poll_info["poll_item_list"][side]["poll_item_id"];
    await Api().forum_vote({
      "tid": widget.topic_id,
      "options": poll_item_id,
    });
    widget.poll_info["voters"]++;
    widget.poll_info["poll_item_list"][side]["total_num"]++;
    var vote_status = await getStorage(
      key: "vote_side",
      initData: "",
    );
    vote_status += "${poll_item_id},";
    await setStorage(key: "vote_side", value: vote_status);
    select = side;
    selected = true;
    setState(() {});
  }

  List<Widget> _buildVote() {
    List<Widget> tmp = [];
    widget.poll_info["poll_item_list"].forEach((element) {
      int ele_idx = widget.poll_info["poll_item_list"].indexOf(element);
      tmp.add(GestureDetector(
        onTap: () {
          _vote(ele_idx);
        },
        child: Container(
          width: MediaQuery.of(context).size.width - 50,
          margin: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Provider.of<ColorProvider>(context).isDark
                ? Color(0x11FFFFFF)
                : os_white,
            borderRadius: BorderRadius.all(Radius.circular(7.5)),
            border: Border.all(
                color: selected
                    ? (Provider.of<ColorProvider>(context).isDark
                        ? os_dark_dark_white
                        : os_color)
                    : (Provider.of<ColorProvider>(context).isDark
                        ? Color(0x00FFFFFF)
                        : Color(0xFFCCCCCC))),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 50,
                padding: EdgeInsets.symmetric(vertical: 7.5, horizontal: 12),
                decoration: !selected
                    ? null
                    : BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6.5)),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: [
                            (element["total_num"] / widget.poll_info["voters"]),
                            (element["total_num"] /
                                    widget.poll_info["voters"]) +
                                0.00001
                          ],
                          colors: [
                            Provider.of<ColorProvider>(context).isDark
                                ? Color(0x11FFFFFF)
                                : os_color_opa,
                            Provider.of<ColorProvider>(context).isDark
                                ? os_light_dark_card
                                : os_white
                          ],
                        ),
                      ),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 180,
                    child: Text(
                      (selected && select == (ele_idx) ? "【已选】" : "") +
                          (element["name"].toString()),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selected
                            ? (Provider.of<ColorProvider>(context).isDark
                                ? os_dark_white
                                : os_color)
                            : (Provider.of<ColorProvider>(context).isDark
                                ? os_dark_white
                                : os_black),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Text(
                  selected
                      ? (element["total_num"] /
                                  widget.poll_info["voters"] *
                                  100)
                              .toStringAsFixed(2) +
                          "%"
                      : "投票",
                  style: TextStyle(
                    color: selected
                        ? (Provider.of<ColorProvider>(context).isDark
                            ? os_dark_white
                            : os_color)
                        : (Provider.of<ColorProvider>(context).isDark
                            ? os_dark_white
                            : os_black),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                right: 10,
              ),
            ],
          ),
        ),
      ));
    });
    tmp.add(Container(
      width: MediaQuery.of(context).size.width - 50,
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Text(
        " 已有 ${widget.poll_info['voters']} 人参与投票",
        style: TextStyle(
          color: os_deep_grey,
          fontSize: 12,
        ),
      ),
    ));
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return widget.poll_info == null
        ? Container()
        : Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Provider.of<ColorProvider>(context).isDark
                  ? Color(0x08FFFFFF)
                  : Color(0xFFF6F6F6),
              borderRadius: BorderRadius.all(Radius.circular(7.5)),
            ),
            child: Column(
              children: _buildVote(),
            ),
          );
  }
}
