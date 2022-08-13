import 'dart:convert';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/cookie.dart';
import 'package:offer_show/asset/size.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoPlayContainer extends StatefulWidget {
  String video_url;
  String video_name;
  VideoPlayContainer({
    Key key,
    this.video_url,
    this.video_name,
  }) : super(key: key);

  @override
  State<VideoPlayContainer> createState() => _VideoPlayContainerState();
}

class _VideoPlayContainerState extends State<VideoPlayContainer> {
  VideoPlayerController _controller;
  ChewieController _chewieController;
  double _progress = 0.0;
  bool is_ok = false;
  File _videoFile;

  _setController() async {
    print("设置Controller");
    print("${_videoFile}");
    if (_videoFile != null) {
      _controller = VideoPlayerController.file(_videoFile)
        ..initialize().then((_) {
          print("${_controller}");
          _chewieController = ChewieController(
            videoPlayerController: _controller,
            autoPlay: false,
            allowFullScreen: false,
            aspectRatio: _controller.value.aspectRatio,
          );
          setState(() {
            is_ok = true;
          });
        });
    }
  }

  // 准备视频
  _prepareVideo() async {
    var directory = await getTemporaryDirectory();
    String savePath = directory.path;
    String saveFileName = widget.video_name;

    _videoFile = File("$savePath$saveFileName");

    if (_videoFile.existsSync()) {
      _setController();
    } else {
      String video_arr_txt = await getStorage(key: "video", initData: "[]");
      List video_arr = jsonDecode(video_arr_txt);
      if (!video_arr.contains(_videoFile.path)) {
        video_arr.add(_videoFile.path);
        await setStorage(key: "video", value: jsonEncode(video_arr));
      }

      String cookie = await getWebCookie();
      Dio dio = new Dio();
      await dio.download(
        widget.video_url,
        "$savePath$saveFileName",
        options: Options(
          headers: {"Cookie": cookie},
        ),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print("${(received / total)}");
            setState(() {
              _progress = (received / total).toDouble();
            });
          }
          if (received == total) {
            _setController();
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _controller?.dispose();
    // _videoFile?.delete();
    super.dispose();
  }

  @override
  void initState() {
    _prepareVideo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: is_ok
          ? Container(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Chewie(
                    controller: _chewieController,
                  ),
                ),
              ),
            )
          : Column(
              children: [
                //视频
                Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0x22000000),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 50,
                    ),
                    child: Center(
                      child: _progress == 0.0
                          ? ElevatedButton(
                              child: Text("重新请求视频"),
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all(
                                      Provider.of<ColorProvider>(context).isDark
                                          ? os_dark_dark_white
                                          : os_black),
                                  backgroundColor: MaterialStateProperty.all(
                                      Provider.of<ColorProvider>(context).isDark
                                          ? os_dark_back
                                          : os_white)),
                              onPressed: () {
                                _videoFile.delete();
                                _chewieController?.dispose();
                                _controller?.dispose();
                                _prepareVideo();
                              },
                            )
                          : Column(
                              children: [
                                CircularProgressIndicator(
                                  color:
                                      Provider.of<ColorProvider>(context).isDark
                                          ? os_dark_dark_white
                                          : os_dark_back,
                                  value: _progress,
                                ),
                                Container(height: 20),
                                Text(
                                  "视频加载中",
                                  style: TextStyle(
                                    color: Provider.of<ColorProvider>(context)
                                            .isDark
                                        ? os_dark_dark_white
                                        : os_dark_back,
                                  ),
                                ),
                              ],
                            ),
                    )),
              ],
            ),
    );
  }
}
