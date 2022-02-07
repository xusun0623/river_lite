import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/components/niw.dart';

class DetailCont extends StatefulWidget {
  var data;
  DetailCont({Key key, this.data}) : super(key: key);

  @override
  _DetailContState createState() => _DetailContState();
}

class _DetailContState extends State<DetailCont> {
  @override
  void initState() {
    super.initState();
  }

  List<InlineSpan> _getRichText(String t) {
    List<InlineSpan> ret = [];
    List<String> tmp = t.split("[mobcent_phiz=");
    ret.add(TextSpan(text: tmp[0]));
    for (var i = 1; i < tmp.length; i++) {
      var first_idx = tmp[i].indexOf(']');
      ret.add(WidgetSpan(
          child: CachedNetworkImage(imageUrl: tmp[i].substring(0, first_idx))));
      ret.add(TextSpan(text: tmp[i].substring(first_idx + 1)));
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.data["type"]) {
      case 0:
        return Container(
          width: MediaQuery.of(context).size.width - 30,
          child: Text.rich(
            TextSpan(
                style: TextStyle(fontSize: 16),
                children: _getRichText(widget.data["infor"])),
          ),
        );
        break;
      case 1:
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(
            decoration: BoxDecoration(
              color: os_grey,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: CachedNetworkImage(
              imageUrl: widget.data["infor"],
              placeholder: (context, url) => Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(color: os_deep_grey),
              ),
            ),
          ),
        );
        break;
      case 2:
        return Container();
        break;
      case 3:
        return Container();
        break;
      case 4:
        return GestureDetector(
          onTap: () {
            print("跳转链接${widget.data['url']}");
          },
          child: Container(
            width: MediaQuery.of(context).size.width - 30,
            child: Text(
              widget.data["infor"],
              style: TextStyle(color: os_color, fontSize: 16),
            ),
          ),
        );
        break;
      case 5:
        return myInkWell(
          color: Color(0xFFF6F6F6),
          tap: () {},
          radius: 10,
          widget: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            width: MediaQuery.of(context).size.width - 30,
            padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "附件" + widget.data["desc"],
                  style: TextStyle(color: os_deep_grey),
                ),
                Text(
                  "点击下载",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: os_color,
                  ),
                ),
              ],
            ),
          ),
        );
        break;
      default:
    }
  }
}
