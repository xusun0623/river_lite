import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/logo.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/components/occu.dart';
import 'package:offer_show/util/interface.dart';
import 'package:offer_show/util/mid_request.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class page1 extends StatefulWidget {
  final param;
  page1({this.param});
  @override
  _page1State createState() => _page1State();
}

class _page1State extends State<page1> with AutomaticKeepAliveClientMixin {
  int _index = 0;
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.all(30),
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Column(
            children: [
              TestProviderMinus(),
              TestProvider(),
              TestProviderAdd(),
              TestProviderMinus(),
              TestProvider(),
              TestProviderAdd(),
              TestProviderMinus(),
              TestProvider(),
              TestProviderAdd(),
            ],
          ),
          os_svg(
            size: 20.0,
            path: "lib/img/share.svg",
          ),
          os_svg(
            path: "lib/img/logo.svg",
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: os_color),
            onPressed: () async {
              var tmp = await Api().webapi_v2_indexad();
            },
            child: Text("首页广告"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: os_color),
            onPressed: () async {
              await Api().webapi_v2_offers_4_lr(
                param: {
                  "xueli": "博士211",
                  "salarytype": "校招",
                  "limit": "3",
                },
              );
            },
            child: Text("最近薪资"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: os_color),
            onPressed: () async {
              await Api().webapi_v2_business_ad();
            },
            child: Text("商业广告"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: os_color),
            onPressed: () async {
              await Api().webapi_v2_offer_detail(
                param: {
                  "id": 121,
                },
              );
            },
            child: Text("薪资详情"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: os_color),
            onPressed: () async {
              await Api().webapi_v2_search_salary(
                param: {
                  "content": "小米",
                  "education": "全部",
                  "ordertype": 2,
                  "part_school": "",
                  "search_priority": 1,
                  "year": "",
                },
              );
            },
            child: Text("搜索结果"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: os_color),
            onPressed: () async {
              await Api().webapi_v2_user_favorite_offer(
                param: {
                  "offerids": "1_2_3",
                  "limit": 8,
                  "offset": 0,
                },
              );
            },
            child: Text("获取用户收藏的薪资条目们"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: os_color),
            onPressed: () async {
              await Api().webapi_v2_report(param: {
                "object_id": 23,
                "object_question": "说脏话",
                "other_details": "赶紧封了它！是它！不是他！",
                "object_type": 1, //{1:薪资,2:一级评论,3:二级评论},
                "object_info": "华为天天有夜宵",
                "user_wechat": "optional",
              });
            },
            child: Text("举报"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: os_color),
            onPressed: () async {
              await Api().webapi_qidongad(param: {});
            },
            child: Text("获取小程序启动页动广告"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: os_color),
            onPressed: () async {
              await Api().webapi_bannerad(param: {});
            },
            child: Text("获取薪资详情页的滑动广告"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: os_color),
            onPressed: () async {
              await Api().webapi_v2_job_comment_list(param: {
                "offer_id": 1,
              });
            },
            child: Text("获取薪资信息的评论们"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: os_color),
            onPressed: () async {
              await Api().webapi_jobmessage(param: {
                "id": 121,
                "content": "xixi",
              });
            },
            child: Text("发评论"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: os_color),
            onPressed: () async {
              await Api().webapi_joblike(param: {
                "id": 121,
              });
            },
            child: Text("点可信"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: os_color),
            onPressed: () async {
              await Api().webapi_jobdislike(param: {
                "id": 121,
              });
            },
            child: Text("点不可信"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: os_color),
            onPressed: () async {
              await Api().webapi_jobrecord(param: {
                "company": "华为",
                "position": "软件开发工程师",
                "city": "杭州",
                "salary": "300",
                "remark": "华为天天有夜宵",
                "xueli": "本科",
                "hangye": "IT",
                "salarytype": "实习",
                "salary_upper": "150000",
                "salary_lower": "25000",
              });
            },
            child: Text("爆料薪资"),
          ),
          occu(),
          occu(),
          occu(),
          occu(),
        ],
      ),
    );
  }
}

class TestProvider extends StatefulWidget {
  @override
  _TestProviderState createState() => _TestProviderState();
}

class _TestProviderState extends State<TestProvider> {
  @override
  Widget build(BuildContext context) {
    MainProvider provider = Provider.of<MainProvider>(context);
    return Container(
      child: Text(provider.curNum.toString()),
    );
  }
}

class TestProviderMinus extends StatefulWidget {
  @override
  _TestProviderMinusState createState() => _TestProviderMinusState();
}

class _TestProviderMinusState extends State<TestProviderMinus> {
  @override
  Widget build(BuildContext context) {
    MainProvider provider = Provider.of<MainProvider>(context);
    return Container(
      child: ElevatedButton(
          onPressed: () {
            provider.minus();
          },
          child: Text("—")),
    );
  }
}

class TestProviderAdd extends StatefulWidget {
  @override
  _TestProviderAddState createState() => _TestProviderAddState();
}

class _TestProviderAddState extends State<TestProviderAdd> {
  @override
  Widget build(BuildContext context) {
    MainProvider provider = Provider.of<MainProvider>(context);
    return Container(
      child: ElevatedButton(
          onPressed: () {
            provider.add();
          },
          child: Icon(Icons.add)),
    );
  }
}
