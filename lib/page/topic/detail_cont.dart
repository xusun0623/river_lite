/*
 * @Author: xusun000「xusun000@foxmail.com」 
 * @Date: 2022-08-14 14:33:53 
 * @Last Modified by: xusun000
 * @Last Modified time: 2022-08-14 15:28:56
 */
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offer_show/outer/flutter_markdown/flutter_markdown.dart';
import 'package:offer_show/outer/markdown/markdown.dart' as md;
import 'package:offer_show/outer/flutter_markdown_latex/flutter_markdown_latex.dart';

import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/modal.dart';
import 'package:offer_show/asset/saveImg.dart';
import 'package:offer_show/asset/toWebUrl.dart';
import 'package:offer_show/asset/to_user.dart';
import 'package:offer_show/asset/vibrate.dart';
import 'package:offer_show/asset/xs_textstyle.dart';
import 'package:offer_show/asset/processUrl.dart';
import 'package:offer_show/components/bilibili_player.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/components/video_player.dart';
import 'package:offer_show/emoji/emoji.dart';
import 'package:offer_show/page/photo_view/photo_view.dart';
import 'package:offer_show/util/cache_manager.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

import '../../util/interface.dart';

class DetailCont extends StatefulWidget {
  var data;
  var imgLists;
  String? format; // 帖子格式
  String? desc; //在图片上的描述
  String? title; //在图片上的描述标题
  bool? isComment;
  bool? removeSelectable; //  是否可以长按复制文字
  bool? fade;
  DetailCont({
    Key? key,
    this.format,
    this.data,
    this.imgLists,
    this.isComment,
    this.desc,
    this.title,
    this.fade,
    this.removeSelectable,
  }) : super(key: key);

  @override
  _DetailContState createState() => _DetailContState();
}

class _DetailContState extends State<DetailCont> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.data["type"]) {
      case 0: //纯文字
        return widget.format == "2" ? WidgetTxtMarkdown(context, widget) : WidgetTxt(context, widget);
      case 1: //图片
        return WidgetImage(context, widget);
      case 2: //未知
        return Container();
      case 3: //未知
        return Container();
      case 4: //网页链接
        return WidgetLink();
      case 5: //附件下载
        return WidgetLinkUrl(); //图片链接就不用下载了
      default:
        return Container();
    }
  }

  bool isIpad() {
    return MediaQuery.of(context).size.shortestSide > 550;
  }

  Widget WidgetLink() {
    String short_url = widget.data['url'].toString();
    if (!isIpad() &&
        short_url.startsWith("https://b23.tv/") &&
        short_url.length < 25 &&
        !isMacOS()) {
      return BilibiliPlayer(short_url: short_url);
    }
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
        print(widget.data);
        // return;
        try {
          if (specialUrl(widget.data['url'].toString())){
            processUrl(widget.data['url'].toString(), context);
          } else
            showModal(
              context: context,
              title: "请确认",
              cont: "即将调用外部浏览器打开此链接，河畔App不保证此链接的安全性",
              confirmTxt: "立即前往",
              cancelTxt: "取消",
              confirm: () async {
                String? text = widget.data['url'];
                if (context == "")
                  return;
                else if (text!.contains(
                    "https://bbs.uestc.edu.cn/forum.php?mod=viewthread&tid=")) {
                  int tid_tmp = int.parse(
                    text.split("mod=viewthread&tid=")[1].split("&")[0],
                  );
                  Navigator.pushNamed(context, "/topic_detail",
                      arguments: tid_tmp);
                  return;
                } else if (text.contains(
                    "https://bbs.uestc.edu.cn/forum.php?mod=redirect&goto=findpost&ptid=")) {
                  int tid_tmp = int.parse(
                    text
                        .split("mod=redirect&goto=findpost&ptid=")[1]
                        .split("&")[0],
                  );
                  Navigator.pushNamed(context, "/topic_detail",
                      arguments: tid_tmp);
                  return;
                } else if (text.contains(
                    "https://bbs.uestc.edu.cn/home.php?mod=space&uid=")) {
                  // https://bbs.uestc.edu.cn/home.php?mod=space&uid=125446
                  int uid_tmp = int.parse(
                    text.split("mod=space&uid=")[1].split("&")[0],
                  );
                  toUserSpace(context, uid_tmp);
                  return;
                } else if (text.contains("https://bbs.uestc.edu.cn")) {
                  int tid = 0;
                  int uid = 0;
                  try {
                    if (text.startsWith("t")) {
                      tid = int.parse(text.split("t")[1]);
                      showToast(context: context, type: XSToast.loading);
                      var pre_search = await Api().forum_postlist({
                        "topicId": tid,
                        "authorId": 0,
                        "order": 0,
                        "page": 1,
                        "pageSize": 0,
                      });
                      hideToast();
                      if (pre_search
                          .toString()
                          .contains("指定的主题不存在或已被删除或正在被审核")) {
                        showToast(
                          context: context,
                          type: XSToast.none,
                          txt: "指定的主题不存在或已被删除或正在被审核",
                          duration: 300,
                        );
                      } else if (pre_search.toString().contains("您没有权限访问该版块")) {
                        showToast(
                          context: context,
                          type: XSToast.none,
                          txt: "您没有权限访问该版块",
                          duration: 300,
                        );
                      } else {
                        Navigator.pushNamed(context, "/topic_detail",
                            arguments: tid);
                      }
                      return;
                    }
                    if (text.startsWith("u")) {
                      uid = int.parse(text.split("u")[1]);
                      showToast(context: context, type: XSToast.loading);
                      var pre_search = await Api().user_userinfo({
                        "userId": uid,
                      });
                      hideToast();
                      if (pre_search.toString().contains("您指定的用户空间不存在")) {
                        showToast(
                          context: context,
                          type: XSToast.none,
                          txt: "您指定的用户空间不存在",
                          duration: 300,
                        );
                      } else {
                        toUserSpace(context, uid);
                      }
                      return;
                    }
                  } catch (e) {}
                } else {
                  xsLanuch(
                    url: widget.data['url'],
                    isExtern: true,
                  );
                }
              },
            );
        } catch (e) {
          print(e);
          showModal(
            context: context,
            title: "请确认",
            cont: "即将调用外部浏览器打开此链接，河畔App不保证此链接的安全性",
            confirmTxt: "立即前往",
            cancelTxt: "取消",
            confirm: () async {
              xsLanuch(
                url: widget.data['url'],
                isExtern: true,
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
          style: XSTextStyle(context: context, color: os_color, fontSize: 16),
        ),
      ),
    );
  }

  Widget WidgetLinkUrl() {
    if (!Platform.isMacOS &&
        !Platform.isWindows &&
        (widget.data["infor"].toString().contains(".mp4") ||
            widget.data["infor"].toString().contains(".m4a") ||
            widget.data["infor"].toString().contains(".flv"))) {
      return VideoPlayContainer(
        video_url: widget.data["url"],
        video_name: Uri.encodeFull(widget.data["infor"]),
      );
    }
    return myInkWell(
      color: Provider.of<ColorProvider>(context, listen: false).isDark
          ? Color(0x0AFFFFFF)
          : Color(0xFFF6F6F6),
      longPress: () {
        XSVibrate().impact();
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
            xsLanuch(url: widget.data['url'], isExtern: true);
          },
          cancel: () {},
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                "附件 \n" + widget.data["infor"],
                style: XSTextStyle(context: context, color: os_deep_grey),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "点击下载",
                style: XSTextStyle(
                  context: context,
                  fontWeight: FontWeight.bold,
                  color: os_color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget WidgetImage(BuildContext context, DetailCont widget) {
  double threeImgsWidth = (MediaQuery.of(context).size.width -
          (widget.isComment ?? false ? 50 : 0) -
          42) /
      3;

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
              ? widget.data["infor"]
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
                      isSmallPic: widget.imgLists.length > 3 ||
                          isDesktop() ||
                          widget.imgLists.length > 20,
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
              child: widget.imgLists.length > 3 ||
                      isDesktop() ||
                      (widget.fade ?? false)
                  ? (widget.imgLists.length > 20
                      ? Container(
                          color: os_grey,
                          width: isDesktop() ? 200 : threeImgsWidth,
                          height: isDesktop() ? 200 : threeImgsWidth,
                          child: CachedNetworkImage(
                            imageUrl: widget.data["infor"],
                            fit: BoxFit.cover,
                            placeholder: (context, url) {
                              return Center(
                                child: Icon(
                                  Icons.image,
                                  color: os_middle_grey,
                                ),
                              );
                            },
                            memCacheWidth:
                                (isDesktop() ? 200 : threeImgsWidth).toInt() *
                                    2,
                            width: isDesktop() ? 200 : threeImgsWidth,
                            height: isDesktop() ? 200 : threeImgsWidth,
                          ),
                        )
                      : Container(
                          child: CachedNetworkImage(
                            imageUrl: widget.data["infor"],
                            width: isDesktop() ? 200 : threeImgsWidth,
                            height: isDesktop() ? 200 : threeImgsWidth,
                            memCacheWidth:
                                (isDesktop() ? 200 : threeImgsWidth).toInt() *
                                    (widget.imgLists.length < 5
                                        ? 5
                                        : widget.imgLists.length < 10
                                            ? 4
                                            : 3),
                            filterQuality: FilterQuality.low,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder: (context, url, progress) {
                              return Center(
                                child: widget.fade ?? false
                                    ? Container(
                                        width: 30,
                                        height: 30,
                                        child: Icon(
                                          Icons.image,
                                          color: os_middle_grey,
                                        ),
                                      )
                                    : Container(
                                        width: 30,
                                        height: 30,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Color.fromARGB(
                                              255, 172, 172, 172),
                                          value: progress.progress,
                                          backgroundColor: Color.fromARGB(
                                              255, 223, 223, 223),
                                        ),
                                      ),
                              );
                            },
                          ),
                        ))
                  : CachedNetworkImage(
                      fit: BoxFit.cover,
                      cacheManager: RiverListCacheManager.instance,
                      imageUrl: widget.data["infor"],
                      progressIndicatorBuilder: (context, url, progress) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 30),
                          child: Center(
                            child: Container(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: os_middle_grey,
                                value: progress.progress,
                              ),
                            ),
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
}

Widget WidgetTxt(BuildContext context, DetailCont widget) {
  return widget.data["infor"].toString().trim() == ""
      ? Container()
      : (widget.data["infor"].toString().characters.length == 1 &&
              emoji
                  .toString()
                  .characters
                  .contains(widget.data["infor"].toString().trim())
          ? Container(
              width: MediaQuery.of(context).size.width - 30,
              child: widget.removeSelectable ?? false
                  ? Text.rich(
                      TextSpan(
                        style: XSTextStyle(
                          context: context,
                          fontSize: 60,
                          height: 1.6,
                          color: Provider.of<ColorProvider>(context).isDark
                              ? os_dark_white
                              : os_black,
                        ),
                        text: widget.data["infor"].toString().trim(),
                      ),
                    )
                  : SelectableText.rich(
                      TextSpan(
                        style: XSTextStyle(
                          context: context,
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
              child: widget.removeSelectable ?? false
                  ? Text.rich(
                      TextSpan(
                        style: XSTextStyle(
                          context: context,
                          fontSize: 15.5,
                          height: 1.6,
                          color: Provider.of<ColorProvider>(context).isDark
                              ? os_dark_white
                              : os_black,
                        ),
                        children: _getRichText(
                          context,
                          widget.data["infor"].indexOf("本帖最后由") > -1
                              ? widget.data["infor"].substring(
                                  (widget.data["infor"].indexOf("编辑") + 7) >=
                                          widget.data["infor"].length
                                      ? widget.data["infor"].length - 1
                                      : widget.data["infor"].indexOf("编辑") + 7)
                              : widget.data["infor"],
                        ),
                      ),
                    )
                  : SelectableText.rich(
                      TextSpan(
                        style: XSTextStyle(
                          context: context,
                          fontSize: 16,
                          height: 1.6,
                          color: Provider.of<ColorProvider>(context).isDark
                              ? os_dark_white
                              : os_black,
                        ),
                        children: _getRichText(
                          context,
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
}

List<InlineSpan> _getRichText(BuildContext context, String t) {
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

// 自定义的 MobcentPhizSyntax
class MobcentPhizSyntax extends md.InlineSyntax {
  MobcentPhizSyntax() : super(r'\[mobcent_phiz=(.*?)\]');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final String url = match.group(1)!;
    final md.Element image = md.Element.empty('mobcent_phiz');
    image.attributes['src'] = url;
    parser.addNode(image);
    return true;
  }
}

// 自定义的 MobcentPhizBuilder
class MobcentPhizBuilder extends MarkdownElementBuilder {
  final bool isDark;

  MobcentPhizBuilder({required this.isDark});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final String? src = element.attributes['src'];
    if (src == null) return null;

    return SizedBox(
      width: 30,
      height: 30,
      child: Opacity(
        opacity: isDark ? 0.8 : 1,
        child: CachedNetworkImage(
          placeholder: (context, url) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.grey,
            ),
          ),
          imageUrl: src,
        ),
      ),
    );
  }
}

// 用于 Markdown 渲染的 WidgetTxt 方法
Widget WidgetTxtMarkdown(BuildContext context, DetailCont widget) {
  if (widget.data["infor"].toString().trim() == "") {
    return Container();
  }

  // 预处理文本
  String markdownText = widget.data["infor"].replaceAll("&nbsp;", " ");

  markdownText = markdownText.replaceAllMapped(
    RegExp(r'本帖最后由(.*?)于(.*)编辑'),
        (match) => '>*本帖最后由${match.group(1)}于${match.group(2)}编辑*\n',
  );

  // 获取 isDark 值
  final bool isDark = Provider.of<ColorProvider>(context, listen: false).isDark;

  // 检查是否为单个表情符号
  if (markdownText.characters.length == 1 &&
      emoji.toString().characters.contains(markdownText.trim())) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      child: Text(
        markdownText.trim(),
        style: XSTextStyle(
          context: context,
          fontSize: 60,
          height: 1.6,
          color: isDark ? os_dark_white : os_black,
        ),
      ),
    );
  }

  // 创建自定义的扩展集
  final md.ExtensionSet customExtensionSet = md.ExtensionSet(
    [
      ...md.ExtensionSet.gitHubFlavored
          .blockSyntaxes, // 移除 4空格的代码块解析  RegExp(r'^(?:    | {0,3}\t)(.*)$');
      LatexBlockSyntax(),
    ],
    [
      MobcentPhizSyntax(),
      ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
      LatexInlineSyntax(),
    ],
  );
  TextStyle commonHeadingStyle = TextStyle(
    color: isDark ? os_dark_white : os_black,
    fontWeight: FontWeight.bold,
  );
  return Container(
    width: MediaQuery.of(context).size.width - 30,
    child: MarkdownBody(
      softLineBreak: true,
      data: markdownText,
      extensionSet: customExtensionSet,
      builders: {
        'mobcent_phiz': MobcentPhizBuilder(isDark: isDark),
        'latex': LatexElementBuilder(
          textStyle: TextStyle(
            color: isDark ? os_dark_white : os_black,
          ),
          textScaleFactor: 1.2,
        ),
      },
      styleSheet: MarkdownStyleSheet(
        p: XSTextStyle(
          context: context,
          fontSize: 16,
          height: 1.6,
          color: isDark ? os_dark_white : os_black,
        ),
        h1: commonHeadingStyle,
        h2: commonHeadingStyle,
        h3: commonHeadingStyle,
        h4: commonHeadingStyle,
        h5: commonHeadingStyle,
        h6: commonHeadingStyle,
        listBullet: commonHeadingStyle, // 设置无序列表编号的Text样式
        blockquote: TextStyle(
          color: os_deep_grey, // 设置引用文本的颜色
          fontStyle: FontStyle.italic,
        ),
        blockquoteDecoration: BoxDecoration(
          color: isDark ? os_light_light_dark_card : os_back, // 设置引用块的背景颜色
          borderRadius: BorderRadius.circular(4),
          border: Border(
            left: BorderSide(
              color: Colors.transparent, // 设置引用块左侧边框的颜色
              width: 4,
            ),
          ),
        ),
        code: TextStyle(
          fontSize: 14,
          color: isDark ? os_dark_white : os_black,
        ),
        codeblockDecoration: BoxDecoration(
          color: isDark ? os_light_light_dark_card : os_back,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
  );
}
