import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:http/http.dart' as http;
import 'package:wakelock_plus/wakelock_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

String selectedQuality = 'Auto';
final ValueNotifier<bool> showControl = ValueNotifier(true);
final ValueNotifier<bool> loadingOverlay = ValueNotifier(false);
late VideoPlayerController _videoPlayerController;
ValueNotifier<ChewieController>? _chewieControllerNotifier;

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool _wasScreenOff = false;
  bool isMuted = false; // Track mute/unmute state

  bool _isFullScreen = false;
  bool hasPrinted = false;
  Timer? _hideControlTimer;
  double _manualSeekProgress = 0.0;
  bool _isSeeking = false;
  Timer? _seekUpdateTimer;

  // double _lastBufferedProgress = 0.0;
  bool isLoading = false;
  List<Map<String, String>> qualityOptions = [];
  String m3u8Url =
      'https://moviedatatesting.s3.ap-southeast-1.amazonaws.com/Mvoie+1/master.m3u8';
  String currentUrl =
      'https://moviedatatesting.s3.ap-southeast-1.amazonaws.com/Mvoie+1/master.m3u8';

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_wasScreenOff) {
        setState(() {
          _videoPlayerController.pause();
        });

        _changeQuality(currentUrl);
      }
      _wasScreenOff = false;
    } else if (state == AppLifecycleState.paused) {
      _wasScreenOff = true;
      _videoPlayerController.pause();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _initializeVideo(m3u8Url);
    super.initState();
  }
  //https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8
  //https://moviedatatesting.s3.ap-southeast-1.amazonaws.com/Mvoie+1/master.m3u8

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

  /// Initialize video player
  void _initializeVideo(String url) {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions: VideoPlayerOptions(
        allowBackgroundPlayback: true,
        mixWithOthers: true,
      ),
    );
    _videoPlayerController.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _chewieControllerNotifier = ValueNotifier(
          ChewieController(
            videoPlayerController: _videoPlayerController,
            showControls: false,
            allowedScreenSleep: false,
            autoInitialize: true,
          ),
        );
        _fetchQualityOptions();
      });

      _videoPlayerController.addListener(() {
        if (_videoPlayerController.value.isPlaying == true) {
          WakelockPlus.enable();
          if (!hasPrinted) {
            hasPrinted = true;
            _resetControlVisibility();
          }
        } else {
          WakelockPlus.disable();
          setState(() {
            hasPrinted = false;
            showControl.value = true;
          });
        }
      });
    });
  }

  ///
  void _resetControlVisibility() {
    showControl.value = true;

    // Cancel the previous timer before creating a new one
    _hideControlTimer?.cancel();
    _hideControlTimer = Timer(const Duration(seconds: 3), () {
      if (_videoPlayerController.value.isPlaying == true) {
        showControl.value = false;
      } else {
        showControl.value = true;
      }
    });
  }

  //quality change
  void _changeQuality(String url, [String? quality]) async {
    selectedQuality = quality ?? selectedQuality; // Update selected quality
    currentUrl = url;
    final currentPosition = _videoPlayerController.value.position;
    final wasPlaying = _videoPlayerController.value.isPlaying;

    // Instead of disposing, update the data source
    await _videoPlayerController.dispose();

    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));

    await _videoPlayerController.initialize();
    _videoPlayerController.seekTo(currentPosition).whenComplete(() {
      if (wasPlaying) {
        _videoPlayerController.play();
      } else {
        _videoPlayerController.pause();
      }
    }); // Restore position

    _chewieControllerNotifier?.value = ChewieController(
      videoPlayerController: _videoPlayerController,
      showControls: false,
      allowedScreenSleep: false,
    );
    _videoPlayerController.setVolume(isMuted ? 0.0 : 1.0);
    _resetControlVisibility();
  }

  //toggle full screen
  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });

    if (_isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    _resetControlVisibility();
  }

  // Function to toggle mute/unmute
  void _toggleMute() {
    setState(() {
      isMuted = !isMuted;
      _videoPlayerController.setVolume(isMuted ? 0.0 : 1.0);
    });
    _resetControlVisibility();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _videoPlayerController.dispose();
    _chewieControllerNotifier?.value.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _hideControlTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isFullScreen ? Colors.black : Colors.white,
      appBar:
          _isFullScreen == true
              ? null
              : AppBar(title: const Text("Video Player")),
      body: Center(
        child:
            _chewieControllerNotifier == null
                ? CircularProgressIndicator()
                : Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      color: Colors.black,
                      height:
                          _isFullScreen == true
                              ? MediaQuery.of(context).size.height - 40
                              : 250,
                      width:
                          _isFullScreen == true
                              ? MediaQuery.of(context).size.width - 20
                              : MediaQuery.of(context).size.width,
                      child: InkWell(
                        onTap: () {
                          _resetControlVisibility();
                        },
                        child: ValueListenableBuilder(
                          valueListenable: _chewieControllerNotifier!,
                          builder:
                              (
                                BuildContext context,
                                ChewieController? value,
                                Widget? child,
                              ) => Chewie(controller: value!),
                        ),
                      ),
                    ),

                    ///play pause view
                    ValueListenableBuilder(
                      valueListenable: showControl,
                      builder:
                          (
                            BuildContext context,
                            bool value,
                            Widget? child,
                          ) => AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            alwaysIncludeSemantics: true,
                            opacity: value ? 1 : 0,
                            child: IgnorePointer(
                              ignoring: !value,
                              child: Row(
                                spacing: 5,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Seek Backward Button
                                  IconButton.filled(
                                    highlightColor: Colors.amber,
                                    onPressed: () {
                                      _resetControlVisibility();

                                      // Ensure the video is initialized before seeking
                                      if (_videoPlayerController
                                          .value
                                          .isInitialized) {
                                        final currentPosition =
                                            _videoPlayerController
                                                .value
                                                .position;
                                        final seekDuration = Duration(
                                          seconds: 10,
                                        );

                                        // Calculate the new position
                                        final newPosition =
                                            currentPosition - seekDuration;

                                        // Make sure the new position is not before the start of the video
                                        if (newPosition > Duration.zero) {
                                          _videoPlayerController.seekTo(
                                            newPosition,
                                          );
                                        } else {
                                          // Seek to the start of the video if the new position is negative
                                          _videoPlayerController.seekTo(
                                            Duration.zero,
                                          );
                                        }
                                      }
                                    },
                                    icon: Icon(CupertinoIcons.gobackward_10),
                                    style: IconButton.styleFrom(
                                      backgroundColor:
                                          Colors
                                              .grey, // Change the background color
                                    ),
                                  ),

                                  // Play/Pause Button
                                  IconButton.filled(
                                    onPressed: () {
                                      if (_videoPlayerController
                                          .value
                                          .isPlaying) {
                                        _videoPlayerController.pause();
                                      } else {
                                        _videoPlayerController.play();
                                      }
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      _videoPlayerController.value.isPlaying
                                          ? Icons.pause_circle
                                          : Icons.play_arrow,
                                      size: 35,
                                    ),
                                  ),

                                  IconButton.filled(
                                    highlightColor: Colors.amber,
                                    onPressed: () {
                                      _resetControlVisibility();
                                      // Ensure the video is initialized before seeking
                                      if (_videoPlayerController
                                          .value
                                          .isInitialized) {
                                        final currentPosition =
                                            _videoPlayerController
                                                .value
                                                .position;
                                        final seekDuration = Duration(
                                          seconds: 10,
                                        );

                                        // Calculate the new position
                                        final newPosition =
                                            currentPosition + seekDuration;

                                        // Make sure the new position doesn't exceed the video duration
                                        final maxDuration =
                                            _videoPlayerController
                                                .value
                                                .duration;
                                        if (newPosition < maxDuration) {
                                          _videoPlayerController.seekTo(
                                            newPosition,
                                          );
                                        } else {
                                          // Seek to the end of the video if the new position exceeds the duration
                                          _videoPlayerController.seekTo(
                                            maxDuration,
                                          );
                                        }
                                      }
                                    },
                                    icon: Icon(CupertinoIcons.goforward_10),
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

                    ///full screen view
                    ValueListenableBuilder(
                      valueListenable: showControl,
                      builder:
                          (BuildContext context, bool value, Widget? child) =>
                              Positioned(
                                top: 10,
                                left: 10,
                                child: AnimatedOpacity(
                                  duration: Duration(milliseconds: 300),
                                  alwaysIncludeSemantics: true,
                                  opacity: value ? 1 : 0,
                                  child: IgnorePointer(
                                    ignoring: !value,
                                    child: InkWell(
                                      onTap: () => _toggleFullScreen(),
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 5,
                                        ),
                                        height: _isFullScreen ? 42 : 29.5,
                                        width: _isFullScreen ? 50 : 46,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
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

                    ///setting view
                    ValueListenableBuilder(
                      valueListenable: showControl,
                      builder:
                          (
                            BuildContext context,
                            bool value,
                            Widget? child,
                          ) => Positioned(
                            top: 10,
                            right: 10,
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
                                        _toggleMute();
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 5,
                                        ),
                                        height: _isFullScreen ? 42 : 29.5,
                                        width: _isFullScreen ? 50 : 46,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
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
                                          isMuted == true
                                              ? CupertinoIcons
                                                  .speaker_slash_fill
                                              : CupertinoIcons.speaker_2_fill,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),

                                    //setting
                                    InkWell(
                                      onTap:
                                          () => showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
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
                                        height: _isFullScreen ? 42 : 29.5,
                                        width: _isFullScreen ? 50 : 46,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
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
                              duration: Duration(milliseconds: 300),
                              alwaysIncludeSemantics: true,
                              opacity: value ? 1 : 0,
                              child: IgnorePointer(
                                ignoring: !value,
                                child: Container(
                                  padding: EdgeInsets.only(left: 16),
                                  margin: EdgeInsets.all(14),
                                  width: MediaQuery.of(context).size.width - 20,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      51,
                                      51,
                                      51,
                                    ).withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Time Labels (Current Time - Total Time)
                                      ValueListenableBuilder(
                                        valueListenable: _videoPlayerController,
                                        builder: (
                                          context,
                                          VideoPlayerValue value,
                                          child,
                                        ) {
                                          final position = value.position;

                                          return Text(
                                            "${_formatDuration(position)} / ${_formatDuration(_videoPlayerController.value.duration)}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          );
                                        },
                                      ),

                                      ValueListenableBuilder(
                                        valueListenable: _videoPlayerController,
                                        builder: (
                                          context,
                                          VideoPlayerValue value,
                                          child,
                                        ) {
                                          final duration = value.duration;
                                          final position = value.position;

                                          double progress = 0.0;
                                          if (duration.inMilliseconds > 0 &&
                                              !_isSeeking) {
                                            progress =
                                                position.inMilliseconds /
                                                duration.inMilliseconds;
                                            progress =
                                                progress.isNaN || progress < 0.0
                                                    ? 0.0
                                                    : (progress > 1.0
                                                        ? 1.0
                                                        : progress);
                                          } else {
                                            progress = _manualSeekProgress;
                                          }

                                          double bufferedProgress = 0.0;
                                          if (value.buffered.isNotEmpty) {
                                            bufferedProgress =
                                                value
                                                    .buffered
                                                    .last
                                                    .end
                                                    .inMilliseconds /
                                                duration.inMilliseconds;
                                            bufferedProgress =
                                                bufferedProgress.isNaN ||
                                                        bufferedProgress < 0.0
                                                    ? 0.0
                                                    : (bufferedProgress > 1.0
                                                        ? 1.0
                                                        : bufferedProgress);
                                          }
                                          // ✅ Ensure buffer progress doesn't reset when seeking
                                          // if (bufferedProgress >
                                          //     _lastBufferedProgress) {
                                          //   _lastBufferedProgress =
                                          //       bufferedProgress;
                                          // } else {
                                          //   bufferedProgress =
                                          //       _lastBufferedProgress;
                                          // }

                                          return Expanded(
                                            child: SliderTheme(
                                              data: SliderTheme.of(
                                                context,
                                              ).copyWith(
                                                trackHeight:
                                                    3.0, // Adjust height for better visibility
                                                inactiveTrackColor: Colors.white
                                                    .withValues(
                                                      alpha: 0.5,
                                                    ), // Default track
                                                activeTrackColor:
                                                    Colors
                                                        .red, // Playback progress color

                                                thumbColor: Colors.red,

                                                thumbShape:
                                                    RoundSliderThumbShape(
                                                      enabledThumbRadius: 6.0,
                                                    ),
                                              ),
                                              child: Stack(
                                                children: [
                                                  // Buffered Progress (Placed behind the actual progress)
                                                  Positioned.fill(
                                                    child: SliderTheme(
                                                      data: SliderTheme.of(
                                                        context,
                                                      ).copyWith(
                                                        trackHeight: 2.0,
                                                        activeTrackColor: Colors
                                                            .white
                                                            .withValues(
                                                              alpha: 0.5,
                                                            ), // Buffer color
                                                        inactiveTrackColor:
                                                            Colors
                                                                .transparent, // Hide inactive part
                                                        thumbShape:
                                                            RoundSliderThumbShape(
                                                              enabledThumbRadius:
                                                                  0.0,
                                                            ), // Hide thumb
                                                      ),
                                                      child: Slider(
                                                        value: bufferedProgress,
                                                        onChanged:
                                                            (
                                                              _,
                                                            ) {}, // Disabled, only for display
                                                      ),
                                                    ),
                                                  ),
                                                  // Actual Seekable Progress Bar
                                                  Slider(
                                                    value: progress,
                                                    onChanged: (
                                                      newValue,
                                                    ) async {
                                                      _resetControlVisibility();
                                                      setState(() {
                                                        _isSeeking = true;
                                                        _manualSeekProgress =
                                                            newValue; // Instantly update UI
                                                      });
                                                    },
                                                    onChangeStart: (value) {
                                                      _videoPlayerController
                                                          .pause();
                                                      _startSeekUpdateLoop();
                                                      _resetControlVisibility();
                                                    },
                                                    onChangeEnd: (value) async {
                                                      _seekUpdateTimer
                                                          ?.cancel(); // Stop the update loop

                                                      final newPosition = Duration(
                                                        milliseconds:
                                                            (duration.inMilliseconds *
                                                                    value)
                                                                .toInt(),
                                                      );

                                                      await _videoPlayerController
                                                          .seekTo(newPosition);

                                                      setState(() {
                                                        _videoPlayerController
                                                            .play();
                                                        _isSeeking = false;
                                                      });

                                                      _resetControlVisibility();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                    ),

                    //loading overlay
                    // ValueListenableBuilder(
                    //   valueListenable: loadingOverlay,
                    //   builder: (
                    //     BuildContext context,
                    //     bool value,
                    //     Widget? child,
                    //   ) {
                    //     if (value == false) return SizedBox();
                    //     return Container(
                    //       color: Colors.black,
                    //       height:
                    //           _isFullScreen == true
                    //               ? MediaQuery.of(context).size.height - 40
                    //               : 250,
                    //       width:
                    //           _isFullScreen == true
                    //               ? MediaQuery.of(context).size.width - 20
                    //               : MediaQuery.of(context).size.width,
                    //       child: Center(
                    //         child: SizedBox(
                    //           width: 30,
                    //           height: 30,
                    //           child: CircularProgressIndicator(),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                ),
      ),
    );
  }

  void _startSeekUpdateLoop() {
    _seekUpdateTimer?.cancel(); // Ensure old timers are cleared
    _seekUpdateTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (!_isSeeking) {
        timer.cancel();
      }
      setState(() {}); // Force UI update every 50ms
    });
  }

  /// Helper Function to Format Duration
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Widget _qualityModalSheet() {
    return Container(
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
              itemCount: qualityOptions.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: SizedBox(
                      height: 35,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _changeQuality(m3u8Url, 'Auto');
                        },
                        child: Row(
                          children: [
                            selectedQuality == 'Auto'
                                ? SizedBox(
                                  width: 30,
                                  child: Icon(Icons.check, color: Colors.green),
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
                          qualityOptions.firstWhere(
                            (element) =>
                                element['quality'] ==
                                qualityOptions[qualityIndex]['quality'],
                          )['url']!;
                      _changeQuality(
                        selectedUrl,
                        qualityOptions[qualityIndex]['quality'] ?? '',
                      );
                    },
                    child: SizedBox(
                      height: 35,
                      child: Row(
                        children: [
                          selectedQuality ==
                                  (qualityOptions[qualityIndex]['quality'] ??
                                      '')
                              ? SizedBox(
                                width: 30,
                                child: Icon(Icons.check, color: Colors.green),
                              )
                              : SizedBox(width: 30),
                          Text(
                            qualityOptions[qualityIndex]['quality'] ?? '',
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
    );
  }
}
