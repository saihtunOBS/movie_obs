import 'package:flutter/material.dart';

import '../utils/colors.dart';

class LoadingView extends StatelessWidget {
  final Color? bgColor;
  const LoadingView({super.key, this.bgColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: bgColor ?? Colors.black12,borderRadius: BorderRadius.circular(24)),
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
