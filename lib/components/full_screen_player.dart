import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:offer_show/asset/color.dart';
import 'package:video_player/video_player.dart';

class FullScreenPlayer extends StatefulWidget {
  VideoPlayerController? controller;
  ChewieController? chewieController;
  FullScreenPlayer({
    Key? key,
    this.controller,
    this.chewieController,
  }) : super(key: key);

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: os_black,
        body: OrientationBuilder(
          builder: (context, orientation) {
            return Stack(
              children: [
                Center(
                  child: SafeArea(
                    child: Chewie(
                      controller: widget.chewieController!,
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 30,
                  child: IconButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0x11000000))),
                    onPressed: () {
                      widget.chewieController!.pause();
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.chevron_left_rounded,
                      color: os_white,
                    ),
                  ),
                )
              ],
            );
          },
        ));
  }
}
