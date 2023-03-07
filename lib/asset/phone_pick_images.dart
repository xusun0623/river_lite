import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';

Future<List> getPhoneImages() async {
  if (Platform.isAndroid) {
    final ImagePicker _picker = ImagePicker();
    final List<XFile> images = await _picker.pickMultiImage();
    return images;
  } else {
    List res = await ImagesPicker.pick(
      count: 10,
      pickType: PickType.image,
      quality: 0.7, //一半的质量
      // maxSize: 2048, //1024KB
    );
    return res;
  }
}
