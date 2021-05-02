import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/components/niw.dart';
import 'package:direct_select/direct_select.dart';

class BrokeSelectInput extends StatefulWidget {
  final TextEditingController controller;
  final elements;
  final index;

  const BrokeSelectInput({
    Key key,
    @required this.controller,
    @required this.elements,
    this.index,
  }) : super(key: key);

  @override
  _BrokeSelectInputState createState() => _BrokeSelectInputState();
}

class _BrokeSelectInputState extends State<BrokeSelectInput> {
  int selectedIndex = 0;
  var elements = [];
  List<Widget> _buildItems1() {
    return elements
        .map((val) => MySelectionItem(
              title: val,
            ))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    elements = widget.elements;
    selectedIndex = widget.index;
    widget.controller.text = elements[selectedIndex];
  }

  @override
  Widget build(BuildContext context) {
    return DirectSelect(
      itemExtent: 35.0,
      selectedIndex: selectedIndex,
      backgroundColor: os_white,
      child: MySelectionItem(
        isForList: false,
        title: elements[selectedIndex],
      ),
      onSelectedItemChanged: (index) {
        widget.controller.text = elements[index];
        setState(() {
          selectedIndex = index;
        });
      },
      items: _buildItems1(),
    );
  }
}

class MySelectionItem extends StatelessWidget {
  final String title;
  final bool isForList;

  const MySelectionItem({Key key, this.title, this.isForList = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 60.0,
        child: isForList
            ? Padding(
                child: _buildItem(context),
                padding: EdgeInsets.all(0.0),
              )
            : myInkWell(
                splashColor: os_color_opa,
                color: os_color_opa,
                highlightColor: os_color_opa,
                widget: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: os_color,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(width: 10),
                        Text(
                          "(上下滑动选择)",
                          style: TextStyle(
                            color: os_color,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                width: os_width - os_padding * 3,
                height: 60,
                radius: 10,
              ));
  }

  _buildItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Text(title, style: TextStyle(fontSize: 16)),
    );
  }
}
