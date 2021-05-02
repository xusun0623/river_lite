import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class os_svg extends StatefulWidget {
  double size;
  final double width;
  final double height;
  String path;
  os_svg({Key key, this.size, this.path, this.width, this.height})
      : super(key: key);
  @override
  _os_svgState createState() => _os_svgState();
}

class _os_svgState extends State<os_svg> {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      widget.path ?? 'lib/img/logo.svg',
      width: widget.size ?? (widget.width ?? 40),
      height: widget.size ?? (widget.height ?? 40),
      placeholderBuilder: (BuildContext context) =>
          Container(child: const CircularProgressIndicator()),
    );
  }
}
