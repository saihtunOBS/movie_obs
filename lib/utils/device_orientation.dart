import 'package:flutter/widgets.dart';

Orientation getDeviceOrientation(BuildContext context) {
  return MediaQuery.of(context).orientation;
}
