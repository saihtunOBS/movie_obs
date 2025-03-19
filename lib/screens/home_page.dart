// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_obs/bloc/video_bloc.dart';
import 'package:movie_obs/screens/popup_video_player.dart';
import 'package:provider/provider.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

final ValueNotifier<bool> isPlay = ValueNotifier(false);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

double previousBufferedProgress = 0.0;
double progress = 0.0;
Orientation? _lastOrientation;

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late final VideoBloc bloc;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      bloc.resetControlVisibility(isSeek: true);
    }
    if (state == AppLifecycleState.paused) {
      videoPlayerController.pause();
    }
    super.didChangeAppLifecycleState(state);
  }

  void _checkOrientation() {
    final Size screenSize =
        WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
    final Orientation newOrientation =
        screenSize.width > screenSize.height
            ? Orientation.landscape
            : Orientation.portrait;

    // ✅ Prevent re-triggering fullscreen if already in fullscreen due to rotation
    if (_lastOrientation == newOrientation) return; // No change, return early

    _lastOrientation = newOrientation;

    // ✅ Prevent auto-switching when already in fullscreen mode
    if (bloc.isFullScreen && newOrientation == Orientation.landscape) return;
    bloc.isFullScreen = _lastOrientation == Orientation.landscape;
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _checkOrientation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (chewieControllerNotifier?.value == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        bloc.initializeVideo(bloc.m3u8Url);
      });
    }
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([]);

    WidgetsBinding.instance.addObserver(this);
    bloc = Provider.of<VideoBloc>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.resetControlVisibility();
      MiniVideoPlayer.removeMiniPlayer();
      isPlay.value = true;
    });
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoBloc>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body:
              chewieControllerNotifier == null &&
                      !videoPlayerController.value.isInitialized
                  ? Container(
                    margin: EdgeInsets.only(top: 100),
                    height: 230,
                    width: double.infinity,
                    color: Colors.black,
                    child: Center(
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.amber,
                      ),
                    ),
                  )
                  : Column(
                    children: [
                      Visibility(
                        visible: !bloc.isFullScreen,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: bloc.isFullScreen ? 0 : 60,
                            bottom: 10,
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  videoPlayerController.pause();
                                  videoPlayerController.seekTo(Duration.zero);
                                },
                                icon: Icon(CupertinoIcons.chevron_back),
                              ),
                              Text(
                                'ZLan Video Player',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        height:
                            bloc.isFullScreen == true
                                ? MediaQuery.of(context).size.height
                                : 230,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onDoubleTapDown: (details) {
                                if (!videoPlayerController
                                    .value
                                    .isInitialized) {
                                  return;
                                }
                                final screenWidth =
                                    MediaQuery.of(context).size.width;
                                final tapPosition = details.localPosition.dx;

                                double tapThreshold =
                                    screenWidth *
                                    0.1; // 10% margin from the edges

                                if (tapPosition <
                                    screenWidth / 2 - tapThreshold) {
                                  bloc.seekBackward(isDoubleTag: true);
                                  bloc.isHoveringLeft.value = true;
                                  bloc.isHoveringRight.value = false;
                                  isPlay.value = false;
                                } else if (tapPosition >
                                    screenWidth / 2 + tapThreshold) {
                                  bloc.seekForward(isDoubleTag: true);
                                  bloc.isHoveringRight.value = true;
                                  bloc.isHoveringLeft.value = false;
                                  isPlay.value = false;
                                }
                                Future.delayed(Duration(milliseconds: 300), () {
                                  bloc.isHoveringLeft.value = false;
                                  bloc.isHoveringRight.value = false;
                                });
                              },

                              onVerticalDragStart:
                                  (details) =>
                                      bloc.onVerticalDragStart(details),

                              onVerticalDragUpdate: (details) {
                                if (bloc.isLockScreen == true) return;
                                if (bloc.isFullScreen) {
                                  double newDragOffset =
                                      bloc.dragOffset + details.delta.dy;
                                  double maxDragOffset = 0;
                                  double minDragOffset = bloc.dragThreshold;

                                  bloc.dragOffset = newDragOffset.clamp(
                                    maxDragOffset,
                                    minDragOffset,
                                  );

                                  if (bloc.dragOffset == 0.0 ||
                                      bloc.dragOffset < 10) {
                                  } else {
                                    bloc.onVerticalDragUpdateFullScreen(
                                      details,
                                    );
                                  }
                                } else {
                                  bloc.onVerticalDragUpdate(details);
                                }
                              },
                              onVerticalDragEnd: (details) {
                                if (bloc.isLockScreen == true) return;
                                if (bloc.isFullScreen) {
                                  if (bloc.dragOffset >= bloc.dragThreshold) {
                                    bloc.toggleFullScreen(); // Exit fullscreen if dragged enough
                                  } else {
                                    bloc.scale = 1.0;
                                    bloc.dragOffset =
                                        0.0; // Reset position if not dragged enough
                                    bloc.updateListener();
                                  }
                                } else {
                                  bloc.onVerticalDragEnd(details);
                                }
                              },

                              onPanStart: (details) {
                                if (bloc.isLockScreen == true) return;

                                bloc.initialPosition =
                                    details
                                        .localPosition
                                        .dy; // Capture initial drag position
                                bloc.initialScale = bloc.scale;
                              },

                              onDoubleTap: () {
                                if (!videoPlayerController
                                    .value
                                    .isInitialized) {
                                  return;
                                }
                                Future.delayed(Duration(milliseconds: 100), () {
                                  bloc.isHoveringRight.value = false;
                                  bloc.isHoveringLeft.value = false;
                                });
                              },
                              onTap: () {
                                if (showMiniControl) return;
                                bloc.resetControlVisibility();
                                bloc.showVolume.value = false;
                              },
                              child:
                                  bloc.isLoading
                                      ? Center(
                                        child:
                                            CircularProgressIndicator.adaptive(
                                              backgroundColor: Colors.amber,
                                            ),
                                      )
                                      : ClipRRect(
                                        child: ValueListenableBuilder(
                                          valueListenable:
                                              chewieControllerNotifier!,
                                          builder:
                                              (
                                                BuildContext context,
                                                ChewieController? value,
                                                Widget? child,
                                              ) => Center(
                                                child: Transform.scale(
                                                  scale: bloc.scale,
                                                  child: AnimatedContainer(
                                                    transform:
                                                        Matrix4.translationValues(
                                                          0,
                                                          bloc.dragOffset,
                                                          0,
                                                        ),
                                                    duration: Duration(
                                                      milliseconds: 100,
                                                    ),
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        //player
                                                        Chewie(
                                                          controller: value!,
                                                        ),
                                                        //hover left
                                                        Positioned(
                                                          child: ValueListenableBuilder<
                                                            bool
                                                          >(
                                                            valueListenable:
                                                                bloc.isHoveringLeft,
                                                            builder: (
                                                              context,
                                                              hoveringLeft,
                                                              child,
                                                            ) {
                                                              return AnimatedOpacity(
                                                                opacity:
                                                                    hoveringLeft
                                                                        ? 0.3
                                                                        : 0,
                                                                duration: Duration(
                                                                  milliseconds:
                                                                      300,
                                                                ),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Container(
                                                                    width:
                                                                        MediaQuery.sizeOf(
                                                                          context,
                                                                        ).width *
                                                                        0.3,

                                                                    decoration: BoxDecoration(
                                                                      color:
                                                                          bloc.isLockScreen ==
                                                                                  true
                                                                              ? Colors.transparent
                                                                              : hoveringLeft
                                                                              ? Colors.blue.withValues(
                                                                                alpha:
                                                                                    0.9,
                                                                              )
                                                                              : Colors.transparent,
                                                                      borderRadius: BorderRadius.only(
                                                                        topRight: Radius.circular(
                                                                          bloc.isFullScreen
                                                                              ? MediaQuery.sizeOf(
                                                                                    context,
                                                                                  ).width /
                                                                                  3
                                                                              : 125,
                                                                        ),
                                                                        bottomRight: Radius.circular(
                                                                          bloc.isFullScreen
                                                                              ? MediaQuery.sizeOf(
                                                                                    context,
                                                                                  ).width /
                                                                                  3
                                                                              : 125,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        //hover right
                                                        Positioned(
                                                          child: ValueListenableBuilder<
                                                            bool
                                                          >(
                                                            valueListenable:
                                                                bloc.isHoveringRight,
                                                            builder: (
                                                              context,
                                                              hoverRight,
                                                              child,
                                                            ) {
                                                              return AnimatedOpacity(
                                                                opacity:
                                                                    hoverRight
                                                                        ? 0.3
                                                                        : 0,
                                                                duration: Duration(
                                                                  milliseconds:
                                                                      300,
                                                                ),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child: Container(
                                                                    width:
                                                                        MediaQuery.sizeOf(
                                                                          context,
                                                                        ).width *
                                                                        0.3,

                                                                    decoration: BoxDecoration(
                                                                      color:
                                                                          bloc.isLockScreen ==
                                                                                  true
                                                                              ? Colors.transparent
                                                                              : hoverRight
                                                                              ? Colors.blue.withValues(
                                                                                alpha:
                                                                                    0.8,
                                                                              )
                                                                              : Colors.transparent,
                                                                      borderRadius: BorderRadius.only(
                                                                        bottomLeft: Radius.circular(
                                                                          bloc.isFullScreen
                                                                              ? MediaQuery.sizeOf(
                                                                                    context,
                                                                                  ).width /
                                                                                  3
                                                                              : 125,
                                                                        ),
                                                                        topLeft: Radius.circular(
                                                                          bloc.isFullScreen
                                                                              ? MediaQuery.sizeOf(
                                                                                    context,
                                                                                  ).width /
                                                                                  3
                                                                              : 125,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        ),
                                      ),
                            ),

                            ///play pause view
                            AnimatedOpacity(
                              duration: Duration(milliseconds: 200),
                              opacity: bloc.toggleCount == 0 ? 1 : 0,
                              child: ValueListenableBuilder(
                                valueListenable: showControl,
                                builder:
                                    (
                                      BuildContext context,
                                      bool value,
                                      Widget? child,
                                    ) => AnimatedOpacity(
                                      duration: Duration(milliseconds: 300),
                                      opacity: value ? 1 : 0,
                                      child: IgnorePointer(
                                        ignoring:
                                            !value ||
                                            !videoPlayerController
                                                    .value
                                                    .isInitialized ==
                                                true,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          spacing: 12,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // Seek Backward Button
                                            IconButton.filled(
                                              highlightColor: Colors.amber,
                                              onPressed: () {
                                                bloc.resetControlVisibility(
                                                  isSeek: true,
                                                );

                                                if (videoPlayerController
                                                    .value
                                                    .isInitialized) {
                                                  bloc.seekBackward();
                                                }
                                                isPlay.value = false;
                                              },
                                              icon: Icon(
                                                CupertinoIcons.gobackward_10,
                                              ),
                                              style: IconButton.styleFrom(
                                                backgroundColor:
                                                    Colors
                                                        .grey, // Change the background color
                                              ),
                                            ),

                                            // Play/Pause Button
                                            IconButton.filled(
                                              onPressed: () {
                                                if (!videoPlayerController
                                                    .value
                                                    .isInitialized) {
                                                  return;
                                                } else {
                                                  if (videoPlayerController
                                                      .value
                                                      .isCompleted) {
                                                    // If the video is completed, restart from the beginning
                                                    videoPlayerController
                                                        .seekTo(Duration.zero)
                                                        .then((_) {
                                                          videoPlayerController
                                                              .play();
                                                          isPlay.value = true;
                                                        });
                                                  } else {
                                                    if (videoPlayerController
                                                        .value
                                                        .isPlaying) {
                                                      videoPlayerController
                                                          .pause();
                                                      isPlay.value = false;
                                                    } else {
                                                      videoPlayerController
                                                          .play();
                                                      isPlay.value = true;
                                                    }
                                                  }

                                                  bloc.resetControlVisibility(
                                                    isSeek: true,
                                                  );
                                                }
                                              },
                                              icon: ValueListenableBuilder(
                                                valueListenable: isPlay,
                                                builder: (
                                                  context,
                                                  value,
                                                  child,
                                                ) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          5.0,
                                                        ),
                                                    child:
                                                        videoPlayerController
                                                                .value
                                                                .isCompleted
                                                            ? Icon(
                                                              CupertinoIcons
                                                                  .arrow_counterclockwise,
                                                            )
                                                            : bloc.seekCount !=
                                                                0
                                                            ? Icon(
                                                              CupertinoIcons
                                                                  .pause,
                                                              size: 30,
                                                            )
                                                            : Icon(
                                                              videoPlayerController
                                                                      .value
                                                                      .isPlaying
                                                                  ? CupertinoIcons
                                                                      .pause
                                                                  : CupertinoIcons
                                                                      .play,
                                                              size: 30,
                                                            ),
                                                  );
                                                },
                                              ),
                                            ),

                                            IconButton.filled(
                                              highlightColor: Colors.amber,
                                              onPressed: () {
                                                bloc.resetControlVisibility(
                                                  isSeek: true,
                                                );
                                                // Ensure the video is initialized before seeking
                                                if (videoPlayerController
                                                    .value
                                                    .isInitialized) {
                                                  bloc.seekForward();
                                                }
                                                isPlay.value = false;
                                              },
                                              icon: Icon(
                                                CupertinoIcons.goforward_10,
                                              ),
                                              style: IconButton.styleFrom(
                                                backgroundColor:
                                                    Colors
                                                        .grey, // Change the background color
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              ),
                            ),

                            ///full screen view
                            ValueListenableBuilder(
                              valueListenable: showControl,
                              builder:
                                  (
                                    BuildContext context,
                                    bool value,
                                    Widget? child,
                                  ) => Positioned(
                                    top: bloc.isFullScreen ? 20 : 10,
                                    left: bloc.isFullScreen ? 20 : 10,
                                    child: AnimatedOpacity(
                                      duration: Duration.zero,
                                      opacity: bloc.toggleCount == 0 ? 1 : 0,
                                      child: AnimatedOpacity(
                                        duration: Duration(milliseconds: 300),
                                        alwaysIncludeSemantics: true,
                                        opacity: value ? 1 : 0,
                                        child: IgnorePointer(
                                          ignoring: !value,
                                          child: Row(
                                            children: [
                                              if (!bloc.isFullScreen)
                                                InkWell(
                                                  onTap: () {
                                                    showMiniControl = true;
                                                    if (!videoPlayerController
                                                        .value
                                                        .isPlaying) {
                                                      showVisibleMiniControl
                                                          .value = true;
                                                    }
                                                    videoPlayerController
                                                            .value
                                                            .isPlaying
                                                        ? isPlay.value = false
                                                        : isPlay.value = true;

                                                    showControl.value = false;
                                                    bloc.updateListener();
                                                    Navigator.pop(context);
                                                    MiniVideoPlayer.showMiniPlayer(
                                                      context,
                                                      bloc.currentUrl,
                                                      isPlay.value,
                                                    );
                                                  },
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 5,
                                                          vertical: 5,
                                                        ),
                                                    height: 30,
                                                    width: 35,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            5,
                                                          ),
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            51,
                                                            51,
                                                            51,
                                                          ).withValues(
                                                            alpha: 0.5,
                                                          ),
                                                    ),
                                                    child: Icon(
                                                      CupertinoIcons
                                                          .chevron_down,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            ),

                            ///setting view
                            ValueListenableBuilder(
                              valueListenable: showControl,
                              builder:
                                  (
                                    BuildContext context,
                                    bool value,
                                    Widget? child,
                                  ) => Positioned(
                                    top: bloc.isFullScreen ? 20 : 10,
                                    right: bloc.isFullScreen ? 20 : 10,
                                    child: AnimatedOpacity(
                                      duration: Duration.zero,
                                      opacity: bloc.toggleCount == 0 ? 1 : 0,
                                      child: AnimatedOpacity(
                                        duration: Duration(milliseconds: 300),
                                        alwaysIncludeSemantics: true,
                                        opacity: value ? 1 : 0,
                                        child: IgnorePointer(
                                          ignoring: !value,
                                          child: Row(
                                            children: [
                                              //mute
                                              InkWell(
                                                onTap: () {
                                                  bloc.toggleMute();
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                    vertical: 5,
                                                  ),
                                                  height:
                                                      bloc.isFullScreen
                                                          ? 42
                                                          : 30,
                                                  width:
                                                      bloc.isFullScreen
                                                          ? 50
                                                          : 46,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          5,
                                                        ),
                                                    color: const Color.fromARGB(
                                                      255,
                                                      51,
                                                      51,
                                                      51,
                                                    ).withValues(alpha: 0.5),
                                                  ),
                                                  child: Icon(
                                                    !bloc.isMuted
                                                        ? CupertinoIcons
                                                            .speaker_3_fill
                                                        : CupertinoIcons
                                                            .speaker_slash,

                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),

                                              //setting
                                              InkWell(
                                                onTap: () {
                                                  showControl.value = false;
                                                  showModalBottomSheet(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    context: context,

                                                    builder: (_) {
                                                      return _buildAdditionalOptions();
                                                    },
                                                  ).whenComplete(() async {
                                                    if (bloc.isQualityClick ==
                                                        0) {
                                                      return;
                                                    }
                                                    Future.delayed(
                                                      Duration(
                                                        milliseconds: 400,
                                                      ),
                                                      () async => await showModalBottomSheet(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        context: context,
                                                        builder: (builder) {
                                                          return bloc.isQualityClick ==
                                                                  1
                                                              ? _qualityModalSheet()
                                                              : _buildPlaybackModalSheet(); // Your second modal content
                                                        },
                                                      ).whenComplete(
                                                        () =>
                                                            bloc.isQualityClick =
                                                                0,
                                                      ),
                                                    );
                                                  });
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                    vertical: 5,
                                                  ),
                                                  height:
                                                      bloc.isFullScreen
                                                          ? 42
                                                          : 30,
                                                  width:
                                                      bloc.isFullScreen
                                                          ? 50
                                                          : 46,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          5,
                                                        ),
                                                    color: const Color.fromARGB(
                                                      255,
                                                      51,
                                                      51,
                                                      51,
                                                    ).withValues(alpha: 0.5),
                                                  ),
                                                  child: Icon(
                                                    Icons.settings,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            ),

                            ///slider
                            ValueListenableBuilder(
                              valueListenable: showControl,
                              builder:
                                  (
                                    BuildContext context,
                                    bool value,
                                    Widget? child,
                                  ) => Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: AnimatedOpacity(
                                      duration: Duration.zero,
                                      opacity: bloc.toggleCount == 0 ? 1 : 0,
                                      child: AnimatedOpacity(
                                        duration: Duration(milliseconds: 300),
                                        alwaysIncludeSemantics: true,
                                        opacity: value ? 1 : 0,
                                        child: IgnorePointer(
                                          ignoring: !value,
                                          child: Container(
                                            padding: EdgeInsets.only(left: 16),
                                            margin: EdgeInsets.all(14),
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width -
                                                20,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                255,
                                                51,
                                                51,
                                                51,
                                              ).withValues(alpha: 0.5),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ValueListenableBuilder(
                                                  valueListenable:
                                                      videoPlayerController,
                                                  builder:
                                                      (
                                                        BuildContext context,
                                                        VideoPlayerValue value,
                                                        Widget? child,
                                                      ) => Text(
                                                        "${bloc.formatDuration(value.position)} / ${bloc.formatDuration(value.duration)}",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                ),

                                                Expanded(
                                                  child: SliderTheme(
                                                    data: SliderTheme.of(
                                                      context,
                                                    ).copyWith(
                                                      trackHeight: 3.0,
                                                      inactiveTrackColor: Colors
                                                          .white
                                                          .withValues(
                                                            alpha: 0.5,
                                                          ), // Default track
                                                      activeTrackColor:
                                                          Colors.red,
                                                      overlayColor: Colors.grey
                                                          .withValues(
                                                            alpha: 0.5,
                                                          ),
                                                      secondaryActiveTrackColor:
                                                          bloc.isSeeking
                                                              ? Colors
                                                                  .transparent
                                                              : Colors.white,
                                                      thumbColor: Colors.red,

                                                      thumbShape:
                                                          RoundSliderThumbShape(
                                                            enabledThumbRadius:
                                                                6.0,
                                                          ),
                                                    ),
                                                    child: ValueListenableBuilder(
                                                      valueListenable:
                                                          videoPlayerController,
                                                      builder: (
                                                        BuildContext context,
                                                        VideoPlayerValue value,
                                                        Widget? child,
                                                      ) {
                                                        final duration =
                                                            value.duration;

                                                        final position =
                                                            value.position;

                                                        if (videoPlayerController
                                                            .value
                                                            .isInitialized) {
                                                          if (duration.inMilliseconds >
                                                                  0 &&
                                                              !bloc.isSeeking) {
                                                            progress = (position
                                                                        .inMilliseconds /
                                                                    duration
                                                                        .inMilliseconds)
                                                                .clamp(
                                                                  0.0,
                                                                  1.0,
                                                                );
                                                          } else {
                                                            // Use manual progress while dragging
                                                            progress =
                                                                bloc.manualSeekProgress;
                                                          }
                                                          // Current buffered progress
                                                          double
                                                          newBufferedProgress =
                                                              value
                                                                      .buffered
                                                                      .isNotEmpty
                                                                  ? (value
                                                                              .buffered
                                                                              .last
                                                                              .end
                                                                              .inMilliseconds /
                                                                          duration
                                                                              .inMilliseconds)
                                                                      .clamp(
                                                                        0.0,
                                                                        1.0,
                                                                      )
                                                                  : 0.0;

                                                          // If the video restarted, reset buffer progress
                                                          if (previousBufferedProgress >
                                                              newBufferedProgress) {
                                                            previousBufferedProgress =
                                                                0.0;
                                                          } else {
                                                            // Smooth interpolation
                                                            previousBufferedProgress =
                                                                previousBufferedProgress +
                                                                (newBufferedProgress -
                                                                        previousBufferedProgress) *
                                                                    0.1;
                                                          }
                                                        }

                                                        return Slider(
                                                          value: progress,
                                                          secondaryTrackValue: max(
                                                            progress,
                                                            previousBufferedProgress,
                                                          ),

                                                          onChanged: (
                                                            newValue,
                                                          ) async {
                                                            bloc.resetControlVisibility();
                                                            bloc.isSeeking =
                                                                true;
                                                            bloc.manualSeekProgress =
                                                                newValue;
                                                            previousBufferedProgress =
                                                                newValue;
                                                            bloc.throttleSliderUpdate();
                                                          },
                                                          onChangeStart: (
                                                            value,
                                                          ) {
                                                            bloc.pausedPlayer();
                                                            bloc.startSeekUpdateLoop();
                                                            bloc.resetControlVisibility();
                                                          },
                                                          onChangeEnd: (
                                                            value,
                                                          ) async {
                                                            setState(() {
                                                              isPlay.value =
                                                                  false;
                                                            });
                                                            bloc.seekUpdateTimer
                                                                ?.cancel(); // Stop the update loop

                                                            final newPosition = Duration(
                                                              milliseconds:
                                                                  (duration.inMilliseconds *
                                                                          value)
                                                                      .toInt(),
                                                            );
                                                            await videoPlayerController
                                                                .seekTo(
                                                                  newPosition,
                                                                );

                                                            bloc.playPlayer();

                                                            bloc.isSeeking =
                                                                false;

                                                            bloc.resetControlVisibility();
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap:
                                                      () =>
                                                          bloc.toggleFullScreen(),
                                                  child: Icon(
                                                    Icons.fullscreen,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
        );
      },
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
                  InkWell(
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
                  InkWell(
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
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildAdditionalRow(String title, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 13,
          children: [
            Icon(icon, size: 20, color: Colors.white),

            Text(title, style: TextStyle(fontSize: 15, color: Colors.white)),
          ],
        ),
        Text(value, style: TextStyle(fontSize: 14, color: Colors.grey)),
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
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                if (selectedQuality == 'Auto') return;
                                bloc.changeQuality(bloc.m3u8Url, 'Auto');
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
                                    'Auto (recommanded)',
                                    style: TextStyle(
                                      fontSize: 15,
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
                        child: InkWell(
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
                                    fontSize: 15,
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
                              (value) => InkWell(
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
