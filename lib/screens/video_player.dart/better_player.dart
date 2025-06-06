// import 'package:flutter/material.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart';

// class VideoScreen extends StatefulWidget {
//   const VideoScreen({super.key});

//   @override
//   State<VideoScreen> createState() => _VideoScreenState();
// }

// class _VideoScreenState extends State<VideoScreen> {
//   late final player = Player();
//   late final videoController = VideoController(player);

//   @override
//   void initState() {
//     super.initState();
//     player.open(
//       Media(
//         "https://moviedatatesting.s3.ap-southeast-1.amazonaws.com/output_test+10min/master.m3u8",
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     player.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("MediaKit Video")),
//       body: Center(child: Video(controller: videoController)),
//     );
//   }
// }
