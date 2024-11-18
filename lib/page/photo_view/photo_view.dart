import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart'; // Import package
import 'package:offer_show/asset/bigScreen.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/saveImg.dart';
import 'package:offer_show/asset/xs_textstyle.dart';
import 'package:offer_show/components/newNaviBar.dart';
import 'package:offer_show/util/cache_manager.dart';
import 'package:offer_show/util/provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

typedef PageChanged = void Function(int index);

class PhotoPreview extends StatefulWidget {
  bool? isSmallPic;
  final List galleryItems; //图片列表
  final int? defaultImage; //默认第几张
  final PageChanged? pageChanged; //切换图片回调
  final Axis? direction; //图片查看方向
  final Decoration? decoration; //背景设计
  final String? desc; //图片描述
  final String? title; //图片描述标题

  PhotoPreview({
    required this.galleryItems,
    this.defaultImage = 1,
    this.isSmallPic,
    this.pageChanged,
    this.direction = Axis.horizontal,
    this.desc,
    this.title,
    this.decoration,
  }) : assert(galleryItems != null);
  @override
  _PhotoPreviewState createState() => _PhotoPreviewState();
}

class _PhotoPreviewState extends State<PhotoPreview> {
  int? tempSelect;
  PageController? _pageController;

  @override
  void initState() {
    _pageController = new PageController(initialPage: widget.defaultImage!);
    tempSelect = widget.defaultImage! + 1;
  }

  List<InlineSpan> _getRichText(String t) {
    List<InlineSpan> ret = [];
    t = t.replaceAll("&nbsp;", " ");
    List<String> tmp = t.split("[mobcent_phiz=");
    ret.add(TextSpan(text: tmp[0]));
    for (var i = 1; i < tmp.length; i++) {
      var first_idx = tmp[i].indexOf(']');
      ret.add(WidgetSpan(
        child: SizedBox(
          width: 30,
          height: 30,
          child: Opacity(
            opacity: Provider.of<ColorProvider>(context).isDark ? 0.8 : 1,
            child: CachedNetworkImage(
              //表情包
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
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return Baaaar(
      isDark: true,
      child: Scaffold(
        backgroundColor: os_black,
        body: Stack(
          children: [
            Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                onLongPress: () {
                  saveImge(context, widget.galleryItems, tempSelect! - 1);
                },
                child: PhotoViewGallery.builder(
                  loadingBuilder: (context, event) => Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: os_black,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: os_white,
                                strokeWidth: 2.5,
                              ),
                            ),
                            Container(width: 10),
                            Text(
                              "加载图片中…",
                              style: XSTextStyle(
                                  context: context, color: os_white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      minScale: PhotoViewComputedScale.contained * 1,
                      heroAttributes: PhotoViewHeroAttributes(
                        tag: widget.galleryItems[index],
                      ),
                      imageProvider: CachedNetworkImageProvider(
                        widget.galleryItems[index],
                        cacheManager: widget.isSmallPic ?? false
                            ? null
                            : RiverListCacheManager.instance,
                      ),
                    );
                  },
                  scrollDirection: widget.direction!,
                  itemCount: widget.galleryItems.length,
                  backgroundDecoration: widget.decoration as BoxDecoration? ??
                      BoxDecoration(color: Colors.black),
                  pageController: _pageController,
                  onPageChanged: (index) => setState(
                    () {
                      tempSelect = index + 1;
                      if (widget.pageChanged != null) {
                        widget.pageChanged!(index);
                      }
                    },
                  ),
                ),
              ),
            ),
            widget.desc == null || widget.title == null
                ? Container()
                : Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0, 1],
                          colors: [Colors.transparent, Colors.black87],
                        ),
                      ),
                      child: ListView(
                        //physics: BouncingScrollPhysics(),
                        children: [
                          Text.rich(
                            TextSpan(
                              style: XSTextStyle(
                                context: context,
                                fontSize: 16,
                                color: os_dark_white,
                              ),
                              children: _getRichText(widget.title!),
                            ),
                          ),
                          Container(height: 5),
                          Text.rich(
                            TextSpan(
                              style: XSTextStyle(
                                context: context,
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                              children: _getRichText(widget.desc!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            Positioned(
              ///布局自己换
              left: MediaQuery.of(context).size.width / 2 - 52,
              top: 50,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: Text(
                  "图片预览 $tempSelect / ${widget.galleryItems.length}",
                  style: XSTextStyle(context: context, color: Colors.white),
                ),
              ),
            ),
            isDesktop()
                ? Positioned(
                    ///返回按钮
                    left: 50,
                    top: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0x33000000),
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: IconButton(
                        color: os_white,
                        icon: Icon(Icons.chevron_left_rounded),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  )
                : Container(),
            (widget.title ?? "").length == 0 || isDesktop()
                ? FuncButton(
                    widget: widget,
                    tempSelect: tempSelect,
                    pageController: _pageController)
                : Container(),
          ],
        ),
      ),
    );
  }
}

class FuncButton extends StatelessWidget {
  const FuncButton({
    Key? key,
    required this.widget,
    required this.tempSelect,
    required PageController? pageController,
  })  : _pageController = pageController,
        super(key: key);

  final PhotoPreview widget;
  final int? tempSelect;
  final PageController? _pageController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      ///布局自己换
      left: isDesktop()
          ? MediaQuery.of(context).size.width / 2 - 90
          : MediaQuery.of(context).size.width / 2 - 53,
      bottom: 70,
      child: GestureDetector(
        onTap: () {
          if (!isDesktop()) {
            saveImge(context, widget.galleryItems, tempSelect! - 1);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          child: isDesktop()
              ? Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _pageController!.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chevron_left_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                          Text(
                            "上一张",
                            style:
                                XSTextStyle(context: context, color: os_white),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 15),
                    Container(
                      width: 1,
                      height: 15,
                      color: Colors.white30,
                    ),
                    Container(width: 15),
                    GestureDetector(
                      onTap: () {
                        _pageController!.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "下一张",
                            style:
                                XSTextStyle(context: context, color: os_white),
                          ),
                          Icon(
                            Icons.chevron_right_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Icon(
                      Icons.download,
                      color: Colors.white70,
                      size: 18,
                    ),
                    Container(width: 5),
                    Text(
                      "保存图片",
                      style: XSTextStyle(
                        context: context,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
