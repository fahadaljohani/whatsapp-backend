import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({super.key, required this.videoUrl});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  bool isPlay = false;
  late CachedVideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize();
    controller.setVolume(1);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(controller),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                if (isPlay) {
                  controller.pause();
                  setState(() {
                    isPlay = false;
                  });
                } else {
                  controller.play();
                  setState(() {
                    isPlay = true;
                  });
                }
              },
              icon: isPlay
                  ? const Icon(Icons.pause_circle)
                  : const Icon(Icons.play_circle),
            ),
          ),
        ],
      ),
    );
  }
}
