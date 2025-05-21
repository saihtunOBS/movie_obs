// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:auto_orientation_v2/auto_orientation_v2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_obs/bloc/video_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
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

import '../../data/videoPlayer/video_player.dart';

final ValueNotifier<bool> isPlay = ValueNotifier(false);
double progress = 0.0;
double bufferedProgress = 0.0;
bool showControl = true;
bool isAutoRotateEnabled = false;
double _volume = 1.0; // Initial volume
double brightness = 1.0;

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    super.key,
    this.url,
    this.videoId,
    required this.isFirstTime,
    required this.type,
  });
  final String? url;
  final String? videoId;
  final bool isFirstTime;
  final String type;

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //bloc.resetControlVisibility(isSeek: true);
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
      videoPlayerController.pause();
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

    if (newOrientation == Orientation.landscape) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    if (_lastOrientation == newOrientation) return;
    _lastOrientation = newOrientation;

    if (bloc.isFullScreen && newOrientation == Orientation.landscape) return;
    bloc.isFullScreen = _lastOrientation == Orientation.landscape;
  }

  @override
  void didChangeMetrics() {
    _checkOrientation();
    super.didChangeMetrics();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (chewieControllerNotifier == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        //  if(widget.isFirstTime == false) return;
        bloc.initializeVideo(widget.url ?? '');
      });
    }
  }

  @override
  void initState() {
    setState(() {
      if (!mounted) return;
      setState(() {
        showControl = true;
      });
    });

    //set up volume listener
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    onStartDrag.value = true;
    WidgetsBinding.instance.addObserver(this);
    bloc = Provider.of<VideoBloc>(context, listen: false);

    if (Platform.isAndroid) {
      _subscription = RotationDetector.onRotationLockChanged.listen((
        isEnabled,
      ) {
        if (mounted) {
          setState(() {
            isAutoRotateEnabled = isEnabled;

            if (Platform.isAndroid) {
              if (isAutoRotateEnabled == true) {
                SystemChrome.setPreferredOrientations([]);
              } else {
                if (bloc.isFullScreen == true) {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight,
                  ]);
                } else {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                  ]);
                }
              }
            }
          });
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.toggleHistory(widget.videoId ?? '', widget.type);
      bloc.isMuted = false;
      bloc.currentUrl = widget.url ?? '';
      MiniVideoPlayer.removeMiniPlayer();
      isPlay.value = true;
      if (widget.isFirstTime == true) {
        _loadCurrentPosition();
      } else {
        bloc.resetControlVisibility(isSeek: true);
      }
    });
    super.initState();
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

    Future.delayed(Duration(milliseconds: 100), () {
      if ((_savedVideo?.position ?? Duration.zero) > Duration.zero) {
        selectedQuality = 'Auto';
        bloc.fetchQualityOptions();
        bloc.changeQuality(
          widget.url ?? '',
          widget.videoId,
          true,
          _savedVideo?.position,
        );
        bloc.updateListener();
      } else {
        bloc.initializeVideo(
          widget.url ?? '',
          videoId: widget.videoId,
          type: widget.type,
        );
        bloc.updateListener();
      }
    });
  }

    @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    if (isClickPopUp != true) {
      videoPlayerController.pause();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoBloc>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 0.0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
          ),
          extendBodyBehindAppBar: true,
          extendBody: true,
          backgroundColor: kBlackColor,
          body: _buildVideoPlayerSection(),
        );
      },
    );
  }

  Widget _buildVideoPlayerSection() {
    return Container(
      color: Colors.transparent,

      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          bloc.resetControlVisibility();
        },
        child: Stack(
          children: [
            chewieControllerNotifier == null ||
                    !videoPlayerController.value.isInitialized ||
                    bloc.isLoading
                ? _buildLoadingIndicator()
                : _buildVideoPlayer(),

            !videoPlayerController.value.isInitialized
                ? SizedBox()
                : showControl == true
                ? _buildPlayPauseControls()
                : SizedBox.shrink(),
            showControl == true ? _buildTopLeftControls() : SizedBox.shrink(),
            showControl == true ? _buildTopRightControls() : SizedBox.shrink(),
            showControl == true ? _buildProgressBar() : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: kPrimaryColor,
        backgroundColor: kWhiteColor,
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Stack(
      children: [
        Stack(
          children: [
            GestureDetector(
              onDoubleTap: _handleDoubleTap,
              onDoubleTapDown: _handleDoubleTapDown,
              behavior: HitTestBehavior.opaque,
              child: IgnorePointer(ignoring: true, child: Player(bloc: bloc)),
            ),
          ],
        ),
      ],
    );
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    if (!videoPlayerController.value.isInitialized) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final tapPosition = details.localPosition.dx;
    final tapThreshold = screenWidth * 0.1;

    if (tapPosition < screenWidth / 2 - tapThreshold) {
      bloc.seekBackward(isDoubleTag: true);
      bloc.isHoveringLeft.value = true;
      bloc.isHoveringRight.value = false;
      isPlay.value = false;
    } else if (tapPosition > screenWidth / 2 + tapThreshold) {
      bloc.seekForward(isDoubleTag: true);
      bloc.isHoveringRight.value = true;
      bloc.isHoveringLeft.value = false;
      isPlay.value = false;
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      bloc.isHoveringLeft.value = false;
      bloc.isHoveringRight.value = false;
    });
  }

  void _handleDoubleTap() {
    if (!videoPlayerController.value.isInitialized) return;
    Future.delayed(const Duration(milliseconds: 100), () {
      bloc.isHoveringRight.value = false;
      bloc.isHoveringLeft.value = false;
    });
  }

  Widget _buildPlayPauseControls() {
    return Align(alignment: Alignment.center, child: _buildControlButtons());
  }

  Widget _buildControlButtons() {
    return IgnorePointer(
      ignoring: !showControl,
      child: Row(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSeekButton(
            icon: CupertinoIcons.gobackward_10,
            onPressed: () {
              bloc.resetControlVisibility(isSeek: true);
              if (videoPlayerController.value.isInitialized) {
                bloc.seekBackward();
              }
              isPlay.value = false;
            },
          ),
          _buildPlayPauseButton(),
          _buildSeekButton(
            icon: CupertinoIcons.goforward_10,
            onPressed: () {
              bloc.resetControlVisibility(isSeek: true);
              if (videoPlayerController.value.isInitialized) {
                bloc.seekForward();
              }
              isPlay.value = false;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSeekButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return IconButton.filled(
      onPressed: onPressed,
      icon: Icon(icon, color: kWhiteColor, size: 27),
      style: IconButton.styleFrom(backgroundColor: Colors.black45),
    );
  }

  Widget _buildPlayPauseButton() {
    return IconButton.filled(
      onPressed: _togglePlayPause,
      icon: ValueListenableBuilder(
        valueListenable: isPlay,
        builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child:
                videoPlayerController.value.isCompleted
                    ? const Icon(
                      CupertinoIcons.arrow_counterclockwise,
                      size: 35,
                      color: kWhiteColor,
                    )
                    : bloc.seekCount != 0
                    ? const Icon(
                      CupertinoIcons.pause,
                      size: 35,
                      color: kWhiteColor,
                    )
                    : Icon(
                      videoPlayerController.value.isPlaying
                          ? CupertinoIcons.pause
                          : CupertinoIcons.play,
                      color: kWhiteColor,
                      size: 35,
                    ),
          );
        },
      ),
      style: IconButton.styleFrom(backgroundColor: Colors.black45),
    );
  }

  void _togglePlayPause() {
    if (videoPlayerController.value.isCompleted) {
      videoPlayerController.seekTo(Duration.zero).then((_) {
        videoPlayerController.play();
        isPlay.value = true;
      });
    } else {
      if (videoPlayerController.value.isPlaying) {
        videoPlayerController.pause();
        isPlay.value = false;
      } else {
        videoPlayerController.play();
        isPlay.value = true;
      }
    }
    bloc.resetControlVisibility(isSeek: true);
  }

  Widget _buildTopLeftControls() {
    return Positioned(top: 70, left: 30, child: _buildExitButton());
  }

  Widget _buildExitButton() {
    if (bloc.isFullScreen) return const SizedBox();
    return Row(
      spacing: 15,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.pop(context);
            videoPlayerController.pause();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.transparent,
            ),
            child: const Icon(
              CupertinoIcons.clear_thick,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (videoPlayerController.value.isInitialized) {
              isClickPopUp = true;
              Navigator.pop(context);
              isPlay.value = !videoPlayerController.value.isPlaying;
              showControl = false;
              bloc.updateListener();
              MiniVideoPlayer.showMiniPlayer(
                context,
                bloc.currentUrl,
                videoPlayerController.value.isPlaying
                    ? isPlay.value = true
                    : isPlay.value = false,
                widget.videoId ?? '',
              );
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
              ]);
            }
          },
          child: Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.transparent,
            ),
            child: Image.asset(
              kPictureInPictureIcon,
              width: 30,
              color: kWhiteColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopRightControls() {
    return Positioned(
      top: bloc.isFullScreen ? 40 : 70,
      right: bloc.isFullScreen ? 70 : 30,
      child: _buildSettingsButtons(),
    );
  }

  Widget _buildSettingsButtons() {
    return IgnorePointer(
      ignoring: !showControl,
      child: Row(children: [_buildSettingsButton()]),
    );
  }

  Widget buildMuteButton() {
    return GestureDetector(
      onTap: () => bloc.toggleMute(),
      child: Container(
        //margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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

  Widget _buildSettingsButton() {
    return GestureDetector(
      onTap: () {
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
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.transparent,
        ),
        child: const Icon(Icons.settings, color: Colors.white, size: 27),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Positioned(
      bottom: 40,
      left: bloc.isFullScreen ? 30 : 10,
      right: bloc.isFullScreen ? 30 : 10,
      child: _buildProgressBarContent(),
    );
  }

  Widget _buildProgressBarContent() {
    return IgnorePointer(
      ignoring: !showControl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            _buildTimeDisplay(),
            Expanded(child: _buildSlider()),
            _buildFullScreenButton(),
            SizedBox(width: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeDisplay() {
    return ValueListenableBuilder(
      valueListenable: videoPlayerController,
      builder: (context, VideoPlayerValue value, child) {
        return Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "${bloc.formatDuration(value.position)} / ${bloc.formatDuration(value.duration)}",
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
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        allowedInteraction: SliderInteraction.slideOnly,
        trackHeight: bloc.isFullScreen ? 2.0 : 3.0,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.5),
        activeTrackColor: kPrimaryColor,
        overlayColor: Colors.grey.withValues(alpha: 0.5),
        secondaryActiveTrackColor:
            bloc.isSeeking ? Colors.transparent : Colors.white,
        thumbColor: kPrimaryColor,
        trackShape: const RoundedRectSliderTrackShape(),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7.0),
      ),
      child: ValueListenableBuilder(
        valueListenable: videoPlayerController,
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
            value: !videoPlayerController.value.isInitialized ? 0.0 : progress,
            secondaryTrackValue:
                !videoPlayerController.value.isInitialized
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
                    (videoPlayerController.value.duration.inMilliseconds *
                            value)
                        .toInt(),
              );

              await videoPlayerController.seekTo(newPosition);
              bloc.isSeeking = false;
              bloc.resetControlVisibility(isSeek: true);

              if (newPosition != videoPlayerController.value.duration) {
                bloc.playPlayer();
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildFullScreenButton() {
    return GestureDetector(
      onTap: () => bloc.toggleFullScreen(),
      child: SizedBox(
        // height: bloc.isFullScreen ? 42 : 30,
        // width: bloc.isFullScreen ? 40 : 30,
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
                              CupertinoIcons.volume_mute,
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
                                  value: _volume,
                                  onChanged: (value) {
                                    setState(() {
                                      _volume = value;
                                    });
                                    videoPlayerController.setVolume(
                                      value,
                                    ); // Set the video volume
                                  },
                                  min: 0.0,
                                  max: 1.0,
                                  activeColor: kSecondaryColor,
                                  inactiveColor: Colors.grey,
                                ),
                              ),
                            ),
                            Icon(CupertinoIcons.volume_up, color: Colors.white),
                          ],
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
      await ScreenBrightness.instance.setSystemScreenBrightness(brightness);
    } catch (e) {
      debugPrint(e.toString());
      ToastService.warningToast('Failed to set system brightness');
      //throw 'Failed to set system brightness';
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
  const Player({super.key, required this.bloc});

  final VideoBloc bloc;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(
                aspectRatio: videoPlayerController.value.aspectRatio,
                child: IgnorePointer(
                  child: Chewie(controller: chewieControllerNotifier!),
                ),
              ),
            ),
          ),
          _buildHoverEffect(Alignment.centerLeft, bloc.isHoveringLeft),
          _buildHoverEffect(Alignment.centerRight, bloc.isHoveringRight),

          if (showControl) _buildOverlay(),
        ],
      ),
    );
  }

  Widget _buildHoverEffect(
    Alignment alignment,
    ValueNotifier<bool> hoveringNotifier,
  ) {
    return Align(
      alignment: alignment,
      child: ValueListenableBuilder<bool>(
        valueListenable: hoveringNotifier,
        builder: (context, hovering, child) {
          return AnimatedOpacity(
            opacity: hovering ? 0.3 : 0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: double.infinity,
              decoration: BoxDecoration(
                color:
                    bloc.isLockScreen
                        ? Colors.transparent
                        : hovering
                        ? Colors.black54
                        : Colors.transparent,
                borderRadius: _getBorderRadius(alignment, context),
              ),
            ),
          );
        },
      ),
    );
  }

  BorderRadius _getBorderRadius(Alignment alignment, BuildContext context) {
    if (alignment == Alignment.centerLeft) {
      return BorderRadius.only(
        topRight: Radius.circular(
          bloc.isFullScreen ? MediaQuery.of(context).size.width / 3 : 125,
        ),
        bottomRight: Radius.circular(
          bloc.isFullScreen ? MediaQuery.of(context).size.width / 3 : 125,
        ),
      );
    } else {
      return BorderRadius.only(
        bottomLeft: Radius.circular(
          bloc.isFullScreen ? MediaQuery.of(context).size.width / 3 : 125,
        ),
        topLeft: Radius.circular(
          bloc.isFullScreen ? MediaQuery.of(context).size.width / 3 : 125,
        ),
      );
    }
  }

  Widget _buildOverlay() {
    return Positioned.fill(child: Container(color: Colors.black45));
  }
}
