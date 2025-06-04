import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  }

  Future<void> logVideoView({
    required String videoId,
    required String videoTitle,
    required Duration duration,
  }) async {
    try {
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      await _analytics.logEvent(
        name: 'video_view',
        parameters: {'video_id': videoId, 'duration': '${duration.inSeconds}'},
      );
      debugPrint('✅ Successfully logged video_view event for $videoId');
    } catch (e) {
      debugPrint('❌ Failed to log event: $e');
    }
  }

  Future<void> logEpisodeView({required String episodeId}) async {
    try {
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      await _analytics.logEvent(
        name: 'episode_view',
        parameters: {'episode_id': episodeId},
      );
      debugPrint('✅ Successfully logged video_view event for $episodeId');
    } catch (e) {
      debugPrint('❌ Failed to log event: $e');
    }
  }

  Future<void> logSeriesView({required String seriesId}) async {
    try {
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      await _analytics.logEvent(
        name: 'series_view',
        parameters: {'series_id': seriesId},
      );
      debugPrint('✅ Successfully logged video_view event for $seriesId');
    } catch (e) {
      debugPrint('❌ Failed to log event: $e');
    }
  }

  Future<void> logSeasonView({required String seasonId}) async {
    try {
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      await _analytics.logEvent(
        name: 'season_view',
        parameters: {'season_id': seasonId},
      );
      debugPrint('✅ Successfully logged video_view event for $seasonId');
    } catch (e) {
      debugPrint('❌ Failed to log event: $e');
    }
  }
}
