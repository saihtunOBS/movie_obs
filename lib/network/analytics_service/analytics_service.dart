import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:movie_obs/bloc/user_bloc.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logVideoView({
    required String videoId,
    required String videoTitle,
    required Duration duration,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'video_view',
        parameters: {
          'video_id': videoId,
          'video_title': videoTitle,
          'duration': duration.inSeconds,
          'user_id':
              userDataListener.value.id ?? '', // Implement this to get user ID
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      debugPrint('✅ Successfully logged video_view event for $videoId');
    } catch (e) {
      debugPrint('error...$e');
    }
  }
}
