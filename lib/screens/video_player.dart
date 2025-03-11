import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:http/http.dart' as http;

class VideoPlayerState with ChangeNotifier {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  String currentQuality = "Auto";
  bool isLoading = false;
  List<Map<String, String>> qualityOptions = [];
  String m3u8Url =
      'https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8';

  VideoPlayerController get videoPlayerController => _videoPlayerController;
  ChewieController? get chewieController => _chewieController;

  VideoPlayerState() {
    _fetchQualityOptions();
    _initializeVideo(m3u8Url);
  }

  Future<void> _fetchQualityOptions() async {
    try {
      final response = await http.get(Uri.parse(m3u8Url));
      if (response.statusCode == 200) {
        String m3u8Content = response.body;

        List<Map<String, String>> qualities = [];
        final regex = RegExp(
          r'#EXT-X-STREAM-INF:.*?RESOLUTION=(\d+)x(\d+).*?\n(.*)',
          multiLine: true,
        );

        for (final match in regex.allMatches(m3u8Content)) {
          int height = int.parse(match.group(2)!);
          String url = match.group(3) ?? '';

          String qualityLabel = _getQualityLabel(height);

          if (!url.startsWith('http')) {
            Uri masterUri = Uri.parse(m3u8Url);
            url = Uri.parse(masterUri.resolve(url).toString()).toString();
          }

          qualities.add({'quality': qualityLabel, 'url': url});
        }

        qualityOptions = qualities;
        _initializeVideo(m3u8Url);
        notifyListeners();

        print('success');
      }
    } catch (e) {
      print("Error fetching M3U8: $e");
      _initializeVideo(m3u8Url);
      notifyListeners();
    }
  }

  String _getQualityLabel(int height) {
    if (height >= 1080) return "1080p";
    if (height >= 720) return "720p";
    if (height >= 480) return "480p";
    if (height >= 360) return "360p";
    if (height >= 240) return "240p";
    return "Low";
  }

  void _initializeVideo(String url) {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
    _videoPlayerController.initialize().then((_) {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        fullScreenByDefault: false,
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
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.white,
        ),
      );
      notifyListeners();
    });
  }

  void _changeQuality(String url) async {
    final currentPosition = _videoPlayerController.value.position;
    final wasPlaying = _videoPlayerController.value.isPlaying;

    bool isFullScreen = _chewieController?.isFullScreen ?? false;

    // if (isFullScreen) {
    //   _chewieController?.exitFullScreen();
    //   await Future.delayed(Duration(milliseconds: 200));
    // }

    _videoPlayerController.pause();
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
    await _videoPlayerController.initialize();
    _videoPlayerController.seekTo(currentPosition);

    if (wasPlaying) {
      _videoPlayerController.play();
     
    }

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      allowFullScreen: true,
      showControls: true,
      allowMuting: true,
      fullScreenByDefault: false,
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
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.redAccent,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.white,
      ),
    );
    notifyListeners();
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
                          _changeQuality(m3u8Url);
                          Navigator.pop(context);
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
                      String selectedUrl =
                          qualityOptions.firstWhere(
                            (element) =>
                                element['quality'] ==
                                qualityOptions[qualityIndex]['quality'],
                          )['url']!;
                      _changeQuality(selectedUrl);
                      Navigator.pop(context);
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
