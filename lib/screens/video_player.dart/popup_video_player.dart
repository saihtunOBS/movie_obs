import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/video_bloc.dart';
import 'package:movie_obs/data/videoPlayer/video_player.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/video_player.dart/video_player_screen.dart';
import 'package:movie_obs/utils/colors.dart';
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
  static late String url;

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
    url = videoUrl;
  }

  static void removeMiniPlayer({bool? isClose}) {
    if (_overlayEntry == null) return;
    _animationController.reverse().then((_) {
      if (isClose == true) {
        videoPlayerController?.pause();
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
  double progress = 0.0;
  double bufferedProgress = 0.0;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.hidden) {
      videoPlayerController?.pause();
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

    videoPlayerController?.addListener(() {
      if (!(videoPlayerController?.value.isPlaying ?? true)) {
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
        videoPlayerController?.pause();
        _pendingDismiss = false;
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

    return Consumer<VideoBloc>(
      builder:
          (context, value, child) => Stack(
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
                      _isDraggingDown =
                          deltaY > 0 && deltaY.abs() > deltaX.abs();
                    });
                  },
                  onPanEnd: _onDragEnd,
                  child: Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
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
                                PageNavigator(ctx: context).nextPage(
                                  page: VideoPlayerScreen(
                                    url: MiniVideoPlayer.url,
                                    isFirstTime: false,
                                    type: '',
                                  ),
                                );
                              },
                              child: SizedBox(height: 230),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ValueListenableBuilder(
                                  valueListenable: playerStatus,
                                  builder:
                                      (
                                        BuildContext context,
                                        int value,
                                        Widget? child,
                                      ) => IconButton(
                                        onPressed: () {
                                          if (videoPlayerController
                                                  ?.value
                                                  .isCompleted ??
                                              true) {
                                            bloc.initializeVideo(
                                              MiniVideoPlayer.url,
                                            );
                                            bloc.updateListener();
                                          } else {
                                            if (videoPlayerController
                                                    ?.value
                                                    .isPlaying ??
                                                true) {
                                              videoPlayerController?.pause();
                                              playerStatus.value = 1;
                                            } else {
                                              videoPlayerController?.play();
                                              playerStatus.value = 2;
                                            }
                                          }
                                        },
                                        icon: Container(
                                          padding: EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black45,
                                          ),
                                          child: Icon(
                                            value == 3
                                                ? CupertinoIcons.arrow_clockwise
                                                : value == 2
                                                ? CupertinoIcons.pause
                                                : CupertinoIcons.play,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                ),
                                IconButton(
                                  icon: Container(
                                    padding: EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black45,
                                    ),
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),

                                  onPressed: () {
                                    MiniVideoPlayer.removeMiniPlayer(
                                      isClose: true,
                                    );
                                    saveVideoProgress([
                                      VideoProgress(
                                        videoId: MiniVideoPlayer.videoId,
                                        position:
                                            videoPlayerController
                                                ?.value
                                                .position ??
                                            Duration.zero,
                                      ),
                                    ]);
                                  },
                                ),
                              ],
                            ),
                          ),

                          Positioned(
                            right: -23,
                            left: -23,
                            bottom: -22,
                            child: IgnorePointer(
                              ignoring: true,
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 1.0,
                                  inactiveTrackColor: Colors.transparent,
                                  activeTrackColor: kSecondaryColor,
                                  trackShape:
                                      const RoundedRectSliderTrackShape(),
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 0.0,
                                  ),
                                ),
                                child: ValueListenableBuilder(
                                  valueListenable:
                                      videoPlayerController
                                          as VideoPlayerController,
                                  builder: (
                                    context,
                                    VideoPlayerValue value,
                                    child,
                                  ) {
                                    if (value.isInitialized) {
                                      final duration = value.duration;
                                      final position = value.position;

                                      if (duration.inMilliseconds > 0 &&
                                          !bloc.isSeeking) {
                                        progress = (position.inMilliseconds /
                                                duration.inMilliseconds)
                                            .clamp(0.0, 1.0);
                                      } else {
                                        progress = bloc.manualSeekProgress;
                                      }
                                    }

                                    return Slider(
                                      value: progress,
                                      onChanged: (newValue) {},
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
