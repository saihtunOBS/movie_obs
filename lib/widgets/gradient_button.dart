import 'package:flutter/material.dart';
import 'package:movie_obs/utils/colors.dart';

import '../utils/dimens.dart';

Widget gradientButton({
  String? title,
  required VoidCallback? onPress,
  Color? backgroundColor,
  bool? isGradient,
  double? borderRadius,
  required BuildContext? context,
}) {
  return GestureDetector(
    onTap: onPress,
    child: Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 24),
        color:
            isGradient == true
                ? Colors.white
                : Colors.grey.withValues(alpha: 0.2),

        gradient:
            isGradient == true
                ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.center,
                  colors: [kGradientOne, kGradientTwo],
                )
                : null,
      ),
      child: Center(
        child: Text(
          title ?? '',
          style: TextStyle(
            color:
                isGradient == true
                    ? kWhiteColor
                    : const Color.fromARGB(255, 124, 124, 124),
            fontWeight: FontWeight.bold,
            fontSize: kTextRegular2x,
          ),
        ),
      ),
    ),
  );
}
