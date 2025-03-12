import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final ValueNotifier<bool> showControl = ValueNotifier(true);
final ValueNotifier<bool> loadingOverlay = ValueNotifier(false);

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isFullScreen = false;
  bool hasPrinted = false;
  Timer? _hideControlTimer;
  double _manualSeekProgress = 0.0;
  bool _isSeeking = false;
  Timer? _seekUpdateTimer;
  String currentQuality = "Auto";
  int selectedInde = -1;
  // double _lastBufferedProgress = 0.0;
  bool isLoading = false;
  List<Map<String, String>> qualityOptions = [];
  String m3u8Url =
      'https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8';

  @override
  void initState() {
    super.initState();
    _fetchQualityOptions();
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
          int height = int.parse(
            match.group(2)!,
          ); // Get video height (e.g., 1080)
          String url = match.group(3) ?? '';

          // Convert resolution height to readable format
          String qualityLabel = _getQualityLabel(height);

          // Convert relative URLs to absolute
          if (!url.startsWith('http')) {
            Uri masterUri = Uri.parse(m3u8Url);
            url = Uri.parse(masterUri.resolve(url).toString()).toString();
          }

          qualities.add({'quality': qualityLabel, 'url': url});
        }

        setState(() {
          qualityOptions = qualities;
          _initializeVideo(m3u8Url);
        });
      }
    } catch (e) {
      debugPrint("Error fetching M3U8: $e");
      _initializeVideo(m3u8Url);
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
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
    _videoPlayerController.initialize().then((_) {
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          showControls: false,
        );
      });

      _chewieController?.videoPlayerController.addListener(() {
        if (_chewieController?.videoPlayerController.value.isPlaying == true) {
          if (!hasPrinted) {
            hasPrinted = true;
            _resetControlVisibility();
          }
        } else {
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
  void _changeQuality(String url) async {
    loadingOverlay.value = true;

    final currentPosition = _videoPlayerController.value.position;
    final wasPlaying = _videoPlayerController.value.isPlaying;

    await _videoPlayerController.dispose();

    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));

    await _videoPlayerController.initialize();
    _videoPlayerController.seekTo(currentPosition); // Restore position

    if (wasPlaying) {
      setState(() {
        _videoPlayerController.play();
      });
    }

    //reinitialized player
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        showControls: false,
      );
    });

    _videoPlayerController.seekTo(currentPosition).whenComplete(() {
      loadingOverlay.value = false;
      _videoPlayerController.play();
      _resetControlVisibility();
      // _lastBufferedProgress = 0.0;
    });
  }

  //toggle
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
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
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
            _chewieController != null
                ? Stack(
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
                        child: Chewie(controller: _chewieController!),
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
                                          _videoPlayerController.value.position;
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
                                ValueListenableBuilder(
                                  valueListenable: _videoPlayerController,
                                  builder:
                                      (
                                        BuildContext context,
                                        VideoPlayerValue value,
                                        Widget? child,
                                      ) => IconButton.filled(
                                        onPressed: () {
                                          if (value.isPlaying) {
                                            _videoPlayerController.pause();
                                          } else {
                                            _videoPlayerController.play();
                                          }
                                        },
                                        icon: Icon(
                                          value.isPlaying
                                              ? Icons.pause_circle
                                              : Icons.play_arrow,
                                          size: 35,
                                        ),
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
                                          _videoPlayerController.value.position;
                                      final seekDuration = Duration(
                                        seconds: 10,
                                      );

                                      // Calculate the new position
                                      final newPosition =
                                          currentPosition + seekDuration;

                                      // Make sure the new position doesn't exceed the video duration
                                      final maxDuration =
                                          _videoPlayerController.value.duration;
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
                                        borderRadius: BorderRadius.circular(8),
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

                    ///setting view
                    ValueListenableBuilder(
                      valueListenable: showControl,
                      builder:
                          (BuildContext context, bool value, Widget? child) =>
                              Positioned(
                                top: 10,
                                right: 10,
                                child: AnimatedOpacity(
                                  duration: Duration(milliseconds: 300),
                                  alwaysIncludeSemantics: true,
                                  opacity: value ? 1 : 0,
                                  child: InkWell(
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
                                        borderRadius: BorderRadius.circular(8),
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
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 300),
                              alwaysIncludeSemantics: true,
                              opacity: value ? 1 : 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 5,
                                ),
                                margin: EdgeInsets.all(16),
                                width: MediaQuery.of(context).size.width - 20,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    51,
                                    51,
                                    51,
                                  ).withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
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

                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _formatDuration(position),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              " / ${_formatDuration(_videoPlayerController.value.duration)}",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
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

                                        // Actual video progress tracking
                                        double progress =
                                            (duration.inMilliseconds > 0 &&
                                                    !_isSeeking)
                                                ? position.inMilliseconds /
                                                    duration.inMilliseconds
                                                : _manualSeekProgress;

                                        // Get buffered progress
                                        double bufferedProgress = 0.0;
                                        if (value.buffered.isNotEmpty) {
                                          bufferedProgress =
                                              value
                                                  .buffered
                                                  .last
                                                  .end
                                                  .inMilliseconds /
                                              duration.inMilliseconds;
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
                                              thumbColor:
                                                  Colors.red, 
                                             
                                              thumbShape: RoundSliderThumbShape(
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
                                                      trackHeight: 3.0,
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
                                                  onChanged: (newValue) async {
                                                    _resetControlVisibility();
                                                    setState(() {
                                                      _isSeeking = true;
                                                      _manualSeekProgress =
                                                          newValue; // Instantly update UI
                                                    });
                                                  },
                                                  onChangeStart: (value) {
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
                                                      _isSeeking = false;
                                                    });

                                                    _videoPlayerController
                                                        .play();
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

                    ///loading overlay
                    ValueListenableBuilder(
                      valueListenable: loadingOverlay,
                      builder: (
                        BuildContext context,
                        bool value,
                        Widget? child,
                      ) {
                        if (value == false) return SizedBox();
                        return Container(
                          color: Colors.black,
                          height:
                              _isFullScreen == true
                                  ? MediaQuery.of(context).size.height - 40
                                  : 250,
                          width:
                              _isFullScreen == true
                                  ? MediaQuery.of(context).size.width - 20
                                  : MediaQuery.of(context).size.width,
                          child: Center(
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                )
                : SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
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
                          _changeQuality(m3u8Url);
                        },
                        child: Center(
                          child: Text(
                            'Auto (recommanded)',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
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
                      _changeQuality(selectedUrl);
                    },
                    child: SizedBox(
                      height: 35,
                      child: Center(
                        child: Text(
                          qualityOptions[qualityIndex]['quality'] ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
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
