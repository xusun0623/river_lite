import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/page/column_waterfall/waterfall_selection.dart';

class ColumnBtn extends StatefulWidget {
  String name;
  int fid;
  bool needPush;
  bool hideArrow;
  Function backData;

  ColumnBtn({
    Key key,
    this.name,
    this.fid,
    this.hideArrow,
    this.needPush,
    this.backData,
  }) : super(key: key);

  @override
  State<ColumnBtn> createState() => _ColumnBtnState();
}

class _ColumnBtnState extends State<ColumnBtn> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.needPush ?? false) {
          Navigator.push(
            context,
            PageRouteBuilder(
              opaque: false,
              transitionDuration: Duration(milliseconds: 500),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  //渐变过渡 0.0-1.0
                  opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: animation, //动画样式
                    curve: Curves.fastOutSlowIn, //动画曲线
                  )),
                  child: child,
                );
              },
              pageBuilder: (context, animation, secondaryAnimation) {
                return ColumnWaterfallSelection(
                  fid: widget.fid,
                  name: widget.name,
                );
              },
            ),
          ).then((value) {
            if (widget.backData != null) {
              widget.backData(value);
            }
          });
        } else {
          Navigator.of(context).pop({
            "name": widget.name,
            "fid": widget.fid,
          });
        }
      },
      child: Hero(
        tag: (widget.name) + (widget.fid.toString()),
        child: Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
            color: os_white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 20,
                offset: Offset(3, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                child: Text(
                  widget.name,
                  style: TextStyle(
                    color: os_black,
                  ),
                ),
              ),
              AnimatedContainer(
                width: widget.hideArrow ?? false ? 0 : 25,
                height: widget.hideArrow ?? false ? 0 : 25,
                duration: Duration(milliseconds: 200),
                child: Center(
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 200),
                    opacity: widget.hideArrow ?? false ? 0 : 1,
                    child: Icon(
                      Icons.arrow_drop_up_outlined,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
