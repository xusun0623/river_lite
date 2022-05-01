import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/components/topic.dart';
import 'package:offer_show/components/totop.dart';
import 'package:offer_show/img/explore/explore.dart';

class ExploreDetail extends StatefulWidget {
  int index;
  ExploreDetail({
    Key key,
    this.index,
  }) : super(key: key);

  @override
  _ExploreDetailState createState() => _ExploreDetailState();
}

class _ExploreDetailState extends State<ExploreDetail> {
  ScrollController _scrollController = new ScrollController();
  bool vibrate = false;
  bool showBackToTop = false;
  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 1000 && !showBackToTop) {
        setState(() {
          showBackToTop = true;
        });
      } else if (_scrollController.position.pixels < 1000 && showBackToTop) {
        setState(() {
          showBackToTop = false;
        });
      }
      if (_scrollController.position.pixels < -150) {
        if (!vibrate) {
          vibrate = true; //不允许再震动
          Vibrate.feedback(FeedbackType.impact);
          Navigator.pop(context);
        }
      }
      if (_scrollController.position.pixels >= 0) {
        vibrate = false; //允许震动
      }
    });
    super.initState();
  }

  List<Widget> _buildWidget() {
    List<Widget> tmp = [];
    tmp.add(ExploreCard(index: widget.index));
    List tmp_data = explore_data[widget.index - 1];
    if (widget.index != 1) {
      tmp_data = tmp_data.reversed.toList();
    }
    for (int i = 0; i < tmp_data.length; i++) {
      tmp.add(Topic(data: tmp_data[i]));
    }
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: os_grey,
        elevation: 0,
        foregroundColor: os_back,
      ),
      backgroundColor: os_grey,
      body: BackToTop(
        bottom: 100,
        controller: _scrollController,
        show: showBackToTop,
        child: ListView(
          physics: BouncingScrollPhysics(),
          controller: _scrollController,
          children: _buildWidget(),
        ),
      ),
    );
  }
}

class ExploreCard extends StatefulWidget {
  int index;
  ExploreCard({
    Key key,
    this.index,
  }) : super(key: key);

  @override
  State<ExploreCard> createState() => _ExploreCardState();
}

class _ExploreCardState extends State<ExploreCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding: EdgeInsets.only(
          top: 10,
        ),
        child: Hero(
          tag: "lib/img/explore/${widget.index}.png",
          child: Stack(
            children: [
              ClipRRect(
                child: Image.asset("lib/img/explore/${widget.index}.png"),
              ),
              Positioned(
                left: 20,
                top: 20,
                child: Icon(Icons.arrow_back, color: os_white, size: 26),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
