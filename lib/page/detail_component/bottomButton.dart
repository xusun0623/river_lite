import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class BottomButton extends StatefulWidget {
  const BottomButton({Key key}) : super(key: key);
  @override
  _BottomButtonState createState() => _BottomButtonState();
}

class _BottomButtonState extends State<BottomButton> {
  @override
  Widget build(BuildContext context) {
    KeyBoard provider = Provider.of<KeyBoard>(context);
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: os_color,
        ),
        width: os_width * 0.45,
        child: InkWell(
          highlightColor: os_black_opa,
          splashColor: os_black_opa,
          onTap: () {
            provider.editingController.text = "";
            provider.open();
            provider.foucs(context);
            // provider.focusNode.requestFocus();
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 40,
            child: Center(
              child: Text(
                "我要留言",
                style: TextStyle(
                  color: os_white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
