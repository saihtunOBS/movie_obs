import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  bool isMiniPlayer = false;
  Offset _position = Offset(20, 500);

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse('https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4'),
    )..initialize().then((_) {
        setState(() {});
      });

    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  void _toggleMiniPlayer() {
    setState(() {
      isMiniPlayer = !isMiniPlayer;
      _position = Offset(20, 500);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          isMiniPlayer ? Container() : _buildFullScreenPlayer(),
          isMiniPlayer ? _buildMiniPlayer() : Container(),
        ],
      ),
    );
  }

  Widget _buildFullScreenPlayer() {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 500) {
          _toggleMiniPlayer();
        }
      },
      child: Center(
        child: Chewie(controller: _chewieController),
      ),
    );
  }

  Widget _buildMiniPlayer() {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _position = Offset(_position.dx + details.delta.dx, _position.dy + details.delta.dy);
          });
        },
        onDoubleTap: _toggleMiniPlayer,
        child: Container(
          width: 200,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Chewie(controller: _chewieController),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => setState(() => isMiniPlayer = false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


/*
 body: ValueListenableBuilder(
            valueListenable: showMiniControlVisible,
            builder:
                (context, value, child) => AnimatedOpacity(
                  opacity: value ? 0 : 1,
                  duration: Duration(milliseconds: 400),
                  child:
                      chewieControllerNotifier == null &&
                              !videoPlayerController.value.isInitialized
                          ? SizedBox()
                          : IgnorePointer(
                            ignoring: value ? true : false,
                            IgnorePointer(
                ignoring: value ? true : false,
                child: Column(

                 ? SizedBox()
              : IgnorePointer(
                ignoring: value ? true : false,
                child: Column(
                  children: [ 

                    // bloc.isLoading = true;
      // bloc.updateListener();
      // Future.delayed(Duration(milliseconds: 500),(){
      //   bloc.isLoading = false;
      //   bloc.updateListener();
      // });


      import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/screens/home_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: OpenContainer(
          useRootNavigator: true,
          closedElevation: 0.0,
          closedColor: Colors.white,
          openElevation: 0.0,
          closedShape: const RoundedRectangleBorder(),
          openShape: const RoundedRectangleBorder(),
          transitionDuration: const Duration(milliseconds: 400),
          closedBuilder: ((context, action) {
            return GestureDetector(
              onTap: action,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.amber,
                ),
                child: Text('Video'),
              ),
            );
          }),
          openBuilder: ((context, action) {
            return HomePage();
          }),
        ),
      ),
    );
  }
}

*/