import 'dart:async';
import 'dart:io';
import 'package:auto_orientation_v2/auto_orientation_v2.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_obs/bloc/video_bloc.dart';
import 'package:movie_obs/data/videoPlayer/video_player.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/network/analytics_service/analytics_service.dart';
import 'package:movie_obs/screens/bottom_nav/bottom_nav_screen.dart';
import 'package:movie_obs/screens/video_player.dart/popup_video_player.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/utils/images.dart';
import 'package:movie_obs/utils/rotation_detector.dart';
import 'package:movie_obs/widgets/toast_service.dart';
import 'package:provider/provider.dart';
import 'package:chewie/chewie.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

final ValueNotifier<bool> isPlay = ValueNotifier(false);
final ValueNotifier<int> playerStatus = ValueNotifier(1);

bool showControl = true;
bool isAutoRotateEnabled = false;
double deviceVolume = 1.0;
double bufferedProgress = 0.0;

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    super.key,
    this.url,
    this.videoId,
    required this.isFirstTime,
    required this.type,
    this.isTrailer,
  });
  final String? url;
  final String? videoId;
  final bool isFirstTime;
  final String type;
  final bool? isTrailer;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with WidgetsBindingObserver {
  late final VideoBloc bloc;
  Orientation? _lastOrientation;
  VideoProgress? _savedVideo;
  bool isClickPopUp = false;
  StreamSubscription<bool>? _subscription;
  double brightness = 1.0;
  double progress = 0.0;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (videoPlayerController?.value.isPlaying ?? true) {
        playerStatus.value = 2;
      } else if (videoPlayerController?.value.isCompleted ?? true) {
        playerStatus.value = 3;
      } else {
        playerStatus.value = 1;
      }
      if (Platform.isIOS) {
        SystemChrome.setPreferredOrientations([]);
      }
    } else if (state == AppLifecycleState.paused) {
      bloc.updateListener();
      if (Platform.isIOS) {
        if (bloc.isFullScreen == true) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        } else {
          AutoOrientation.portraitUpMode();
        }
      }
    } else if (state == AppLifecycleState.hidden) {
      videoPlayerController?.pause();
    }

    super.didChangeAppLifecycleState(state);
  }

  void _checkOrientation() {
    final screenSize =
        WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
    final newOrientation =
        screenSize.width > screenSize.height
            ? Orientation.landscape
            : Orientation.portrait;

    if (_lastOrientation == newOrientation) return;
    _lastOrientation = newOrientation;

    if (bloc.isFullScreen && newOrientation == Orientation.landscape) return;
    bloc.isFullScreen = _lastOrientation == Orientation.landscape;
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (_) {
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    if (_connectionStatus.first == ConnectivityResult.none) {
      videoPlayerController?.pause();
      chewieControllerNotifier?.pause();
    }
  }

  @override
  void didChangeMetrics() {
    _checkOrientation();
    super.didChangeMetrics();
  }

  @override
  void initState() {
    super.initState();
    selectedQuality = 'Auto';
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    WidgetsBinding.instance.addObserver(this);
    bloc = Provider.of<VideoBloc>(context, listen: false);
    if (Platform.isAndroid) {
      _subscription = RotationDetector.onRotationLockChanged.listen((
        isEnabled,
      ) {
        if (!mounted) return;

        setState(() {
          isAutoRotateEnabled = isEnabled;

          if (isAutoRotateEnabled) {
            SystemChrome.setPreferredOrientations([]);
          } else {
            SystemChrome.setPreferredOrientations(
              bloc.isFullScreen
                  ? [
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight,
                  ]
                  : [DeviceOrientation.portraitUp],
            );
          }
        });
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      WakelockPlus.enable();
      bloc.toggleHistory(widget.videoId ?? '', widget.type);
      bloc.isMuted = false;
      bloc.currentUrl = widget.url ?? '';
      bloc.lastKnownPosition = Duration.zero;
      MiniVideoPlayer.removeMiniPlayer();
      isPlay.value = true;
      initConnectivity();
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        _updateConnectionStatus,
      );

      if (widget.isFirstTime == true) {
        if (widget.isTrailer == true) {
          bloc.initializeVideo(widget.url ?? '', duration: Duration.zero);
        } else {
          _loadCurrentPosition();
        }
      } else {}
    });
  }

  Future<void> _loadCurrentPosition() async {
    final savedProgressList = await loadVideoProgress();
    _savedVideo = savedProgressList.firstWhere(
      (progress) => progress.videoId == widget.videoId,
      orElse:
          () => VideoProgress(
            videoId: widget.videoId ?? '',
            position: Duration.zero,
          ),
    );

    bloc.initializeVideo(widget.url ?? '', duration: _savedVideo?.position);
    bloc.updateListener();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    _connectivitySubscription.cancel();
    if (widget.videoId != null &&
        (videoPlayerController?.value.isInitialized ?? true)) {
      final position = videoPlayerController?.value.position ?? Duration.zero;
      final duration = videoPlayerController?.value.duration ?? Duration.zero;

      if (duration.inSeconds > 0) {
        final progress = position.inSeconds / duration.inSeconds;
        if (progress > 0.25) {
          AnalyticsService().logVideoView(
            videoId: widget.videoId ?? "",
            videoTitle: '',
            duration: duration,
          );
        }
      }
      saveVideoProgress([
        VideoProgress(videoId: widget.videoId ?? '', position: position),
      ]);
    }

    if (isClickPopUp != true) {
      videoPlayerController?.dispose();
      playerStatus.value = 1;
    }
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    bloc.isFullScreen = false;
    bloc.updateListener();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoBloc>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 60,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title:
                showControl == true
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        20.hGap,
                        _buildTopLeftControls(),
                        Spacer(),
                        _buildTopRightControls(),
                        20.hGap,
                      ],
                    )
                    : SizedBox.shrink(),
          ),
          extendBodyBehindAppBar: true,
          extendBody: true,
          backgroundColor: kBlackColor,
          body: _buildVideoPlayerSection(),
          bottomNavigationBar: SizedBox(
            height: bloc.isFullScreen ? 80 : 100,
            child: Visibility(
              visible: showControl == true,
              child: _buildProgressBarContent(),
            ),
          ),
        );
      },
    );
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    startDragOffset = null;
  }

  Offset? startDragOffset;

  void _onVerticalDragStart(DragStartDetails details) {
    startDragOffset = details.localPosition;
  }

  void _onVerticalDragUpdate(
    DragUpdateDetails details,
    String side,
    double height,
  ) {
    if (startDragOffset == null) return;

    final dy = details.globalPosition.dy;

    final deltaY = dy - details.globalPosition.dy;
    final newValue = (deviceVolume + deltaY / 300).clamp(0.0, 1.0);

    if (side == 'left') {
      setState(() {
        deviceVolume = newValue;
        volumeController?.setVolume(deviceVolume);
      });
    }
  }

  Widget _buildVideoPlayerSection() {
    return Consumer<VideoBloc>(
      builder:
          (context, bloc, child) => LayoutBuilder(
            builder: (context, constraints) {
              double screenHeight = constraints.maxHeight;
              final screenWidth = constraints.maxWidth;
              final leftZone = screenWidth * 0.3;
              return Container(
                color: Colors.transparent,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (_connectionStatus.first == ConnectivityResult.none) {
                      ToastService.warningToast('Please check your connection');
                    }
                    bloc.resetControlVisibility();
                  },
                  child: Stack(
                    children: [
                      _buildVideoPlayer(),
                      Positioned(
                        left: 0,
                        width: leftZone,
                        height: screenHeight,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onVerticalDragStart: _onVerticalDragStart,
                          onVerticalDragUpdate:
                              (details) => _onVerticalDragUpdate(
                                details,
                                'left',
                                screenHeight,
                              ),
                          onVerticalDragEnd: _onVerticalDragEnd,
                        ),
                      ),
                      bloc.isLoading == true ||
                              !(videoPlayerController?.value.isInitialized ??
                                  true) ||
                              _connectionStatus.first ==
                                  ConnectivityResult.none ||
                              bloc.isPlaying == false
                          ? Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 60,
                              height: 60,
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: kPrimaryColor,
                                backgroundColor: kWhiteColor,
                              ),
                            ),
                          )
                          : SizedBox(),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }

  Widget _buildVideoPlayer() {
    return Align(
      alignment: Alignment.center,
      child: IgnorePointer(
        ignoring: true,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Player(),
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Consumer<VideoBloc>(
      builder:
          (context, bloc, child) => IgnorePointer(
            ignoring: !showControl,
            child: Row(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                videoPlayerController?.value.isCompleted ?? true
                    ? SizedBox.shrink()
                    : _buildSeekButton(
                      icon: CupertinoIcons.gobackward_10,
                      onPressed: () {
                        if (_connectionStatus.first !=
                            ConnectivityResult.none) {
                          if (videoPlayerController?.value.isInitialized ??
                              true) {
                            bloc.seekBy(Duration(seconds: -10));
                          }
                          isPlay.value = false;
                        } else {
                          ToastService.warningToast(
                            'Please check your connection!',
                          );
                        }
                      },
                    ),
                _buildPlayPauseButton(),
                videoPlayerController?.value.isCompleted ?? true
                    ? SizedBox.shrink()
                    : _buildSeekButton(
                      icon: CupertinoIcons.goforward_10,
                      onPressed: () {
                        if (_connectionStatus.first !=
                            ConnectivityResult.none) {
                          if (videoPlayerController?.value.isInitialized ??
                              true) {
                            bloc.seekBy(Duration(seconds: 10));
                          }
                        } else {
                          ToastService.warningToast(
                            'Please check your connection!',
                          );
                        }
                      },
                    ),
              ],
            ),
          ),
    );
  }

  Widget _buildSeekButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: kWhiteColor, size: 25),
    );
  }

  Widget _buildPlayPauseButton() {
    return ValueListenableBuilder(
      valueListenable: playerStatus,
      builder:
          (context, value, child) => IconButton(
            onPressed: _togglePlayPause,
            icon: Padding(
              padding: const EdgeInsets.all(5.0),
              child:
                  value == 3
                      ? const Icon(
                        CupertinoIcons.arrow_counterclockwise,
                        size: 30,
                        color: kWhiteColor,
                      )
                      : Icon(
                        value == 2 ? CupertinoIcons.pause : CupertinoIcons.play,
                        color: kWhiteColor,
                        size: 30,
                      ),
            ),
          ),
    );
  }

  void _togglePlayPause() {
    if (videoPlayerController?.value.isCompleted ?? true) {
      bloc.initializeVideo(bloc.currentUrl);
    } else {
      if (videoPlayerController?.value.isPlaying ?? true) {
        videoPlayerController?.pause();
        isPlay.value = false;
        playerStatus.value = 1;
      } else {
        videoPlayerController?.play();
        playerStatus.value = 2;
        isPlay.value = true;
      }
    }
    bloc.resetControlVisibility(isSeek: true);
  }

  Widget _buildTopLeftControls() {
    return _buildExitButton();
  }

  Widget _buildExitButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pop(context);
        videoPlayerController?.pause();
      },
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: bloc.isFullScreen ? kSecondaryColor : Colors.transparent,
        ),
        child: const Icon(
          CupertinoIcons.clear_thick,
          color: Colors.white,
          size: 23,
        ),
      ),
    );
  }

  Widget _buildTopRightControls() {
    return _buildSettingsButtons();
  }

  Widget _buildSettingsButtons() {
    return IgnorePointer(
      ignoring: !showControl,
      child: Row(
        spacing: 20,
        children: [
          bloc.isFullScreen
              ? SizedBox.shrink()
              : GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (_connectionStatus.first == ConnectivityResult.none) {
                    ToastService.warningToast('Please check your connection');
                  } else {
                    if (videoPlayerController?.value.isInitialized ?? true) {
                      isClickPopUp = true;
                      Navigator.pop(context);
                      isPlay.value =
                          !(videoPlayerController?.value.isPlaying ?? true);
                      showControl = false;
                      bloc.updateListener();
                      MiniVideoPlayer.showMiniPlayer(
                        context,
                        bloc.currentUrl,
                        videoPlayerController?.value.isPlaying ?? true
                            ? isPlay.value = true
                            : isPlay.value = false,
                        widget.videoId ?? '',
                      );
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                      ]);
                    }
                  }
                },
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.transparent,
                  ),
                  child: Image.asset(
                    kPictureInPictureIcon,
                    width: 30,
                    color: kWhiteColor,
                  ),
                ),
              ),
          _buildSettingsButton(),
        ],
      ),
    );
  }

  Widget _buildSettingsButton() {
    return GestureDetector(
      onTap: () {
        if (_connectionStatus.first == ConnectivityResult.none) {
          ToastService.warningToast('Please check your connection!');
        } else {
          showControl = true;
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (_) => _buildAdditionalOptions(),
          ).whenComplete(() async {
            if (bloc.isQualityClick == 0) return;
            await Future.delayed(const Duration(milliseconds: 400), () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (builder) {
                  return bloc.isQualityClick == 1
                      ? _qualityModalSheet()
                      : _buildPlaybackModalSheet();
                },
              ).whenComplete(() => bloc.isQualityClick = 0);
            });
          });
        }
      },
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: bloc.isFullScreen ? kSecondaryColor : Colors.transparent,
        ),
        child: const Icon(Icons.settings, color: Colors.white, size: 27),
      ),
    );
  }

  Widget _buildProgressBarContent() {
    return IgnorePointer(
      ignoring:
          !showControl || _connectionStatus.first == ConnectivityResult.none,
      child: Container(
        color: Colors.black45,
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            3.vGap,
            Row(
              spacing: bloc.isFullScreen ? 10 : 0,
              children: [
                !bloc.isFullScreen ? SizedBox.shrink() : _buildTimeDisplay(),
                Expanded(child: _buildSlider()),
                !bloc.isFullScreen
                    ? SizedBox.shrink()
                    : Text(
                      bloc.formatDuration(
                        videoPlayerController?.value.duration ?? Duration.zero,
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ],
            ),

            bloc.isFullScreen
                ? SizedBox.shrink()
                : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTimeDisplay(),

                    Text(
                      bloc.formatDuration(
                        videoPlayerController?.value.duration ?? Duration.zero,
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMuteButton(),
                _buildControlButtons(),
                _buildFullScreenButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMuteButton() {
    return GestureDetector(
      onTap: () => bloc.toggleMute(),
      child: Container(
        height: bloc.isFullScreen ? 42 : 30,
        width: bloc.isFullScreen ? 50 : 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.transparent,
        ),
        child: Icon(
          !bloc.isMuted
              ? CupertinoIcons.speaker_3_fill
              : CupertinoIcons.speaker_slash_fill,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildTimeDisplay() {
    return ValueListenableBuilder(
      valueListenable: videoPlayerController as VideoPlayerController,
      builder: (context, VideoPlayerValue value, child) {
        return Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            bloc.formatDuration(value.position),
            style: const TextStyle(
              color: Colors.white,
              // fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSlider() {
    return IgnorePointer(
      ignoring:
          _connectionStatus.first == ConnectivityResult.none ||
          bloc.isPlaying == false ||
          (videoPlayerController?.value.isCompleted ?? true),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 1),
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            allowedInteraction: SliderInteraction.slideThumb,
            trackHeight: 3.0,
            inactiveTrackColor: Colors.white.withValues(alpha: 0.5),
            activeTrackColor: kPrimaryColor,
            padding: EdgeInsets.zero,
            secondaryActiveTrackColor:
                bloc.isSeeking
                    ? Colors.transparent
                    : !(videoPlayerController?.value.isInitialized ?? true)
                    ? Colors.transparent
                    : Colors.white,
            thumbColor: kPrimaryColor,
            trackShape: const RoundedRectSliderTrackShape(),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7.0),
          ),
          child: ValueListenableBuilder(
            valueListenable: videoPlayerController as VideoPlayerController,
            builder: (context, VideoPlayerValue value, child) {
              if (value.isInitialized) {
                final duration = value.duration;
                final position = value.position;

                if (duration.inMilliseconds > 0 && !bloc.isSeeking) {
                  progress = (position.inMilliseconds / duration.inMilliseconds)
                      .clamp(0.0, 1.0);
                } else {
                  progress = bloc.manualSeekProgress;
                }

                if (value.buffered.isNotEmpty) {
                  bufferedProgress = (value.buffered.last.end.inMilliseconds /
                          duration.inMilliseconds)
                      .clamp(0.0, 1.0);
                }
              }

              return Slider(
                value:
                    !(videoPlayerController?.value.isInitialized ?? true)
                        ? 0.0
                        : progress,
                secondaryTrackValue:
                    !(videoPlayerController?.value.isInitialized ?? true)
                        ? 0.0
                        : bufferedProgress,
                onChanged: (newValue) {
                  bloc.resetControlVisibility(isSeek: true);
                  bloc.isSeeking = true;
                  bloc.manualSeekProgress = newValue;
                  bloc.throttleSliderUpdate();
                },
                onChangeStart: (value) {
                  bloc.pausedPlayer();
                  bloc.startSeekUpdateLoop();
                  bloc.resetControlVisibility(isSeek: true);
                },
                onChangeEnd: (value) async {
                  isPlay.value = false;
                  bloc.seekUpdateTimer?.cancel();

                  final newPosition = Duration(
                    milliseconds:
                        ((videoPlayerController
                                        ?.value
                                        .duration
                                        .inMilliseconds ??
                                    0) *
                                value)
                            .toInt(),
                  );

                  await videoPlayerController?.seekTo(newPosition);
                  bloc.isSeeking = false;
                  bloc.resetControlVisibility(isSeek: true);

                  if (newPosition != videoPlayerController?.value.duration) {
                    bloc.playPlayer();
                    playerStatus.value = 2;
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFullScreenButton() {
    return GestureDetector(
      onTap: () {
        showControl = false;
        bloc.toggleFullScreen();
      },

      child: SizedBox(
        child: Icon(Icons.fullscreen, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildAdditionalOptions() {
    return Consumer<VideoBloc>(
      builder:
          (context, value, child) => Container(
            margin: EdgeInsets.only(bottom: 40, left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 60, 60, 60),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            height: null,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 30,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      bloc.isQualityClick = 1;
                      Navigator.of(context).pop();
                    },
                    child: _buildAdditionalRow(
                      'Quality',
                      '$selectedQuality >',
                      CupertinoIcons.slider_horizontal_3,
                    ),
                  ),
                  SizedBox(height: 25),
                  GestureDetector(
                    onTap: () async {
                      bloc.isQualityClick = 2;
                      Navigator.pop(context);
                    },
                    child: _buildAdditionalRow(
                      'Playback Speed',
                      '${bloc.videoCurrentSpeed} >',
                      Icons.speed,
                    ),
                  ),

                  20.vGap,
                  StatefulBuilder(
                    builder:
                        (
                          BuildContext context,
                          void Function(void Function()) setState,
                        ) => Row(
                          spacing: 10,
                          children: [
                            Icon(
                              CupertinoIcons.brightness,
                              color: Colors.white,
                            ),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 2.0,
                                  thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 7.0,
                                  ),
                                  overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 5.0,
                                  ),
                                ),
                                child: Slider(
                                  value: brightness,
                                  onChanged: (value) {
                                    setState(() {
                                      brightness = value;
                                      setSystemBrightness(brightness);
                                    });
                                  },
                                  min: 0.0,
                                  max: 1.0,
                                  activeColor: kSecondaryColor,
                                  inactiveColor: Colors.grey,
                                ),
                              ),
                            ),
                            Icon(
                              CupertinoIcons.brightness_solid,
                              color: Colors.white,
                            ),
                          ],
                        ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> setSystemBrightness(double brightness) async {
    try {
      await ScreenBrightness.instance.setApplicationScreenBrightness(
        brightness,
      );
    } catch (e) {
      debugPrint(e.toString());
      ToastService.warningToast('Failed to set system brightness');
    }
  }

  Widget _buildAdditionalRow(String title, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 13,
          children: [
            Icon(icon, size: 20, color: Colors.white),

            Text(
              title,
              style: TextStyle(fontSize: kTextRegular2x, color: Colors.white),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(fontSize: kTextRegular2x, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _qualityModalSheet() {
    return Consumer<VideoBloc>(
      builder:
          (context, bloc, child) => Container(
            margin: EdgeInsets.only(bottom: 40, left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 60, 60, 60),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: null,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                      width: 30,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: 10),
                    shrinkWrap: true,
                    itemCount: bloc.qualityOptions.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: SizedBox(
                            height: 35,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                if (selectedQuality == 'Auto') return;
                                bloc.changeQuality(
                                  widget.url ?? '',
                                  widget.videoId,
                                  false,
                                  null,
                                  'Auto',
                                );
                              },
                              child: Row(
                                children: [
                                  selectedQuality == 'Auto'
                                      ? SizedBox(
                                        width: 30,
                                        child: Icon(
                                          CupertinoIcons.checkmark,
                                          color: Colors.green,
                                          size: 18,
                                        ),
                                      )
                                      : SizedBox(width: 30),
                                  Text(
                                    'Auto (recommended)',
                                    style: TextStyle(
                                      fontSize: kTextRegular2x,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      int qualityIndex = index - 1;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            String selectedUrl =
                                bloc.qualityOptions.firstWhere(
                                  (element) =>
                                      element['quality'] ==
                                      bloc.qualityOptions[qualityIndex]['quality'],
                                )['url']!;
                            if ((selectedQuality ==
                                (bloc.qualityOptions[qualityIndex]['quality'] ??
                                    ''))) {
                              return;
                            }

                            bloc.changeQuality(
                              selectedUrl,
                              widget.videoId,
                              false,
                              null,
                              bloc.qualityOptions[qualityIndex]['quality'] ??
                                  '',
                            );
                          },
                          child: SizedBox(
                            height: 35,
                            child: Row(
                              children: [
                                selectedQuality ==
                                        (bloc.qualityOptions[qualityIndex]['quality'] ??
                                            '')
                                    ? SizedBox(
                                      width: 30,
                                      child: Icon(
                                        CupertinoIcons.checkmark,
                                        color: Colors.green,
                                        size: 18,
                                      ),
                                    )
                                    : SizedBox(width: 30),
                                Text(
                                  bloc.qualityOptions[qualityIndex]['quality'] ??
                                      '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: kTextRegular2x,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
    );
  }

  final List<double> speeds = [0.25, 1.0, 1.25, 1.5, 2.0];

  Widget _buildPlaybackModalSheet() {
    return Consumer<VideoBloc>(
      builder:
          (context, bloc, child) => Container(
            margin: EdgeInsets.only(bottom: 40, left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 60, 60, 60),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: null,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                      width: 30,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FittedBox(
                    child: Container(
                      height: 30,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          bloc.videoCurrentSpeed == 1.0
                              ? '${bloc.videoCurrentSpeed} - normal'
                              : bloc.videoCurrentSpeed.toString(),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:
                        speeds
                            .map(
                              (value) => GestureDetector(
                                onTap: () {
                                  bloc.updateSpeed(value);
                                },
                                child: Container(
                                  width: 50,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      85,
                                      84,
                                      84,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),

                                  child: Center(
                                    child: Text(
                                      value.toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
    );
  }
}

class Player extends StatelessWidget {
  const Player({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<VideoBloc>(
      builder:
          (context, bloc, child) => AspectRatio(
            aspectRatio: videoPlayerController?.value.aspectRatio ?? 0.0,
            child: Chewie(
              controller:
                  chewieControllerNotifier ??
                  ChewieController(
                    videoPlayerController:
                        videoPlayerController as VideoPlayerController,
                    showControls: false,
                  ),
            ),
          ),
    );
  }
}
