import 'package:flutter/material.dart';

Future<bool?> showCommonDialog({
  required BuildContext context,
  Widget? dialogWidget,
  bool? isBarrierDismiss,
}) async {
  return showGeneralDialog(
    barrierLabel: "Label",
    barrierDismissible: isBarrierDismiss ?? true,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    transitionDuration: const Duration(milliseconds: 300),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.center,
        child: SizedBox.expand(child: dialogWidget),
      );
    },
    // transitionBuilder: (context, anim1, anim2, child) {
    //   return FadeTransition(opacity: anim1);
    // },
  );
}
