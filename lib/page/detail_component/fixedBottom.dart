import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/page/detail_component/bottomButton.dart';
import 'package:offer_show/page/detail_component/bottomRightButtons.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class fixedBottom extends StatefulWidget {
  final bool showText;
  final Function tapLeave;
  final Function sent;

  const fixedBottom(
      {Key key, @required this.showText, @required this.tapLeave, this.sent})
      : super(key: key);
  @override
  _fixedBottomState createState() => _fixedBottomState();
}

class _fixedBottomState extends State<fixedBottom> {
  @override
  Widget build(BuildContext context) {
    KeyBoard provider = Provider.of<KeyBoard>(context);
    return provider.isOpen
        ? BottomState2(
            sent: () {
              widget.sent();
            },
          )
        : BottomState1();
  }
}

class BottomState2 extends StatefulWidget {
  final Function sent;
  const BottomState2({Key key, this.sent}) : super(key: key);
  @override
  _BottomState2State createState() => _BottomState2State();
}

class _BottomState2State extends State<BottomState2> {
  @override
  Widget build(BuildContext context) {
    KeyBoard provider = Provider.of<KeyBoard>(context);
    return Container(
      width: os_width,
      height: 200,
      padding: EdgeInsets.only(
        left: os_padding,
        right: os_padding,
      ),
      decoration: BoxDecoration(
        color: os_white,
        boxShadow: [
          BoxShadow(
            color: os_black_opa,
            blurRadius: 10,
          )
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: os_width * 0.8,
            height: 180,
            child: TextField(
              controller: provider.editingController,
              focusNode: provider.focusNode,
              decoration: InputDecoration(
                hintText: "请友善留言，不要中伤他人",
                fillColor: os_black_opa_opa,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 20,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              myInkWell(
                tap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  provider.close();
                },
                widget: Container(
                  decoration: BoxDecoration(
                    color: os_black_opa,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      "取消",
                      style: TextStyle(
                        color: os_black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                width: os_width * 0.125,
                height: 50,
                radius: 10,
              ),
              Container(height: 10),
              myInkWell(
                tap: () async {
                  final tmp = provider.editingController.text;
                  final now = provider.nowSalaryId;
                  final res = await Api().webapi_jobmessage(param: {
                    "id": now,
                    "content": tmp,
                  });
                  if (res["r"] == 1) {
                    print("OK");
                    provider.editingController.clear();
                    provider.close();
                    provider.unfocus();
                    widget.sent();
                    Fluttertoast.showToast(
                      msg: "发表成功！",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: os_color,
                      textColor: os_white,
                      fontSize: 16.0,
                    );
                  }
                },
                splashColor: os_color_opa,
                highlightColor: os_color_opa,
                widget: Container(
                  decoration: BoxDecoration(
                    color: os_color_opa,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      "发送",
                      style: TextStyle(
                        color: os_color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                width: os_width * 0.125,
                height: 120,
                radius: 10,
              ),
              Container(height: 10),
            ],
          ),
        ],
      ),
    );
  }
}

class BottomState1 extends StatefulWidget {
  const BottomState1({Key key}) : super(key: key);
  @override
  _BottomState1State createState() => _BottomState1State();
}

class _BottomState1State extends State<BottomState1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: os_width,
      height: 60,
      padding: EdgeInsets.only(
        left: os_padding,
        right: os_padding,
      ),
      decoration: BoxDecoration(
          color: os_white,
          boxShadow: [
            BoxShadow(
              color: os_black_opa,
              blurRadius: 10,
            )
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BottomButton(),
          RightButtons(),
        ],
      ),
    );
  }
}
