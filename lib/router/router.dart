import 'package:offer_show/page/404.dart';
import 'package:offer_show/page/broke.dart';
import 'package:offer_show/page/home.dart';
import 'package:offer_show/page/me.dart';
import 'package:offer_show/page/myhome.dart';
import 'package:offer_show/page/photo_view/photo_view.dart';
import 'package:offer_show/page/search/search.dart';
import 'package:offer_show/page/square.dart';
import 'package:offer_show/page/topic/topic_detail.dart';

final routers = {
  "/": () => Home(),
  "/broke": () => Broke(),
  "/me": () => Me(),
  "/myhome": () => MyHome(),
  "/square": () => Square(),
  "/404": () => Page404(),
  "/topic_detail": (data) => TopicDetail(topicID: data),
  "/search": () => Search(),
  "/photo_view": ({data}) => PhotoPreview(
        galleryItems: data.galleryItems,
        defaultImage: data.defaultImage,
        pageChanged: data.pageChanged,
        direction: data.direction,
        decoration: data.decoration,
      ),
};
