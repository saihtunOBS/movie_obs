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

  bool isMuted = false;
  Timer? hideControlTimer;
  double manualSeekProgress = 0.0;
  bool isSeeking = false;
  Timer? seekUpdateTimer;

  Timer? toggleTimer;
  int toggleCount = 0;

  double videoCurrentSpeed = 1.0;
  int isQualityClick = 0;
  Timer? _timer;
  int _elapsedSeconds = 0;
  Duration lastKnownPosition = Duration.zero;

  bool isLoading = true;
  List<Map<String, String>> qualityOptions = [];

  String currentUrl = '';
  double scale = 1.0;
  bool hasError = false;
  int seekCount = 0;
  Timer? seekTimer;

  final MovieModel _movieModel = MovieModelImpl();
  String token = '';

  bool isPlaying = true;

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
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true),
    );
    videoPlayerController?.initialize().then((_) {
      videoPlayerController?.seekTo(duration ?? Duration.zero);
      chewieControllerNotifier = ChewieController(
        videoPlayerController: videoPlayerController!,
        showControls: false,
        autoPlay: true,
        aspectRatio: 16 / 9,
        useRootNavigator: false,
        allowFullScreen: false,
        draggableProgressBar: false,
        bufferingBuilder: (context) {
          return const LoadingView();
        },
      );
      playerStatus.value = 2;
      fetchQualityOptions();
    });

    videoPlayerController?.addListener(() {
      if (videoPlayerController?.value.isPlaying ?? true) {
        isPlaying = true;
        lastKnownPosition =
            videoPlayerController?.value.position ?? Duration.zero;
      } else if (videoPlayerController?.value.isCompleted ?? true) {
        isPlay.value = false;
        playerStatus.value = 3;
        showControl = true;
        notifyListeners();
      }
    });
    hideLoading();
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
      if (videoPlayerController?.value.isPlaying ?? true) {
        isPlaying = true;
        lastKnownPosition =
            videoPlayerController?.value.position ?? Duration.zero;
      } else if (videoPlayerController?.value.isCompleted ?? true) {
        isPlay.value = false;
        playerStatus.value = 3;
        showControl = true;
        notifyListeners();
      } else if (videoPlayerController?.value.hasError ?? true) {
        playerStatus.value = 1;
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
      await videoPlayerController?.play();
      await chewieControllerNotifier?.play();
    }
    showControl = false;
    hideLoading();
    notifyListeners();
  }

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
  bool _isSeeking = false;

  void seekBy(Duration offset) {
    final currentPosition =
        videoPlayerController?.value.position ?? Duration.zero;
    final newPosition = currentPosition + offset;
    final duration = videoPlayerController?.value.duration ?? Duration.zero;

    if (newPosition < duration && newPosition > Duration.zero) {
      isPlaying = false;
      notifyListeners();
      _seekOffset += offset;
      _debounceSeekTimer?.cancel();

      _debounceSeekTimer = Timer(const Duration(milliseconds: 300), () async {
        final controller = videoPlayerController;
        if (controller == null ||
            !controller.value.isInitialized ||
            _isSeeking) {
          return;
        }

        final currentPosition = controller.value.position;
        final duration = controller.value.duration;

        final newPosition = (currentPosition + _seekOffset).clamp(
          Duration.zero,
          duration,
        );

        final isCompleted = controller.value.isCompleted;
        final isSeekingTooFarBack =
            newPosition <= Duration.zero && offset.isNegative;

        if (isCompleted || isSeekingTooFarBack) {
          _seekOffset = Duration.zero;
          return;
        }

        _isSeeking = true;
        _seekOffset = Duration.zero;

        try {
          isPlaying = false;
          notifyListeners();
          await controller.seekTo(newPosition);

          if (!controller.value.isPlaying) {
            await controller.play();
            chewieControllerNotifier?.play();
            isPlaying = true;
            playerStatus.value = 2;
            notifyListeners();
          }
        } catch (e) {
          debugPrint("Seek error: $e");
        } finally {
          _isSeeking = false;
          notifyListeners();
        }
      });
    }
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
