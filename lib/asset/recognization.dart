import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:offer_show/asset/processUrl.dart';

recognizationQr(String filePath, BuildContext context) async {
  final String data = await FlutterQrReader.imgScan(filePath);
  if (specialUrl(data)) {
    processUrl(data, context);
  }
}
