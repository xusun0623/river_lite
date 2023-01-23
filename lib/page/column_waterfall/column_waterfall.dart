import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:offer_show/asset/color.dart';

class ColumnWaterfall extends StatefulWidget {
  const ColumnWaterfall({Key key}) : super(key: key);

  @override
  State<ColumnWaterfall> createState() => _ColumnWaterfallState();
}

class _ColumnWaterfallState extends State<ColumnWaterfall> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return MasonryGridView.count(
      crossAxisCount: w > 1200 ? 3 : (w > 800 ? 2 : 1),
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      itemBuilder: (context, index) {
        return Container(
          color: os_light_dark_card,
          height: (index % 5 + 1) * 50.0,
          child: Center(
            child: Text(
              index.toString(),
              style: TextStyle(
                color: os_white,
              ),
            ),
          ),
        );
      },
    );
  }
}
