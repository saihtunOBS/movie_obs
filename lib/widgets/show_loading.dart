import 'package:flutter/material.dart';

import '../utils/colors.dart';

class LoadingView extends StatelessWidget {
  final Color? bgColor;
  final double? radius;
  const LoadingView({super.key, this.bgColor, this.radius});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor ?? Colors.black12,
        borderRadius: BorderRadius.circular(radius ?? 24),
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: kPrimaryColor,
          backgroundColor: kWhiteColor,
        ),
      ),
    );
  }
}
