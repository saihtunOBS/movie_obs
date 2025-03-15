import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

String selectedQuality = 'Auto';

class VideoBloc extends ChangeNotifier {
  final ValueNotifier<bool> showControl = ValueNotifier(true);
  final ValueNotifier<bool> userAction = ValueNotifier(false);
  final ValueNotifier<bool> showVolume = ValueNotifier(false);

  ValueNotifier<bool> isHoveringLeft = ValueNotifier(false);
  ValueNotifier<bool> isHoveringRight = ValueNotifier(false);

  final ValueNotifier<bool> loadingOverlay = ValueNotifier(false);
  late VideoPlayerController videoPlayerController;
  ValueNotifier<ChewieController>? chewieControllerNotifier;
  bool wasScreenOff = false;
  bool isMuted = false;
  bool isFullScreen = false;
  bool hasPrinted = false;
  Timer? hideControlTimer;
  double manualSeekProgress = 0.0;
  bool isSeeking = false;
  Timer? seekUpdateTimer;
  double dragOffset = 0.0; // Track vertical drag
  final double dragThreshold = 100.0; // Distance needed to exit fullscreen
  Timer? toggleTimer;
  int toggleCount = 0;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  double bufferedProgress = 0.0;
  double progress = 0.0;
  double volume = 0.5;

  bool isLoading = false;
  List<Map<String, String>> qualityOptions = [];
  String m3u8Url = 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8';
  String currentUrl = 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8';

  double scale = 1.0; // Initial scale of the video
  double initialScale = 1.0; // Scale at the start of the drag
  double initialPosition = 0.0; // Initial position of the drag

  // Maximum and minimum scaling limits (like YouTube)
  final double minScale = 1.0;
  final double maxScale = 2.0; // Set a reasonable maximum zoom level

  VideoBloc() {
    initializeVideo(m3u8Url);
  }

  void onVerticalDragStart(DragStartDetails details) {
    initialPosition = details.localPosition.dy; // Track the start position
    initialScale = scale; // Save the initial scale when drag starts
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    // Calculate the difference in the drag position
    double dragDifference = details.localPosition.dy - initialPosition;

    // Adjust the scale based on the drag difference
    double scaleChange =
        dragDifference / 200; // Adjust this value for sensitivity

    // Update the scale and clamp it within the allowed range
    scale = (initialScale - scaleChange).clamp(minScale, maxScale);

    // Notify listeners to trigger a redraw of the widget
    notifyListeners();
  }

  void onVerticalDragEnd(DragEndDetails details) {
    initialScale = scale;
    if (initialScale == 1.0) return;
    toggleFullScreen();
    notifyListeners();
  }

  void pausedPlayer() {
    videoPlayerController.pause();
    notifyListeners();
  }

  void playPlayer() {
    videoPlayerController.play();
    isSeeking = false;
    notifyListeners();
  }

  void updateUserAction(bool value) {
    userAction.value = value;
    notifyListeners();
  }

  // void updateOrientation(Orientation orientation) {
  //   isFullScreen = orientation == Orientation.landscape;
  // }

  void playPauseVideoPlayer() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
    } else {
      videoPlayerController.play();
    }
    resetControlVisibility();
    notifyListeners();
  }

  /// Fetch and parse M3U8 file to extract quality options
  Future<void> _fetchQualityOptions() async {
    try {
      final response = await http.get(Uri.parse(m3u8Url));
      if (response.statusCode == 200) {
        String m3u8Content = response.body;

        // Extract quality options using regex
        List<Map<String, String>> qualities = [];
        final regex = RegExp(
          r'#EXT-X-STREAM-INF:.*?RESOLUTION=(\d+)x(\d+).*?\n(.*)',
          multiLine: true,
        );

        for (final match in regex.allMatches(m3u8Content)) {
          int height = int.parse(match.group(2)!);

          // Get video height (e.g., 1080)
          String url = match.group(3) ?? '';

          String qualityLabel = _getQualityLabel(height);

          // Convert relative URLs to absolute
          if (!url.startsWith('http')) {
            Uri masterUri = Uri.parse(m3u8Url);
            url = Uri.parse(masterUri.resolve(url).toString()).toString();
          }

          qualities.add({'quality': qualityLabel, 'url': url});
        }

        qualityOptions = qualities;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching M3U8: $e");
    }
  }

  /// Convert resolution height to standard quality labels
  String _getQualityLabel(int height) {
    if (height >= 1080) return "1080p";
    if (height >= 720) return "720p";
    if (height >= 480) return "480p";
    if (height >= 360) return "360p";
    if (height >= 240) return "240p";
    return "Low";
  }

  // Throttle updates to every 200ms
  void throttleSliderUpdate() {
    if (seekUpdateTimer?.isActive ?? false) return;
    seekUpdateTimer = Timer(Duration(milliseconds: 10), () {
      notifyListeners();
    });
  }

  /// Initialize video player
  void initializeVideo(String url) {
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions: VideoPlayerOptions(
        allowBackgroundPlayback: true,
        mixWithOthers: true,
      ),
    );
    videoPlayerController.initialize().then((_) {
      chewieControllerNotifier = ValueNotifier(
        ChewieController(
          videoPlayerController: videoPlayerController,
          showControls: false,
          allowedScreenSleep: false,
          autoInitialize: true,
        ),
      );
      _fetchQualityOptions();
    });

    videoPlayerController.addListener(() {
      if (videoPlayerController.value.isPlaying) return;
      showControl.value = true;
      notifyListeners();
    });
  }

  ///reset play state (android only)
  void resetControlVisibility({bool isSeek = false}) {
    if (!videoPlayerController.value.isPlaying || isSeek == true) {
      showControl.value = true;
    } else {
      showControl.value = !showControl.value;
    }

    // Cancel the previous timer before creating a new one
    hideControlTimer?.cancel();
    hideControlTimer = Timer(const Duration(seconds: 3), () {
      if (videoPlayerController.value.isPlaying == true) {
        showControl.value = false;
      } else {
        showControl.value = true;
      }
    });
    notifyListeners();
  }

  //quality change
  void changeQuality(String url, [String? quality]) async {
    userAction.value = true;
    notifyListeners();
    selectedQuality = quality ?? selectedQuality;
    currentUrl = url;
    final currentPosition = videoPlayerController.value.position;
    final wasPlaying = videoPlayerController.value.isPlaying;

    await videoPlayerController.dispose();

    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));

    await videoPlayerController.initialize();
    videoPlayerController.seekTo(currentPosition).then((_) {
      userAction.value = false;
      notifyListeners();
    });
    chewieControllerNotifier?.value = ChewieController(
      videoPlayerController: videoPlayerController,
      showControls: false,
      allowedScreenSleep: false,
    );
    if (wasPlaying) {
      videoPlayerController.play();
    } else {
      videoPlayerController.pause();
    }
    videoPlayerController.setVolume(isMuted ? 0.0 : 1.0);
    notifyListeners();

    resetControlVisibility(isSeek: true);
  }

  //toggle full screen
  void toggleFullScreen({Orientation? orientation}) {
    isFullScreen = !isFullScreen;
    initialPosition = 0.0;
    scale = 1.0;
    initialScale = 1.0;
    dragOffset = 0.0;
    toggleCount++;
    notifyListeners();

    toggleTimer?.cancel();
    toggleTimer = Timer(Duration(milliseconds: 800), () {
      toggleCount = 0;
      notifyListeners();
    });

    if (isFullScreen == true) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }

    notifyListeners();
    resetControlVisibility();
  }

  // Function to toggle mute/unmute
  void toggleMute() {
    isMuted = !isMuted;
    videoPlayerController.setVolume(isMuted ? 0.0 : 1.0);
    resetControlVisibility();
    notifyListeners();
  }

  void seekBackward() {
    final currentPosition = videoPlayerController.value.position;
    final seekDuration = Duration(seconds: 10);
    final newPosition = currentPosition - seekDuration;

    if (newPosition > Duration.zero) {
      videoPlayerController.seekTo(newPosition);
    } else {
      videoPlayerController.seekTo(
        Duration.zero,
      ); // Don't seek past the start of the video
    }
    notifyListeners();
  }

  /// Helper Function to Format Duration
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void seekForward() {
    final currentPosition = videoPlayerController.value.position;
    final seekDuration = Duration(seconds: 10);
    final newPosition = currentPosition + seekDuration;

    if (newPosition < videoPlayerController.value.duration) {
      videoPlayerController.seekTo(newPosition);
    } else {
      videoPlayerController.seekTo(
        videoPlayerController.value.duration,
      ); // Don't seek past the end of the video
    }
    notifyListeners();
  }

  void startSeekUpdateLoop() {
    seekUpdateTimer?.cancel(); // Ensure old timers are cleared
    seekUpdateTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (!isSeeking) {
        timer.cancel();
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieControllerNotifier?.dispose();
    hideControlTimer?.cancel();
    toggleTimer?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
