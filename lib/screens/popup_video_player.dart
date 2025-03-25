import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/video_bloc.dart';
import 'package:movie_obs/data/videoPlayer/video_player.dart';
import 'package:movie_obs/screens/home_page.dart';
import 'package:provider/provider.dart';
import 'package:chewie/chewie.dart';

class MiniVideoPlayer {
  static OverlayEntry? _overlayEntry;

  static void showMiniPlayer(
    BuildContext context,
    String videoUrl,
    bool isPlaying,
  ) async {
    if (_overlayEntry != null) return;

    chewieControllerNotifier?.value = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: false,
      allowFullScreen: false,
      allowMuting: false,
      draggableProgressBar: false,
      aspectRatio: 16 / 9,
      showControls: false,
      showOptions: false,
      allowPlaybackSpeedChanging: false,
    );

    _overlayEntry = OverlayEntry(builder: (context) => _MiniPlayerOverlay());
    Overlay.of(context).insert(_overlayEntry!);
  }

  static void removeMiniPlayer({bool? isClose}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showMiniControlVisible.value = false;
      _overlayEntry?.remove();
      if (isClose == true) {
        videoPlayerController.pause();
        videoPlayerController.initialize();
        videoPlayerController.seekTo(Duration.zero);
      } else {
        if (videoPlayerController.value.isPlaying) {
          videoPlayerController.play();
          chewieControllerNotifier?.value.play();
        } else {
          videoPlayerController.pause();
          chewieControllerNotifier?.value.pause();
        }
      }
      _overlayEntry = null;
      showMiniControl = false;
    });
  }
}

class _MiniPlayerOverlay extends StatefulWidget {
  @override
  __MiniPlayerOverlayState createState() => __MiniPlayerOverlayState();
}

class __MiniPlayerOverlayState extends State<_MiniPlayerOverlay>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  Offset _position = Offset(20, 0);
  final double _width = 180;
  final double _height = 110;
  late AnimationController _controller;
  late Animation<Offset> _animation;
  double _dragStartY = 0;
  double _dragStartX = 0;
  bool _isDraggingDown = false;
  bool _pendingDismiss = false;
  bool hasPrinted = false;
  late final VideoBloc bloc; // Declare provider outside build

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      videoPlayerController.pause();
      setState(() {
      });
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    bloc = Provider.of<VideoBloc>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showMiniControlVisible.value = true;
    });

    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300), // Smooth transition time
    );

    videoPlayerController.addListener(() {
      if (videoPlayerController.value.isPlaying) {
        saveVideoProgress([
          VideoProgress(
            videoId: '1',
            position: videoPlayerController.value.position,
          ),
        ]);
      } else if (videoPlayerController.value.isCompleted) {
        isPlay.value = false;
        showControl.value = true;
      }
    });
  }

  void _snapToNearestCorner(Size screenSize) {
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    double left = 20;
    double right =
        screenWidth - _width - 20 - MediaQuery.of(context).padding.right;
    double top = 60;
    double bottom =
        screenHeight - _height - 60 - MediaQuery.of(context).padding.bottom;

    double newX = (_position.dx < screenWidth / 2) ? left : right;
    double newY = (_position.dy < screenHeight / 2) ? top : bottom;

    _animation = Tween<Offset>(
      begin: _position,
      end: Offset(newX, newY),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.reset();
    _controller.forward();

    _animation.addListener(() {
      setState(() {
        _position = _animation.value;
      });
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final screenSize = MediaQuery.of(context).size;

    // If dragging downward and beyond the threshold, dismiss the player
    if (_isDraggingDown && _position.dy > screenSize.height * 0.9) {
      if (!_pendingDismiss) {
        _pendingDismiss = true;
        Future.delayed(Duration(milliseconds: 200), () {
          if (_isDraggingDown) {
            MiniVideoPlayer.removeMiniPlayer();
          }
          _pendingDismiss = false;
          showMiniControl = false;
        });
      }
    } else {
      _snapToNearestCorner(screenSize);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (_position == Offset(20, 0)) {
      _position = Offset(20, screenSize.height - _height - 93);
    }

    return Consumer<VideoBloc>(
      builder:
          (context, value, child) => Positioned(
            left: _position.dx,
            top: _position.dy,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (details) {
                _dragStartY = details.globalPosition.dy;
                _dragStartX = details.globalPosition.dx;
              },
              onPanUpdate: (details) {
                double deltaX = details.globalPosition.dx - _dragStartX;
                double deltaY = details.globalPosition.dy - _dragStartY;

                setState(() {
                  _position = Offset(
                    _position.dx + details.delta.dx,
                    _position.dy + details.delta.dy,
                  );

                  _isDraggingDown = deltaY > 0 && deltaY.abs() > deltaX.abs();
                });
              },

              onPanEnd: _onDragEnd,
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          IgnorePointer(
                            ignoring: true,
                            child: ValueListenableBuilder(
                              valueListenable: chewieControllerNotifier!,
                              builder:
                                  (context, value, child) => Container(
                                    color: Colors.black,
                                    width: _width,
                                    height: _height,
                                    child: Chewie(controller: value),
                                  ),
                            ),
                          ),

                          Positioned(
                            right: 0,
                            left: 0,
                            child: InkWell(
                              onTap: () {
                                context.pushTransparentRoute(
                                  HomePage(url: '', isFirstTime: false),
                                );
                              },
                              child: SizedBox(height: 230),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: Icon(Icons.close, color: Colors.white),
                              onPressed:
                                  () => MiniVideoPlayer.removeMiniPlayer(
                                    isClose: true,
                                  ),
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: videoPlayerController,
                            builder: (context, value, child) {
                              final duration = value.duration;

                              final position = value.position;

                              if (videoPlayerController.value.isInitialized) {
                                if (duration.inMilliseconds > 0 &&
                                    !bloc.isSeeking) {
                                  progress = (position.inMilliseconds /
                                          duration.inMilliseconds)
                                      .clamp(0.0, 1.0);
                                } else {
                                  // Use manual progress while dragging
                                  progress = bloc.manualSeekProgress;
                                }
                              }
                              return Positioned(
                                bottom: -23,
                                right: -23,
                                left: -23,
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      trackHeight: 1.0,
                                      thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: 1.0,
                                      ),
                                      inactiveTrackColor: Colors.transparent,
                                    ),
                                    child: Slider(
                                      value: progress,
                                      onChanged: (_) {},
                                      activeColor: Colors.red,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      Container(
                        color: Colors.black54,
                        height: 43,
                        width: 180,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 18,
                              onPressed: () {
                                bloc.seekBackward();
                              },
                              icon: Icon(
                                CupertinoIcons.gobackward_10,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (videoPlayerController.value.isPlaying) {
                                  videoPlayerController.pause();
                                  bloc.updateListener();
                                  isPlay.value = true;
                                } else {
                                  videoPlayerController.play();
                                  bloc.updateListener();
                                  isPlay.value = false;
                                }
                              },
                              icon:
                                  videoPlayerController.value.isCompleted
                                      ? Icon(
                                        CupertinoIcons.arrow_counterclockwise,
                                        color: Colors.white,
                                      )
                                      : bloc.seekCount != 0
                                      ? Icon(
                                        CupertinoIcons.pause,
                                        size: 28,
                                        color: Colors.white,
                                      )
                                      : Icon(
                                        videoPlayerController.value.isPlaying
                                            ? CupertinoIcons.pause
                                            : CupertinoIcons.play,
                                        size: 28,
                                        color: Colors.white,
                                      ),
                            ),
                            IconButton(
                              iconSize: 18,
                              onPressed: () {
                                bloc.seekForward();
                              },
                              icon: Icon(
                                CupertinoIcons.goforward_10,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
