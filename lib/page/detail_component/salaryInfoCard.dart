import 'package:flutter/material.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/asset/svg.dart';
import 'package:offer_show/util/provider.dart';
import 'package:provider/provider.dart';

class SalaryInfoCard extends StatefulWidget {
  const SalaryInfoCard({
    Key key,
    @required this.title,
    @required this.cont,
    @required this.icon,
  }) : super(key: key);

  final Widget icon;
  final String title;
  final String cont;
  @override
  _SalaryInfoCardState createState() => _SalaryInfoCardState();
}

class _SalaryInfoCardState extends State<SalaryInfoCard> {
  @override
  Widget build(BuildContext context) {
    KeyBoard provider = Provider.of<KeyBoard>(context);
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Color(0xFFFAFAFA),
        ),
        height: 130,
        width: os_width * 0.29,
        child: InkWell(
          onTap: () {
            provider.close();
          },
          borderRadius: BorderRadius.circular(15),
          child: Container(
            child: Stack(
              children: [
                Positioned(
                  top: 5,
                  left: -1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.icon,
                      Container(
                        margin: EdgeInsets.only(left: 1.0),
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  width: os_width * 0.2,
                  child: Text(
                    widget.cont ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  top: 30,
                ),
                Positioned(
                  child: os_svg(
                    size: 8,
                    path: "lib/img/detail-rightBottom.svg",
                  ),
                  bottom: 0,
                  right: 0,
                ),
              ],
            ),
            padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: 15,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
      ),
    );
  }
}
