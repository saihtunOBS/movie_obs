import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/video_bloc.dart';
import 'package:movie_obs/data/videoPlayer/video_player.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/screens/video_player.dart/video_player_screen.dart';
import 'package:provider/provider.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class MiniVideoPlayer {
  static OverlayEntry? _overlayEntry;
  static late AnimationController _animationController;
  static late Animation<double> _fadeAnimation;
  static late Animation<Offset> _slideAnimation;
  static late bool isPlay;
  static late String videoId;

  static void showMiniPlayer(
    BuildContext context,
    String videoUrl,
    bool isPlaying,
    String id,
  ) {
    if (_overlayEntry != null) return;

    final TickerProvider ticker = Navigator.of(context);
    _animationController = AnimationController(
      vsync: ticker,
      duration: Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(_animationController);

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _MiniPlayerOverlay(),
                ),
              ),
            ],
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
    isPlay = isPlaying;
    videoId = id;
  }

  static void removeMiniPlayer({bool? isClose}) {
    if (_overlayEntry == null) return;
    _animationController.reverse().then((_) {
      if (isClose == true) {
        videoPlayerController.pause();
      }
      _overlayEntry?.remove();
      _overlayEntry = null;
      _animationController.dispose();
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
  final double _width = getDeviceType() == 'phone' ? 180 : 250;
  final double _height = getDeviceType() == 'phone' ? 110 : 200;
  late AnimationController _controller;
  late Animation<Offset> _animation;
  double _dragStartY = 0;
  double _dragStartX = 0;
  bool _isDraggingDown = false;
  bool _pendingDismiss = false;
  late final VideoBloc bloc;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.hidden) {
      videoPlayerController.pause();
      MiniVideoPlayer.isPlay = false;
      setState(() {});
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
      duration: Duration(milliseconds: 300),
    );

    videoPlayerController.addListener(() {
      if (videoPlayerController.value.isPlaying) {
        saveVideoProgress([
          VideoProgress(
            videoId: MiniVideoPlayer.videoId,
            position: videoPlayerController.value.position,
          ),
        ]);
      } else if (!videoPlayerController.value.isPlaying) {
        MiniVideoPlayer.isPlay = false;
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
        screenHeight - _height - 70 - MediaQuery.of(context).padding.bottom;

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

    if (_isDraggingDown && _position.dy > screenSize.height * 0.85) {
      if (!_pendingDismiss) {
        _pendingDismiss = true;
        MiniVideoPlayer.removeMiniPlayer();
        videoPlayerController.pause();
        _pendingDismiss = false;
        showMiniControl = false;
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
      _position = Offset(20, screenSize.height - _height - 105);
    }

    return Stack(
      children: [
        Positioned(
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
                          child: Container(
                            color: Colors.grey.withValues(alpha: 0.4),
                            width: _width,
                            height: _height,
                            child: Chewie(
                              controller: chewieControllerNotifier!,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          left: 0,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              context.pushTransparentRoute(
                                VideoPlayerScreen(url: '', isFirstTime: false),
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
                      ],
                    ),
                    Container(
                      color: Colors.grey.withValues(alpha: 0.4),
                      height: 43,
                      width: getDeviceType() == 'phone' ? 180 : 250,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 18,
                            onPressed: () {
                              bloc.seekBackward();
                              MiniVideoPlayer.isPlay = true;
                            },
                            icon: Icon(
                              CupertinoIcons.gobackward_10,
                              color: Colors.white,
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: videoPlayerController,
                            builder:
                                (
                                  BuildContext context,
                                  VideoPlayerValue value,
                                  Widget? child,
                                ) => IconButton(
                                  onPressed: () {
                                    if (value.isCompleted) {
                                      videoPlayerController
                                          .seekTo(Duration.zero)
                                          .then((_) {
                                            videoPlayerController.play();
                                          });
                                    } else {
                                      if (value.isPlaying) {
                                        videoPlayerController.pause();
                                        MiniVideoPlayer.isPlay = false;
                                      } else {
                                        videoPlayerController.play();
                                        MiniVideoPlayer.isPlay = true;
                                      }
                                    }
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    value.isCompleted
                                        ? CupertinoIcons.arrow_clockwise
                                        : MiniVideoPlayer.isPlay
                                        ? CupertinoIcons.pause
                                        : CupertinoIcons.play,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                          ),
                          IconButton(
                            iconSize: 18,
                            onPressed: () {
                              bloc.seekForward();
                              MiniVideoPlayer.isPlay = true;
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
      ],
    );
  }
}
