import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class AdaptiveVideoPlayer extends StatefulWidget {
  @override
  _AdaptiveVideoPlayerState createState() => _AdaptiveVideoPlayerState();
}

class _AdaptiveVideoPlayerState extends State<AdaptiveVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    // Initialize the VideoPlayerController with the HLS URL
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8',
      ),
    );

    // Initialize ChewieController with VideoPlayerController
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      // Controls for play, pause, volume, fullscreen, etc.
    );

    // Rebuild the widget when the controller is ready
    setState(() {});
  }

  @override
  void dispose() {
    // Dispose of the controllers when widget is removed from the tree
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("YouTube-style Adaptive Video Player")),
      body: Center(
        child:
            _chewieController != null &&
                    _chewieController.videoPlayerController.value.isInitialized
                ? Chewie(controller: _chewieController)
                : CircularProgressIndicator(),
      ),
    );
  }
}
