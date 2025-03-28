import 'dart:async';
import 'dart:io';
import 'package:auto_orientation_v2/auto_orientation_v2.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:movie_obs/data/videoPlayer/video_player.dart';
import 'package:movie_obs/screens/home_page.dart';
import 'package:video_player/video_player.dart';

bool showMiniControl = false;
bool isFullScreen = false;
final ValueNotifier<bool> showVisibleMiniControl = ValueNotifier(true);
final ValueNotifier<bool> onStartDrag = ValueNotifier(true);

late VideoPlayerController videoPlayerController;
ChewieController? chewieControllerNotifier;

final ValueNotifier<bool> showMiniControlVisible = ValueNotifier(false);

String selectedQuality = 'Auto';

class VideoBloc extends ChangeNotifier {
  final ValueNotifier<bool> showVolume = ValueNotifier(false);
  final ValueNotifier<bool> showLock = ValueNotifier(false);

  ValueNotifier<bool> isHoveringLeft = ValueNotifier(false);
  ValueNotifier<bool> isHoveringRight = ValueNotifier(false);

  bool wasScreenOff = false;
  bool isMuted = false;
  bool showControl = false;
  bool hasPrinted = false;
  Timer? hideControlTimer;
  Timer? hideMiniControlTimer;
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
  double videoCurrentSpeed = 1.0;
  bool isLockScreen = false;
  int isQualityClick = 0;

  bool isLoading = false;
  List<Map<String, String>> qualityOptions = [];

  String currentUrl = '';

  double scale = 1.0;
  double initialScale = 1.0;
  double initialPosition = 0.0;

  final double minScale = 1.0;
  final double maxScale = 2.0;
  bool igNorePointer = true;

  int seekCount = 0;
  Timer? seekTimer;

  void igNorePointerToggle() {
    igNorePointer = !igNorePointer;
    notifyListeners();
  }

  void onVerticalDragStart(ForcePressDetails details) {
    initialPosition = details.localPosition.dy;
    initialScale = scale;
  }

  void toggleLockScreen() {
    showLock.value = !showLock.value;
    notifyListeners();
  }

  void onVerticalDragUpdateFullScreen(DragUpdateDetails details) {
    if (isLockScreen == true) return;

    notifyListeners();
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    if (isLockScreen == true) return;
    // Calculate the difference in the drag position
    double dragDifference = details.localPosition.dy - initialPosition;
    // Adjust the scale based on the drag difference
    double scaleChange =
        dragDifference / 200; // Adjust this value for sensitivity

    scale = (initialScale - scaleChange).clamp(minScale, maxScale);

    notifyListeners();
  }

  void onVerticalDragEnd(DragEndDetails details) {
    if (isLockScreen == true) return;
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
    // isSeeking = false;
    notifyListeners();
  }

  void updateSpeed(double value) {
    videoCurrentSpeed = value;
    videoPlayerController.setPlaybackSpeed(value);
    notifyListeners();
  }

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
      final response = await http.get(Uri.parse(currentUrl));
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
            Uri masterUri = Uri.parse(currentUrl);
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
    isLoading = true;
    notifyListeners();
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true),
    );
    videoPlayerController.initialize().then((_) {
      chewieControllerNotifier = ChewieController(
        videoPlayerController: videoPlayerController,
        showControls: false,
        aspectRatio: 16 / 9,
        useRootNavigator: false,
        allowFullScreen: false,
        draggableProgressBar: false,
        deviceOrientationsOnEnterFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      );

      _fetchQualityOptions();
    });

    isLoading = false;
    resetControlVisibility();

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
        //showControl.value = true;
        notifyListeners();
      }
    });
  }

  void resetControlVisibility({bool isSeek = false}) {
    if (isSeek == true) {
      showControl = true;
    } else {
      showControl = !showControl;
    }

    // Cancel the previous timer before creating a new one
    hideControlTimer?.cancel();
    hideControlTimer = Timer(const Duration(seconds: 4), () {
      showControl = false;
      notifyListeners();
    });
    notifyListeners();
  }

  //quality change
  void changeQuality(
    String url,
    Duration? currentDuration, [
    String? quality,
  ]) async {
    showMiniControl = true;
    isLoading = true;

    updateListener();
    selectedQuality = quality ?? selectedQuality;
    currentUrl = url;
    final currentPosition = videoPlayerController.value.position;
    final wasPlaying = videoPlayerController.value.isPlaying;

    await videoPlayerController.pause();
    // await videoPlayerController.dispose();

    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));

    await videoPlayerController.initialize().then((_) async {
      await videoPlayerController.seekTo(currentDuration ?? currentPosition);

      if (wasPlaying) {
        videoPlayerController.play();
        notifyListeners();
      } else {
        videoPlayerController.pause();
        notifyListeners();
      }
      isLoading = false;
    });

    chewieControllerNotifier = ChewieController(
      videoPlayerController: videoPlayerController,
      showControls: false,
    );
    videoPlayerController.setVolume(isMuted ? 0.0 : 1.0);
    showMiniControl = false;

    videoPlayerController.addListener(() {
      if (videoPlayerController.value.isPlaying) {
        saveVideoProgress([
          VideoProgress(
            videoId: '1',
            position: videoPlayerController.value.position,
          ),
        ]);
        notifyListeners();
      } else if (videoPlayerController.value.isCompleted) {
        isPlay.value = false;
        showControl = true;

        notifyListeners();
      }
    });
    notifyListeners();
  }

  //toggle full screen
  void toggleFullScreen({bool? isLock}) async {
    //isLockScreen = isLock ?? false;

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
      Platform.isAndroid
          ? await AutoOrientation.landscapeAutoMode(forceSensor: false).then((
            _,
          ) {
            // Future.delayed(Duration(seconds: 5), () {
            //   AutoOrientation.fullAutoMode(forceSensor: true);
            // });
          })
          : await AutoOrientation.landscapeRightMode();
    } else {
      await AutoOrientation.portraitAutoMode().then((_) {
        if (Platform.isIOS) return;
        Future.delayed(Duration(seconds: 5), () {
          AutoOrientation.fullAutoMode(forceSensor: false);
        });
      });
    }
    resetControlVisibility(isSeek: true);

    notifyListeners();
  }

  // Function to toggle mute/unmute
  void toggleMute() {
    isMuted = !isMuted;
    videoPlayerController.setVolume(isMuted ? 0.0 : 1.0);
    resetControlVisibility(isSeek: true);
    notifyListeners();
  }

  updateListener() {
    notifyListeners();
  }

  /// Helper Function to Format Duration
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void seekForward({bool? isDoubleTag}) {
    if (!videoPlayerController.value.isInitialized || isLockScreen) {
      return;
    }
    final newPosition =
        videoPlayerController.value.position + Duration(seconds: 10);

    if (newPosition > videoPlayerController.value.duration) {
      return;
    }
    smoothSeek(newPosition, isDoubleTag ?? false);
  }

  void seekBackward({bool? isDoubleTag}) {
    if (!videoPlayerController.value.isInitialized || isLockScreen) return;

    final newPosition =
        videoPlayerController.value.position - Duration(seconds: 10);
    smoothSeek(newPosition, isDoubleTag ?? false);
  }

  Future<void> smoothSeek(Duration targetPosition, bool isDoubleTag) async {
    seekCount++;
    seekTimer?.cancel();
    seekTimer = Timer(Duration(milliseconds: 300), () {
      seekCount = 0;
      videoPlayerController.play();
      if (isDoubleTag == true || showMiniControl == true) return;

      resetControlVisibility(isSeek: true);
      notifyListeners();
    });

    // Ensure the target position is within valid bounds
    if (targetPosition < Duration.zero) {
      targetPosition = Duration.zero;
    } else if (targetPosition > videoPlayerController.value.duration) {
      targetPosition = videoPlayerController.value.duration;
    }

    // Seek to the new position in one go
    await videoPlayerController.seekTo(targetPosition);
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
    seekTimer?.cancel();
    super.dispose();
  }
}
