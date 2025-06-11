import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/bottom_nav/bottom_nav_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/utils/images.dart';
import 'package:movie_obs/widgets/gradient_button.dart';

class PaymentStatusScreen extends StatelessWidget {
  const PaymentStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Column(
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
                      width: 200,
                      height: 200,
                      child: Image.asset(
                        kPaymentSuccessLogo,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      'Payment Successful!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kGradientOne,
                      ),
                    ),
                    10.vGap,
                    Text(
                      'Thank you for processing your most recent payment.',
                      style: TextStyle(color: kBlackColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacer(),
          bottomView(context),
        ],
      ),
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
        children: [
          gradientButton(
            onPress: () {},
            context: context,
            isGradient: false,
            title: 'Try Again',
          ),
          gradientButton(
            onPress: () {
              tab.value = true;
              PageNavigator(ctx: context).nextPageOnly(page: BottomNavScreen());
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
