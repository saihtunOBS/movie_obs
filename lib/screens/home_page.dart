import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_obs/bloc/video_bloc.dart';
import 'package:provider/provider.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  late final VideoBloc bloc; // Declare provider outside build
  bool _wasScreenOff = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (Platform.isAndroid) {
      if (state == AppLifecycleState.resumed) {
        if (_wasScreenOff) {
          bloc.pausedPlayer();

          bloc.changeQuality(bloc.currentUrl);
        }
        _wasScreenOff = false;
      } else if (state == AppLifecycleState.paused) {
        _wasScreenOff = true;
        bloc.pausedPlayer();
      }
    } else {
      if (state == AppLifecycleState.resumed) {
        bloc.pausedPlayer();
        bloc.resetControlVisibility();
      } else {
        bloc.pausedPlayer();
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    bloc = Provider.of<VideoBloc>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.initializeVideo(bloc.m3u8Url);
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Consumer<VideoBloc>(
        builder:
            (context, value, child) => Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 70,
                  child: Text(
                    'Video Player',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                bloc.chewieControllerNotifier == null
                    ? CircularProgressIndicator()
                    : AnimatedContainer(
                      duration: Duration(milliseconds: 300),
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
                              if (bloc.userAction.value == true) return;
                              final screenWidth =
                                  MediaQuery.of(context).size.width;
                              final tapPosition = details.localPosition.dx;

                              //disable tap while user change quality

                              double tapThreshold =
                                  screenWidth *
                                  0.1; // 10% margin from the edges

                              if (tapPosition <
                                  screenWidth / 2 - tapThreshold) {
                                bloc.seekBackward();
                                bloc.isHoveringLeft.value = true;
                                bloc.isHoveringRight.value = false;
                              } else if (tapPosition >
                                  screenWidth / 2 + tapThreshold) {
                                bloc.seekForward();
                                bloc.isHoveringRight.value = true;
                                bloc.isHoveringLeft.value = false;
                              }
                              Future.delayed(Duration(milliseconds: 300), () {
                                bloc.isHoveringLeft.value = false;
                                bloc.isHoveringRight.value = false;
                              });
                            },

                            onVerticalDragStart: (details) => bloc.onVerticalDragStart(details),

                            onVerticalDragUpdate: (details) {
                              bloc.onVerticalDragUpdate(details);

                              if (bloc.isFullScreen) {
                                // Calculate new drag position
                                double newDragOffset =
                                    bloc.dragOffset + details.delta.dy;
                                double maxDragOffset = 0; // Prevent moving up
                                double minDragOffset =
                                    bloc.dragThreshold; // Allow dragging down

                                bloc.dragOffset = newDragOffset.clamp(
                                  maxDragOffset,
                                  minDragOffset,
                                );
                              }
                            },
                            onVerticalDragEnd: (details) {
                              if (bloc.isFullScreen) {
                                if (bloc.dragOffset >= bloc.dragThreshold) {
                                  bloc.toggleFullScreen(); // Exit fullscreen if dragged enough
                                } else {
                                  bloc.dragOffset =
                                      0.0; // Reset position if not dragged enough
                                }
                              } else {
                                bloc.onVerticalDragEnd(details);
                              }
                            },


                            onPanStart: (details) {
                              bloc.initialPosition =
                                  details
                                      .localPosition
                                      .dy; // Capture initial drag position
                              bloc.initialScale = bloc.scale;
                            },

                            onDoubleTap: () {
                              if (bloc.userAction.value == true) return;
                              Future.delayed(Duration(milliseconds: 100), () {
                                bloc.isHoveringRight.value = false;
                                bloc.isHoveringLeft.value = false;
                                bloc.playPlayer();
                              });
                            },
                            onTap: () {
                              bloc.resetControlVisibility();
                              if (bloc.showVolume.value == false) return;
                              bloc.showVolume.value = false;
                            },
                            child: ClipRRect(
                              child: ValueListenableBuilder(
                                valueListenable: bloc.chewieControllerNotifier!,
                                builder:
                                    (
                                      BuildContext context,
                                      ChewieController? value,
                                      Widget? child,
                                    ) => Center(
                                      child: Transform.scale(
                                        scale: bloc.scale,
                                        child: AnimatedContainer(
                                          transform: Matrix4.translationValues(
                                            0,
                                            bloc.dragOffset,
                                            0,
                                          ),
                                          duration: Duration(milliseconds: 100),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              //player
                                              Chewie(controller: value!),
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
                                                        milliseconds: 300,
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
                                                                hoveringLeft
                                                                    ? Colors
                                                                        .blue
                                                                        .withValues(
                                                                          alpha:
                                                                              0.9,
                                                                        )
                                                                    : Colors
                                                                        .transparent,
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
                                                          hoverRight ? 0.3 : 0,
                                                      duration: Duration(
                                                        milliseconds: 300,
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
                                                                hoverRight
                                                                    ? Colors
                                                                        .blue
                                                                        .withValues(
                                                                          alpha:
                                                                              0.8,
                                                                        )
                                                                    : Colors
                                                                        .transparent,
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
                              valueListenable: bloc.showControl,
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
                                          bloc.userAction.value == true,
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
                                      
                                              if (bloc
                                                  .videoPlayerController
                                                  .value
                                                  .isInitialized) {
                                                bloc.seekBackward();
                                              }
                                            },
                                            icon: Icon(
                                              CupertinoIcons
                                                  .gobackward_10,
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
                                              bloc.playPauseVideoPlayer();
                                            },
                                            icon: Icon(
                                              bloc.videoPlayerController.value.isPlaying
                                                  ? Icons.pause_circle
                                                  : Icons.play_arrow,
                                              size: 40,
                                            ),
                                          ),
                                      
                                          IconButton.filled(
                                            highlightColor: Colors.amber,
                                            onPressed: () {
                                              bloc.resetControlVisibility(
                                                isSeek: true,
                                              );
                                              // Ensure the video is initialized before seeking
                                              if (bloc
                                                  .videoPlayerController
                                                  .value
                                                  .isInitialized) {
                                                bloc.seekForward();
                                              }
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

                          //volume view
                          ValueListenableBuilder(
                            valueListenable: bloc.showVolume,
                            builder:
                                (context, value, child) => Positioned(
                                  right: 10,
                                  child: Visibility(
                                    visible: value == true ? true : false,
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.blue,
                                            ),
                                          ),
                                          child: Icon(
                                            bloc.volume == 0.0
                                                ? CupertinoIcons.volume_off
                                                : bloc.volume > 0.0 &&
                                                    bloc.volume <= 0.5
                                                ? CupertinoIcons.volume_down
                                                : bloc.volume == 1.0
                                                ? CupertinoIcons.volume_up
                                                : CupertinoIcons
                                                    .volume_down, // Icon to show volume control
                                            size: 20,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              bloc.isFullScreen
                                                  ? MediaQuery.sizeOf(
                                                        context,
                                                      ).height /
                                                      1.5
                                                  : 170,
                                          child: RotatedBox(
                                            quarterTurns:
                                                3, // Rotate the slider by 90 degrees (clockwise)
                                            child: SliderTheme(
                                              data: SliderTheme.of(
                                                context,
                                              ).copyWith(
                                                trackHeight:
                                                    2.0, // Set the thickness of the slider's track
                                                thumbShape:
                                                    RoundSliderThumbShape(
                                                      enabledThumbRadius: 7,
                                                    ),
                                              ),
                                              child: Slider(
                                                value: bloc.volume,
                                                min: 0.0,
                                                max: 1.0,

                                                divisions:
                                                    10, // Optional: Divides the slider into intervals
                                                onChanged: (newVolume) {
                                                  bloc.showControl.value =
                                                      false;
                                                  setState(() {
                                                    bloc.volume = newVolume;
                                                    bloc.videoPlayerController
                                                        .setVolume(newVolume);
                                                  });
                                                },
                                                onChangeEnd: (value) {
                                                  bloc.resetControlVisibility();
                                                  bloc.showVolume.value = false;
                                                },
                                                activeColor:
                                                    Colors
                                                        .blue, // Color of the active part of the slider
                                                inactiveColor:
                                                    Colors
                                                        .grey, // Color of the inactive part of the slider
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          ),

                          ///full screen view
                          ValueListenableBuilder(
                            valueListenable: bloc.showControl,
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
                                        child: InkWell(
                                          onTap: () => bloc.toggleFullScreen(),
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 5,
                                              vertical: 5,
                                            ),
                                            height: bloc.isFullScreen ? 42 : 30,
                                            width: bloc.isFullScreen ? 50 : 46,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: const Color.fromARGB(
                                                255,
                                                51,
                                                51,
                                                51,
                                              ).withValues(alpha: 0.5),
                                            ),
                                            child: Icon(
                                              Icons.fullscreen,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          ),

                          ///setting view
                          ValueListenableBuilder(
                            valueListenable: bloc.showControl,
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
                                                bloc.showVolume.value = true;
                                              },
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 5,
                                                  vertical: 5,
                                                ),
                                                height:
                                                    bloc.isFullScreen ? 42 : 30,
                                                width:
                                                    bloc.isFullScreen ? 50 : 46,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: const Color.fromARGB(
                                                    255,
                                                    51,
                                                    51,
                                                    51,
                                                  ).withValues(alpha: 0.5),
                                                ),
                                                child: Icon(
                                                  bloc.volume == 0.0
                                                      ? CupertinoIcons
                                                          .volume_off
                                                      : bloc.volume > 0.0 &&
                                                          bloc.volume <= 0.5
                                                      ? CupertinoIcons
                                                          .volume_down
                                                      : bloc.volume == 1.0
                                                      ? CupertinoIcons.volume_up
                                                      : CupertinoIcons
                                                          .volume_down,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),

                                            //setting
                                            InkWell(
                                              onTap:
                                                  () => showModalBottomSheet(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    context: context,
                                                    builder: (_) {
                                                      return _qualityModalSheet();
                                                    },
                                                  ),
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 5,
                                                  vertical: 5,
                                                ),
                                                height:
                                                    bloc.isFullScreen ? 42 : 30,
                                                width:
                                                    bloc.isFullScreen ? 50 : 46,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
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
                            valueListenable: bloc.showControl,
                            builder:
                                (
                                  BuildContext context,
                                  bool value,
                                  Widget? child,
                                ) => Positioned(
                                  bottom: bloc.isFullScreen ? 10 : 0,
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
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ValueListenableBuilder(
                                                valueListenable:
                                                    bloc.videoPlayerController,
                                                builder:
                                                    (
                                                      BuildContext context,
                                                      VideoPlayerValue value,
                                                      Widget? child,
                                                    ) => SizedBox(
                                                      width: 78,
                                                      child: Text(
                                                        "${bloc.formatDuration(value.position)} / ${bloc.formatDuration(value.duration)}",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                        ),
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
                                                        .withValues(alpha: 0.5),
                                                    secondaryActiveTrackColor:
                                                        Colors.white,
                                                    thumbColor: Colors.red,

                                                    thumbShape:
                                                        RoundSliderThumbShape(
                                                          enabledThumbRadius:
                                                              6.0,
                                                        ),
                                                  ),
                                                  child: ValueListenableBuilder(
                                                    valueListenable:
                                                        bloc.videoPlayerController,
                                                    builder: (
                                                      BuildContext context,
                                                      VideoPlayerValue value,
                                                      Widget? child,
                                                    ) {
                                                      final duration =
                                                          value.duration;
                                                      final position =
                                                          value.position;

                                                      double progress = 0.0;
                                                      if (duration.inMilliseconds >
                                                              0 &&
                                                          !bloc.isSeeking) {
                                                        progress =
                                                            position
                                                                .inMilliseconds /
                                                            duration
                                                                .inMilliseconds;
                                                        progress =
                                                            progress.isNaN ||
                                                                    progress <
                                                                        0.0
                                                                ? 0.0
                                                                : (progress >
                                                                        1.0
                                                                    ? 1.0
                                                                    : progress);
                                                      } else {
                                                        progress =
                                                            bloc.manualSeekProgress;
                                                      }

                                                      double bufferedProgress =
                                                          0.0;

                                                      // Enable buffering only when the video is playing
                                                      if (value
                                                          .buffered
                                                          .isNotEmpty) {
                                                        final double
                                                        newBufferedProgress =
                                                            value
                                                                .buffered
                                                                .last
                                                                .end
                                                                .inMilliseconds /
                                                            duration
                                                                .inMilliseconds;

                                                        // Ensure the buffer progress stays within 0.0 - 1.0 range
                                                        bufferedProgress =
                                                            newBufferedProgress
                                                                .clamp(
                                                                  0.0,
                                                                  1.0,
                                                                );
                                                      }

                                                      return Slider(
                                                        value: progress,
                                                        secondaryTrackValue:
                                                            max(
                                                              progress,
                                                              bufferedProgress,
                                                            ),
                                                        onChanged: (
                                                          newValue,
                                                        ) async {
                                                          bloc.resetControlVisibility();
                                                          bloc.isSeeking = true;
                                                          bloc.manualSeekProgress =
                                                              newValue;
                                                          bloc.throttleSliderUpdate();
                                                        },
                                                        onChangeStart: (value) {
                                                          bloc.pausedPlayer();
                                                          bloc.startSeekUpdateLoop();
                                                          bloc.resetControlVisibility();
                                                        },
                                                        onChangeEnd: (
                                                          value,
                                                        ) async {
                                                          bloc.updateUserAction(
                                                            true,
                                                          );
                                                          bloc.seekUpdateTimer
                                                              ?.cancel(); // Stop the update loop

                                                          final newPosition = Duration(
                                                            milliseconds:
                                                                (duration.inMilliseconds *
                                                                        value)
                                                                    .toInt(),
                                                          );
                                                          await bloc
                                                              .videoPlayerController
                                                              .seekTo(
                                                                newPosition,
                                                              );

                                                          bloc.playPlayer();
                                                          bloc.updateUserAction(
                                                            false,
                                                          );
                                                          bloc.isSeeking =
                                                              false;

                                                          bloc.resetControlVisibility();
                                                        },
                                                      );
                                                    },
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
                          ),
                        ],
                      ),
                    ),
              ],
            ),
      ),
    );
  }

  Widget _qualityModalSheet() {
    return Consumer<VideoBloc>(
      builder:
          (context, bloc, child) => Container(
            margin: EdgeInsets.only(bottom: 40, left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: null,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Choose Quality',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
    );
  }
}
