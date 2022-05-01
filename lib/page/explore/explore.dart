import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';

class Explore extends StatefulWidget {
  Explore({Key key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: os_white,
        elevation: 0,
        foregroundColor: os_black,
      ),
      backgroundColor: os_white,
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ExploreHead(),
          ExploreCard(index: 1),
          ExploreCard(index: 2),
          ExploreCard(index: 3),
          ExploreCard(index: 4),
          ExploreCard(index: 5),
          ExploreCard(index: 6),
          Container(height: 10),
        ],
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
        Navigator.pushNamed(
          context,
          "/explore_detail",
          arguments: widget.index,
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: os_edge,
          vertical: 5,
        ),
        child: Hero(
          tag: "lib/img/explore/${widget.index}.png",
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Image.asset("lib/img/explore/${widget.index}.png"),
          ),
        ),
      ),
    );
  }
}

class ExploreHead extends StatefulWidget {
  const ExploreHead({Key key}) : super(key: key);

  @override
  State<ExploreHead> createState() => _ExploreHeadState();
}

class _ExploreHeadState extends State<ExploreHead> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: os_edge,
            right: os_edge,
            top: 30,
            bottom: 25,
          ),
          child: os_svg(
            path: "lib/img/explore/explore.svg",
            width: 200,
            height: 19,
          ),
        ),
      ],
    );
  }
}
