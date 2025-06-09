import 'dart:async';
import 'dart:io';
import 'package:auto_orientation_v2/auto_orientation_v2.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:movie_obs/bloc/user_bloc.dart';
import 'package:movie_obs/data/model/movie_model.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/screens/video_player.dart/video_player_screen.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:video_player/video_player.dart';

import '../data/model/movie_model_impl.dart';
import '../data/persistence/persistence_data.dart' show PersistenceData;
import '../network/requests/history_request.dart';

final ValueNotifier<bool> showVisibleMiniControl = ValueNotifier(true);
final ValueNotifier<bool> onStartDrag = ValueNotifier(true);

VideoPlayerController? videoPlayerController;
ChewieController? chewieControllerNotifier;

final ValueNotifier<bool> showMiniControlVisible = ValueNotifier(false);

String selectedQuality = 'Auto';

class VideoBloc extends ChangeNotifier {
  bool isFullScreen = false;

  bool wasScreenOff = false;
  bool isMuted = false;
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
  int isQualityClick = 0;
  Duration errorDuration = Duration.zero;
  Timer? _timer;
  int _elapsedSeconds = 0;

  bool isLoading = true;
  List<Map<String, String>> qualityOptions = [];

  String currentUrl = '';
  double scale = 1.0;

  int seekCount = 0;
  Timer? seekTimer;

  final MovieModel _movieModel = MovieModelImpl();
  String token = '';

  VideoBloc() {
    initializeVideo(currentUrl);
    token = PersistenceData.shared.getToken();
  }

  toggleHistory(String id, String type) {
    if (type != 'trailer') {
      var request = HistoryRequest(
        userDataListener.value.id ?? '',
        id,
        0,
        type,
      );
      _movieModel
          .toggleHistory(token, request)
          .then((_) {})
          .whenComplete(() {})
          .catchError((error) {});
    }
  }

  void showLoading() {
    isLoading = true;
    notifyListeners();
  }

  void hideLoading() {
    isLoading = false;
    notifyListeners();
  }

  void pausedPlayer() {
    videoPlayerController?.pause();
    notifyListeners();
  }

  void playPlayer() {
    videoPlayerController?.play();
    notifyListeners();
  }

  void updateSpeed(double value) {
    videoCurrentSpeed = value;
    videoPlayerController?.setPlaybackSpeed(value);
    notifyListeners();
  }

  void playPauseVideoPlayer() {
    if (videoPlayerController?.value.isPlaying ?? true) {
      videoPlayerController?.pause();
    } else {
      videoPlayerController?.play();
    }
    resetControlVisibility();
    notifyListeners();
  }

  /// Fetch and parse M3U8 file to extract quality options
  Future<void> fetchQualityOptions() async {
    showLoading();
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

          String qualityLabel = getQualityLabel(height);

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
      hideLoading();
    } catch (e) {
      debugPrint("Error fetching M3U8: $e");
    }
  }

  /// Convert resolution height to standard quality labels
  String getQualityLabel(int height) {
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
  Future<void> initializeVideo(
    String url, {
    String? videoId,
    String? type,
    Duration? duration,
  }) async {
    showLoading();
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true),
    );
    videoPlayerController?.initialize().then((_) {
      videoPlayerController?.seekTo(duration ?? Duration.zero);
      chewieControllerNotifier = ChewieController(
        videoPlayerController: videoPlayerController!,
        showControls: false,
        aspectRatio: 16 / 9,
        useRootNavigator: false,
        allowFullScreen: false,
        draggableProgressBar: false,
        bufferingBuilder: (context) {
          return const LoadingView();
        },
      );

      fetchQualityOptions();
    });

    videoPlayerController?.addListener(() {
      print('your position is...${videoPlayerController?.value.position}');
      if (videoPlayerController?.value.isCompleted ?? true) {
        isPlay.value = false;
        playerStatus.value = 3;
        showControl = true;
        notifyListeners();
      } else if (videoPlayerController?.value.hasError ?? true) {
        _handlePlaybackError();
        playerStatus.value = 2;
      }
    });
    hideLoading();
  }

  Future<void> _handlePlaybackError() async {
    // Store the current position
    final errorPosition =
        videoPlayerController?.value.position ?? Duration.zero;

    // Try to recover after a short delay
    await Future.delayed(Duration(seconds: 2));

    if (videoPlayerController?.value.hasError ?? false) {
      // If still in error state, try to reinitialize
      await _recoverPlayback(errorPosition);
    }
  }

  Future<void> _recoverPlayback(Duration position) async {
    try {
      // Pause the current player
      await videoPlayerController?.pause();

      // Create a new controller with the same URL
      final newController = VideoPlayerController.networkUrl(
        Uri.parse(currentUrl),
        videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true),
      );

      await newController.initialize();
      await newController.seekTo(position);

      // Replace the old controller
      final oldController = videoPlayerController;
      videoPlayerController = newController;

      // Update Chewie controller
      chewieControllerNotifier = ChewieController(
        videoPlayerController: newController,
        showControls: false,
        aspectRatio: 16 / 9,
        useRootNavigator: false,
        allowFullScreen: false,
        draggableProgressBar: false,
        bufferingBuilder: (context) => const LoadingView(),
      );

      // Try to play again
      await newController.play();

      // Dispose old controller
      oldController?.dispose();
    } catch (e) {
      debugPrint("Recovery failed: $e");
    } finally {}
  }

  void resetControlVisibility({bool isSeek = false}) {
    if (isSeek == true) {
      showControl = true;
    } else {
      showControl = !showControl;
    }

    // Cancel the previous timer before creating a new one
    hideControlTimer?.cancel();
    hideControlTimer = Timer(const Duration(seconds: 6), () {
      if (videoPlayerController?.value.isCompleted ?? true) {
        showControl = true;
        notifyListeners();
      } else {
        showControl = false;
        notifyListeners();
      }
    });
    notifyListeners();
  }

  Future<void> changeQuality(
    String url,
    String? videoId,
    bool isFirstTime,
    Duration? currentDuration, [
    String? quality,
  ]) async {
    if (isFirstTime) {
      showLoading();
      notifyListeners();
    }
    selectedQuality = quality ?? selectedQuality;
    final oldController = videoPlayerController;
    final oldChewieController = chewieControllerNotifier;

    final currentPosition = oldController?.value.position ?? Duration.zero;
    final wasPlaying = oldController?.value.isPlaying ?? true;

    // Load new controller in the background
    final newController = VideoPlayerController.networkUrl(Uri.parse(url));
    await newController.initialize();

    // 👇 Prevent Android from displaying first frame
    await newController.pause(); // pause immediately
    await newController.setLooping(false); // ensure it doesn't auto-loop

    // Seek to previous position BEFORE playing
    await newController.seekTo(
      (currentDuration ?? currentPosition) +
          Duration(seconds: isFirstTime == true ? 0 : 8),
    );

    // Set volume
    newController.setVolume(isMuted ? 0.0 : 1.0);

    // Attach listener
    newController.addListener(() {
      if (newController.value.isCompleted) {
        isPlay.value = false;
        showControl = true;
        playerStatus.value = 3;
        notifyListeners();
      }
    });

    // Create new ChewieController
    final newChewieController = ChewieController(
      videoPlayerController: newController,
      showControls: false,
      aspectRatio: 16 / 9,
      useRootNavigator: false,
      allowFullScreen: false,
      draggableProgressBar: false,
      autoInitialize: true,
      autoPlay: false, // 👈 Prevent autoPlay flicker
      bufferingBuilder: (context) {
        return const LoadingView();
      },
    );
    await Future.delayed(
      Duration(
        milliseconds:
            isFirstTime == true
                ? 0
                : Platform.isIOS
                ? 0
                : 7000,
      ),
    );
    // Now replace the current player
    await oldController?.pause();
    await oldController?.dispose();
    oldChewieController?.dispose();

    videoPlayerController = newController;
    chewieControllerNotifier = newChewieController;

    // Start playing only after everything is ready
    if (wasPlaying) {
      await newController.play();
    }
    hideLoading();
    notifyListeners();
  }

  // Future<void> changeQuality(
  //   String url,
  //   String? videoId,
  //   bool isFirstTime,
  //   Duration? currentDuration, [
  //   String? quality,
  // ]) async {
  //   if (isFirstTime) {
  //     showLoading();
  //     notifyListeners();
  //   }

  //   selectedQuality = quality ?? selectedQuality;
  //   final oldController = videoPlayerController;
  //   final oldChewieController = chewieControllerNotifier;

  //   final currentPosition = oldController?.value.position ?? Duration.zero;
  //   final wasPlaying = oldController?.value.isPlaying ?? true;

  //   // Load new controller in the background
  //   final newController = VideoPlayerController.networkUrl(Uri.parse(url));
  //   await newController.initialize();

  //   // Pause to prevent first frame display
  //   await newController.pause();
  //   await newController.setLooping(false);

  //   // Seek to previous position + buffer offset if not first time
  //   final positionToSeek =
  //       (currentDuration ?? currentPosition) + Duration(seconds: 8);

  //   await newController.seekTo(positionToSeek);

  //   // Set volume
  //   newController.setVolume(isMuted ? 0.0 : 1.0);

  //   // Completion listener
  //   newController.addListener(() {
  //     if (newController.value.isCompleted) {
  //       isPlay.value = false;
  //       showControl = true;
  //       playerStatus.value = 3;
  //       notifyListeners();
  //     }
  //   });

  //   // Wait until frame is ready (max 10 seconds)
  //   const maxWait = Duration(seconds: 8);
  //   final startTime = DateTime.now();

  //   while (true) {
  //     final now = DateTime.now();
  //     final isReady =
  //         newController.value.isInitialized &&
  //         !newController.value.isBuffering &&
  //         newController.value.position >= positionToSeek;

  //     if (isReady) break;

  //     if (now.difference(startTime) > maxWait) {
  //       debugPrint("Timeout waiting for video to buffer.");
  //       break;
  //     }

  //     await Future.delayed(Duration(milliseconds: 200));
  //   }

  //   // Create Chewie controller AFTER readiness
  //   final newChewieController = ChewieController(
  //     videoPlayerController: newController,
  //     showControls: false,
  //     aspectRatio: 16 / 9,
  //     useRootNavigator: false,
  //     allowFullScreen: false,
  //     draggableProgressBar: false,
  //     autoInitialize: true,
  //     autoPlay: false,
  //     bufferingBuilder: (context) => const LoadingView(),
  //   );

  //   // Clean up old controllers
  //   await oldController?.pause();
  //   await oldController?.dispose();
  //   oldChewieController?.dispose();

  //   // Assign new controllers
  //   videoPlayerController = newController;
  //   chewieControllerNotifier = newChewieController;

  //   // Start playing after everything is ready
  //   if (wasPlaying) {
  //     await newController.play();
  //   }

  //   hideLoading();
  //   notifyListeners();
  // }

  //toggle full screen
  void toggleFullScreen({bool? isLock}) async {
    //isLockScreen = isLock ?? false;
    _stopTimer();
    isFullScreen = !isFullScreen;
    scale = 1.0;
    toggleCount++;
    notifyListeners();

    toggleTimer?.cancel();
    toggleTimer = Timer(Duration(seconds: 1), () {
      toggleCount = 0;
      notifyListeners();
    });

    if (isFullScreen) {
      if (Platform.isAndroid) {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else {
        AutoOrientation.landscapeRightMode();
      }
    } else {
      if (Platform.isAndroid) {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      } else {
        AutoOrientation.portraitUpMode();
      }
    }

    if (Platform.isAndroid) _startTimer();

    resetControlVisibility(isSeek: true);

    notifyListeners();
  }

  _startTimer() {
    _elapsedSeconds = 0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      if (_elapsedSeconds >= 3) {
        _stopTimer();
        if (isAutoRotateEnabled == true) {
          SystemChrome.setPreferredOrientations([]);
        }

        _stopTimer();
      }
    });
  }

  _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _elapsedSeconds = 0;
  }

  // Function to toggle mute/unmute
  void toggleMute() {
    isMuted = !isMuted;
    videoPlayerController?.setVolume(isMuted ? 0.0 : 1.0);
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

  Duration _seekOffset = Duration.zero;
  Timer? _debounceSeekTimer;

  void seekBy(Duration offset) {
    _seekOffset += offset;
    _debounceSeekTimer?.cancel();

    _debounceSeekTimer = Timer(const Duration(milliseconds: 300), () async {
      final controller = videoPlayerController;
      if (controller == null || !controller.value.isInitialized) return;

      final currentPosition = controller.value.position;
      final duration = controller.value.duration;

      final newPosition = (currentPosition + _seekOffset).clamp(
        Duration.zero,
        duration,
      );

      _seekOffset = Duration.zero;

      await controller.seekTo(newPosition);

      if (!controller.value.isPlaying) {
        await controller.play();
        chewieControllerNotifier?.play();
      }

      notifyListeners();
    });
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
    hideControlTimer?.cancel();
    toggleTimer?.cancel();
    seekTimer?.cancel();
    _timer?.cancel();
    super.dispose();
  }
}
