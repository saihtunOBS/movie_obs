import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8',
      ),
      // Replace with your video URL
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true); // Set video to loop
    _controller.setVolume(1.0); // Set volume (1.0 for max)
  }

  @override
  void dispose() {
    super.dispose();
    _controller
        .dispose(); // Dispose the video player controller when the widget is removed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Video Player')),
      body: Center(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            // If the video is initialized, show the player
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  const SizedBox(height: 20),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                  const SizedBox(height: 20),
                  IconButton(
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_controller.value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      });
                    },
                  ),
                ],
              );
            } else {
              // If the video is not initialized, show a loading spinner
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
