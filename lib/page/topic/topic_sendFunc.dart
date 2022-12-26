import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/util/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class SendFunc extends StatefulWidget {
  String path;
  Function tap;
  bool? loading;
  int? nums;
  double? uploadProgress;
  SendFunc({
    Key? key,
    required this.path,
    required this.tap,
    this.loading,
    this.nums,
    this.uploadProgress,
  }) : super(key: key);

  @override
  _SendFuncState createState() => _SendFuncState();
}

class _SendFuncState extends State<SendFunc> {
  @override
  Widget build(BuildContext context) {
    return myInkWell(
      color: Colors.transparent,
      tap: () {
        if (widget.uploadProgress == null) {
          widget.tap();
        } else {
          if (widget.uploadProgress != null && widget.uploadProgress == 0) {
            widget.tap();
          }
        }
      },
      widget: Stack(
        children: [
          widget.nums == null
              ? Container()
              : Positioned(
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Provider.of<ColorProvider>(context).isDark
                          ? os_dark_dark_white
                          : Color(0x22004DFF),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: Text(
                        widget.nums.toString(),
                        style: TextStyle(
                          color: Provider.of<ColorProvider>(context).isDark
                              ? os_dark_back
                              : Color(0xFF004DFF),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  right: 5,
                  top: 5,
                ),
          Container(
            padding: EdgeInsets.all(15),
            child: widget.loading ?? false
                ? Container(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: os_deep_blue,
                    ),
                  )
                : (widget.uploadProgress == null
                    ? os_svg(
                        path: widget.path,
                        width: 24,
                        height: 24,
                      )
                    : (widget.uploadProgress == 0
                        ? os_svg(
                            path: widget.path,
                            width: 24,
                            height: 24,
                          )
                        : (widget.uploadProgress == 1
                            ? Container(
                                width: 24,
                                height: 24,
                                child: Icon(
                                  Icons.cloud_done_rounded,
                                  color:
                                      Provider.of<ColorProvider>(context).isDark
                                          ? os_dark_dark_white
                                          : os_deep_blue,
                                ),
                              )
                            : Container(
                                width: 24,
                                height: 24,
                                child: CircularPercentIndicator(
                                  radius: 12,
                                  lineWidth: 3,
                                  percent: widget.uploadProgress!,
                                  progressColor: os_deep_blue,
                                ),
                              )))),
          ),
        ],
      ),
      radius: 100,
    );
  }
}
