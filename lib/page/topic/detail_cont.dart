import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/page/photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailCont extends StatefulWidget {
  var data;
  var imgLists;
  DetailCont({
    Key key,
    this.data,
    this.imgLists,
  }) : super(key: key);

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
        child: SizedBox(
          width: 30,
          height: 30,
          child: CachedNetworkImage(
            placeholder: (context, url) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: os_grey,
              ),
            ),
            imageUrl: tmp[i].substring(0, first_idx),
          ),
        ),
      ));
      ret.add(TextSpan(text: tmp[i].substring(first_idx + 1)));
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.data["type"]) {
      case 0: //纯文字
        return Container(
          width: MediaQuery.of(context).size.width - 30,
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
              children: _getRichText(widget.data["infor"]),
            ),
          ),
        );
        break;
      case 1: //图片
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(7.5)),
          child: Container(
            decoration: BoxDecoration(
              color: os_grey,
              borderRadius: BorderRadius.all(Radius.circular(7.5)),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PhotoPreview(
                      galleryItems: widget.imgLists,
                      defaultImage:
                          widget.imgLists.indexOf(widget.data["infor"]),
                    ),
                  ),
                );
              },
              child: CachedNetworkImage(
                imageUrl: widget.data["infor"],
                placeholder: (context, url) => Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(color: os_deep_grey),
                ),
              ),
            ),
          ),
        );
        break;
      case 2: //未知
        return Container();
        break;
      case 3: //未知
        return Container();
        break;
      case 4: //网页链接
        return myInkWell(
          radius: 0,
          tap: () {
            showModal(
              context: context,
              title: "请确认",
              cont: "即将调用外部浏览器打开此链接，河畔App不保证此链接的安全性",
              confirmTxt: "立即前往",
              cancelTxt: "取消",
              confirm: () {
                Navigator.pop(context);
                launch(widget.data['url']);
              },
            );
          },
          color: Colors.transparent,
          widget: Container(
            width: MediaQuery.of(context).size.width - 30,
            child: Text(
              widget.data["infor"],
              style: TextStyle(color: os_color, fontSize: 16),
            ),
          ),
        );
        break;
      case 5: //附件下载
        return myInkWell(
          color: Color(0xFFF6F6F6),
          tap: () {
            showModal(
              context: context,
              title: "请确认",
              cont: "即将调用外部浏览器下载此附件，河畔App不保证此链接的安全性",
              confirmTxt: "立即前往",
              cancelTxt: "取消",
              confirm: () {
                Navigator.pop(context);
                launch(widget.data['url']);
              },
            );
          },
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
