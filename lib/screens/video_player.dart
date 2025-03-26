import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

final videoPlayerController = VideoPlayerController.networkUrl(
  Uri.parse(
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  ),
);

final chewieController = ChewieController(
  videoPlayerController: videoPlayerController,
  autoPlay: true,
  looping: true,
  allowFullScreen: true,
);

final playerWidget = Chewie(controller: chewieController);

class NewPlayer extends StatefulWidget {
  const NewPlayer({super.key});

  @override
  State<NewPlayer> createState() => _NewPlayerState();
}

class _NewPlayerState extends State<NewPlayer> {
  @override
  void initState() {
    videoPlayerController.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: AspectRatio(
      aspectRatio: videoPlayerController.value.aspectRatio,
      child: playerWidget)));
  }
}
