import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/util/interface.dart';

class Square extends StatefulWidget {
  const Square({Key key}) : super(key: key);

  @override
  _SquareState createState() => _SquareState();
}

class _SquareState extends State<Square> {
  FocusNode _focusNode = new FocusNode();
  TextEditingController _controller = new TextEditingController();
  bool showCancel = false;
  var data = [];

  _getData() async {
    var tmp = await Api().forum_forumlist({});
    if (tmp != null && tmp["list"] != null) {
      data = tmp["list"];
    }
    setState(() {});
  }

  List<Widget> _buildCont() {
    List<Widget> tmp = [];
    tmp.add(_getInput());
    if (data != null && data.length != 0) {
      for (var i = 0; i < data.length; i++) {
        tmp.add(Column(
          children: [
            Text(data[i]["board_category_name"]),
          ],
        ));
        for (var j = 0; j < data[i]["board_list"].length; j++) {
          tmp.add(
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  "/column",
                  arguments: data[i]["board_list"][j]["board_id"],
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(data[i]["board_list"][j]["board_name"]),
              ),
            ),
          );
        }
      }
    }
    return tmp;
  }

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {
        showCancel = _controller.text.length > 0;
      });
    });
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: os_back,
      appBar: AppBar(
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: os_back,
        foregroundColor: os_black,
        elevation: 0,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: _buildCont(),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.unfocus();
    super.dispose();
  }

  Widget _getInput() {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      padding: EdgeInsets.only(left: 15),
      height: 50,
      decoration: BoxDecoration(
        color: os_white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 95,
              height: 45,
              child: TextField(
                cursorColor: os_black,
                focusNode: _focusNode,
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "搜一搜",
                  suffixIcon: showCancel
                      ? IconButton(
                          onPressed: () {
                            _controller.clear();
                            _focusNode.requestFocus();
                          },
                          icon: Icon(
                            Icons.cancel,
                            size: 20,
                            color: Color(0xFFAAAAAA),
                          ),
                        )
                      : Icon(Icons.cancel, color: Color(0x00AAAAAA)),
                  border: InputBorder.none,
                ),
              ),
            ),
            myInkWell(
              tap: () {
                _focusNode.unfocus();
              },
              radius: 100,
              widget: Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(15),
                child: os_svg(
                  path: "lib/img/search_blue.svg",
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
