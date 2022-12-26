import 'dart:convert';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offer_show/asset/color.dart';
import 'package:offer_show/asset/cookie.dart';
import 'package:offer_show/components/full_screen_player.dart';
import 'package:offer_show/components/niw.dart';
import 'package:offer_show/util/provider.dart';
import 'package:offer_show/util/storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoPlayContainer extends StatefulWidget {
  String? video_url;
  String? video_name;
  VideoPlayContainer({
    Key? key,
    this.video_url,
    this.video_name,
  }) : super(key: key);

  @override
  State<VideoPlayContainer> createState() => _VideoPlayContainerState();
}

class _VideoPlayContainerState extends State<VideoPlayContainer> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  double _progress = 0.0;
  bool is_ok = false;
  bool is_to_fullscreen = false;
  File? _videoFile;

  _setController() async {
    if (_videoFile != null) {
      _controller = VideoPlayerController.file(_videoFile!);
      await _controller!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _controller!,
        autoPlay: false,
        allowFullScreen: false,
        aspectRatio: _controller!.value.aspectRatio,
        allowedScreenSleep: false,
        showOptions: false,
      );
      setState(() {
        is_ok = true;
      });
    }
  }

  // 准备视频
  _prepareVideo() async {
    var directory = await getTemporaryDirectory();
    String savePath = directory.path;
    String? saveFileName = widget.video_name;

    _videoFile = File("$savePath$saveFileName");

    if (_videoFile!.existsSync()) {
      _setController();
    } else {
      String video_arr_txt = await getStorage(key: "video", initData: "[]");
      List video_arr = jsonDecode(video_arr_txt);
      if (!video_arr.contains(_videoFile!.path)) {
        video_arr.add(_videoFile!.path);
        await setStorage(key: "video", value: jsonEncode(video_arr));
      }

      String cookie = await getWebCookie();
      Dio dio = new Dio();
      await dio.download(
        widget.video_url!,
        "$savePath$saveFileName",
        options: Options(
          headers: {"Cookie": cookie},
        ),
        onReceiveProgress: (received, total) {
          if (total != -1) {
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

  void pushFullScreenVideo() {
    if (_chewieController == null ||
        _controller == null ||
        _videoFile == null) {
      return;
    }
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );
    is_to_fullscreen = true;
    _chewieController = ChewieController(
      videoPlayerController: _controller!,
      autoPlay: false,
      allowFullScreen: false,
      aspectRatio: _controller!.value.aspectRatio,
      allowedScreenSleep: false,
      showControls: true,
    );
    print("true");
    Navigator.of(context)
        .push(
      PageRouteBuilder(
        opaque: false,
        settings: RouteSettings(),
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FullScreenPlayer(
            controller: _controller,
            chewieController: _chewieController,
          );
        },
      ),
    )
        .then(
      (value) {
        print("false");
        is_to_fullscreen = false;
        _chewieController = ChewieController(
          videoPlayerController: _controller!,
          autoPlay: false,
          allowFullScreen: false,
          aspectRatio: _controller!.value.aspectRatio,
          allowedScreenSleep: false,
          showControls: false,
        );
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: SystemUiOverlay.values);
        SystemChrome.setPreferredOrientations(
          [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    if (!is_to_fullscreen) {
      _chewieController?.dispose();
      _controller?.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    _prepareVideo();
    super.initState();
  }

  _reGetVideo() {
    setState(() {
      _progress = 0.0;
      is_ok = false;
    });
    _videoFile!.delete();
    _chewieController?.dispose();
    _controller?.dispose();
    _prepareVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: is_ok
          ? Column(
              children: [
                Stack(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 500,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: Chewie(
                            controller: _chewieController!,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 5,
                      top: 5,
                      child: myInkWell(
                        tap: () {
                          pushFullScreenVideo();
                        },
                        color: Color(0x77000000),
                        widget: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 4,
                          ),
                          child: Icon(
                            Icons.fullscreen,
                            color: os_white,
                          ),
                        ),
                        radius: 10,
                      ),
                    )
                  ],
                ),
                ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh),
                      Text("重新拉取视频"),
                    ],
                  ),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                        Provider.of<ColorProvider>(context).isDark
                            ? os_dark_dark_white
                            : os_deep_grey),
                    shadowColor: MaterialStateProperty.all(
                      Colors.transparent,
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Colors.transparent,
                    ),
                  ),
                  onPressed: () {
                    _reGetVideo();
                  },
                )
              ],
            )
          : Column(
              children: [
                //视频
                Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0x11000000),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 50,
                    ),
                    child: Center(
                      child: _progress == 0.0
                          ? ElevatedButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.refresh),
                                  Text("重新请求视频"),
                                ],
                              ),
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(
                                    Provider.of<ColorProvider>(context).isDark
                                        ? os_dark_dark_white
                                        : os_deep_grey),
                                shadowColor: MaterialStateProperty.all(
                                  Colors.transparent,
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.transparent,
                                ),
                              ),
                              onPressed: () {
                                _reGetVideo();
                              },
                            )
                          : Column(
                              children: [
                                CircularProgressIndicator(
                                  color:
                                      Provider.of<ColorProvider>(context).isDark
                                          ? os_dark_dark_white
                                          : os_deep_grey,
                                  value: _progress,
                                ),
                                Container(height: 20),
                                Text(
                                  "视频加载中",
                                  style: TextStyle(
                                    color: Provider.of<ColorProvider>(context)
                                            .isDark
                                        ? os_dark_dark_white
                                        : os_deep_grey,
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
