import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/page/column_waterfall/waterfall_selection.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class ColumnBtn extends StatefulWidget {
  String? name;
  int? fid;
  bool? loading;
  bool? needPush;
  bool? hideArrow;
  bool? showBackToTop;
  Function? backData;
  Function? clickBackToTop;

  ColumnBtn({
    Key? key,
    this.name,
    this.fid,
    this.loading,
    this.showBackToTop,
    this.hideArrow,
    this.needPush,
    this.backData,
    this.clickBackToTop,
  }) : super(key: key);

  @override
  State<ColumnBtn> createState() => _ColumnBtnState();
}

class _ColumnBtnState extends State<ColumnBtn> {
  @override
  Widget build(BuildContext context) {
    bool loading = widget.loading ?? false;
    return Container(
      child: GestureDetector(
        onTap: () {
          if (widget.showBackToTop ?? false) {
            widget.clickBackToTop!();
            return;
          }
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
                    opacity:
                        Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
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
                widget.backData!(value);
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
          tag: widget.name! + (widget.fid.toString()),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
            width: loading ? 180 : 110,
            height: loading ? 60 : 40,
            decoration: BoxDecoration(
              color: Provider.of<ColorProvider>(context).isDark
                  ? os_light_dark_card
                  : os_white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: widget.hideArrow ?? false
                  ? []
                  : [
                      BoxShadow(
                        color: loading ? Color(0x16000000) : Color(0x33000000),
                        blurRadius: 20,
                        offset: loading ? Offset(3, 30) : Offset(3, 3),
                      ),
                    ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: Offset(!loading ? 3 : 0, 0),
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      widget.name!,
                      style: TextStyle(
                        color: Provider.of<ColorProvider>(context).isDark
                            ? os_dark_white
                            : os_black,
                        // fontSize: 13.5,
                      ),
                    ),
                  ),
                ),
                AnimatedContainer(
                  width: widget.hideArrow ?? false ? 0 : 25,
                  height: widget.hideArrow ?? false ? 0 : 25,
                  duration: Duration(milliseconds: 100),
                  child: Center(
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      opacity: widget.hideArrow ?? false ? 0 : 1,
                      child: loading
                          ? AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              width: 16,
                              height: 16,
                              margin: EdgeInsets.only(left: 10),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color:
                                    Provider.of<ColorProvider>(context).isDark
                                        ? os_dark_white
                                        : os_black,
                              ),
                            )
                          : widget.showBackToTop ?? false
                              ? FadeInUp(
                                  from: 30,
                                  duration: Duration(milliseconds: 200),
                                  child: Icon(
                                    Icons.vertical_align_top_outlined,
                                    size: 18,
                                    color: Provider.of<ColorProvider>(context)
                                            .isDark
                                        ? os_dark_white
                                        : os_black,
                                  ),
                                )
                              : Transform.translate(
                                  offset: Offset(2, 0),
                                  child: Icon(
                                    Icons.arrow_drop_up_outlined,
                                    color: Provider.of<ColorProvider>(context)
                                            .isDark
                                        ? os_dark_white
                                        : os_black,
                                  ),
                                ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
