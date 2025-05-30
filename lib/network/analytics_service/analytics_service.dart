import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:movie_obs/bloc/user_bloc.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<String?> _getUserId() async {
    return userDataListener.value.id;
  }

  Future setUserId() async {
    final userId = await _getUserId();
    await _analytics.setUserId(id: userId);
  }

  Future<void> logVideoView({
    required String videoId,
    required String videoTitle,
    required Duration duration,
  }) async {
    try {
      final userId = await _getUserId();
      await _analytics.setUserId(id: userId);

      await _analytics.logEvent(
        name: 'video_view',
        parameters: {
          'id': videoId,
          'video_title': videoTitle,
          'duration': duration.inSeconds,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      debugPrint('✅ Successfully logged video_view event for $videoId');
    } catch (e) {
      debugPrint('❌ Failed to log event: $e');
    }
  }
}
