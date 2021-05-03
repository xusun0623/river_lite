import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/data.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/page/home_component/FilterTip.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class HomeFilter extends StatefulWidget {
  final int part_school; //0-校招 1-实习
  final Function filter;

  const HomeFilter({Key key, this.part_school, @required this.filter})
      : super(key: key);
  @override
  _HomeFilterState createState() => _HomeFilterState();
}

class _HomeFilterState extends State<HomeFilter> {
  int _selectMainindex = 0;
  int _selectTipIndex = 0;
  final filterDataTip = [
    industry,
    education,
  ];
  var _selectTipIndexs = [0, 0];
  final filterDataTitle = [
    {"title": "行业"},
    {"title": "学历"}
  ];

  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () {
      setState(() {
        _selectMainindex =
            Provider.of<FilterSchool>(context, listen: false).mainIndex;
        if (_selectMainindex == 0) {
          _selectTipIndexs[0] =
              Provider.of<FilterSchool>(context, listen: false).tipIndex1;
        } else {
          _selectTipIndexs[1] =
              Provider.of<FilterSchool>(context, listen: false).tipIndex2;
        }
      });
    });
  }

  List<Widget> _buildMainTitle(FilterSchool provider) {
    List<Widget> tmp = [];
    for (var i = 0; i < filterDataTitle.length; i++) {
      tmp.add((_selectMainindex == i)
          ? (HomeFilterTipLeft(
              txt: filterDataTitle[i]["title"],
            ))
          : (HomeFilterTipLeftUnSelect(
              tap: () {
                setState(() {
                  provider.setMainIndex(i);
                  _selectMainindex = i;
                });
              },
              txt: filterDataTitle[i]["title"],
            )));
    }
    return tmp;
  }

  List<Widget> _buildSelectTip(FilterSchool provider) {
    List<Widget> tmp = [];
    for (var i = 0; i < filterDataTip[_selectMainindex].length; i++) {
      tmp.add(
        (_selectTipIndexs[_selectMainindex] == i)
            ? (FilterTip(
                txt: filterDataTip[_selectMainindex][i],
                width: os_width * 0.5,
                selected: true,
              ))
            : (FilterTip(
                tap: () {
                  setState(() {
                    if (_selectMainindex == 0) {
                      provider.setTipIndex1(i);
                    } else {
                      provider.setTipIndex2(i);
                    }
                    _selectTipIndexs[_selectMainindex] = i;
                    widget.filter();
                  });
                },
                txt: filterDataTip[_selectMainindex][i],
                width: os_width * 0.5,
              )),
      );
    }
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    FilterSchool provider = Provider.of<FilterSchool>(context);

    return Container(
      width: os_width - 2 * os_padding,
      decoration: BoxDecoration(
        color: os_white,
        borderRadius: BorderRadius.circular(os_round),
      ),
      margin: EdgeInsets.only(
        left: os_padding,
        right: os_padding,
        top: os_space,
      ),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: _buildMainTitle(provider),
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
                border: Border(
              left: BorderSide(
                width: 0.5, //宽度
                color: os_middle_grey, //边框颜色
              ),
            )),
            child: Column(
              children: _buildSelectTip(provider),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeFilterTipLeftUnSelect extends StatefulWidget {
  final String txt;
  final Function tap;

  const HomeFilterTipLeftUnSelect({Key key, this.txt, this.tap})
      : super(key: key);
  @override
  _HomeFilterTipLeftUnSelectState createState() =>
      _HomeFilterTipLeftUnSelectState();
}

class _HomeFilterTipLeftUnSelectState extends State<HomeFilterTipLeftUnSelect> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.tap();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          // color: os_color_opa,
          borderRadius: BorderRadius.circular(7),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          widget.txt ?? "年份",
          style: TextStyle(
            color: os_middle_grey,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class HomeFilterTipLeft extends StatefulWidget {
  final String txt;

  const HomeFilterTipLeft({Key key, this.txt}) : super(key: key);
  @override
  _HomeFilterTipLeftState createState() => _HomeFilterTipLeftState();
}

class _HomeFilterTipLeftState extends State<HomeFilterTipLeft> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: os_color_opa, borderRadius: BorderRadius.circular(7)),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        widget.txt ?? "公司",
        style: TextStyle(
          color: os_color,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
