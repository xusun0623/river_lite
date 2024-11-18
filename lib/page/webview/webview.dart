import 'dart:async';
import 'package:flutter/material.dart';

class OSWebViewPage extends StatefulWidget {
  String url;
  OSWebViewPage({super.key, required this.url});

  @override
  State<OSWebViewPage> createState() => _OSWebViewPageState();
}

class _OSWebViewPageState extends State<OSWebViewPage> {
  @override
  void initState() {
    super.initState();
  }

  getWebView() async {}

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(),
    );
  }
}
