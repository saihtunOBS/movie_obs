import 'package:flutter/material.dart';

import '../utils/dimens.dart';

Widget customButton({
  String? title,
  required VoidCallback? onPress,
  bool? isLogout,
  Color? backgroundColor,
  Color? textColor,
  Color? borderColor,
  bool? isOnlyBorder,
  double? height,
  required BuildContext? context,
}) {
  return GestureDetector(
    onTap: onPress,
    child: Container(
      height: height ?? 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kMarginMedium2),
        color: backgroundColor,
        border: Border.all(color: borderColor ?? Colors.transparent),
      ),
      child: Center(
        child: Text(title ?? '', style: TextStyle(color: textColor,fontWeight: FontWeight.w700,fontSize: kTextRegular2x)),
      ),
    ),
  );
}
