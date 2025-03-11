import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class CustomChewieControls extends StatefulWidget {
  final ChewieController chewieController;

  const CustomChewieControls({Key? key, required this.chewieController}) : super(key: key);

  @override
  _CustomChewieControlsState createState() => _CustomChewieControlsState();
}

class _CustomChewieControlsState extends State<CustomChewieControls> {
  @override
  Widget build(BuildContext context) {
    final videoPlayerController = widget.chewieController.videoPlayerController;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Play/Pause Button
        Positioned(
          left: 10,
          bottom: 30,
          child: IconButton(
            icon: Icon(
              videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              setState(() {
                videoPlayerController.value.isPlaying
                    ? videoPlayerController.pause()
                    : videoPlayerController.play();
              });
            },
          ),
        ),

        // Seek Bar (Progress Bar)
        VideoProgressIndicator(
          videoPlayerController,
          allowScrubbing: true,
          colors: VideoProgressColors(
            playedColor: Colors.red,
            bufferedColor: Colors.white54,
            backgroundColor: Colors.white30,
          ),
        ),

        // Full-Screen Toggle
        Positioned(
          right: 10,
          bottom: 30,
          child: IconButton(
            icon: Icon(
              widget.chewieController.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              widget.chewieController.enterFullScreen();
            },
          ),
        ),

        // Additional Options Button
        Positioned(
          right: 50,
          bottom: 30,
          child: IconButton(
            icon: Icon(Icons.settings, color: Colors.white, size: 30),
            onPressed: () {
              _showQualityOptions();
            },
          ),
        ),
      ],
    );
  }

  void _showQualityOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Video Quality', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ListTile(
                title: Text('Auto'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                title: Text('1080p'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                title: Text('720p'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                title: Text('480p'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
