import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoProgress {
  final String videoId;
  final Duration position;

  VideoProgress({required this.videoId, required this.position});

  Map<String, dynamic> toMap() {
    return {
      'videoId': videoId,
      'position': position.inSeconds,
    }; // Save position as seconds
  }

  static VideoProgress fromMap(Map<String, dynamic> map) {
    return VideoProgress(
      videoId: map['videoId'],
      position: Duration(seconds: map['position']), // Convert back to Duration
    );
  }
}

Future<void> saveVideoProgress(List<VideoProgress> newVideoProgress) async {
  final prefs = await SharedPreferences.getInstance();

  // 1. Load existing progress
  List<VideoProgress> existingProgress = await loadVideoProgress();

  // 2. Update or add the new progress
  for (var newProgress in newVideoProgress) {
    // Remove existing entry for this video if it exists
    existingProgress.removeWhere((p) => p.videoId == newProgress.videoId);
    // Add the new progress
    existingProgress.add(newProgress);
  }

  // 3. Save the complete updated list
  List<String> videoData =
      existingProgress.map((video) {
        return '${video.videoId}:${video.position.inSeconds}';
      }).toList();

  await prefs.setStringList('videoProgress', videoData);

  // Debug print to verify saving
  debugPrint('Saved progress for ${newVideoProgress.length} videos');
  debugPrint('Total videos in storage: ${existingProgress.length}');
}

Future<List<VideoProgress>> loadVideoProgress() async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? videoData = prefs.getStringList('videoProgress');

  if (videoData == null) return [];

  return videoData
      .map((data) {
        try {
          final parts = data.split(':');
          if (parts.length != 2) throw FormatException('Invalid format');
          return VideoProgress(
            videoId: parts[0],
            position: Duration(seconds: int.tryParse(parts[1]) ?? 0),
          );
        } catch (e) {
          debugPrint('Error parsing video progress: $e for data: $data');
          return VideoProgress(videoId: '', position: Duration.zero);
        }
      })
      .where((progress) => progress.videoId.isNotEmpty)
      .toList(); // Filter out invalid entries
}
