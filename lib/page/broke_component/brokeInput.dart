import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';

class BrokeInput extends StatefulWidget {
  final lines;
  final bool enable;
  final String hint;
  final TextEditingController controller;

  const BrokeInput({
    Key key,
    @required this.hint,
    @required this.controller,
    @required this.enable,
    this.lines,
  }) : super(key: key);
  @override
  _BrokeInputState createState() => _BrokeInputState();
}

class _BrokeInputState extends State<BrokeInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: os_width - 3 * os_padding,
      child: TextField(
        maxLines: widget.lines ?? 1,
        enabled: widget.enable,
        controller: widget.controller,
        style: TextStyle(
          color: os_old_color,
        ),
        cursorColor: os_old_color,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 15.0,
          ),
          fillColor: Color.fromRGBO(0, 0, 0, 0.025),
          filled: true, //920
          hintStyle: TextStyle(
            color: Color(0xFFA6A5A6),
          ),
          hintText: widget.hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
