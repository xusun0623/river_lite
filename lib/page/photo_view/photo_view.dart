import 'package:flutter/material.dart'; // Import package
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/saveImg.dart';
import 'package:offer_show/outer/cached_network_image/cached_image_widget.dart';
import 'package:offer_show/page/topic/detail_cont.dart';
import 'package:offer_show/util/provider.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

typedef PageChanged = void Function(int index);

class PhotoPreview extends StatefulWidget {
  final List galleryItems; //图片列表
  final int defaultImage; //默认第几张
  final PageChanged pageChanged; //切换图片回调
  final Axis direction; //图片查看方向
  final Decoration decoration; //背景设计
  final String desc; //图片描述
  final String title; //图片描述标题

  PhotoPreview(
      {this.galleryItems,
      this.defaultImage = 1,
      this.pageChanged,
      this.direction = Axis.horizontal,
      this.desc,
      this.title,
      this.decoration})
      : assert(galleryItems != null);
  @override
  _PhotoPreviewState createState() => _PhotoPreviewState();
}

class _PhotoPreviewState extends State<PhotoPreview> {
  int tempSelect;
  @override
  void initState() {
    tempSelect = widget.defaultImage + 1;
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
    return Scaffold(
      backgroundColor: os_black,
      body: Stack(
        children: [
          Container(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              onLongPress: () {
                saveImge(context, widget.galleryItems, tempSelect - 1);
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
                            style: TextStyle(color: os_white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(widget.galleryItems[index]),
                  );
                },
                scrollDirection: widget.direction,
                itemCount: widget.galleryItems.length,
                backgroundDecoration:
                    widget.decoration ?? BoxDecoration(color: Colors.black),
                pageController:
                    PageController(initialPage: widget.defaultImage),
                onPageChanged: (index) => setState(
                  () {
                    tempSelect = index + 1;
                    if (widget.pageChanged != null) {
                      widget.pageChanged(index);
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
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
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
                      physics: BouncingScrollPhysics(),
                      children: [
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 16,
                              color: os_dark_white,
                            ),
                            children: _getRichText(widget.title),
                          ),
                        ),
                        Container(height: 5),
                        Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                            children: _getRichText(widget.desc),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          Positioned(
            ///布局自己换
            left: 20,
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
                '$tempSelect/${widget.galleryItems.length}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
