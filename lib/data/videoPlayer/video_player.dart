import 'package:shared_preferences/shared_preferences.dart';

  
class VideoProgress {
  final String videoId;
  final Duration position;

  VideoProgress({required this.videoId, required this.position});

  Map<String, dynamic> toMap() {
    return {'videoId': videoId, 'position': position.inSeconds}; // Save position as seconds
  }

  static VideoProgress fromMap(Map<String, dynamic> map) {
    return VideoProgress(
      videoId: map['videoId'],
      position: Duration(seconds: map['position']), // Convert back to Duration
    );
  }
}

Future<void> saveVideoProgress(List<VideoProgress> videoList) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> videoData = videoList.map((video) {
    // Store the videoId and position in seconds as a string
    return '${video.videoId}:${video.position.inSeconds}';
  }).toList();
  await prefs.setStringList('videoProgress', videoData);
}

Future<List<VideoProgress>> loadVideoProgress() async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? videoData = prefs.getStringList('videoProgress');

  if (videoData == null) return [];

  return videoData.map((data) {
    final parts = data.split(':');
    return VideoProgress(
      videoId: parts[0],
      position: Duration(seconds: int.tryParse(parts[1]) ?? 0), // Convert seconds back to Duration
    );
  }).toList();
}
