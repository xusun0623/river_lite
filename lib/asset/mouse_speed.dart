import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

speedUp(ScrollController _scrollController) {
  if (Platform.isLinux || Platform.isWindows) {
    //对鼠标指针进行加速
    _scrollController.addListener(() {
      const _extraScrollSpeed = 10;
      // const _extraScrollSpeed = 80;
      ScrollDirection scrollDirection =
          _scrollController.position.userScrollDirection;
      if (scrollDirection != ScrollDirection.idle) {
        double scrollEnd = _scrollController.offset +
            (scrollDirection == ScrollDirection.reverse
                ? _extraScrollSpeed
                : -_extraScrollSpeed);
        scrollEnd = min(_scrollController.position.maxScrollExtent,
            max(_scrollController.position.minScrollExtent, scrollEnd));
        _scrollController.jumpTo(scrollEnd);
      }
    });
  }
}
