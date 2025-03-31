// rotation_detector.dart
import 'dart:async';
import 'package:flutter/services.dart';

class RotationDetector {
  static const EventChannel _eventChannel = EventChannel('rotation_channel');
  static Stream<bool>? _stream;

  static Stream<bool> get onRotationLockChanged {
    _stream ??= _eventChannel.receiveBroadcastStream()
        .map((event) => event as bool)
        .handleError((error) {
          print('Rotation detection error: $error');
          return false;
        })
        .asBroadcastStream();
    return _stream!;
  }
}