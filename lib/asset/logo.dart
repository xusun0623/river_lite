import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class os_logo extends StatefulWidget {
  double size;
  os_logo({Key key, this.size}) : super(key: key);
  @override
  _os_logoState createState() => _os_logoState();
}

class _os_logoState extends State<os_logo> {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'lib/asset/logo.svg',
      width: widget.size ?? 40,
      height: widget.size ?? 40,
      placeholderBuilder: (BuildContext context) =>
          Container(child: const CircularProgressIndicator()),
    );
  }
}
