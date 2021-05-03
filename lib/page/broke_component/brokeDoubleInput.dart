import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';

class BrokeInputDouble extends StatefulWidget {
  final bool enable;
  final String hint1;
  final String hint2;
  final TextEditingController controller1;
  final TextEditingController controller2;

  const BrokeInputDouble({
    Key key,
    @required this.hint1,
    @required this.hint2,
    @required this.controller1,
    @required this.controller2,
    @required this.enable,
  }) : super(key: key);
  @override
  _BrokeInputDoubleState createState() => _BrokeInputDoubleState();
}

class _BrokeInputDoubleState extends State<BrokeInputDouble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: os_width - 3 * os_padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: os_width * 0.42,
            child: TextField(
              enabled: widget.enable,
              controller: widget.controller1,
              style: TextStyle(
                color: os_color,
              ),
              cursorColor: os_color_opa,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 15.0,
                ),
                fillColor: os_color_opa_opa,
                filled: true, //920
                hintStyle: TextStyle(
                  color: Color(0xFFA6A5A6),
                ),
                hintText: widget.hint1,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Text("—", style: TextStyle(color: Color(0xFFA6A6A6))),
          Container(
            width: os_width * 0.42,
            child: TextField(
              enabled: widget.enable,
              controller: widget.controller2,
              style: TextStyle(
                color: os_color,
              ),
              cursorColor: os_color_opa,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 15.0,
                ),
                fillColor: os_color_opa_opa,
                filled: true, //920
                hintStyle: TextStyle(
                  color: Color(0xFFA6A5A6),
                ),
                hintText: widget.hint2,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
