import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/vibrate.dart';
import 'package:offer_show/asset/xs_textstyle.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQRCode extends StatefulWidget {
  ScanQRCode({Key? key}) : super(key: key);

  @override
  State<ScanQRCode> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '扫码',
          style: XSTextStyle(context: context, fontSize: 16),
        ),
        elevation: 0,
        foregroundColor: os_white,
        backgroundColor: os_black,
        actions: [
          // IconButton(
          //   onPressed: () async {
          //     List<Media> res = await ImagesPicker.pick(
          //       count: 1,
          //       cropOpt: CropOption(),
          //       pickType: PickType.image,
          //       quality: 0.7, //一半的质量
          //       maxSize: 2048, //1024KB
          //     );
          //     recognizationQr(res[0].path, context);
          //   },
          //   icon: Icon(Icons.image_outlined),
          // )
        ],
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: os_black,
      body: Center(child: MobileScanner(onDetect: (result) {
        XSVibrate().success();
        final code = result.barcodes.first.rawValue;
        if (code?.contains("https://bbs.uestc.edu.cn/forum.php?mod=viewthread&tid=") == true) {
          final id = int.parse(code!.split(
              "https://bbs.uestc.edu.cn/forum.php?mod=viewthread&tid=")[1]);
          Navigator.pushNamed(context, '/topic_detail', arguments: id);
          }
      })),
    );
  }
}
