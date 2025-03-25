// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:movie_obs/bloc/video_bloc.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
// import 'package:http/http.dart' as http;
// import 'package:wakelock_plus/wakelock_plus.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// String selectedQuality = 'Auto';
// final ValueNotifier<bool> showControl = ValueNotifier(false);
// final ValueNotifier<bool> userAction = ValueNotifier(false);

// ValueNotifier<bool> isHoveringLeft = ValueNotifier(false);
// ValueNotifier<bool> isHoveringRight = ValueNotifier(false);

// final ValueNotifier<bool> loadingOverlay = ValueNotifier(false);
// late VideoPlayerController _videoPlayerController;
// ValueNotifier<ChewieController>? _chewieControllerNotifier;

// class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
//   bool _wasScreenOff = false;
//   bool isMuted = false;
//   bool _isFullScreen = false;
//   bool hasPrinted = false;
//   Timer? _hideControlTimer;
//   double _manualSeekProgress = 0.0;
//   bool _isSeeking = false;
//   Timer? _seekUpdateTimer;
//   double _dragOffset = 0.0; // Track vertical drag
//   final double _dragThreshold = 100.0; // Distance needed to exit fullscreen

//   bool isLoading = false;
//   List<Map<String, String>> qualityOptions = [];
//   String m3u8Url =
//       'https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8';
//   String currentUrl =
//       'https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8';

//   double _scale = 1.0; // Initial scale of the video
//   double _initialScale = 1.0; // Scale at the start of the drag
//   double _initialPosition = 0.0; // Initial position of the drag

//   // Maximum and minimum scaling limits (like YouTube)
//   final double _minScale = 1.0;
//   final double _maxScale = 2.0; // Set a reasonable maximum zoom level

//   // Drag update callback to scale the video player
//   void _onVerticalDragUpdate(DragUpdateDetails details) {
//     setState(() {
//       double scaleChange =
//           (_initialPosition - details.localPosition.dy) /
//           100; // Adjust sensitivity
//       _scale = (_initialScale + scaleChange).clamp(_minScale, _maxScale);
//     });
//   }

//   void _onVerticalDragEnd(DragEndDetails details) {
//     setState(() {
//       _initialScale = _scale;
//       if (_initialScale == 1.0) return;
//       _toggleFullScreen();
//     });
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (Platform.isAndroid) {
//       if (state == AppLifecycleState.resumed) {
//         if (_wasScreenOff) {
//           setState(() {
//             _videoPlayerController.pause();
//           });

//           _changeQuality(currentUrl);
//         }
//         _wasScreenOff = false;
//       } else if (state == AppLifecycleState.inactive) {
//         _wasScreenOff = true;
//         _videoPlayerController.pause();
//       }
//     } else {
//       if (state == AppLifecycleState.resumed) {
//         _videoPlayerController.pause();
//         _resetControlVisibility();
//       } else if (state == AppLifecycleState.inactive) {
//         setState(() {
//           _videoPlayerController.pause();
//         });
//       }
//     }
//   }

// } else if (state == AppLifecycleState.paused) {
//         _wasScreenOff = true;

//         bloc.pausedPlayer();
//         bloc.changeQuality(bloc.currentUrl);
//         bloc.chewieControllerNotifier?.value.pause();
//         bloc.updateListener();
//       } else if (state == AppLifecycleState.inactive) {
//         if (_timer == null) {
//           _startTimer();
//         }
//         if (bloc.chewieControllerNotifier?.value.isPlaying ?? true) {
//           bloc.chewieControllerNotifier?.value.play();
//         } else {
//           bloc.chewieControllerNotifier?.value.pause();
//         }
//         bloc.updateListener();
//       }
//     } el

//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);
//     _initializeVideo(m3u8Url);
//     super.initState();
//   }

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
//           int height = int.parse(match.group(2)!);

//           // Get video height (e.g., 1080)
//           String url = match.group(3) ?? '';

//           String qualityLabel = _getQualityLabel(height);

//           // Convert relative URLs to absolute
//           if (!url.startsWith('http')) {
//             Uri masterUri = Uri.parse(m3u8Url);
//             url = Uri.parse(masterUri.resolve(url).toString()).toString();
//           }

//           qualities.add({'quality': qualityLabel, 'url': url});
//         }

//         qualityOptions = qualities;
//       }
//     } catch (e) {
//       debugPrint("Error fetching M3U8: $e");
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
//     _videoPlayerController = VideoPlayerController.networkUrl(
//       Uri.parse(url),
//       videoPlayerOptions: VideoPlayerOptions(
//         allowBackgroundPlayback: true,
//         mixWithOthers: true,
//       ),
//     );
//     _videoPlayerController.initialize().then((_) {
//       if (!mounted) return;
//       setState(() {
//         _chewieControllerNotifier = ValueNotifier(
//           ChewieController(
//             videoPlayerController: _videoPlayerController,
//             showControls: false,
//             allowedScreenSleep: false,
//             autoInitialize: true,
//           ),
//         );
//         _fetchQualityOptions();
//       });

//       _videoPlayerController.addListener(() {
//         if (_videoPlayerController.value.isPlaying == true) {
//           WakelockPlus.enable();
//           if (!hasPrinted) {
//             hasPrinted = true;
//             _resetControlVisibility();
//           }
//         } else {
//           WakelockPlus.disable();
//           setState(() {
//             hasPrinted = false;
//             showControl.value = true;
//           });
//         }
//       });
//     });
//   }

//   ///reset play state (android only)
//   void _resetControlVisibility() {
//     showControl.value = true;

//     // Cancel the previous timer before creating a new one
//     _hideControlTimer?.cancel();
//     _hideControlTimer = Timer(const Duration(seconds: 3), () {
//       if (_videoPlayerController.value.isPlaying == true) {
//         showControl.value = false;
//       } else {
//         showControl.value = true;
//       }
//     });
//   }

//   //quality change
//   void _changeQuality(String url, [String? quality]) async {
//     setState(() {
//       userAction.value = true;
//     });

//     selectedQuality = quality ?? selectedQuality;
//     currentUrl = url;
//     final currentPosition = _videoPlayerController.value.position;
//     final wasPlaying = _videoPlayerController.value.isPlaying;

//     await _videoPlayerController.dispose();

//     _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));

//     await _videoPlayerController.initialize();
//     _videoPlayerController.seekTo(currentPosition).then((_) {
//       setState(() {
//         userAction.value = false;
//       });
//     });
//     _chewieControllerNotifier?.value = ChewieController(
//       videoPlayerController: _videoPlayerController,
//       showControls: false,
//       allowedScreenSleep: false,
//     );
//     if (wasPlaying) {
//       _videoPlayerController.play();
//     } else {
//       _videoPlayerController.pause();
//     }
//     _videoPlayerController.setVolume(isMuted ? 0.0 : 1.0);
//     _resetControlVisibility();
//   }

//Orientation? _lastOrientation;

  // void _checkOrientation() {
  //   final Size screenSize =
  //       WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
  //   final Orientation newOrientation =
  //       screenSize.width > screenSize.height
  //           ? Orientation.landscape
  //           : Orientation.portrait;

  //   // ✅ Prevent re-triggering fullscreen if already in fullscreen due to rotation
  //   if (_lastOrientation == newOrientation) return; // No change, return early

  //   _lastOrientation = newOrientation;

  //   // ✅ Prevent auto-switching when already in fullscreen mode
  //   if (isFullScreen && newOrientation == Orientation.landscape) return;

  //   bloc.updateOrientation(_lastOrientation!);
  // }

  // @override
  // void didChangeMetrics() {
  //   super.didChangeMetrics();
  //   _checkOrientation();
  // }

//   //toggle full screen
//   void _toggleFullScreen() {
//     setState(() {
//       _isFullScreen = !_isFullScreen;
//       _initialPosition = 0.0;
//       _scale = 1.0;
//       _initialScale = 1.0;
//       _dragOffset = 0.0;
//     });

//     if (_isFullScreen) {
//       // Lock in landscape mode
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.landscapeRight,
//         DeviceOrientation.landscapeLeft,
//       ]);
//       SystemChrome.setEnabledSystemUIMode(
//         SystemUiMode.immersive,
//       ); // Hide UI for fullscreen
//     } else {
//       // Restore default orientation behavior
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.portraitUp,
//         DeviceOrientation.portraitDown,
//       ]);
//       SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive); // Restore UI
//     }
//     _resetControlVisibility();
//   }

//   // Function to toggle mute/unmute
//   void _toggleMute() {
//     setState(() {
//       isMuted = !isMuted;
//       _videoPlayerController.setVolume(isMuted ? 0.0 : 1.0);
//     });
//     _resetControlVisibility();
//   }

//   void _seekBackward() {
//     final currentPosition = _videoPlayerController.value.position;
//     final seekDuration = Duration(seconds: 10);
//     final newPosition = currentPosition - seekDuration;

//     if (newPosition > Duration.zero) {
//       _videoPlayerController.seekTo(newPosition);
//     } else {
//       _videoPlayerController.seekTo(
//         Duration.zero,
//       ); // Don't seek past the start of the video
//     }
//   }

//   void _seekForward() {
//     final currentPosition = _videoPlayerController.value.position;
//     final seekDuration = Duration(seconds: 10);
//     final newPosition = currentPosition + seekDuration;

//     if (newPosition < _videoPlayerController.value.duration) {
//       _videoPlayerController.seekTo(newPosition);
//     } else {
//       _videoPlayerController.seekTo(
//         _videoPlayerController.value.duration,
//       ); // Don't seek past the end of the video
//     }
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _videoPlayerController.dispose();
//     _chewieControllerNotifier?.value.dispose();
//     isHoveringLeft.dispose();
//     isHoveringRight.dispose();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     _hideControlTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       body: Center(
//         child: Consumer<VideoBloc>(
//           builder: (context, value, child) => 
//            _chewieControllerNotifier == null
//               ? CircularProgressIndicator()
//               : AnimatedContainer(
//                 duration: Duration(milliseconds: 300),
//                 color: Colors.black,
//                 height:
//                     _isFullScreen == true
//                         ? MediaQuery.of(context).size.height
//                         : 250,
//                 width: MediaQuery.of(context).size.width,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     GestureDetector(
//                       behavior: HitTestBehavior.opaque,
//                       onDoubleTapDown: (details) {
//                         final screenWidth = MediaQuery.of(context).size.width;
//                         final tapPosition = details.localPosition.dx;
          
//                         //disable tap while user change quality
//                         if (userAction.value == true) return;
//                         if (tapPosition < screenWidth / 2) {
//                           _seekBackward();
//                           isHoveringLeft.value = true;
//                           isHoveringRight.value = false;
//                         } else {
//                           _seekForward();
//                           isHoveringRight.value = true;
//                           isHoveringLeft.value = false;
//                         }
//                       },
          
//                       onVerticalDragUpdate: (details) {
//                         _onVerticalDragUpdate(details);
//                         if (_isFullScreen && details.delta.dy > 0) {
//                           setState(() {
//                             _dragOffset += details.delta.dy; // Move video down
//                           });
//                         }
//                       },
//                       onVerticalDragEnd: (details) {
//                         if (_isFullScreen) {
//                           if (_dragOffset > _dragThreshold) {
//                             _toggleFullScreen();
//                           } else {
//                             setState(() {
//                               _dragOffset =
//                                   0.0; // Reset position if not enough drag
//                             });
//                           }
//                         } else {
//                           _onVerticalDragEnd(details);
//                         }
//                       },
//                       onPanStart: (details) {
//                         _initialPosition =
//                             details
//                                 .localPosition
//                                 .dy; // Capture initial drag position
//                         _initialScale = _scale;
//                       },
          
//                       onDoubleTap: () {
//                         if (userAction.value == true) return;
//                         Future.delayed(Duration(milliseconds: 100), () {
//                           isHoveringRight.value = false;
//                           isHoveringLeft.value = false;
//                         });
//                       },
//                       onTap: () {
//                         _resetControlVisibility();
//                       },
//                       child: ValueListenableBuilder(
//                         valueListenable: _chewieControllerNotifier!,
//                         builder:
//                             (
//                               BuildContext context,
//                               ChewieController? value,
//                               Widget? child,
//                             ) => Center(
//                               child: Transform.scale(
//                                 scale: _scale,
//                                 child: AnimatedContainer(
//                                   transform: Matrix4.translationValues(
//                                     0,
//                                     _dragOffset,
//                                     0,
//                                   ),
//                                   duration: Duration(milliseconds: 200),
//                                   child: Stack(
//                                     alignment: Alignment.center,
//                                     children: [
//                                       Chewie(controller: value!),
//                                       //hover left
//                                       Positioned(
//                                         child: ValueListenableBuilder<bool>(
//                                           valueListenable: isHoveringLeft,
//                                           builder: (
//                                             context,
//                                             hoveringLeft,
//                                             child,
//                                           ) {
//                                             return AnimatedOpacity(
//                                               opacity: hoveringLeft ? 0.3 : 0,
//                                               duration: Duration(
//                                                 milliseconds: 300,
//                                               ),
//                                               child: Container(
//                                                 width:
//                                                     MediaQuery.sizeOf(
//                                                       context,
//                                                     ).width *
//                                                     0.3,
          
//                                                 decoration: BoxDecoration(
//                                                   color:
//                                                       hoveringLeft
//                                                           ? Colors.blue
//                                                               .withValues(
//                                                                 alpha: 0.9,
//                                                               )
//                                                           : Colors.transparent,
//                                                   borderRadius: BorderRadius.only(
//                                                     topRight: Radius.circular(
//                                                       _isFullScreen
//                                                           ? MediaQuery.sizeOf(
//                                                                 context,
//                                                               ).width /
//                                                               3
//                                                           : 125,
//                                                     ),
//                                                     bottomRight: Radius.circular(
//                                                       _isFullScreen
//                                                           ? MediaQuery.sizeOf(
//                                                                 context,
//                                                               ).width /
//                                                               3
//                                                           : 125,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                       Positioned(
//                                         child: ValueListenableBuilder<bool>(
//                                           valueListenable: isHoveringRight,
//                                           builder: (
//                                             context,
//                                             hoverRight,
//                                             child,
//                                           ) {
//                                             return AnimatedOpacity(
//                                               opacity: hoverRight ? 0.3 : 0,
//                                               duration: Duration(
//                                                 milliseconds: 300,
//                                               ),
//                                               child: Align(
//                                                 alignment:
//                                                     Alignment.centerRight,
//                                                 child: Container(
//                                                   width:
//                                                       MediaQuery.sizeOf(
//                                                         context,
//                                                       ).width *
//                                                       0.3,
          
//                                                   decoration: BoxDecoration(
//                                                     color:
//                                                         hoverRight
//                                                             ? Colors.blue
//                                                                 .withValues(
//                                                                   alpha: 0.8,
//                                                                 )
//                                                             : Colors
//                                                                 .transparent,
//                                                     borderRadius: BorderRadius.only(
//                                                       bottomLeft: Radius.circular(
//                                                         _isFullScreen
//                                                             ? MediaQuery.sizeOf(
//                                                                   context,
//                                                                 ).width /
//                                                                 3
//                                                             : 125,
//                                                       ),
//                                                       topLeft: Radius.circular(
//                                                         _isFullScreen
//                                                             ? MediaQuery.sizeOf(
//                                                                   context,
//                                                                 ).width /
//                                                                 3
//                                                             : 125,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                       ),
//                     ),
          
//                     ///play pause view
//                     ValueListenableBuilder(
//                       valueListenable: showControl,
//                       builder:
//                           (
//                             BuildContext context,
//                             bool value,
//                             Widget? child,
//                           ) => AnimatedOpacity(
//                             duration: Duration(milliseconds: 300),
//                             opacity: value ? 1 : 0,
          
//                             child: IgnorePointer(
//                               ignoring: !value || userAction.value == true,
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 spacing: 12,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   // Seek Backward Button
//                                   IconButton.filled(
//                                     highlightColor: Colors.amber,
//                                     onPressed: () {
//                                       _resetControlVisibility();
          
//                                       if (_videoPlayerController
//                                           .value
//                                           .isInitialized) {
//                                         _seekBackward();
//                                       }
//                                     },
//                                     icon: Icon(CupertinoIcons.gobackward_10),
//                                     style: IconButton.styleFrom(
//                                       backgroundColor:
//                                           Colors
//                                               .grey, // Change the background color
//                                     ),
//                                   ),
          
//                                   // Play/Pause Button
//                                   IconButton.filled(
//                                     onPressed: () {
//                                       if (_videoPlayerController
//                                           .value
//                                           .isPlaying) {
//                                         _videoPlayerController.pause();
//                                       } else {
//                                         _videoPlayerController.play();
//                                       }
//                                       setState(() {});
//                                     },
//                                     icon: Icon(
//                                       _videoPlayerController.value.isPlaying
//                                           ? Icons.pause_circle
//                                           : Icons.play_arrow,
//                                       size: 40,
//                                     ),
//                                   ),
          
//                                   IconButton.filled(
//                                     highlightColor: Colors.amber,
//                                     onPressed: () {
//                                       _resetControlVisibility();
//                                       // Ensure the video is initialized before seeking
//                                       if (_videoPlayerController
//                                           .value
//                                           .isInitialized) {
//                                         _seekForward();
//                                       }
//                                     },
//                                     icon: Icon(CupertinoIcons.goforward_10),
//                                     style: IconButton.styleFrom(
//                                       backgroundColor:
//                                           Colors
//                                               .grey, // Change the background color
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                     ),
          
//                     ///full screen view
//                     ValueListenableBuilder(
//                       valueListenable: showControl,
//                       builder:
//                           (BuildContext context, bool value, Widget? child) =>
//                               Positioned(
//                                 top: 10,
//                                 left: 10,
//                                 child: AnimatedOpacity(
//                                   duration: Duration(milliseconds: 300),
//                                   alwaysIncludeSemantics: true,
//                                   opacity: value ? 1 : 0,
//                                   child: IgnorePointer(
//                                     ignoring: !value,
//                                     child: InkWell(
//                                       onTap: () => _toggleFullScreen(),
//                                       child: Container(
//                                         margin: EdgeInsets.symmetric(
//                                           horizontal: 5,
//                                           vertical: 5,
//                                         ),
//                                         height: _isFullScreen ? 42 : 29.5,
//                                         width: _isFullScreen ? 50 : 46,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(
//                                             5,
//                                           ),
//                                           color: const Color.fromARGB(
//                                             255,
//                                             51,
//                                             51,
//                                             51,
//                                           ).withValues(alpha: 0.5),
//                                         ),
//                                         child: Icon(
//                                           Icons.fullscreen,
//                                           color: Colors.white,
//                                           size: 20,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                     ),
          
//                     ///setting view
//                     ValueListenableBuilder(
//                       valueListenable: showControl,
//                       builder:
//                           (
//                             BuildContext context,
//                             bool value,
//                             Widget? child,
//                           ) => Positioned(
//                             top: 10,
//                             right: 10,
//                             child: AnimatedOpacity(
//                               duration: Duration(milliseconds: 300),
//                               alwaysIncludeSemantics: true,
//                               opacity: value ? 1 : 0,
//                               child: IgnorePointer(
//                                 ignoring: !value,
//                                 child: Row(
//                                   children: [
//                                     //mute
//                                     InkWell(
//                                       onTap: () {
//                                         _toggleMute();
//                                       },
//                                       child: Container(
//                                         margin: EdgeInsets.symmetric(
//                                           horizontal: 5,
//                                           vertical: 5,
//                                         ),
//                                         height: _isFullScreen ? 42 : 29.5,
//                                         width: _isFullScreen ? 50 : 46,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(
//                                             5,
//                                           ),
//                                           color: const Color.fromARGB(
//                                             255,
//                                             51,
//                                             51,
//                                             51,
//                                           ).withValues(alpha: 0.5),
//                                         ),
//                                         child: Icon(
//                                           isMuted == true
//                                               ? CupertinoIcons
//                                                   .speaker_slash_fill
//                                               : CupertinoIcons.speaker_2_fill,
//                                           color: Colors.white,
//                                           size: 20,
//                                         ),
//                                       ),
//                                     ),
          
//                                     //setting
//                                     InkWell(
//                                       onTap:
//                                           () => showModalBottomSheet(
//                                             backgroundColor: Colors.transparent,
//                                             context: context,
//                                             builder: (_) {
//                                               return _qualityModalSheet();
//                                             },
//                                           ),
//                                       child: Container(
//                                         margin: EdgeInsets.symmetric(
//                                           horizontal: 5,
//                                           vertical: 5,
//                                         ),
//                                         height: _isFullScreen ? 42 : 29.5,
//                                         width: _isFullScreen ? 50 : 46,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(
//                                             5,
//                                           ),
//                                           color: const Color.fromARGB(
//                                             255,
//                                             51,
//                                             51,
//                                             51,
//                                           ).withValues(alpha: 0.5),
//                                         ),
//                                         child: Icon(
//                                           Icons.settings,
//                                           color: Colors.white,
//                                           size: 20,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                     ),
          
//                     ///slider
//                     ValueListenableBuilder(
//                       valueListenable: showControl,
//                       builder:
//                           (
//                             BuildContext context,
//                             bool value,
//                             Widget? child,
//                           ) => Positioned(
//                             bottom: 0,
//                             left: 0,
//                             right: 0,
//                             child: AnimatedOpacity(
//                               duration: Duration(milliseconds: 300),
//                               alwaysIncludeSemantics: true,
//                               opacity: value ? 1 : 0,
//                               child: IgnorePointer(
//                                 ignoring: !value,
//                                 child: Container(
//                                   padding: EdgeInsets.only(left: 16),
//                                   margin: EdgeInsets.all(14),
//                                   width: MediaQuery.of(context).size.width - 20,
//                                   height: 25,
//                                   decoration: BoxDecoration(
//                                     color: const Color.fromARGB(
//                                       255,
//                                       51,
//                                       51,
//                                       51,
//                                     ).withValues(alpha: 0.5),
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                   child: Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                     children: [
//                                       // Time Labels (Current Time - Total Time)
//                                       ValueListenableBuilder(
//                                         valueListenable: _videoPlayerController,
//                                         builder: (
//                                           context,
//                                           VideoPlayerValue value,
//                                           child,
//                                         ) {
//                                           final position = value.position;
          
//                                           return Text(
//                                             "${_formatDuration(position)} / ${_formatDuration(_videoPlayerController.value.duration)}",
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 12,
//                                             ),
//                                           );
//                                         },
//                                       ),
          
//                                       ValueListenableBuilder(
//                                         valueListenable: _videoPlayerController,
//                                         builder: (
//                                           context,
//                                           VideoPlayerValue value,
//                                           child,
//                                         ) {
//                                           final duration = value.duration;
//                                           final position = value.position;
          
//                                           double progress = 0.0;
//                                           if (duration.inMilliseconds > 0 &&
//                                               !_isSeeking) {
//                                             progress =
//                                                 position.inMilliseconds /
//                                                 duration.inMilliseconds;
//                                             progress =
//                                                 progress.isNaN || progress < 0.0
//                                                     ? 0.0
//                                                     : (progress > 1.0
//                                                         ? 1.0
//                                                         : progress);
//                                           } else {
//                                             progress = _manualSeekProgress;
//                                           }
          
//                                           double bufferedProgress = 0.0;
//                                           if (value.buffered.isNotEmpty) {
//                                             bufferedProgress =
//                                                 value
//                                                     .buffered
//                                                     .last
//                                                     .end
//                                                     .inMilliseconds /
//                                                 duration.inMilliseconds;
//                                             bufferedProgress =
//                                                 bufferedProgress.isNaN ||
//                                                         bufferedProgress < 0.0
//                                                     ? 0.0
//                                                     : (bufferedProgress > 1.0
//                                                         ? 1.0
//                                                         : bufferedProgress);
//                                           }
//                                           return Expanded(
//                                             child: SliderTheme(
//                                               data: SliderTheme.of(
//                                                 context,
//                                               ).copyWith(
//                                                 trackHeight: 3.0,
//                                                 inactiveTrackColor: Colors.white
//                                                     .withValues(
//                                                       alpha: 0.5,
//                                                     ), // Default track
//                                                 activeTrackColor: Colors.red,
          
//                                                 thumbColor: Colors.red,
          
//                                                 thumbShape:
//                                                     RoundSliderThumbShape(
//                                                       enabledThumbRadius: 6.0,
//                                                     ),
//                                               ),
//                                               child: Stack(
//                                                 children: [
//                                                   Positioned.fill(
//                                                     child: SliderTheme(
//                                                       data: SliderTheme.of(
//                                                         context,
//                                                       ).copyWith(
//                                                         trackHeight: 2.0,
//                                                         activeTrackColor: Colors
//                                                             .white
//                                                             .withValues(
//                                                               alpha: 0.5,
//                                                             ), // Buffer color
//                                                         inactiveTrackColor:
//                                                             Colors.transparent,
//                                                         thumbShape:
//                                                             RoundSliderThumbShape(
//                                                               enabledThumbRadius:
//                                                                   0.0,
//                                                             ), // Hide thumb
//                                                       ),
//                                                       child: Slider(
//                                                         value: bufferedProgress,
//                                                         onChanged:
//                                                             (double value) {},
//                                                       ),
//                                                     ),
//                                                   ),
          
//                                                   // Actual Seekable Progress Bar
//                                                   Slider(
//                                                     value: progress,
//                                                     onChanged: (
//                                                       newValue,
//                                                     ) async {
//                                                       _resetControlVisibility();
//                                                       setState(() {
//                                                         _isSeeking = true;
//                                                         _manualSeekProgress =
//                                                             newValue;
//                                                       });
//                                                     },
//                                                     onChangeStart: (value) {
//                                                       _videoPlayerController
//                                                           .pause();
//                                                       _startSeekUpdateLoop();
//                                                       _resetControlVisibility();
//                                                     },
//                                                     onChangeEnd: (value) async {
//                                                       _seekUpdateTimer
//                                                           ?.cancel(); // Stop the update loop
          
//                                                       final newPosition = Duration(
//                                                         milliseconds:
//                                                             (duration.inMilliseconds *
//                                                                     value)
//                                                                 .toInt(),
//                                                       );
          
//                                                       await _videoPlayerController
//                                                           .seekTo(newPosition);
          
//                                                       setState(() {
//                                                         _videoPlayerController
//                                                             .play();
//                                                         _isSeeking = false;
//                                                       });
          
//                                                       _resetControlVisibility();
//                                                     },
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                     ),
//                   ],
//                 ),
//               ),
//         ),
//       ),
//     );
//   }

//   void _startSeekUpdateLoop() {
//     _seekUpdateTimer?.cancel(); // Ensure old timers are cleared
//     _seekUpdateTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
//       if (!_isSeeking) {
//         timer.cancel();
//       }
//       setState(() {}); // Force UI update every 50ms
//     });
//   }

//   /// Helper Function to Format Duration
//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     String minutes = twoDigits(duration.inMinutes.remainder(60));
//     String seconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$minutes:$seconds";
//   }

//   Widget _qualityModalSheet() {
//     return Container(
//       margin: EdgeInsets.only(bottom: 40, left: 20, right: 20),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.white,
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       height: null,
//       width: MediaQuery.of(context).size.width,
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 20),
//             Text(
//               'Choose Quality',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),

//             ListView.builder(
//               physics: NeverScrollableScrollPhysics(),
//               padding: EdgeInsets.only(top: 10),
//               shrinkWrap: true,
//               itemCount: qualityOptions.length + 1,
//               itemBuilder: (context, index) {
//                 if (index == 0) {
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 5),
//                     child: SizedBox(
//                       height: 35,
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.pop(context);
//                           if (selectedQuality == 'Auto') return;
//                           _changeQuality(m3u8Url, 'Auto');
//                         },
//                         child: Row(
//                           children: [
//                             selectedQuality == 'Auto'
//                                 ? SizedBox(
//                                   width: 30,
//                                   child: Icon(
//                                     CupertinoIcons.checkmark,
//                                     color: Colors.green,
//                                     size: 18,
//                                   ),
//                                 )
//                                 : SizedBox(width: 30),
//                             Text(
//                               'Auto (recommanded)',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//                 int qualityIndex = index - 1;
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 5),
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                       String selectedUrl =
//                           qualityOptions.firstWhere(
//                             (element) =>
//                                 element['quality'] ==
//                                 qualityOptions[qualityIndex]['quality'],
//                           )['url']!;
//                       if ((selectedQuality ==
//                           (qualityOptions[qualityIndex]['quality'] ?? ''))) {
//                         return;
//                       }

//                       _changeQuality(
//                         selectedUrl,
//                         qualityOptions[qualityIndex]['quality'] ?? '',
//                       );
//                     },
//                     child: SizedBox(
//                       height: 35,
//                       child: Row(
//                         children: [
//                           selectedQuality ==
//                                   (qualityOptions[qualityIndex]['quality'] ??
//                                       '')
//                               ? SizedBox(
//                                 width: 30,
//                                 child: Icon(
//                                   CupertinoIcons.checkmark,
//                                   color: Colors.green,
//                                   size: 18,
//                                 ),
//                               )
//                               : SizedBox(width: 30),
//                           Text(
//                             qualityOptions[qualityIndex]['quality'] ?? '',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w400,
//                               fontSize: 15,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
// ValueListenableBuilder(
//                             valueListenable: bloc.showVolume,
//                             builder:
//                                 (context, value, child) => Positioned(
//                                   right: 10,
//                                   child: Visibility(
//                                     visible: value == true ? true : false,
//                                     child: Row(
//                                       children: [
//                                         SizedBox(
//                                           height:
//                                               isFullScreen
//                                                   ? MediaQuery.sizeOf(
//                                                         context,
//                                                       ).height /
//                                                       1.5
//                                                   : 170,
//                                           child: RotatedBox(
//                                             quarterTurns:
//                                                 3, // Rotate the slider by 90 degrees (clockwise)
//                                             child: SliderTheme(
//                                               data: SliderTheme.of(
//                                                 context,
//                                               ).copyWith(
//                                                 trackHeight:
//                                                     2.0, // Set the thickness of the slider's track
//                                                 thumbShape:
//                                                     RoundSliderThumbShape(
//                                                       enabledThumbRadius: 7,
//                                                     ),
//                                               ),
//                                               child: Slider(
//                                                 value: bloc.volume,
//                                                 min: 0.0,
//                                                 max: 1.0,

//                                                 divisions:
//                                                     10, // Optional: Divides the slider into intervals
//                                                 onChanged: (newVolume) {
//                                                   bloc.showControl.value =
//                                                       false;
//                                                   setState(() {
//                                                     bloc.volume = newVolume;
//                                                     bloc.videoPlayerController
//                                                         .setVolume(newVolume);
//                                                   });
//                                                 },
//                                                 onChangeEnd: (value) {
//                                                   bloc.showVolume.value = false;
//                                                 },
//                                                 activeColor:
//                                                     Colors
//                                                         .blue, // Color of the active part of the slider
//                                                 inactiveColor:
//                                                     Colors
//                                                         .grey, // Color of the inactive part of the slider
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                           ),