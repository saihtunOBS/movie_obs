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
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0), // From right
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
