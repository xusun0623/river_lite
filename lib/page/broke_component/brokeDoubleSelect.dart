import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';

class BrokeDoubleSelect extends StatefulWidget {
  final TextEditingController controller;

  const BrokeDoubleSelect({
    Key key,
    this.controller,
  }) : super(key: key);
  @override
  _BrokeDoubleSelectState createState() => _BrokeDoubleSelectState();
}

class _BrokeDoubleSelectState extends State<BrokeDoubleSelect> {
  double _right = 0.0;
  final double rright = (os_width - 3 * os_padding) / 2;

  @override
  void initState() {
    super.initState();
    widget.controller.text = "校招";
  }

  _slide() {
    setState(() {
      _right = (_right == 0.0) ? rright : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = widget.controller;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            var t = (_right == 0.0 ? "实习" : "校招");
            _controller.text = t;
            _slide();
          },
          child: Container(
            margin: EdgeInsets.only(
              left: os_padding * 1.5,
              right: os_padding * 1.5,
            ),
            child: Stack(children: [
              Container(
                width: os_width - 3 * os_padding,
                height: 60,
                decoration: BoxDecoration(
                  color: os_color_opa,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              new AnimatedPositioned(
                curve: Curves.easeInOut,
                child: Container(
                  width: (os_width - 3 * os_padding) / 2,
                  height: 60,
                  decoration: BoxDecoration(
                    color: os_color,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular((rright - _right) / rright * 10),
                      topRight: Radius.circular((_right) / rright * 10),
                      bottomLeft:
                          Radius.circular((rright - _right) / rright * 10),
                      bottomRight: Radius.circular((_right) / rright * 10),
                    ),
                  ),
                ),
                left: _right,
                duration: Duration(milliseconds: 300),
              ),
              Positioned(
                top: 17,
                child: Container(
                  width: os_width - 3 * os_padding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Text(
                          "校招",
                          style: TextStyle(
                            color: (_right == 0.0) ? os_white : os_color,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          "实习",
                          style: TextStyle(
                            color: (_right == 0.0) ? os_color : os_white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
