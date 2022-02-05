import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/provider.dart';

/// 接口文档：https://github.com/UESTC-BBS/API-Docs/wiki/Mobcent-API

class Api {
  portal_newslist() async {
    return await XHttp().post(
      url: "",
      param: {
        "r": "portal/newslist",
        "moduleId": 2,
      },
    );
  }

  forum_vote(Map m) async {
    m.addAll({"r": "forum/vote"});
    return await XHttp().post(
      url: "",
      param: m,
    );
  }

  forum_support(Map m) async {
    m.addAll({"r": "forum/support"});
    return await XHttp().post(
      url: "",
      param: m,
    );
  }

  /// "xueli": "博士211",
  /// "salarytype": "校招",
  /// "limit": "3",
  webapi_v2_offers_4_lr({Map param}) async {
    loadingStatus = false; //有骨架屏了，不需要加载弹窗
    return await XHttp().postWithGlobalToken(
      param: param,
      url: "/webapi/v2/offers_4_lr",
    );
  }

  webapi_v2_business_ad({Map param}) async {
    return await XHttp().postWithGlobalToken(
      param: param,
      url: "/webapi/v2/business_ad",
    );
  }

  /// "id": 121,
  webapi_v2_offer_detail({Map param}) async {
    loadingStatus = false; //有骨架屏了，不需要加载弹窗
    return await XHttp().postWithGlobalToken(
      param: param,
      url: "/webapi/v2/offer_detail",
    );
  }

  /// "content": "小米",
  /// "education": "全部",
  /// "ordertype": 2,
  /// "part_school": "",
  /// "search_priority": 1,
  /// "year": "",
  webapi_v2_search_salary({Map param}) async {
    return await XHttp().postWithGlobalToken(
      param: param,
      url: "/webapi/v2/search_salary",
    );
  }

  /// "offerids": "1_2_3",
  /// "limit": 8,
  /// "offset": 0,
  webapi_v2_user_favorite_offer({Map param}) async {
    loadingStatus = false;
    return await XHttp().postWithGlobalToken(
      param: param,
      url: "/webapi/v2/user_favorite_offer",
    );
  }

  /// "object_id": 23,
  /// "object_question": "说脏话",
  /// "other_details": "赶紧封了它！是它！不是他！",
  /// "object_type": 1, //{1:薪资,2:一级评论,3:二级评论},
  /// "object_info": "华为天天有夜宵",
  /// "user_wechat": "optional",
  webapi_v2_report({Map param}) async {
    return await XHttp().postWithGlobalToken(
      param: param,
      url: "/webapi/v2/report",
    );
  }

  webapi_qidongad({Map param}) async {
    return await XHttp().postWithGlobalToken(
      param: param,
      url: "/webapi/qidongad/",
    );
  }

  webapi_bannerad({Map param}) async {
    return await XHttp().postWithGlobalToken(
      param: param,
      url: "/webapi/bannerad/",
    );
  }

  /// "offer_id": 1,
  webapi_v2_job_comment_list({Map param}) async {
    loadingStatus = false;
    return await XHttp().postWithGlobalToken(
      param: param,
      url: "/webapi/v2/job_comment_list",
    );
  }

  /// "id": 121,
  /// "content": "xixi",
  webapi_jobmessage({Map param}) async {
    return await XHttp().postWithGlobalToken(
      param: param,
      url: "/webapi/jobmessage/",
    );
  }

  /// "id": "2"
  webapi_joblike({Map param}) async {
    return await XHttp().postWithGlobalToken(
      param: param,
      url: "/webapi/joblike/",
    );
  }

  /// "id": "2"
  webapi_jobdislike({Map param}) async {
    return await XHttp().postWithGlobalToken(
      param: param,
      url: "/webapi/jobdislike/",
    );
  }

  /// "company":"华为",
  /// "position":"软件开发工程师",
  /// "city":"杭州",
  /// "salary":"300",
  /// "remark":"华为天天有夜宵",
  /// "xueli":"本科",
  /// "hangye":"IT",
  /// "salarytype":"实习",
  /// "salary_upper":"150000",
  /// "salary_lower":"25000",
  webapi_jobrecord({Map param}) async {
    return await XHttp().postWithGlobalToken(
      param: param,
      url: "/webapi/jobrecord/",
    );
  }
}
