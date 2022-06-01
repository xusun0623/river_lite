import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/to_user.dart';
import 'package:offer_show/outer/cached_network_image/cached_image_widget.dart';
import 'package:offer_show/outer/card_swiper/flutter_page_indicator/flutter_page_indicator.dart';
import 'package:offer_show/outer/card_swiper/swiper.dart';
import 'package:offer_show/outer/card_swiper/swiper_pagination.dart';
import 'package:offer_show/page/topic/topic_detail.dart';
import 'package:offer_show/util/storage.dart';

class PicSquare extends StatefulWidget {
  PicSquare({Key key}) : super(key: key);

  @override
  State<PicSquare> createState() => _PicSquareState();
}

class _PicSquareState extends State<PicSquare> with TickerProviderStateMixin {
  TabController _tabController;
  List<Map> photo = [
    {
      "topic_id": 1938816, //帖子ID
      "uid": 128897, //帖子ID
      "photo": [
        //每个帖子的图片链接
        "https://bbs.uestc.edu.cn/data/attachment/forum/202205/26/082733etwfnyhy3tl709n9.jpg",
        "https://bbs.uestc.edu.cn/data/attachment/forum/202205/26/082723j4lylxwmpt0t747n.jpg",
        "https://bbs.uestc.edu.cn/data/attachment/forum/202205/26/105037fqswxo0ii0o4lbgg.jpg",
      ],
      "head_img":
          "https://bbs.uestc.edu.cn/uc_server/avatar.php?uid=128897&size=middle",
      "name": "labor_labour",
      "like": 20,
      "title": "[原创-微距]小荷才露尖尖角,早有蜻蜓立上头",
      "cont": "其实是一只豆娘，当时我与小猛禽的距离只有200公分"
    },
    {
      "topic_id": 1938816, //帖子ID
      "uid": 128897, //帖子ID
      "photo": [
        //每个帖子的图片链接
        "https://bbs.uestc.edu.cn/data/attachment/forum/202205/26/082733etwfnyhy3tl709n9.jpg",
        "https://bbs.uestc.edu.cn/data/attachment/forum/202205/26/082723j4lylxwmpt0t747n.jpg",
        "https://bbs.uestc.edu.cn/data/attachment/forum/202205/26/105037fqswxo0ii0o4lbgg.jpg",
      ],
      "head_img":
          "https://bbs.uestc.edu.cn/uc_server/avatar.php?uid=128897&size=middle",
      "name": "labor_labour",
      "like": 20,
      "title": "[原创-微距]小荷才露尖尖角,早有蜻蜓立上头",
      "cont": "其实是一只豆娘，当时我与小猛禽的距离只有200公分"
    },
    {
      "topic_id": 1938816, //帖子ID
      "uid": 128897, //帖子ID
      "photo": [
        //每个帖子的图片链接
        "https://bbs.uestc.edu.cn/data/attachment/forum/202205/26/082733etwfnyhy3tl709n9.jpg",
        "https://bbs.uestc.edu.cn/data/attachment/forum/202205/26/082723j4lylxwmpt0t747n.jpg",
        "https://bbs.uestc.edu.cn/data/attachment/forum/202205/26/105037fqswxo0ii0o4lbgg.jpg",
      ],
      "head_img":
          "https://bbs.uestc.edu.cn/uc_server/avatar.php?uid=128897&size=middle",
      "name": "labor_labour",
      "like": 20,
      "title": "[原创-微距]小荷才露尖尖角,早有蜻蜓立上头",
      "cont": "其实是一只豆娘，当时我与小猛禽的距离只有200公分"
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
        child: RefreshIndicator(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.2),
          color: os_white,
          onRefresh: () async {
            print("下拉刷新");
            return await Future.delayed(Duration(milliseconds: 300));
          },
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
  bool isLiked = false;

  void _getLikeStatus() async {
    //获取点赞状态
    String tmp = await getStorage(key: "topic_like", initData: "");
    List<String> ids = tmp.split(",");
    if (ids.indexOf(widget.data["topic_id"].toString()) > -1) {
      setState(() {
        isLiked = true;
      });
    }
  }

  _tapLike() async {
    Vibrate.feedback(FeedbackType.impact);
    if (!isLiked) {
      print("在此点赞");
    } else {
      print("在此点赞但是点过赞了");
    }
  }

  _tapMore() async {
    Vibrate.feedback(FeedbackType.impact);
    print("更多更多");
  }

  @override
  void initState() {
    _getLikeStatus();
    super.initState();
  }

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
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/topic_detail",
                      arguments: widget.data["topic_id"],
                    );
                  },
                  onDoubleTap: () {
                    _tapLike();
                  },
                  onLongPress: () {
                    _tapMore();
                  },
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
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
                  ),
                ),
              );
            },
          ),
          PicBottom(
            isLiked: isLiked,
            tapLike: () {
              _tapLike();
            },
            tapMore: () {
              _tapMore();
            },
            data: widget.data,
          ),
        ],
      ),
    );
  }
}

class PicBottom extends StatefulWidget {
  var data;
  bool isLiked;
  Function tapLike;
  Function tapMore;
  PicBottom({
    Key key,
    this.data,
    this.isLiked,
    this.tapLike,
    this.tapMore,
  }) : super(key: key);

  @override
  State<PicBottom> createState() => _PicBottomState();
}

class _PicBottomState extends State<PicBottom> {
  //底部按钮
  @override
  Widget build(BuildContext context) {
    return Positioned(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: MediaQuery.of(context).size.width - 140,
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        child: GestureDetector(
                          onTap: () {
                            toUserSpace(context, widget.data["uid"]);
                          },
                          child: CachedNetworkImage(
                            width: 25,
                            height: 25,
                            fit: BoxFit.cover,
                            imageUrl: widget.data["head_img"],
                          ),
                        ),
                      ),
                      Container(width: 7.5),
                      Container(
                        width: MediaQuery.of(context).size.width - 180,
                        // color: os_grey,
                        child: Text(
                          widget.data["title"],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: os_white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.tapLike != null) {
                            widget.tapLike();
                          }
                        },
                        child: Container(
                          color: Color.fromRGBO(0, 0, 0, 0.001),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  (widget.data["like"] +
                                          (widget.isLiked ?? false ? 1 : 0))
                                      .toString(),
                                  style: TextStyle(
                                    color: widget.isLiked ?? false
                                        ? os_color
                                        : os_white,
                                    fontSize: 14,
                                  ),
                                ),
                                Container(width: 5),
                                Icon(
                                  Icons.thumb_up_alt_sharp,
                                  color: widget.isLiked ?? false
                                      ? os_color
                                      : os_white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (widget.tapMore != null) {
                            widget.tapMore();
                          }
                        },
                        child: Container(
                          color: Color.fromRGBO(0, 0, 0, 0.001),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.more_horiz,
                                  color: os_white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(height: 5),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              width: MediaQuery.of(context).size.width - 30,
              child: Text(
                widget.data["cont"],
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xDDFFFFFF),
                  fontSize: 14,
                ),
              ),
            ),
            Container(height: 27.5),
          ],
        ),
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
