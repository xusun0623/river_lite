import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/saveImg.dart';
import 'package:offer_show/asset/toWebUrl.dart';
import 'package:offer_show/asset/to_user.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/emoji/emoji.dart';
import 'package:offer_show/page/photo_view/photo_view.dart';
import 'package:offer_show/util/cache_manager.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../outer/cached_network_image/cached_image_widget.dart';

class DetailCont extends StatefulWidget {
  var data;
  var imgLists;
  String desc; //在图片上的描述
  String title; //在图片上的描述标题
  bool isComment;
  DetailCont({
    Key key,
    this.data,
    this.imgLists,
    this.isComment,
    this.desc,
    this.title,
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
    t = t.replaceAll("&nbsp;", " ");
    List<String> tmp = t.split("[mobcent_phiz=");
    ret.add(TextSpan(text: tmp[0]));
    for (var i = 1; i < tmp.length; i++) {
      var first_idx = tmp[i].indexOf(']');
      if (first_idx != -1) {
        ret.add(WidgetSpan(
          child: SizedBox(
            width: 30,
            height: 30,
            child: Opacity(
              opacity: Provider.of<ColorProvider>(context).isDark ? 0.8 : 1,
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
          ),
        ));
        ret.add(TextSpan(text: tmp[i].substring(first_idx + 1)));
      }
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.data["type"]) {
      case 0: //纯文字
        return widget.data["infor"].toString().trim() == ""
            ? Container()
            : (widget.data["infor"].toString().characters.length == 1 &&
                    emoji
                        .toString()
                        .characters
                        .contains(widget.data["infor"].toString().trim())
                ? Container(
                    width: MediaQuery.of(context).size.width - 30,
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 60,
                          height: 1.6,
                          color: Provider.of<ColorProvider>(context).isDark
                              ? os_dark_white
                              : os_black,
                        ),
                        text: widget.data["infor"].toString().trim(),
                      ),
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width - 30,
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Provider.of<ColorProvider>(context).isDark
                              ? os_dark_white
                              : os_black,
                        ),
                        children: _getRichText(
                          widget.data["infor"].indexOf("本帖最后由") > -1
                              ? widget.data["infor"].substring(
                                  (widget.data["infor"].indexOf("编辑") + 7) >=
                                          widget.data["infor"].length
                                      ? widget.data["infor"].length - 1
                                      : widget.data["infor"].indexOf("编辑") + 7)
                              : widget.data["infor"],
                        ),
                      ),
                    ),
                  ));
        break;
      case 1: //图片
        return GestureDetector(
          onLongPress: () {
            saveImge(
              context,
              widget.imgLists,
              widget.imgLists.indexOf(widget.data["infor"]),
            );
          },
          child: Opacity(
            opacity: Provider.of<ColorProvider>(context).isDark ? 0.8 : 1,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(
                  widget.imgLists.length > 3 || isDesktop() ? 2.5 : 5)),
              child: Hero(
                tag: widget.imgLists.length > 10
                    ? "不显示Hero动画"
                    : widget.data["infor"],
                child: Container(
                  decoration: BoxDecoration(
                    color: os_grey,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PhotoPreview(
                            desc: widget.desc,
                            title: widget.title,
                            galleryItems: widget.imgLists,
                            defaultImage: widget.imgLists.indexOf(
                              widget.data["infor"],
                            ),
                          ),
                        ),
                      );
                    },
                    child: widget.imgLists.length > 3 || isDesktop()
                        ? (widget.imgLists.length > 10
                            ? Container(
                                color: os_grey,
                                width: isDesktop()
                                    ? 200
                                    : (MediaQuery.of(context).size.width -
                                            (widget.isComment ?? false
                                                ? 50
                                                : 0) -
                                            42) /
                                        3,
                                height: isDesktop()
                                    ? 200
                                    : (MediaQuery.of(context).size.width -
                                            (widget.isComment ?? false
                                                ? 50
                                                : 0) -
                                            42) /
                                        3,
                                child: Image.network(
                                  widget.data["infor"],
                                  fit: BoxFit.cover,
                                  width: isDesktop()
                                      ? 200
                                      : (MediaQuery.of(context).size.width -
                                              (widget.isComment ?? false
                                                  ? 50
                                                  : 0) -
                                              42) /
                                          3,
                                  height: isDesktop()
                                      ? 200
                                      : (MediaQuery.of(context).size.width -
                                              (widget.isComment ?? false
                                                  ? 50
                                                  : 0) -
                                              42) /
                                          3,
                                ),
                              )
                            : CachedNetworkImage(
                                cacheManager: RiverListCacheManager.instance,
                                imageUrl: widget.data["infor"],
                                width: isDesktop()
                                    ? 200
                                    : (MediaQuery.of(context).size.width -
                                            (widget.isComment ?? false
                                                ? 50
                                                : 0) -
                                            42) /
                                        3,
                                height: isDesktop()
                                    ? 200
                                    : (MediaQuery.of(context).size.width -
                                            (widget.isComment ?? false
                                                ? 50
                                                : 0) -
                                            42) /
                                        3,
                                maxHeightDiskCache: 800,
                                maxWidthDiskCache: 800,
                                memCacheWidth: 800,
                                memCacheHeight: 800,
                                filterQuality: FilterQuality.low,
                                fit: BoxFit.cover,
                                progressIndicatorBuilder:
                                    (context, url, progress) {
                                  return Padding(
                                    padding: const EdgeInsets.all(45.0),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: os_middle_grey,
                                      value: progress.progress,
                                    ),
                                  );
                                },
                              ))
                        : CachedNetworkImage(
                            cacheManager: RiverListCacheManager.instance,
                            imageUrl: widget.data["infor"],
                            progressIndicatorBuilder: (context, url, progress) {
                              return Padding(
                                padding: const EdgeInsets.all(45.0),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: os_middle_grey,
                                  value: progress.progress,
                                ),
                              );
                            },
                          ),
                  ),
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
          longPress: () {
            Clipboard.setData(ClipboardData(text: widget.data['url']));
            showToast(
              context: context,
              type: XSToast.success,
              txt: "复制成功",
              duration: 500,
            );
          },
          tap: () {
            try {
              if (widget.data['url']
                      .toString()
                      .indexOf(base_url + "forum.php?mod=viewthread&tid=") >
                  -1) {
                Navigator.pushNamed(
                  context,
                  "/topic_detail",
                  arguments:
                      int.parse(widget.data["url"].toString().split("tid=")[1]),
                );
              } else if (widget.data['url']
                      .toString()
                      .indexOf(base_url + "home.php?mod=space&uid=") >
                  -1) {
                toUserSpace(
                  context,
                  int.parse(widget.data["url"].toString().split("uid=")[1]),
                );
              } else
                showModal(
                  context: context,
                  title: "请确认",
                  cont: "即将调用外部浏览器打开此链接，河畔App不保证此链接的安全性",
                  confirmTxt: "立即前往",
                  cancelTxt: "取消",
                  confirm: () {
                    xsLanuch(
                      url: widget.data['url'],
                      isExtern: false,
                    );
                  },
                );
            } catch (e) {
              showModal(
                context: context,
                title: "请确认",
                cont: "即将调用外部浏览器打开此链接，河畔App不保证此链接的安全性",
                confirmTxt: "立即前往",
                cancelTxt: "取消",
                confirm: () {
                  xsLanuch(
                    url: widget.data['url'],
                    isExtern: false,
                  );
                },
              );
            }
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
        return //图片链接就不用下载了
            myInkWell(
          color: Provider.of<ColorProvider>(context, listen: false).isDark
              ? Color(0x0AFFFFFF)
              : Color(0xFFF6F6F6),
          longPress: () {
            Vibrate.feedback(FeedbackType.impact);
            Clipboard.setData(ClipboardData(text: widget.data['url']));
            showToast(context: context, type: XSToast.success, txt: "复制链接成功");
          },
          tap: () {
            showModal(
                context: context,
                title: "请确认",
                cont: "即将调用外部浏览器下载此附件，河畔App不保证此链接的安全性",
                confirmTxt: "立即前往",
                cancelTxt: "取消",
                confirm: () {
                  launch(Uri.encodeFull(widget.data['url']));
                },
                cancel: () {});
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
