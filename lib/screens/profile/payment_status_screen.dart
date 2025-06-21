import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/bottom_nav/bottom_nav_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/utils/images.dart';
import 'package:movie_obs/widgets/gradient_button.dart';

class PaymentStatusScreen extends StatefulWidget {
  const PaymentStatusScreen({super.key, required this.status});
  final String status;

  @override
  State<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(kPaymentBarLogo, fit: BoxFit.cover),
                Positioned(
                  top: 130,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 198,
                        height: 198,
                        child: Image.asset(
                          widget.status == 'success'
                              ? kPaymentSuccessLogo
                              : kPaymentFailLogo,
                          fit: BoxFit.cover,
                        ),
                      ),
                      10.vGap,
                      Text(
                        widget.status == 'success'
                            ? 'Payment Successful!'
                            : 'Payment Fail!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: kGradientOne,
                        ),
                      ),
                      10.vGap,
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kMarginMedium2,
                          ),
                          child: Text(
                            widget.status == 'success'
                                ? 'Thank you for processing your most recent payment.'
                                : 'Sorry, your payment was not successful proceed. Please try again.',
                            style: TextStyle(color: kBlackColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: bottomView(context),
    );
  }

  Widget bottomView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kMarginMedium2,
        vertical: kMarginMedium2,
      ),
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: widget.status == 'fail',
            child: gradientButton(
              onPress: () {
                initialIndex = 3;
                tab.value = true;
                PageNavigator(
                  ctx: context,
                ).nextPageOnly(page: BottomNavScreen(openPromotion: true));
              },
              context: context,
              isGradient: false,
              title: 'Try Again',
            ),
          ),
          gradientButton(
            onPress: () {
              initialIndex = 3;
              tab.value = true;
              PageNavigator(
                ctx: context,
              ).nextPageOnly(page: BottomNavScreen(openPromotion: true));
            },
            context: context,
            isGradient: true,
            title: 'Back to Homepage',
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [
              Text('Powered by', style: TextStyle(color: kBlackColor)),
              Text(
                'OBS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kGradientTwo,
                ),
              ),
            ],
          ),
          10.vGap,
        ],
      ),
    );
  }
}
