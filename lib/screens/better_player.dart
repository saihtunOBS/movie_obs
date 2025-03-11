import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class SamplePlayer extends StatefulWidget {
  const SamplePlayer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SamplePlayerState createState() => _SamplePlayerState();
}

class _SamplePlayerState extends State<SamplePlayer> {
  late FlickManager flickManager;
  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      autoPlay: false,
      videoPlayerController: VideoPlayerController.networkUrl(
        Uri.parse(
          "https://moviedatatesting.s3.ap-southeast-1.amazonaws.com/Mvoie+1/master.m3u8",
        ),
      ),
    );
  }

  update() {
      
      flickManager.handleChangeVideo(
        VideoPlayerController.networkUrl(
          Uri.parse(
            'https://moviedatatesting.s3.ap-southeast-1.amazonaws.com/Mvoie+1/stream_2/playlist.m3u8',
          ),
        ),
      );
      Duration currentPosition = getCurrentPosition();
      flickManager.flickVideoManager?.videoPlayerController?.seekTo(
        currentPosition,
      );
  }

  Duration getCurrentPosition() {
    return flickManager
            .flickVideoManager
            ?.videoPlayerController
            ?.value
            .position ??
        Duration.zero;
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 8,
          child: FlickVideoPlayer(
            flickManager: flickManager,
            flickVideoWithControls: FlickVideoWithControls(
              closedCaptionTextStyle: TextStyle(fontSize: 8),
              controls: Stack(
                children: [
                  FlickPortraitControls(
                    progressBarSettings: FlickProgressBarSettings(
                      bufferedColor: Colors.blue,
                      playedColor: Colors.black,
                      handleColor: Colors.amber,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  FlickAutoHideChild(child: InkWell(
                    onTap: () => update(),
                    child: Icon(Icons.select_all))),
                ],
              ),

              backgroundColor:
                  Colors.transparent, // Background color of controls
              iconThemeData: IconThemeData(
                color: Colors.red,
              ), // Icon color (play, pause, etc.)
              textStyle: TextStyle(color: Colors.grey),
            ),
            flickVideoWithControlsFullscreen: FlickVideoWithControls(
              controls: FlickPortraitControls(
                progressBarSettings: FlickProgressBarSettings(
                  bufferedColor: Colors.blue,
                  playedColor: Colors.black,
                  handleColor: Colors.amber,
                  backgroundColor: Colors.grey,
                ),
              ),
              backgroundColor: Colors.green, // Background color of controls
              iconThemeData: IconThemeData(
                color: Colors.red,
              ), // Icon color (play, pause, etc.)
              textStyle: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
