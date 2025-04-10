import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/auth/otp_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/cache_image.dart';
import 'package:movie_obs/widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: kMarginMedium,
          children: [
            Text(
              'LOGIN',
              style: TextStyle(
                letterSpacing: 5.0,
                fontSize: kTextRegular32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Enter your phone number.\n We\'ll send you a verification code',
              style: TextStyle(fontSize: kTextRegular2x),
            ),
            20.vGap,
            Row(
              spacing: kMarginMedium,
              children: [
                Container(
                  height: 50,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: kWhiteColor,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: kMarginMedium),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kWhiteColor,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            20.vGap,
            //button
            customButton(
              onPress: () {
                PageNavigator(ctx: context).nextPage(page: OTPScreen());
              },
              context: context,
              backgroundColor: kBlackColor,
              title: 'Send OTP',
              textColor: kWhiteColor,
            ),

            //spacer
            Spacer(),
            Row(
              spacing: kMargin24,
              children: [
                Expanded(child: Divider(color: kBlackColor)),
                Text('Or', style: TextStyle(fontSize: kTextRegular2x)),
                Expanded(child: Divider(color: kBlackColor)),
              ],
            ),
            10.vGap,
            GestureDetector(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kMarginMedium2),
                  color: kBlackColor,
                ),
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: cacheImage(
                        'https://techcrunch.com/wp-content/uploads/2019/02/GettyImages-1127359452.jpg',
                      ),
                    ),
                    Text(
                      'Continue with Google',
                      style: TextStyle(
                        color: kWhiteColor,
                        fontWeight: FontWeight.w700,
                        fontSize: kTextRegular2x,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            20.vGap
          ],
        ),
      ),
    );
  }
}
