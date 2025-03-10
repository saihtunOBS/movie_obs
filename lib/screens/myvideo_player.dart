import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class MyVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const MyVideoPlayer(
    this.videoUrl, {
    super.key,
  }); // passing Unique key to dispose old class instance and create new with new data

  @override
  // ignore: library_private_types_in_public_api
  _MyVideoPlayerState createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  late VideoPlayerController _controller;
  ChewieController? _chewie;

  @override
  void initState() {
    _initControllers(widget.videoUrl);
    super.initState();
  }

  void _initControllers(String url) {
    _controller = VideoPlayerController.networkUrl(Uri.parse(url));

    _controller.initialize().then((_) {
      setState(() {
        // Pause before switching quality
        _chewie = ChewieController(
          videoPlayerController: _controller,
          allowFullScreen: true,
          looping: false,
          showControls: true,
          zoomAndPan: true,
          allowMuting: true,
          playbackSpeeds: [0.5, 1.0, 1.5, 2.0],

          autoPlay: false,
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewie?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _chewie != null && _chewie!.videoPlayerController.value.isInitialized
        ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: Center(child: Chewie(controller: _chewie!)),
        )
        : CircularProgressIndicator();
  }
}
