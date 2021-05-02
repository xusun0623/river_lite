import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/components/occu.dart';

class BrokeDeclare extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "—",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: os_deep_grey,
            fontSize: 24,
            height: 1.8,
          ),
        ),
        Text(
          "严肃声明",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: os_deep_grey,
            fontSize: 24,
            height: 1.8,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          "所有数据未经允许，不得盗用！侵权必究！",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: os_deep_grey,
            fontSize: 13,
            height: 1.8,
          ),
        ),
        Text(
          "所有薪资信息均基于自愿共享原则完全匿名发布",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: os_deep_grey,
            fontSize: 13,
            height: 1.8,
          ),
        ),
        Text(
          "任何收集用户隐私的薪资爆料竞品请谨慎对待！",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: os_deep_grey,
            fontSize: 13,
            height: 1.8,
          ),
        ),
        Text(
          "希望大家共同维护良好的薪资交流环境，遵守OfferShow公约",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: os_deep_grey,
            fontSize: 13,
            height: 1.8,
          ),
        ),
        Text(
          "如因为个人隐私问题要屏蔽薪资或者留言数据",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: os_deep_grey,
            fontSize: 13,
            height: 1.8,
          ),
        ),
        Text(
          "请按照以下流程处理：",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: os_deep_grey,
            fontSize: 13,
            height: 1.8,
          ),
        ),
        Text(
          "在对应的薪资下选择反馈或者举报，描述具体原因",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: os_deep_grey,
            fontSize: 13,
            height: 1.8,
          ),
        ),
        Text(
          "请大家不要重复举报，举报反馈原因选择隐私屏蔽选项",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: os_deep_grey,
            fontSize: 13,
            height: 1.8,
          ),
        ),
        Text(
          "我们将会3-7个工作日内对反馈信息处理，理由不合适不予通过",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: os_deep_grey,
            fontSize: 13,
            height: 1.8,
          ),
        ),
        Text(
          "同时也请大家遵守法律法规，杜绝任何违规有害内容",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: os_deep_grey,
            fontSize: 13,
            height: 1.8,
          ),
        ),
        Text(
          "如有其他侵权或者建议反馈等请联系小编微信 zjuerdream",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: os_deep_grey,
            fontSize: 13,
            height: 1.8,
          ),
        ),
        Text(
          "校招薪水，用薪相随！更多薪资清单请关注校招薪水公众号！",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: os_deep_grey,
            fontSize: 13,
            height: 1.8,
          ),
        ),
        occu(),
        Text(
          "—",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: os_deep_grey,
            fontSize: 13,
            height: 1.8,
          ),
        ),
        Text(
          "Show哥 宣",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: os_deep_grey,
            fontSize: 13,
            height: 1.8,
          ),
        ),
      ],
    );
  }
}
