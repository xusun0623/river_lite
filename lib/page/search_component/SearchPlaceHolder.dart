import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class SearchPlaceholder extends StatefulWidget {
  @override
  _SearchPlaceholderState createState() => _SearchPlaceholderState();
}

class _SearchPlaceholderState extends State<SearchPlaceholder> {
  @override
  Widget build(BuildContext context) {
    SearchProvider provider = Provider.of<SearchProvider>(context);
    return provider.getDone
        ? Container()
        : Container(
            margin: EdgeInsets.only(
              top: os_space,
              left: os_padding,
              right: os_padding,
            ),
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: os_white,
              borderRadius: BorderRadius.circular(os_round),
            ),
            child: Column(
              children: [
                PlaceHolderTip(index: 0, txt: '腾讯'),
                PlaceHolderTip(index: 1, txt: '华为'),
                PlaceHolderTip(index: 2, txt: '字节'),
                PlaceHolderTip(index: 3, txt: '美团'),
                PlaceHolderTip(index: 4, txt: '阿里'),
                PlaceHolderTip(index: 5, txt: 'offershow'),
              ],
            ),
          );
  }
}

class PlaceHolderTip extends StatefulWidget {
  final int index;
  final String txt;

  const PlaceHolderTip({
    Key key,
    @required this.index,
    @required this.txt,
  }) : super(key: key);
  @override
  _PlaceHolderTipState createState() => _PlaceHolderTipState();
}

class _PlaceHolderTipState extends State<PlaceHolderTip> {
  @override
  Widget build(BuildContext context) {
    SearchProvider provider = Provider.of<SearchProvider>(context);
    return myInkWell(
      tap: () {
        provider.searchController.text = widget.txt;
        provider.getSearchSalary();
      },
      widget: Container(
        padding: EdgeInsets.symmetric(horizontal: os_padding * 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  (widget.index + 1).toString(),
                  style: TextStyle(
                    color: widget.index > 2
                        ? Color(0xFFDADADA)
                        : [
                            Color(0xFFFE6F61),
                            Color(0xFFFF8C46),
                            Color(0xFF50B8FF)
                          ][widget.index],
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Container(width: 10),
                Text(
                  widget.txt,
                  style: TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            os_svg(
              path: "lib/img/search-placeholder.svg",
              size: 14,
            ),
          ],
        ),
      ),
      width: os_width - 2 * os_padding,
      height: 40,
      radius: 0,
    );
  }
}
