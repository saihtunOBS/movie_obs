import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/video_bloc.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class MiniVideoPlayer {
  static OverlayEntry? _overlayEntry;
  static late VideoPlayerController _videoController;
  static late ChewieController _chewieController;
  static VideoBloc? bloc;

  static void showMiniPlayer(
    BuildContext context,
    String videoUrl,
    VideoPlayerController controller,
  ) async {
    if (_overlayEntry != null) return;

    _videoController = controller;
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
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

  static void removeMiniPlayer() {
    showMiniControlVisible.value = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
    _videoController.pause();
    _chewieController.pause();
    showMiniControl = false;
    bloc?.changeQuality(bloc?.currentUrl ?? '');
    bloc?.updateListener();
  }
}

class _MiniPlayerOverlay extends StatefulWidget {
  @override
  __MiniPlayerOverlayState createState() => __MiniPlayerOverlayState();
}

class __MiniPlayerOverlayState extends State<_MiniPlayerOverlay>
    with SingleTickerProviderStateMixin {
  Offset _position = Offset(20, 0);
  final double _width = 230;
  final double _height = 130;
  late AnimationController _controller;
  late Animation<Offset> _animation;
  double _dragStartY = 0;
  double _dragStartX = 0;
  bool _isDraggingDown = false;
  bool _pendingDismiss = false;
  bool hasPrinted = false;
  late final VideoBloc bloc; // Declare provider outside build

  @override
  void initState() {
    bloc = Provider.of<VideoBloc>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showMiniControlVisible.value = true;
    });

    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300), // Smooth transition time
    );
  }

  void _snapToNearestCorner(Size screenSize) {
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    double left = 20;
    double right =
        screenWidth - _width - 20 - MediaQuery.of(context).padding.right;
    double top = 20;
    double bottom =
        screenHeight - _height - 20 - MediaQuery.of(context).padding.bottom;

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
    if (_isDraggingDown && _position.dy > screenSize.height * 0.7) {
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (_position == Offset(20, 0)) {
      _position = Offset(20, screenSize.height - _height - 60);
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
                elevation: 8,
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    IgnorePointer(
                      ignoring: true,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Colors.black,
                          width: _width,
                          height: _height,
                          child: Chewie(
                            controller: MiniVideoPlayer._chewieController,
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: MiniVideoPlayer.removeMiniPlayer,
                      ),
                    ),

                    Positioned(
                      bottom: 5,
                      left: 0,
                      right: 0,
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        alwaysIncludeSemantics: true,
                        opacity: showVisibleMiniControl ? 1 : 0,
                        child: Container(
                          color: Colors.transparent,
                          height: 45,

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: IconButton.filled(
                                  iconSize: 13,
                                  highlightColor: Colors.amber,
                                  onPressed: () {
                                    bloc.seekBackward();
                                  },
                                  icon: Icon(CupertinoIcons.gobackward_10),
                                  style: IconButton.styleFrom(
                                    backgroundColor:
                                        Colors
                                            .grey, // Change the background color
                                  ),
                                ),
                              ),
                              IconButton.filled(
                                onPressed: () {
                                  bloc.resetMiniControlVisibility();
                                  if (bloc
                                      .videoPlayerController
                                      .value
                                      .isPlaying) {
                                    bloc.videoPlayerController.pause();
                                    bloc.updateListener();
                                  } else {
                                    bloc.videoPlayerController.play();
                                    bloc.updateListener();
                                  }
                                },
                                icon: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    bloc.videoPlayerController.value.isPlaying
                                        ? CupertinoIcons.pause
                                        : bloc
                                            .videoPlayerController
                                            .value
                                            .isCompleted
                                        ? CupertinoIcons.arrow_counterclockwise
                                        : CupertinoIcons.play,
                                    size: 15,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: IconButton.filled(
                                  iconSize: 13,
                                  highlightColor: Colors.amber,
                                  onPressed: () {
                                    bloc.seekForward();
                                  },
                                  icon: Icon(CupertinoIcons.goforward_10),

                                  style: IconButton.styleFrom(
                                    backgroundColor:
                                        Colors
                                            .grey, // Change the background color
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      right: 0,
                      left: 0,
                      bottom: 45,
                      child: InkWell(
                        onTap: () => MiniVideoPlayer.removeMiniPlayer(),
                        child: Container(
                          height: 200,
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
