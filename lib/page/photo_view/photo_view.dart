import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offer_show/asset/color.dart';
import 'package:photo_view/photo_view_gallery.dart';

typedef PageChanged = void Function(int index);

class PhotoPreview extends StatefulWidget {
  final List galleryItems; //图片列表
  final int defaultImage; //默认第几张
  final PageChanged pageChanged; //切换图片回调
  final Axis direction; //图片查看方向
  final Decoration decoration; //背景设计

  PhotoPreview(
      {this.galleryItems,
      this.defaultImage = 1,
      this.pageChanged,
      this.direction = Axis.horizontal,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: PhotoViewGallery.builder(
              loadingBuilder: (context, event) => Center(
                child: Text("加载图片中…"),
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
              pageController: PageController(initialPage: widget.defaultImage),
              onPageChanged: (index) => setState(
                () {
                  tempSelect = index + 1;
                  if (widget.pageChanged != null) {
                    widget.pageChanged(index);
                  }
                },
              ),
            ),
          )),
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
          )
        ],
      ),
    );
  }
}
