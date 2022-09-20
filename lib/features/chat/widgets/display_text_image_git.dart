import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:whatsapp/enums/message_enums.dart';
import 'package:whatsapp/features/chat/widgets/video_player_item.dart';

class DisplayTextImageGif extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGif({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AudioPlayer audioPlayer = AudioPlayer();
    bool isPlaying = false;
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(fontSize: 16),
          )
        : type == MessageEnum.image
            ? CachedNetworkImage(imageUrl: message)
            : type == MessageEnum.video
                ? VideoPlayerItem(videoUrl: message)
                : StatefulBuilder(builder: (context, setState) {
                    return IconButton(
                      constraints: const BoxConstraints(minWidth: 100),
                      onPressed: () async {
                        if (isPlaying) {
                          await audioPlayer.pause();
                          setState(() => isPlaying = false);
                        } else {
                          await audioPlayer.play(UrlSource(message));
                          setState(() => isPlaying = true);
                        }
                      },
                      icon: isPlaying
                          ? const Icon(Icons.pause_circle)
                          : const Icon(Icons.play_circle),
                    );
                  });
  }
}
