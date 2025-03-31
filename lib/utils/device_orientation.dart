// screen_rotation.dart
import 'package:flutter/services.dart';

class ScreenRotation {
  static const MethodChannel _methodChannel =
      MethodChannel('com.example/orientation');
  static const EventChannel _eventChannel =
      EventChannel('com.example/orientation/events');

  /// Check current auto-rotate status
  static Future<bool> isAutoRotateEnabled() async {
    try {
      return await _methodChannel.invokeMethod('isAutoRotateEnabled');
    } on PlatformException {
      return true; // Default to enabled if we can't determine
    }
  }

  /// Listen for auto-rotate status changes
  static Stream<bool> get onAutoRotateChanged {
    return _eventChannel.receiveBroadcastStream().map((event) => event as bool);
  }
}