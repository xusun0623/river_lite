import 'package:offer_show/page/404.dart';
import 'package:offer_show/page/about/about.dart';
import 'package:offer_show/page/account/account.dart';
import 'package:offer_show/page/blacklist/black_list.dart';
import 'package:offer_show/page/broke.dart';
import 'package:offer_show/page/collection_detail/collection_detail.dart';
import 'package:offer_show/page/column/column.dart';
import 'package:offer_show/page/crop/crop.dart';
import 'package:offer_show/page/explore/explore.dart';
import 'package:offer_show/page/home.dart';
import 'package:offer_show/page/hot/homeHot.dart';
import 'package:offer_show/page/home/myhome.dart';
import 'package:offer_show/page/login/login.dart';
import 'package:offer_show/page/login/login_helper.dart';
import 'package:offer_show/page/me/me.dart';
import 'package:offer_show/page/me_func/me_func.dart';
import 'package:offer_show/page/msg_detail/msg_detail.dart';
import 'package:offer_show/page/msg_three/msg_three.dart';
import 'package:offer_show/page/new/new.dart';
import 'package:offer_show/page/person_detail/personDetail.dart';
import 'package:offer_show/page/personal/personal.dart';
import 'package:offer_show/page/photo_view/photo_view.dart';
import 'package:offer_show/page/question/question.dart';
import 'package:offer_show/page/scan_qrcode/scan_qrcode.dart';
import 'package:offer_show/page/search/search.dart';
import 'package:offer_show/page/setting/setting.dart';
import 'package:offer_show/page/square/square.dart';
import 'package:offer_show/page/start/start.dart';
import 'package:offer_show/page/test/test.dart';
import 'package:offer_show/page/topic/alter_sent.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/page/topic/topic_edit.dart';
import 'package:offer_show/page/user_list/user_list.dart';
import 'package:offer_show/page/waterTask/task_list.dart';
import 'package:offer_show/page/waterTask/water_inout_detail.dart';
import 'package:offer_show/page/waterTask/water_task.dart';
import 'package:offer_show/page/water_total/water_total.dart';

final routers = {
  "/": () => Start(),
  "/water_inout_detail": () => WaterInoutDetail(),
  "/water_total": () => WaterTotal(),
  "/list": (data) => CollectionDetail(data: data),
  "/scan_qrcode": () => ScanQRCode(),
  "/body": () => Home(),
  "/question": () => Question(),
  "/login": (data) => Login(index: data ?? 0),
  "/water_task": () => WaterTask(),
  "/person_detail": (uid) => PersonDetail(uid: uid),
  "/about": () => About(),
  "/test": () => Test(),
  "/setting": () => Setting(),
  "/account": () => Account(),
  "/explore": () => Explore(),
  "/login_helper": () => LoginHelper(),
  "/broke": () => Broke(),
  "/task_list": () => TaskList(),
  "/me": () => Me(),
  "/myhome": () => MyHome(),
  "/square": () => Square(),
  "/404": () => Page404(),
  "/me_func": (data) => MeFunc(type: data["type"], uid: data["uid"]),
  "/person_center": (data) => PersonCenter(param: data),
  "/alter_sent": () => AlterSent(),
  "/topic_detail": (data) => TopicDetail(topicID: data),
  "/topic_edit": (data) => TopicEdit(tid: data["tid"], pid: data["pid"]),
  "/search": (int type) => Search(type: type),
  "/crop": () => CropImg(),
  "/column": (data) => TopicColumn(columnID: data),
  "/hot": () => Hot(),
  "/new": (data) => PostNew(board_id: data),
  "/black_list": () => BlackList(),
  "/msg_three": (data) => MsgThree(type: data),
  "/msg_detail": (data) => MsgDetail(usrInfo: data),
  "/user_list": (data) => UserList(data: data),
  "/photo_view": ({data}) => PhotoPreview(
        galleryItems: data.galleryItems,
        defaultImage: data.defaultImage,
        pageChanged: data.pageChanged,
        direction: data.direction,
        decoration: data.decoration,
      ),
};
