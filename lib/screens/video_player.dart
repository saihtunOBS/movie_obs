// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:movie_obs/bloc/video_bloc.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// // final ValueNotifier<bool> showControl = ValueNotifier(false);
// // final ValueNotifier<bool> userAction = ValueNotifier(false);

// // ValueNotifier<bool> isHoveringLeft = ValueNotifier(false);
// // ValueNotifier<bool> isHoveringRight = ValueNotifier(false);

// class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
//   late final VideoBloc bloc; // Declare provider outside build

//   // bool _wasScreenOff = false;
//   // bool isMuted = false;
//   // bool _isFullScreen = false;
//   // bool hasPrinted = false;
//   // Timer? _hideControlTimer;
//   // double _manualSeekProgress = 0.0;
//   // bool _isSeeking = false;
//   // Timer? _seekUpdateTimer;
//   // double _dragOffset = 0.0; // Track vertical drag
//   // final double _dragThreshold = 100.0; // Distance needed to exit fullscreen

//   // bool isLoading = false;
//   // List<Map<String, String>> qualityOptions = [];
//   // String m3u8Url =
//   //     'https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8';
//   // String currentUrl =
//   //     'https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8';

//   // double _scale = 1.0; // Initial scale of the video
//   // double _initialScale = 1.0; // Scale at the start of the drag
//   // double _initialPosition = 0.0; // Initial position of the drag

//   // // Maximum and minimum scaling limits (like YouTube)
//   // final double _minScale = 1.0;
//   // final double _maxScale = 2.0; // Set a reasonable maximum zoom level

//   // // Drag update callback to scale the video player
//   // void _onVerticalDragUpdate(DragUpdateDetails details) {
//   //   setState(() {
//   //     double scaleChange =
//   //         (_initialPosition - details.localPosition.dy) /
//   //         100; // Adjust sensitivity
//   //     _scale = (_initialScale + scaleChange).clamp(_minScale, _maxScale);
//   //   });
//   // }

//   // void _onVerticalDragEnd(DragEndDetails details) {
//   //   setState(() {
//   //     _initialScale = _scale;
//   //     if (_initialScale == 1.0) return;
//   //     _toggleFullScreen();
//   //   });
//   // }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (Platform.isAndroid) {
//       if (state == AppLifecycleState.resumed) {
//         if (bloc.wasScreenOff) {
//           setState(() {
//             bloc.videoPlayerController.pause();
//           });

//           bloc.changeQuality(bloc.currentUrl);
//         }
//         bloc.wasScreenOff = false;
//       } else if (state == AppLifecycleState.inactive) {
//         bloc.wasScreenOff = true;
//         bloc.videoPlayerController.pause();
//       }
//     } else {
//       if (state == AppLifecycleState.resumed) {
//         bloc.videoPlayerController.pause();
//         bloc.resetControlVisibility();
//       } else if (state == AppLifecycleState.inactive) {
//         setState(() {
//           bloc.videoPlayerController.pause();
//         });
//       }
//     }
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);
//     bloc = Provider.of<VideoBloc>(context, listen: false);
//     WidgetsBinding.instance.addPostFrameCallback((_){
//       bloc.initializeVideo(bloc.m3u8Url);
//     });
//     super.initState();
//   }

//   // /// Fetch and parse M3U8 file to extract quality options
//   // Future<void> _fetchQualityOptions() async {
//   //   try {
//   //     final response = await http.get(Uri.parse(m3u8Url));
//   //     if (response.statusCode == 200) {
//   //       String m3u8Content = response.body;

//   //       // Extract quality options using regex
//   //       List<Map<String, String>> qualities = [];
//   //       final regex = RegExp(
//   //         r'#EXT-X-STREAM-INF:.*?RESOLUTION=(\d+)x(\d+).*?\n(.*)',
//   //         multiLine: true,
//   //       );

//   //       for (final match in regex.allMatches(m3u8Content)) {
//   //         int height = int.parse(match.group(2)!);

//   //         // Get video height (e.g., 1080)
//   //         String url = match.group(3) ?? '';

//   //         String qualityLabel = _getQualityLabel(height);

//   //         // Convert relative URLs to absolute
//   //         if (!url.startsWith('http')) {
//   //           Uri masterUri = Uri.parse(m3u8Url);
//   //           url = Uri.parse(masterUri.resolve(url).toString()).toString();
//   //         }

//   //         qualities.add({'quality': qualityLabel, 'url': url});
//   //       }

//   //       qualityOptions = qualities;
//   //     }
//   //   } catch (e) {
//   //     debugPrint("Error fetching M3U8: $e");
//   //   }
//   // }

//   // /// Convert resolution height to standard quality labels
//   // String _getQualityLabel(int height) {
//   //   if (height >= 1080) return "1080p";
//   //   if (height >= 720) return "720p";
//   //   if (height >= 480) return "480p";
//   //   if (height >= 360) return "360p";
//   //   if (height >= 240) return "240p";
//   //   return "Low";
//   // }

//   // /// Initialize video player
//   // void _initializeVideo(String url) {
//   //   _videoPlayerController = VideoPlayerController.networkUrl(
//   //     Uri.parse(url),
//   //     videoPlayerOptions: VideoPlayerOptions(
//   //       allowBackgroundPlayback: true,
//   //       mixWithOthers: true,
//   //     ),
//   //   );
//   //   _videoPlayerController.initialize().then((_) {
//   //     if (!mounted) return;
//   //     setState(() {
//   //       _chewieControllerNotifier = ValueNotifier(
//   //         ChewieController(
//   //           videoPlayerController: _videoPlayerController,
//   //           showControls: false,
//   //           allowedScreenSleep: false,
//   //           autoInitialize: true,
//   //         ),
//   //       );
//   //       _fetchQualityOptions();
//   //     });

//   //     _videoPlayerController.addListener(() {
//   //       if (_videoPlayerController.value.isPlaying == true) {
//   //         WakelockPlus.enable();
//   //         if (!hasPrinted) {
//   //           hasPrinted = true;
//   //           _resetControlVisibility();
//   //         }
//   //       } else {
//   //         WakelockPlus.disable();
//   //         setState(() {
//   //           hasPrinted = false;
//   //           showControl.value = true;
//   //         });
//   //       }
//   //     });
//   //   });
//   // }

//   // ///reset play state (android only)
//   // void _resetControlVisibility() {
//   //   showControl.value = true;

//   //   // Cancel the previous timer before creating a new one
//   //   _hideControlTimer?.cancel();
//   //   _hideControlTimer = Timer(const Duration(seconds: 3), () {
//   //     if (_videoPlayerController.value.isPlaying == true) {
//   //       showControl.value = false;
//   //     } else {
//   //       showControl.value = true;
//   //     }
//   //   });
//   // }

//   // //quality change
//   // void _changeQuality(String url, [String? quality]) async {
//   //   setState(() {
//   //     userAction.value = true;
//   //   });

//   //   selectedQuality = quality ?? selectedQuality;
//   //   currentUrl = url;
//   //   final currentPosition = _videoPlayerController.value.position;
//   //   final wasPlaying = _videoPlayerController.value.isPlaying;

//   //   await _videoPlayerController.dispose();

//   //   _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));

//   //   await _videoPlayerController.initialize();
//   //   _videoPlayerController.seekTo(currentPosition).then((_) {
//   //     setState(() {
//   //       userAction.value = false;
//   //     });
//   //   });
//   //   _chewieControllerNotifier?.value = ChewieController(
//   //     videoPlayerController: _videoPlayerController,
//   //     showControls: false,
//   //     allowedScreenSleep: false,
//   //   );
//   //   if (wasPlaying) {
//   //     _videoPlayerController.play();
//   //   } else {
//   //     _videoPlayerController.pause();
//   //   }
//   //   _videoPlayerController.setVolume(isMuted ? 0.0 : 1.0);
//   //   _resetControlVisibility();
//   // }

//   // //toggle full screen
//   // void _toggleFullScreen() {
//   //   setState(() {
//   //     _isFullScreen = !_isFullScreen;
//   //     _initialPosition = 0.0;
//   //     _scale = 1.0;
//   //     _initialScale = 1.0;
//   //     _dragOffset = 0.0;
//   //   });

//   //   if (_isFullScreen) {
//   //     // Lock in landscape mode
//   //     SystemChrome.setPreferredOrientations([
//   //       DeviceOrientation.landscapeRight,
//   //       DeviceOrientation.landscapeLeft,
//   //     ]);
//   //     SystemChrome.setEnabledSystemUIMode(
//   //       SystemUiMode.immersive,
//   //     ); // Hide UI for fullscreen
//   //   } else {
//   //     // Restore default orientation behavior
//   //     SystemChrome.setPreferredOrientations([
//   //       DeviceOrientation.portraitUp,
//   //       DeviceOrientation.portraitDown,
//   //     ]);
//   //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive); // Restore UI
//   //   }
//   //   _resetControlVisibility();
//   // }

//   // // Function to toggle mute/unmute
//   // void _toggleMute() {
//   //   setState(() {
//   //     isMuted = !isMuted;
//   //     _videoPlayerController.setVolume(isMuted ? 0.0 : 1.0);
//   //   });
//   //   _resetControlVisibility();
//   // }

//   // void _seekBackward() {
//   //   final currentPosition = _videoPlayerController.value.position;
//   //   final seekDuration = Duration(seconds: 10);
//   //   final newPosition = currentPosition - seekDuration;

//   //   if (newPosition > Duration.zero) {
//   //     _videoPlayerController.seekTo(newPosition);
//   //   } else {
//   //     _videoPlayerController.seekTo(
//   //       Duration.zero,
//   //     ); // Don't seek past the start of the video
//   //   }
//   // }

//   // void _seekForward() {
//   //   final currentPosition = _videoPlayerController.value.position;
//   //   final seekDuration = Duration(seconds: 10);
//   //   final newPosition = currentPosition + seekDuration;

//   //   if (newPosition < _videoPlayerController.value.duration) {
//   //     _videoPlayerController.seekTo(newPosition);
//   //   } else {
//   //     _videoPlayerController.seekTo(
//   //       _videoPlayerController.value.duration,
//   //     ); // Don't seek past the end of the video
//   //   }
//   // }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.white,
//       child: Consumer<VideoBloc>(
//         builder: (context, value, child) => 
//          Stack(
//           alignment: Alignment.center,
//           children: [
//             Positioned(
//               top: 70,
//               child: Text(
//                 'Video Player',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//             bloc.chewieControllerNotifier == null
//                 ? CircularProgressIndicator()
//                 : AnimatedContainer(
//                   duration: Duration(milliseconds: 300),
//                   color: Colors.black,
//                   height:
//                       bloc.isFullScreen == true
//                           ? MediaQuery.of(context).size.height
//                           : 250,
//                   width: MediaQuery.of(context).size.width,
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       GestureDetector(
//                         behavior: HitTestBehavior.opaque,
//                         onDoubleTapDown: (details) {
//                           final screenWidth = MediaQuery.of(context).size.width;
//                           final tapPosition = details.localPosition.dx;
            
//                           //disable tap while user change quality
//                           if (bloc.userAction.value == true) return;
//                           if (tapPosition < screenWidth / 2) {
//                             bloc.seekBackward();
//                             bloc.isHoveringLeft.value = true;
//                             bloc.isHoveringRight.value = false;
//                           } else {
//                             bloc.seekForward();
//                             bloc.isHoveringRight.value = true;
//                             bloc.isHoveringLeft.value = false;
//                           }
//                         },
            
//                         onVerticalDragUpdate: (details) {
//                           bloc.onVerticalDragUpdate(details);
//                           if (bloc.isFullScreen && details.delta.dy > 0) {
//                             setState(() {
//                               bloc.dragOffset +=
//                                   details.delta.dy; // Move video down
//                             });
//                           }
//                         },
//                         onVerticalDragEnd: (details) {
//                           if (bloc.isFullScreen) {
//                             if (bloc.dragOffset > bloc.dragThreshold) {
//                               bloc.toggleFullScreen();
//                             } else {
//                               setState(() {
//                                 bloc.dragOffset =
//                                     0.0; // Reset position if not enough drag
//                               });
//                             }
//                           } else {
//                             bloc.onVerticalDragEnd(details);
//                           }
//                         },
//                         onPanStart: (details) {
//                           bloc.initialPosition =
//                               details
//                                   .localPosition
//                                   .dy; // Capture initial drag position
//                           bloc.initialScale = bloc.scale;
//                         },
            
//                         onDoubleTap: () {
//                           if (bloc.userAction.value == true) return;
//                           Future.delayed(Duration(milliseconds: 100), () {
//                             bloc.isHoveringRight.value = false;
//                             bloc.isHoveringLeft.value = false;
//                             bloc.videoPlayerController.play();
//                           });
//                         },
//                         onTap: () {
//                           bloc.resetControlVisibility();
//                         },
//                         child: ValueListenableBuilder(
//                           valueListenable: bloc.chewieControllerNotifier!,
//                           builder:
//                               (
//                                 BuildContext context,
//                                 ChewieController? value,
//                                 Widget? child,
//                               ) => Center(
//                                 child: Transform.scale(
//                                   scale: bloc.scale,
//                                   child: AnimatedContainer(
//                                     transform: Matrix4.translationValues(
//                                       0,
//                                       bloc.dragOffset,
//                                       0,
//                                     ),
//                                     duration: Duration(milliseconds: 200),
//                                     child: Stack(
//                                       alignment: Alignment.center,
//                                       children: [
//                                         Chewie(controller: value!),
//                                         //hover left
//                                         Positioned(
//                                           child: ValueListenableBuilder<bool>(
//                                             valueListenable:
//                                                 bloc.isHoveringLeft,
//                                             builder: (
//                                               context,
//                                               hoveringLeft,
//                                               child,
//                                             ) {
//                                               return AnimatedOpacity(
//                                                 opacity: hoveringLeft ? 0.3 : 0,
//                                                 duration: Duration(
//                                                   milliseconds: 300,
//                                                 ),
//                                                 child: Align(
//                                                   alignment:
//                                                       Alignment.centerLeft,
//                                                   child: Container(
//                                                     width:
//                                                         MediaQuery.sizeOf(
//                                                           context,
//                                                         ).width *
//                                                         0.3,
            
//                                                     decoration: BoxDecoration(
//                                                       color:
//                                                           hoveringLeft
//                                                               ? Colors.blue
//                                                                   .withValues(
//                                                                     alpha: 0.9,
//                                                                   )
//                                                               : Colors
//                                                                   .transparent,
//                                                       borderRadius: BorderRadius.only(
//                                                         topRight: Radius.circular(
//                                                           bloc.isFullScreen
//                                                               ? MediaQuery.sizeOf(
//                                                                     context,
//                                                                   ).width /
//                                                                   3
//                                                               : 125,
//                                                         ),
//                                                         bottomRight:
//                                                             Radius.circular(
//                                                               bloc.isFullScreen
//                                                                   ? MediaQuery.sizeOf(
//                                                                         context,
//                                                                       ).width /
//                                                                       3
//                                                                   : 125,
//                                                             ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                         Positioned(
//                                           child: ValueListenableBuilder<bool>(
//                                             valueListenable:
//                                                 bloc.isHoveringRight,
//                                             builder: (
//                                               context,
//                                               hoverRight,
//                                               child,
//                                             ) {
//                                               return AnimatedOpacity(
//                                                 opacity: hoverRight ? 0.3 : 0,
//                                                 duration: Duration(
//                                                   milliseconds: 300,
//                                                 ),
//                                                 child: Align(
//                                                   alignment:
//                                                       Alignment.centerRight,
//                                                   child: Container(
//                                                     width:
//                                                         MediaQuery.sizeOf(
//                                                           context,
//                                                         ).width *
//                                                         0.3,
            
//                                                     decoration: BoxDecoration(
//                                                       color:
//                                                           hoverRight
//                                                               ? Colors.blue
//                                                                   .withValues(
//                                                                     alpha: 0.8,
//                                                                   )
//                                                               : Colors
//                                                                   .transparent,
//                                                       borderRadius: BorderRadius.only(
//                                                         bottomLeft: Radius.circular(
//                                                           bloc.isFullScreen
//                                                               ? MediaQuery.sizeOf(
//                                                                     context,
//                                                                   ).width /
//                                                                   3
//                                                               : 125,
//                                                         ),
//                                                         topLeft: Radius.circular(
//                                                           bloc.isFullScreen
//                                                               ? MediaQuery.sizeOf(
//                                                                     context,
//                                                                   ).width /
//                                                                   3
//                                                               : 125,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                         ),
//                       ),
            
//                       ///play pause view
//                       ValueListenableBuilder(
//                         valueListenable: bloc.showControl,
//                         builder:
//                             (
//                               BuildContext context,
//                               bool value,
//                               Widget? child,
//                             ) => AnimatedOpacity(
//                               duration: Duration(milliseconds: 300),
//                               opacity: value ? 1 : 0,
            
//                               child: IgnorePointer(
//                                 ignoring:
//                                     !value || bloc.userAction.value == true,
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.max,
//                                   spacing: 12,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     // Seek Backward Button
//                                     IconButton.filled(
//                                       highlightColor: Colors.amber,
//                                       onPressed: () {
//                                         bloc.resetControlVisibility();
            
//                                         if (bloc
//                                             .videoPlayerController
//                                             .value
//                                             .isInitialized) {
//                                           bloc.seekBackward();
//                                         }
//                                       },
//                                       icon: Icon(CupertinoIcons.gobackward_10),
//                                       style: IconButton.styleFrom(
//                                         backgroundColor:
//                                             Colors
//                                                 .grey, // Change the background color
//                                       ),
//                                     ),
            
//                                     // Play/Pause Button
//                                     IconButton.filled(
//                                       onPressed: () {
//                                         if (bloc
//                                             .videoPlayerController
//                                             .value
//                                             .isPlaying) {
//                                           bloc.videoPlayerController.pause();
//                                         } else {
//                                           bloc.videoPlayerController.play();
//                                         }
//                                         setState(() {});
//                                       },
//                                       icon: Icon(
//                                         bloc
//                                                 .videoPlayerController
//                                                 .value
//                                                 .isPlaying
//                                             ? Icons.pause_circle
//                                             : Icons.play_arrow,
//                                         size: 40,
//                                       ),
//                                     ),
            
//                                     IconButton.filled(
//                                       highlightColor: Colors.amber,
//                                       onPressed: () {
//                                         bloc.resetControlVisibility();
//                                         // Ensure the video is initialized before seeking
//                                         if (bloc
//                                             .videoPlayerController
//                                             .value
//                                             .isInitialized) {
//                                           bloc.seekForward();
//                                         }
//                                       },
//                                       icon: Icon(CupertinoIcons.goforward_10),
//                                       style: IconButton.styleFrom(
//                                         backgroundColor:
//                                             Colors
//                                                 .grey, // Change the background color
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                       ),
            
//                       ///full screen view
//                       ValueListenableBuilder(
//                         valueListenable: bloc.showControl,
//                         builder:
//                             (BuildContext context, bool value, Widget? child) =>
//                                 Positioned(
//                                   top: 10,
//                                   left: 10,
//                                   child: AnimatedOpacity(
//                                     duration: Duration(milliseconds: 300),
//                                     alwaysIncludeSemantics: true,
//                                     opacity: value ? 1 : 0,
//                                     child: IgnorePointer(
//                                       ignoring: !value,
//                                       child: InkWell(
//                                         onTap: () => bloc.toggleFullScreen(),
//                                         child: Container(
//                                           margin: EdgeInsets.symmetric(
//                                             horizontal: 5,
//                                             vertical: 5,
//                                           ),
//                                           height: bloc.isFullScreen ? 42 : 29.5,
//                                           width: bloc.isFullScreen ? 50 : 46,
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(
//                                               5,
//                                             ),
//                                             color: const Color.fromARGB(
//                                               255,
//                                               51,
//                                               51,
//                                               51,
//                                             ).withValues(alpha: 0.5),
//                                           ),
//                                           child: Icon(
//                                             Icons.fullscreen,
//                                             color: Colors.white,
//                                             size: 20,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                       ),
            
//                       ///setting view
//                       ValueListenableBuilder(
//                         valueListenable: bloc.showControl,
//                         builder:
//                             (
//                               BuildContext context,
//                               bool value,
//                               Widget? child,
//                             ) => Positioned(
//                               top: 10,
//                               right: 10,
//                               child: AnimatedOpacity(
//                                 duration: Duration(milliseconds: 300),
//                                 alwaysIncludeSemantics: true,
//                                 opacity: value ? 1 : 0,
//                                 child: IgnorePointer(
//                                   ignoring: !value,
//                                   child: Row(
//                                     children: [
//                                       //mute
//                                       InkWell(
//                                         onTap: () {
//                                           bloc.toggleMute();
//                                         },
//                                         child: Container(
//                                           margin: EdgeInsets.symmetric(
//                                             horizontal: 5,
//                                             vertical: 5,
//                                           ),
//                                           height: bloc.isFullScreen ? 42 : 29.5,
//                                           width: bloc.isFullScreen ? 50 : 46,
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(
//                                               5,
//                                             ),
//                                             color: const Color.fromARGB(
//                                               255,
//                                               51,
//                                               51,
//                                               51,
//                                             ).withValues(alpha: 0.5),
//                                           ),
//                                           child: Icon(
//                                             bloc.isMuted == true
//                                                 ? CupertinoIcons
//                                                     .speaker_slash_fill
//                                                 : CupertinoIcons.speaker_2_fill,
//                                             color: Colors.white,
//                                             size: 20,
//                                           ),
//                                         ),
//                                       ),
            
//                                       //setting
//                                       InkWell(
//                                         onTap:
//                                             () => showModalBottomSheet(
//                                               backgroundColor:
//                                                   Colors.transparent,
//                                               context: context,
//                                               builder: (_) {
//                                                 return _qualityModalSheet();
//                                               },
//                                             ),
//                                         child: Container(
//                                           margin: EdgeInsets.symmetric(
//                                             horizontal: 5,
//                                             vertical: 5,
//                                           ),
//                                           height: bloc.isFullScreen ? 42 : 29.5,
//                                           width: bloc.isFullScreen ? 50 : 46,
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(
//                                               5,
//                                             ),
//                                             color: const Color.fromARGB(
//                                               255,
//                                               51,
//                                               51,
//                                               51,
//                                             ).withValues(alpha: 0.5),
//                                           ),
//                                           child: Icon(
//                                             Icons.settings,
//                                             color: Colors.white,
//                                             size: 20,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                       ),
            
//                       ///slider
//                       ValueListenableBuilder(
//                         valueListenable: bloc.showControl,
//                         builder:
//                             (
//                               BuildContext context,
//                               bool value,
//                               Widget? child,
//                             ) => Positioned(
//                               bottom: 0,
//                               left: 0,
//                               right: 0,
//                               child: AnimatedOpacity(
//                                 duration: Duration(milliseconds: 300),
//                                 alwaysIncludeSemantics: true,
//                                 opacity: value ? 1 : 0,
//                                 child: IgnorePointer(
//                                   ignoring: !value,
//                                   child: Container(
//                                     padding: EdgeInsets.only(left: 16),
//                                     margin: EdgeInsets.all(14),
//                                     width:
//                                         MediaQuery.of(context).size.width - 20,
//                                     height: 25,
//                                     decoration: BoxDecoration(
//                                       color: const Color.fromARGB(
//                                         255,
//                                         51,
//                                         51,
//                                         51,
//                                       ).withValues(alpha: 0.5),
//                                       borderRadius: BorderRadius.circular(16),
//                                     ),
//                                     child: Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         // Time Labels (Current Time - Total Time)
//                                         ValueListenableBuilder(
//                                           valueListenable:
//                                               bloc.videoPlayerController,
//                                           builder: (
//                                             context,
//                                             VideoPlayerValue value,
//                                             child,
//                                           ) {
//                                             final position = value.position;
            
//                                             return Text(
//                                               "${_formatDuration(position)} / ${_formatDuration(bloc.videoPlayerController.value.duration)}",
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 12,
//                                               ),
//                                             );
//                                           },
//                                         ),
            
//                                         ValueListenableBuilder(
//                                           valueListenable:
//                                               bloc.videoPlayerController,
//                                           builder: (
//                                             context,
//                                             VideoPlayerValue value,
//                                             child,
//                                           ) {
//                                             final duration = value.duration;
//                                             final position = value.position;
            
//                                             double progress = 0.0;
//                                             if (duration.inMilliseconds > 0 &&
//                                                 !bloc.isSeeking) {
//                                               progress =
//                                                   position.inMilliseconds /
//                                                   duration.inMilliseconds;
//                                               progress =
//                                                   progress.isNaN ||
//                                                           progress < 0.0
//                                                       ? 0.0
//                                                       : (progress > 1.0
//                                                           ? 1.0
//                                                           : progress);
//                                             } else {
//                                               progress =
//                                                   bloc.manualSeekProgress;
//                                             }
            
//                                             double bufferedProgress = 0.0;
//                                             if (value.buffered.isNotEmpty) {
//                                               bufferedProgress =
//                                                   value
//                                                       .buffered
//                                                       .last
//                                                       .end
//                                                       .inMilliseconds /
//                                                   duration.inMilliseconds;
//                                               bufferedProgress =
//                                                   bufferedProgress.isNaN ||
//                                                           bufferedProgress < 0.0
//                                                       ? 0.0
//                                                       : (bufferedProgress > 1.0
//                                                           ? 1.0
//                                                           : bufferedProgress);
//                                             }
//                                             return Expanded(
//                                               child: SliderTheme(
//                                                 data: SliderTheme.of(
//                                                   context,
//                                                 ).copyWith(
//                                                   trackHeight: 3.0,
//                                                   inactiveTrackColor: Colors
//                                                       .white
//                                                       .withValues(
//                                                         alpha: 0.5,
//                                                       ), // Default track
//                                                   activeTrackColor: Colors.red,
            
//                                                   thumbColor: Colors.red,
            
//                                                   thumbShape:
//                                                       RoundSliderThumbShape(
//                                                         enabledThumbRadius: 6.0,
//                                                       ),
//                                                 ),
//                                                 child: Stack(
//                                                   children: [
//                                                     Positioned.fill(
//                                                       child: SliderTheme(
//                                                         data: SliderTheme.of(
//                                                           context,
//                                                         ).copyWith(
//                                                           trackHeight: 2.0,
//                                                           activeTrackColor: Colors
//                                                               .white
//                                                               .withValues(
//                                                                 alpha: 0.5,
//                                                               ), // Buffer color
//                                                           inactiveTrackColor:
//                                                               Colors
//                                                                   .transparent,
//                                                           thumbShape:
//                                                               RoundSliderThumbShape(
//                                                                 enabledThumbRadius:
//                                                                     0.0,
//                                                               ), // Hide thumb
//                                                         ),
//                                                         child: Slider(
//                                                           value:
//                                                               bufferedProgress,
//                                                           onChanged:
//                                                               (double value) {},
//                                                         ),
//                                                       ),
//                                                     ),
            
//                                                     // Actual Seekable Progress Bar
//                                                     Slider(
//                                                       value: progress,
//                                                       onChanged: (
//                                                         newValue,
//                                                       ) async {
//                                                         bloc.resetControlVisibility();
//                                                         setState(() {
//                                                           bloc.isSeeking = true;
//                                                           bloc.manualSeekProgress =
//                                                               newValue;
//                                                         });
//                                                       },
//                                                       onChangeStart: (value) {
//                                                         bloc.videoPlayerController
//                                                             .pause();
//                                                         bloc.startSeekUpdateLoop();
//                                                         bloc.resetControlVisibility();
//                                                       },
//                                                       onChangeEnd: (
//                                                         value,
//                                                       ) async {
//                                                         bloc.seekUpdateTimer
//                                                             ?.cancel(); // Stop the update loop
            
//                                                         final newPosition =
//                                                             Duration(
//                                                               milliseconds:
//                                                                   (duration.inMilliseconds *
//                                                                           value)
//                                                                       .toInt(),
//                                                             );
            
//                                                         await bloc
//                                                             .videoPlayerController
//                                                             .seekTo(
//                                                               newPosition,
//                                                             );
            
//                                                         setState(() {
//                                                           bloc.videoPlayerController
//                                                               .play();
//                                                           bloc.isSeeking =
//                                                               false;
//                                                         });
            
//                                                         bloc.resetControlVisibility();
//                                                       },
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                       ),
//                     ],
//                   ),
//                 ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Helper Function to Format Duration
//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     String minutes = twoDigits(duration.inMinutes.remainder(60));
//     String seconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$minutes:$seconds";
//   }

//   Widget _qualityModalSheet() {
//     return Consumer<VideoBloc>(
//       builder:
//           (context, bloc, child) => Container(
//             margin: EdgeInsets.only(bottom: 40, left: 20, right: 20),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: Colors.white,
//             ),
//             padding: EdgeInsets.symmetric(horizontal: 20),
//             height: null,
//             width: MediaQuery.of(context).size.width,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SizedBox(height: 20),
//                   Text(
//                     'Choose Quality',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),

//                   ListView.builder(
//                     physics: NeverScrollableScrollPhysics(),
//                     padding: EdgeInsets.only(top: 10),
//                     shrinkWrap: true,
//                     itemCount: bloc.qualityOptions.length + 1,
//                     itemBuilder: (context, index) {
//                       if (index == 0) {
//                         return Padding(
//                           padding: const EdgeInsets.only(bottom: 5),
//                           child: SizedBox(
//                             height: 35,
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.pop(context);
//                                 if (selectedQuality == 'Auto') return;
//                                 bloc.changeQuality(bloc.m3u8Url, 'Auto');
//                               },
//                               child: Row(
//                                 children: [
//                                   selectedQuality == 'Auto'
//                                       ? SizedBox(
//                                         width: 30,
//                                         child: Icon(
//                                           CupertinoIcons.checkmark,
//                                           color: Colors.green,
//                                           size: 18,
//                                         ),
//                                       )
//                                       : SizedBox(width: 30),
//                                   Text(
//                                     'Auto (recommanded)',
//                                     style: TextStyle(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       }
//                       int qualityIndex = index - 1;
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 5),
//                         child: InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                             String selectedUrl =
//                                 bloc.qualityOptions.firstWhere(
//                                   (element) =>
//                                       element['quality'] ==
//                                       bloc.qualityOptions[qualityIndex]['quality'],
//                                 )['url']!;
//                             if ((selectedQuality ==
//                                 (bloc.qualityOptions[qualityIndex]['quality'] ??
//                                     ''))) {
//                               return;
//                             }

//                             bloc.changeQuality(
//                               selectedUrl,
//                               bloc.qualityOptions[qualityIndex]['quality'] ??
//                                   '',
//                             );
//                           },
//                           child: SizedBox(
//                             height: 35,
//                             child: Row(
//                               children: [
//                                 selectedQuality ==
//                                         (bloc.qualityOptions[qualityIndex]['quality'] ??
//                                             '')
//                                     ? SizedBox(
//                                       width: 30,
//                                       child: Icon(
//                                         CupertinoIcons.checkmark,
//                                         color: Colors.green,
//                                         size: 18,
//                                       ),
//                                     )
//                                     : SizedBox(width: 30),
//                                 Text(
//                                   bloc.qualityOptions[qualityIndex]['quality'] ??
//                                       '',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w400,
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//     );
//   }
// }

// SizedBox(height: 20),
//                   GestureDetector(
//                     behavior: HitTestBehavior.opaque,
//                     onTap: () {
//                       Navigator.pop(context);
//                       bloc.showControl.value = false;
//                       bloc.isLockScreen = true;
//                       bloc.showLock.value = true;
//                       bloc.playPlayer();
//                       bloc.updateListener();
//                       if (bloc.isFullScreen == true) return;
//                       bloc.toggleFullScreen(isLock: true);
//                     },
//                     child: _buildAdditionalRow(
//                       'Lock Screen',
//                       '',
//                       CupertinoIcons.lock_circle,
//                     ),
//                   ),


//  ValueListenableBuilder(
//                                                               valueListenable:
//                                                                   bloc.showLock,
//                                                               builder:
//                                                                   (
//                                                                     context,
//                                                                     value,
//                                                                     child,
//                                                                   ) => Positioned(
//                                                                     bottom: 20,
//                                                                     child: AnimatedOpacity(
//                                                                       opacity:
//                                                                           value
//                                                                               ? 1
//                                                                               : 0,
//                                                                       duration: Duration(
//                                                                         milliseconds:
//                                                                             200,
//                                                                       ),
//                                                                       child: InkWell(
//                                                                         onTap: () {
//                                                                           bloc.showLock.value =
//                                                                               false;
//                                                                           bloc.isLockScreen =
//                                                                               false;
//                                                                           bloc.showControl.value =
//                                                                               true;
//                                                                           bloc.resetControlVisibility();
//                                                                         },
//                                                                         child: Container(
//                                                                           height:
//                                                                               30,
//                                                                           padding: EdgeInsets.symmetric(
//                                                                             horizontal:
//                                                                                 10,
//                                                                           ),
//                                                                           decoration: BoxDecoration(
//                                                                             borderRadius: BorderRadius.circular(
//                                                                               20,
//                                                                             ),
//                                                                             color:
//                                                                                 Colors.white,
//                                                                             boxShadow: [
//                                                                               BoxShadow(
//                                                                                 blurRadius:
//                                                                                     4,
//                                                                                 color: const Color.fromARGB(
//                                                                                   255,
//                                                                                   195,
//                                                                                   195,
//                                                                                   195,
//                                                                                 ),
//                                                                               ),
//                                                                             ],
//                                                                           ),
//                                                                           child: Row(
//                                                                             spacing:
//                                                                                 5,
//                                                                             children: [
//                                                                               Icon(
//                                                                                 CupertinoIcons.lock,
//                                                                                 color:
//                                                                                     Colors.black,
//                                                                                 size:
//                                                                                     20,
//                                                                               ),
//                                                                               Text(
//                                                                                 'Tap to unlock.',
//                                                                                 style: TextStyle(
//                                                                                   fontSize:
//                                                                                       14,
//                                                                                   fontWeight:
//                                                                                       FontWeight.w400,
//                                                                                 ),
//                                                                               ),
//                                                                             ],
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                             ),

//bool _wasScreenOff = false;

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (Platform.isAndroid) {
  //     if (state == AppLifecycleState.resumed) {
  //       if (_elapsedSeconds > 60) {
  //         bloc.changeQuality(bloc.currentUrl);
  //         bloc.updateListener();
  //       }
  //       _stopTimer();
  //       if (_wasScreenOff) {
  //         bloc.isLockScreen = false;
  //         bloc.showLock.value = false;
  //         if (chewieControllerNotifier?.value.isPlaying ?? true) {
  //           chewieControllerNotifier?.value.play();
  //         } else {
  //           chewieControllerNotifier?.value.pause();
  //         }
  //         bloc.updateListener();
  //       }
  //       _wasScreenOff = false;
  //     } else if (state == AppLifecycleState.paused) {
  //       _wasScreenOff = true;

  //       bloc.pausedPlayer();
  //       bloc.changeQuality(bloc.currentUrl);
  //       chewieControllerNotifier?.value.pause();
  //       bloc.updateListener();
  //       setState(() {});
  //     } else if (state == AppLifecycleState.inactive) {
  //       if (_timer == null) {
  //         _startTimer();
  //       }
  //       if (chewieControllerNotifier?.value.isPlaying ?? true) {
  //         chewieControllerNotifier?.value.play();
  //       } else {
  //         chewieControllerNotifier?.value.pause();
  //       }
  //       _wasScreenOff = true;
  //       bloc.updateListener();
  //       setState(() {});
  //     }
  //   } else {
  //     if (state == AppLifecycleState.resumed) {
  //       bloc.isLockScreen = false;
  //       bloc.showLock.value = false;
  //       bloc.updateListener();
  //       setState(() {});
  //     } else {
  //       bloc.pausedPlayer();
  //       bloc.updateListener();
  //     }
  //   }
  // }

  // void _startTimer() {
  //   if (_timer != null) {
  //     return;
  //   }

  //   _elapsedSeconds = 0;

  //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     _elapsedSeconds++;
  //   });
  // }

  // void _stopTimer() {
  //   if (_timer != null) {
  //     _timer?.cancel();
  //     _timer = null;
  //   }




  // onVerticalDragUpdate: (details) {
                  //   if (bloc.isLockScreen == true) return;
                  //   if (bloc.isFullScreen) {
                  //     double newDragOffset =
                  //         bloc.dragOffset + details.delta.dy;
                  //     double maxDragOffset = 0;
                  //     double minDragOffset = bloc.dragThreshold;

                  //     bloc.dragOffset = newDragOffset.clamp(
                  //       maxDragOffset,
                  //       minDragOffset,
                  //     );

                  //     if (bloc.dragOffset == 0.0 || bloc.dragOffset < 10) {
                  //     } else {
                  //       bloc.onVerticalDragUpdateFullScreen(details);
                  //     }
                  //   } else {
                  //     bloc.onVerticalDragUpdate(details);
                  //   }
                  // },
                  // onVerticalDragEnd: (details) {
                  //   if (bloc.isLockScreen == true) return;
                  //   if (bloc.isFullScreen) {
                  //     if (bloc.dragOffset >= bloc.dragThreshold) {
                  //       bloc.toggleFullScreen(); // Exit fullscreen if dragged enough
                  //     } else {
                  //       bloc.scale = 1.0;
                  //       bloc.dragOffset =
                  //           0.0; // Reset position if not dragged enough
                  //       bloc.updateListener();
                  //     }
                  //   } else {
                  //     bloc.onVerticalDragEnd(details);
                  //   }
                  // },

                  // onPanStart: (details) {
                  //   if (bloc.isLockScreen == true) return;

                  //   bloc.initialPosition =
                  //       details
                  //           .localPosition
                  //           .dy; // Capture initial drag position
                  //   bloc.initialScale = bloc.scale;
                  // },



                    // onVerticalDragStart:
                        //     (details) => bloc.onVerticalDragStart(details),

                        // onVerticalDragUpdate: (details) {
                        //   if (bloc.isLockScreen == true) return;
                        //   if (bloc.isFullScreen) {
                        //     double newDragOffset =
                        //         bloc.dragOffset + details.delta.dy;
                        //     double maxDragOffset = 0;
                        //     double minDragOffset = bloc.dragThreshold;

                        //     bloc.dragOffset = newDragOffset.clamp(
                        //       maxDragOffset,
                        //       minDragOffset,
                        //     );

                        //     if (bloc.dragOffset == 0.0 ||
                        //         bloc.dragOffset < 10) {
                        //     } else {
                        //       bloc.onVerticalDragUpdateFullScreen(details);
                        //     }
                        //   } else {
                        //     bloc.onVerticalDragUpdate(details);
                        //   }
                        // },
                        // onVerticalDragEnd: (details) {
                        //   if (bloc.isLockScreen == true) return;
                        //   if (bloc.isFullScreen) {
                        //     if (bloc.dragOffset >= bloc.dragThreshold) {
                        //       bloc.toggleFullScreen();
                        //     } else {
                        //       bloc.scale = 1.0;
                        //       bloc.dragOffset = 0.0;
                        //       bloc.updateListener();
                        //     }
                        //   } else {
                        //     bloc.onVerticalDragEnd(details);
                        //   }
                        // },

                        // onPanStart: (details) {
                        //   if (bloc.isLockScreen == true) return;

                        //   bloc.initialPosition =
                        //       details
                        //           .localPosition
                        //           .dy; // Capture initial drag position
                        //   bloc.initialScale = bloc.scale;
                        // },

  // }