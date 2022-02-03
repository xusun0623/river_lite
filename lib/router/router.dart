import 'package:offer_show/page/404.dart';
import 'package:offer_show/page/broke.dart';
import 'package:offer_show/page/home.dart';
import 'package:offer_show/page/me.dart';
import 'package:offer_show/page/myhome.dart';
import 'package:offer_show/page/search.dart';
import 'package:offer_show/page/square.dart';

final routers = {
  "/": () => Home(),
  "/broke": () => Broke(),
  "/me": () => Me(),
  "/search": () => OSSearch(),
  "/myhome": () => MyHome(),
  "/square": () => Square(),
  "/404": () => Page404(),
};
