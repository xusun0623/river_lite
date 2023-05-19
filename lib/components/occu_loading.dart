import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class OccuLoading extends StatefulWidget {
  OccuLoading({Key? key}) : super(key: key);

  @override
  _OccuLoadingState createState() => _OccuLoadingState();
}

class _OccuLoadingState extends State<OccuLoading> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: MediaQuery.of(context).size.height - 100,
          child: Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 150),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Provider.of<ColorProvider>(context).isDark
                          ? os_dark_dark_white
                          : Colors.black26,
                    ),
                  ),
                  Container(width: 10),
                  Text(
                    "加载中…",
                    style: TextStyle(
                      color: Provider.of<ColorProvider>(context).isDark
                          ? os_dark_dark_white
                          : Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
