import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  String currentQuality = "Auto";
  List<Map<String, String>> qualityOptions = [];
  String m3u8Url =
      'https://moviedatatesting.s3.ap-southeast-1.amazonaws.com/Mvoie+1/master.m3u8';

  @override
  void initState() {
    super.initState();
    _fetchQualityOptions();
  }

  /// Fetch and parse M3U8 file to extract quality options
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
          autoPlay: false,
          looping: false,
          allowFullScreen: true,
          allowMuting: true,
          showControls: true,
          zoomAndPan: true,
          playbackSpeeds: [0.5, 1.0, 1.5, 2.0],
          additionalOptions: (context) {
            return <OptionItem>[
              OptionItem(
                onTap: (_) {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    context: context,
                    builder: (_) {
                      return _qualityModalSheet();
                    },
                  );
                },
                iconData: CupertinoIcons.slider_horizontal_3,
                title: 'Choose Quality',
              ),
            ];
          },
          // optionsBuilder: (context, defaultOptions) async {
          //   await showDialog<void>(
          //     context: context,
          //     builder: (ctx) {
          //       return AlertDialog(
          //         backgroundColor: Colors.white,
          //         contentPadding: EdgeInsets.zero,
          //         insetPadding: EdgeInsets.zero,
          //         alignment: Alignment.bottomCenter,
          //         content: SizedBox(
          //           width: MediaQuery.of(context).size.width - 20,
          //           child: SingleChildScrollView(
          //             child: Column(
          //               children: List.generate(
          //                 defaultOptions.length,
          //                 (i) => ActionChip(
          //                   label: Text(defaultOptions[i].title),
          //                   onPressed: () => defaultOptions[i].onTap(context),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   );
          // },
          // materialProgressColors: ChewieProgressColors(
          //   playedColor: Colors.red,
          //   handleColor: Colors.redAccent,
          //   backgroundColor: Colors.grey,
          //   bufferedColor: Colors.lightGreen,
          // ),
        );
      });
    });
  }

  void _changeQuality(String url) async {
    final currentPosition = _videoPlayerController.value.position;
    final wasPlaying = _videoPlayerController.value.isPlaying;

    _videoPlayerController.dispose(); // Pause before switching

    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
    await _videoPlayerController.initialize();
    _videoPlayerController.seekTo(currentPosition); // Restore position

    if (wasPlaying) {
      _videoPlayerController.play(); // Resume playback
    }

    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: false,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        zoomAndPan: true,
        playbackSpeeds: [0.5, 1.0, 1.5, 2.0],
        additionalOptions: (context) {
          return <OptionItem>[
            OptionItem(
              onTap: (_) {
                Navigator.pop(context);
                showModalBottomSheet(
                  backgroundColor: Colors.white,
                  context: context,
                  builder: (_) {
                    return _qualityModalSheet();
                  },
                );
              },
              iconData: CupertinoIcons.slider_horizontal_3,
              title: 'Choose Quality',
            ),
          ];
        },
      );
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Player")),
      body: Center(
        child:
            _chewieController != null &&
                    _chewieController!.videoPlayerController.value.isInitialized
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 230,
                      width: double.infinity,
                      color: Colors.black,
                      child: Chewie(controller: _chewieController!),
                    ),
                  ],
                )
                : const CircularProgressIndicator(),
      ),
    );
  }

  Widget _qualityModalSheet() {
    return Container(
      margin: EdgeInsets.all(16),
      height: null,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Choose Quality',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 16),
              shrinkWrap: true,
              itemCount: qualityOptions.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      height: 35,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _changeQuality(m3u8Url);
                        },
                        child: Center(
                          child: Text(
                            'Auto',
                            style: TextStyle(
                              fontSize: 16,
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
                  padding: const EdgeInsets.only(bottom: 10),
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
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
