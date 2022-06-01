import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/outer/cached_network_image/cached_image_widget.dart';
import 'package:offer_show/outer/card_swiper/flutter_page_indicator/flutter_page_indicator.dart';
import 'package:offer_show/outer/card_swiper/swiper.dart';
import 'package:offer_show/outer/card_swiper/swiper_pagination.dart';
import 'package:offer_show/page/topic/topic_detail.dart';

class PicSquare extends StatefulWidget {
  PicSquare({Key key}) : super(key: key);

  @override
  State<PicSquare> createState() => _PicSquareState();
}

class _PicSquareState extends State<PicSquare> with TickerProviderStateMixin {
  TabController _tabController;
  List<Map> photo = [
    {
      "topic_id": 13333, //帖子ID
      "photo": [
        //每个帖子的图片链接
        "https://image.meiye.art/pic_1628435115136",
        "https://image.meiye.art/pic_1628435029305",
        "https://image.meiye.art/pic_1628435199840",
        "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fhbimg.huabanimg.com%2F4b62b20bfd0031d4696629a393e65d876188014313a20e-j1tOnz_fw658&refer=http%3A%2F%2Fhbimg.huabanimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1656670990&t=7295b3b9363eb50ad0b7703e794d2b04",
        "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.daimg.com%2Fuploads%2Fallimg%2F190324%2F1-1Z324233415.jpg&refer=http%3A%2F%2Fimg.daimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1656670990&t=3a58e06fa884aecf151b519da1b52ad4",
      ],
      "head_img":
          "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.daimg.com%2Fuploads%2Fallimg%2F190324%2F1-1Z324233415.jpg&refer=http%3A%2F%2Fimg.daimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1656670990&t=3a58e06fa884aecf151b519da1b52ad4",
      "name": "xusun000",
      "like": 13,
      "title": "标题",
      "cont": "文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本"
    },
    {
      "topic_id": 13333, //帖子ID
      "photo": [
        //每个帖子的图片链接
        "https://image.meiye.art/pic_1628435115136",
        "https://image.meiye.art/pic_1628435029305",
        "https://image.meiye.art/pic_1628435199840",
      ],
      "head_img": "https://image.meiye.art/pic_1628435199840",
      "name": "xusun000",
      "like": 13,
      "title": "标题",
      "cont": "文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本"
    },
  ];
  @override
  void initState() {
    _tabController = TabController(
      length: 7,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        leadingWidth: 0,
        elevation: 0,
        backgroundColor: os_dark_back,
        foregroundColor: os_white,
        title: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: os_white,
          indicator: BubbleTabIndicator(
            indicatorHeight: 25.0,
            indicatorColor: Color.fromRGBO(255, 255, 255, 0.2),
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
          isScrollable: true,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          tabs: [
            Tab(text: "镜头下的成电"),
            Tab(text: "风光"),
            Tab(text: "人像"),
            Tab(text: "人文"),
            Tab(text: "小品"),
            Tab(text: "技术"),
            Tab(text: "杂片"),
          ],
        ),
      ),
      backgroundColor: os_dark_back,
      body: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
          maxHeight: MediaQuery.of(context).size.height,
        ),
        child: Swiper(
          fade: 0.1,
          scrollDirection: Axis.vertical,
          loop: false,
          itemCount: photo.length,
          scale: 0.8,
          physics: DefineSwiperPhySics(),
          itemBuilder: (context, index) {
            return PhotoCard(
              data: photo[index],
            );
          },
        ),
      ),
    );
  }
}

class PhotoCard extends StatefulWidget {
  Map data;
  PhotoCard({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  State<PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<PhotoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            178,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      child: Stack(
        children: [
          Swiper(
            itemCount: widget.data["photo"].length,
            loop: false,
            duration: 100,
            pagination: new SwiperPagination(
              builder: DotSwiperPaginationBuilder(
                color: Colors.white54,
                activeColor: Colors.white,
                size: 7.5,
                activeSize: 10,
                space: 10,
              ),
            ),
            indicatorLayout: PageIndicatorLayout.WARM,
            itemBuilder: (context, index) {
              return Center(
                child: Container(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Center(
                      child: Opacity(
                        opacity: 0.3,
                        child: BottomLoading(
                          color: Colors.transparent,
                          txt: "",
                        ),
                      ),
                    ),
                    imageUrl: widget.data["photo"][index],
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 1],
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
              child: Column(
                children: [
                  Container(height: 15),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    width: MediaQuery.of(context).size.width - 60,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          child: CachedNetworkImage(
                            width: 25,
                            height: 25,
                            fit: BoxFit.cover,
                            imageUrl: widget.data["head_img"],
                          ),
                        ),
                        Container(width: 7.5),
                        Container(
                          width: MediaQuery.of(context).size.width - 100,
                          child: Text(
                            widget.data["title"],
                            style: TextStyle(
                              color: os_white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 5),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    width: MediaQuery.of(context).size.width - 60,
                    child: Text(
                      widget.data["cont"],
                      style: TextStyle(
                        color: Color(0xDDFFFFFF),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Container(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DefineSwiperPhySics extends ScrollPhysics {
  const DefineSwiperPhySics({ScrollPhysics parent}) : super(parent: parent);

  @override
  DefineSwiperPhySics applyTo(ScrollPhysics ancestor) {
    return DefineSwiperPhySics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 50, //质量
        stiffness: 100, //硬度
        damping: 0.8, //阻尼系数
      );
}
