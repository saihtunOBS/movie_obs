// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
// import 'package:http/http.dart' as http;

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// late VideoPlayerController _videoPlayerController;
// ChewieController? _chewieController;
// bool _isFullScreen = false;
// bool hasPrinted = false;
// Timer? _hideControlTimer;

// final ValueNotifier<bool> showControl = ValueNotifier(false);

// class _HomePageState extends State<HomePage> {
//   String currentQuality = "Auto";
//   bool isLoading = false;
//   List<Map<String, String>> qualityOptions = [];
//   String m3u8Url =
//       'https://moviedatatesting.s3.ap-southeast-1.amazonaws.com/Mvoie+1/master.m3u8';

//   @override
//   void initState() {
//     super.initState();
//     _fetchQualityOptions();
//   }
//   //https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8
//   //https://moviedatatesting.s3.ap-southeast-1.amazonaws.com/Mvoie+1/master.m3u8

//   /// Fetch and parse M3U8 file to extract quality options
//   Future<void> _fetchQualityOptions() async {
//     try {
//       final response = await http.get(Uri.parse(m3u8Url));
//       if (response.statusCode == 200) {
//         String m3u8Content = response.body;

//         // Extract quality options using regex
//         List<Map<String, String>> qualities = [];
//         final regex = RegExp(
//           r'#EXT-X-STREAM-INF:.*?RESOLUTION=(\d+)x(\d+).*?\n(.*)',
//           multiLine: true,
//         );

//         for (final match in regex.allMatches(m3u8Content)) {
//           int height = int.parse(
//             match.group(2)!,
//           ); // Get video height (e.g., 1080)
//           String url = match.group(3) ?? '';

//           // Convert resolution height to readable format
//           String qualityLabel = _getQualityLabel(height);

//           // Convert relative URLs to absolute
//           if (!url.startsWith('http')) {
//             Uri masterUri = Uri.parse(m3u8Url);
//             url = Uri.parse(masterUri.resolve(url).toString()).toString();
//           }

//           qualities.add({'quality': qualityLabel, 'url': url});
//         }

//         setState(() {
//           qualityOptions = qualities;
//           _initializeVideo(m3u8Url);
//         });
//       }
//     } catch (e) {
//       debugPrint("Error fetching M3U8: $e");
//       _initializeVideo(m3u8Url);
//     }
//   }

//   /// Convert resolution height to standard quality labels
//   String _getQualityLabel(int height) {
//     if (height >= 1080) return "1080p";
//     if (height >= 720) return "720p";
//     if (height >= 480) return "480p";
//     if (height >= 360) return "360p";
//     if (height >= 240) return "240p";
//     return "Low";
//   }

//   /// Initialize video player
//   void _initializeVideo(String url) {
//     _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
//     _videoPlayerController.initialize().then((_) {
//       setState(() {
//         _chewieController = ChewieController(
//           videoPlayerController: _videoPlayerController,
//           autoPlay: false,
//           looping: false,
//           allowFullScreen: false,
//           allowMuting: true,
//           showControls: true,
//           fullScreenByDefault: false,
//           zoomAndPan: true,
//           hideControlsTimer: Duration(seconds: 5),
//           playbackSpeeds: [0.5, 1.0, 1.5, 2.0],
//           additionalOptions: (context) {
//             return <OptionItem>[
//               OptionItem(
//                 onTap: (_) {
//                   Navigator.pop(context);
//                   showModalBottomSheet(
//                     backgroundColor: Colors.white,
//                     context: context,
//                     builder: (_) {
//                       return _qualityModalSheet();
//                     },
//                   );
//                 },
//                 iconData: CupertinoIcons.slider_horizontal_3,
//                 title: 'Choose Quality',
//               ),
//             ];
//           },
//           // optionsBuilder: (context, defaultOptions) async {
//           //   await showDialog<void>(
//           //     context: context,
//           //     builder: (ctx) {
//           //       return AlertDialog(
//           //         backgroundColor: Colors.white,
//           //         contentPadding: EdgeInsets.zero,
//           //         insetPadding: EdgeInsets.zero,
//           //         alignment: Alignment.bottomCenter,
//           //         content: SizedBox(
//           //           width: MediaQuery.of(context).size.width - 20,
//           //           child: SingleChildScrollView(
//           //             child: Column(
//           //               children: List.generate(
//           //                 defaultOptions.length,
//           //                 (i) => ActionChip(
//           //                   label: Text(defaultOptions[i].title),
//           //                   onPressed: () => defaultOptions[i].onTap(context),
//           //                 ),
//           //               ),
//           //             ),
//           //           ),
//           //         ),
//           //       );
//           //     },
//           //   );
//           // },
//           materialProgressColors: ChewieProgressColors(
//             playedColor: Colors.red,
//             handleColor: Colors.redAccent,
//             backgroundColor: Colors.grey,
//             bufferedColor: Colors.white,
//           ),
//         );
//       });

//       _chewieController?.videoPlayerController.addListener(() {
//         if (_chewieController?.videoPlayerController.value.isPlaying == true) {
//           if (!hasPrinted) {
//             hasPrinted = true;
//             _resetControlVisibility();
//           }
//         } else {
//           setState(() {
//             hasPrinted = false;
//           });
//           showControl.value = false;
//         }
//       });
//     });
//   }

//   void _resetControlVisibility() {
//     showControl.value = true;

//     // Cancel the previous timer before creating a new one
//     _hideControlTimer?.cancel();
//     _hideControlTimer = Timer(const Duration(seconds: 5), () {
//       showControl.value = false;
//     });
//   }

//   void _changeQuality(String url) async {
//     final currentPosition = _videoPlayerController.value.position;
//     final wasPlaying = _videoPlayerController.value.isPlaying;

//     await _videoPlayerController.dispose();

//     _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));

//     await _videoPlayerController.initialize();
//     _videoPlayerController.seekTo(currentPosition); // Restore position

//     if (wasPlaying) {
//       setState(() {
//         _videoPlayerController.play();
//       });
//     }

//     setState(() {
//       _chewieController = ChewieController(
//         videoPlayerController: _videoPlayerController,
//         autoPlay: false,
//         looping: false,
//         allowFullScreen: false,
//         showControls: true,
//         allowMuting: true,
//         hideControlsTimer: Duration(seconds: 5),
//         fullScreenByDefault: false, // Keep it false for manual control
//         playbackSpeeds: [0.5, 1.0, 1.5, 2.0],
//         additionalOptions: (context) {
//           return <OptionItem>[
//             OptionItem(
//               onTap: (_) {
//                 Navigator.pop(context);
//                 showModalBottomSheet(
//                   backgroundColor: Colors.white,
//                   context: context,
//                   builder: (_) {
//                     return _qualityModalSheet();
//                   },
//                 );
//               },
//               iconData: CupertinoIcons.slider_horizontal_3,
//               title: 'Choose Quality',
//             ),
//           ];
//         },
//         materialProgressColors: ChewieProgressColors(
//           playedColor: Colors.red,
//           handleColor: Colors.redAccent,
//           backgroundColor: Colors.grey,
//           bufferedColor: Colors.white,
//         ),
//       );
//     });
//   }

//   void _toggleFullScreen() {
//     setState(() {
//       _isFullScreen = !_isFullScreen;
//     });

//     if (_isFullScreen) {
//       // SystemChrome.setPreferredOrientations([
//       //   DeviceOrientation.landscapeRight,
//       //   DeviceOrientation.landscapeLeft,
//       // ]);
//     } else {
//       // SystemChrome.setPreferredOrientations([
//       //   DeviceOrientation.portraitUp,
//       //   DeviceOrientation.portraitDown,
//       // ]);
//     }
//   }

//   @override
//   void dispose() {
//     _videoPlayerController.dispose();
//     _chewieController?.dispose();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     _hideControlTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _isFullScreen ? Colors.black : Colors.white,
//       appBar:
//           _isFullScreen == true
//               ? null
//               : AppBar(title: const Text("Video Player")),
//       body: Center(
//         child:
//             _chewieController != null
//                 ? Stack(
//                   children: [
//                     Container(
//                       color: Colors.black,
//                       height:
//                           _isFullScreen == true
//                               ? MediaQuery.of(context).size.height - 40
//                               : 250,
//                       width:
//                           _isFullScreen == true
//                               ? MediaQuery.of(context).size.width - 20
//                               : MediaQuery.of(context).size.width,
//                       child: Listener(
//                         onPointerDown: (event) {
//                           if (_chewieController!.isPlaying) {
//                             _resetControlVisibility();
//                           }
//                         },
//                         child: Chewie(controller: _chewieController!),
//                       ),
//                     ),

//                     ValueListenableBuilder(
//                       valueListenable: showControl,
//                       builder:
//                           (BuildContext context, bool value, Widget? child) =>
//                               Positioned(
//                                 top: 0,
//                                 left: 0,
//                                 child: AnimatedOpacity(
//                                   duration: Duration(milliseconds: 300),
//                                   alwaysIncludeSemantics: true,
//                                   opacity: value ? 1 : 0,
//                                   child: InkWell(
//                                     onTap: () => _toggleFullScreen(),
//                                     child: Container(
//                                       margin: EdgeInsets.symmetric(
//                                         horizontal: 5,
//                                         vertical: 5,
//                                       ),
//                                       height: _isFullScreen ? 42 : 29.5,
//                                       width: _isFullScreen ? 50 : 46,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(8),
//                                         color: const Color.fromARGB(
//                                           255,
//                                           84,
//                                           83,
//                                           83,
//                                         ).withValues(alpha: 0.5),
//                                       ),
//                                       child: Icon(
//                                         Icons.fullscreen,
//                                         color: Colors.white,
//                                         size: 20,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                     ),
//                   ],
//                 )
//                 : SizedBox(),
//       ),
//     );
//   }

//   Widget _qualityModalSheet() {
//     return Container(
//       margin: EdgeInsets.all(16),
//       height: null,
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Text(
//               'Choose Quality',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),

//             ListView.builder(
//               physics: NeverScrollableScrollPhysics(),
//               padding: EdgeInsets.only(top: 16),
//               shrinkWrap: true,
//               itemCount: qualityOptions.length + 1,
//               itemBuilder: (context, index) {
//                 if (index == 0) {
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 10),
//                     child: SizedBox(
//                       height: 35,
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.pop(context);
//                           _changeQuality(m3u8Url);
//                         },
//                         child: Center(
//                           child: Text(
//                             'Auto',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//                 int qualityIndex = index - 1;
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 10),
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                       String selectedUrl =
//                           qualityOptions.firstWhere(
//                             (element) =>
//                                 element['quality'] ==
//                                 qualityOptions[qualityIndex]['quality'],
//                           )['url']!;
//                       _changeQuality(selectedUrl);
//                     },
//                     child: SizedBox(
//                       height: 35,
//                       child: Center(
//                         child: Text(
//                           qualityOptions[qualityIndex]['quality'] ?? '',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w400,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
