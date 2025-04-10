// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/bottom_nav/bottom_nav_screen.dart';
import 'package:movie_obs/widgets/custom_button.dart';
import 'package:pinput/pinput.dart';

import '../../utils/colors.dart';
import '../../utils/dimens.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key, this.phone, this.token});
  final String? phone;
  final String? token;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final pinController = TextEditingController();
  bool isFilled = false;
  final focusNode = FocusNode();
  Timer? _timer;
  int _start = 300;

  String token = '';

  @override
  void dispose() {
    pinController.clear();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _start = 300;
    startTimer();
    token = widget.token ?? '';
    super.initState();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_start > 0) {
          _start--;
        } else {
          _timer?.cancel();
          _start = 300;
        }
      });
    });
  }

  String get timerText {
    final minutes = (_start ~/ 60).toString().padLeft(2, '0');
    final seconds = (_start % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
            child: Column(
              spacing: kMarginMedium2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VERIFICATION',
                  style: TextStyle(
                    letterSpacing: 5.0,
                    fontSize: kTextRegular32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Send OTP Code to +95 09888888888.\n Enter your OTP Code here.',
                  style: TextStyle(fontSize: kTextRegular2x),
                ),
                10.vGap,
                _buildPinView(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '00:16',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Resend',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            margin: EdgeInsets.only(
              left: kMarginMedium2,right: kMarginMedium2,bottom: 27
            ),
            child: customButton(
              onPress: () {
                PageNavigator(
                  ctx: context,
                ).nextPageOnly(page: BottomNavScreen());
              },
              context: context,
              backgroundColor: kBlackColor,
              title: 'Confirm',
              textColor: kWhiteColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPinView() {
    final defaultPinTheme = PinTheme(
      width: kSize64,
      height: kSize64,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      textStyle: const TextStyle(fontSize: kTextRegular22, color: Colors.black),
      decoration: BoxDecoration(color: kWhiteColor, shape: BoxShape.circle),
    );
    final submittedPinTheme = PinTheme(
      width: kSize64,
      height: kSize64,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      textStyle: const TextStyle(fontSize: kTextRegular22, color: Colors.black),
      decoration: BoxDecoration(color: kWhiteColor, shape: BoxShape.circle),
    );
    return Center(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Pinput(
          controller: pinController,
          length: 6,
          autofocus: true,
          focusNode: focusNode,
          defaultPinTheme: defaultPinTheme,
          submittedPinTheme: submittedPinTheme,
          focusedPinTheme: submittedPinTheme,
          onClipboardFound: (value) {
            pinController.setText(value);
          },
          onCompleted: (pin) {
            setState(() {
              isFilled = true;
            });
          },
          onChanged: (value) {
            setState(() {
              if (pinController.text.length < 6) {
                isFilled = false;
              }
            });
          },
        ),
      ),
    );
  }
}
