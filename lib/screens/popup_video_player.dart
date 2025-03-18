import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class MiniVideoPlayer {
  static OverlayEntry? _overlayEntry;
  static late VideoPlayerController _videoController;
  static late ChewieController _chewieController;

  static void showMiniPlayer(
    BuildContext context,
    String videoUrl,
    VideoPlayerController existingController,
  ) {
    if (_overlayEntry != null) return;

    _videoController = existingController;
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: false,
      looping: false,
      allowFullScreen: false,
      allowMuting: false,
      draggableProgressBar: false,
      aspectRatio: 16 / 9,
      showControls: true,
      showOptions: false,
      allowPlaybackSpeedChanging: false,
      
    );

    _overlayEntry = OverlayEntry(builder: (context) => _MiniPlayerOverlay());
    Overlay.of(context).insert(_overlayEntry!);
  }

  static void removeMiniPlayer() {
    _chewieController.dispose();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class _MiniPlayerOverlay extends StatefulWidget {
  @override
  __MiniPlayerOverlayState createState() => __MiniPlayerOverlayState();
}

class __MiniPlayerOverlayState extends State<_MiniPlayerOverlay>
    with SingleTickerProviderStateMixin {
  Offset _position = Offset(20, 0);
  final double _width = 200;
  final double _height = 150;
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
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

    // Create a smooth animation
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
    _snapToNearestCorner(screenSize);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Set initial position to bottom-left corner on first build
    if (_position == Offset(20, 0)) {
      _position = Offset(20, screenSize.height - _height - 60);
    }
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanUpdate: (details) {
          setState(() {
            _position = Offset(
              _position.dx + details.delta.dx,
              _position.dy + details.delta.dy,
            );
          });
        },
        onPanEnd: _onDragEnd,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Colors.white,
                  width: _width,
                  height: _height,
                  child: Chewie(controller: MiniVideoPlayer._chewieController),
                ),
              ),
              Positioned(
                right: 5,
                top: 5,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: MiniVideoPlayer.removeMiniPlayer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
