import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/screens/auth/login_screen.dart';
import 'package:movie_obs/screens/bottom_nav/bottom_nav_screen.dart';

import '../extension/page_navigator.dart';
import '../utils/colors.dart';
import '../utils/dimens.dart';

class ErrorDialogView extends StatelessWidget {
  final String? errorMessage;
  final bool? isLogin;
  const ErrorDialogView({super.key, required this.errorMessage, this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      // surfaceTintColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          20.vGap,
          Container(
            padding: const EdgeInsets.all(kMarginMedium2),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.error_outline, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Oops...",
            style: TextStyle(
              fontSize: kTextRegular,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            errorMessage ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: kTextRegular,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: () {
                if(isLogin == true){
                  tab.value = false;
                  PageNavigator(
                      ctx: context,
                    ).nextPageOnly(page: LoginScreen());
                }else {
                  Navigator.of(context).pop();
                }
               
              },
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width / 1.5,
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Ok',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
