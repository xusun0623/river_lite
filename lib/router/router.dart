import 'package:offer_show/page/404.dart';
import 'package:offer_show/page/broke.dart';
import 'package:offer_show/page/detail.dart';
import 'package:offer_show/page/home.dart';
import 'package:offer_show/page/me.dart';
import 'package:offer_show/page/page1.dart';
import 'package:offer_show/page/page2.dart';

final routers = {
  "/": () => Home(),
  "/broke": () => Broke(),
  "/salary_detail": (data) => SalaryDetail(
        salaryId: data,
      ),
  "/me": () => Me(),
  "/404": () => Page404(),
  "/1": (param) => page1(
        param: param,
      ),
  "/2": () => page2(),
};
