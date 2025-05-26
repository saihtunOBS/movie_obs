// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:movie_obs/bloc/auth_bloc.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/auth/change_language_screen.dart';
import 'package:movie_obs/widgets/custom_button.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:movie_obs/widgets/toast_service.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';
import '../../utils/dimens.dart';
import '../../utils/images.dart';

import 'package:movie_obs/l10n/app_localizations.dart';
class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key, this.phone, this.requestId});
  final String? phone;
  final String? requestId;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final pinController = TextEditingController();
  bool isFilled = false;
  final focusNode = FocusNode();
  Timer? _timer;
  int _start = 180;

  @override
  void dispose() {
    pinController.clear();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    pinController.clear();
    _start = 180;
    startTimer();
    super.initState();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_start > 0) {
          _start--;
        } else {
          _timer?.cancel();
          _start = 180;
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
    return ChangeNotifierProvider(
      create: (context) => AuthBloc(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
        body: Consumer<AuthBloc>(
          builder:
              (context, bloc, child) => Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      getDeviceType() == 'phone'
                          ? kMarginMedium2
                          : MediaQuery.of(context).size.width * 0.15,
                ),
                child: Stack(
                  children: [
                    Column(
                      spacing: kMarginMedium2,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'VERIFICATION',
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            letterSpacing: 10.0,
                            fontSize: kTextRegular32,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                        ),
                        PersistenceData.shared.getLocale() == 'en'
                            ? Text(
                              '${AppLocalizations.of(context)?.sendOtpCode ?? ''} ${widget.phone}. ${AppLocalizations.of(context)?.enterOTP ?? ''}',
                              style: TextStyle(
                                fontSize: kTextRegular2x,
                                height: 1.7,
                              ),
                            )
                            : Text(
                              '${AppLocalizations.of(context)?.yourPhoneNumber ?? ''} ${widget.phone} ${AppLocalizations.of(context)?.willSend ?? ''}',
                              style: TextStyle(
                                fontSize: kTextRegular2x,
                                height: 1.7,
                              ),
                            ),
                        10.vGap,
                        _buildPinView(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              timerText,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_start == 180) {
                                  pinController.clear();
                                  startTimer();
                                  bloc
                                      .userLogin(widget.phone ?? '')
                                      .then((_) {
                                        ToastService.successToast(
                                          'Code sent success',
                                        );
                                      })
                                      .catchError((error) {
                                        ToastService.warningToast(
                                          error.toString(),
                                        );
                                      });
                                }
                              },
                              child: Text(
                                AppLocalizations.of(context)?.resend ?? '',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    //loading
                    bloc.isLoading ? LoadingView() : SizedBox.shrink(),
                  ],
                ),
              ),
        ),
        bottomNavigationBar: Consumer<AuthBloc>(
          builder:
              (context, bloc, child) => Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                margin: EdgeInsets.only(
                  left:
                      getDeviceType() == 'phone'
                          ? kMarginMedium2
                          : MediaQuery.of(context).size.width * 0.15,
                  right:
                      getDeviceType() == 'phone'
                          ? kMarginMedium2
                          : MediaQuery.of(context).size.width * 0.15,
                  bottom: 27,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 2,
                  children: [
                    customButton(
                      onPress: () {
                        FocusScope.of(context).unfocus();
                        Future.delayed(Duration(milliseconds: 300), () {
                          bloc
                              .verifyOtp(
                                widget.phone ?? '',
                                widget.requestId ?? '',
                                pinController.text,
                              )
                              .then((response) {
                                PersistenceData.shared.saveToken(
                                  response.accessToken ?? '',
                                );
                                PageNavigator(
                                  ctx: context,
                                ).nextPage(page: ChangeLanguageScreen());
                              })
                              .catchError((error) {
                                ToastService.warningToast(error.toString());
                              });
                        });
                      },
                      context: context,
                      backgroundColor: kSecondaryColor,
                      title: AppLocalizations.of(context)?.confirm ?? '',
                      textColor: kWhiteColor,
                    ),
                    Image.asset(kShadowImage),
                  ],
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildPinView() {
    final defaultPinTheme = PinTheme(
      width: kSize64 + 10,
      height: kSize64 + 10,
      margin: EdgeInsets.symmetric(
        horizontal: getDeviceType() == 'phone' ? 1 : 10,
      ),
      textStyle: const TextStyle(fontSize: kTextRegular22, color: Colors.black),
      decoration: BoxDecoration(color: kWhiteColor, shape: BoxShape.circle),
    );
    final submittedPinTheme = PinTheme(
      width: kSize64 + 10,
      height: kSize64 + 10,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      textStyle: const TextStyle(fontSize: kTextRegular22, color: Colors.black),
      decoration: BoxDecoration(color: kWhiteColor, shape: BoxShape.circle),
    );
    return Center(
      child: SizedBox(
        height: 100,
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
      ),
    );
  }
}
