// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:movie_obs/utils/rotation_detector.dart';

// class RotationLockIndicator extends StatefulWidget {
//   @override
//   _RotationLockIndicatorState createState() => _RotationLockIndicatorState();
// }

// class _RotationLockIndicatorState extends State<RotationLockIndicator> {
//   bool _isLocked = false;
//   StreamSubscription<bool>? _subscription;

//   @override
//   void initState() {
//     super.initState();
//     _subscription = RotationDetector.onRotationLockChanged.listen((isLocked) {
//       if (mounted) {
//         setState(() => _isLocked = isLocked);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _subscription?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Chip(
//         label: Text('Rotation ${_isLocked ? 'Locked' : 'Unlocked'}'),
//         backgroundColor: _isLocked ? Colors.red : Colors.green,
//         labelStyle: TextStyle(color: Colors.white),
//       ),
//     );
//   }
// }
