import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/auth/otp_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/utils/images.dart';
import 'package:movie_obs/widgets/cache_image.dart';
import 'package:movie_obs/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Country? selectedCountryCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              getDeviceType() == 'phone'
                  ? kMarginMedium2
                  : MediaQuery.of(context).size.width * 0.15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: kMarginMedium,
          children: [
            Text(
              'LOGIN',
              style: TextStyle(
                letterSpacing: 10.0,
                fontSize: kTextRegular32,
                fontWeight: FontWeight.bold,
                color: kThirdColor,
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
                GestureDetector(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      useSafeArea: true,
                      searchAutofocus: true,
                      useRootNavigator: true,
                      moveAlongWithKeyboard: false,
                      countryListTheme: CountryListThemeData(
                        bottomSheetHeight:
                            MediaQuery.of(context).size.height / 1.5,
                        inputDecoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: kWhiteColor),
                          ),
                          labelText: 'Search Country',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                        ),

                        textStyle: TextStyle(
                          fontSize: getDeviceType() == 'phone' ? 16 : 20,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.black,
                        searchTextStyle: TextStyle(
                          color: kWhiteColor,
                          fontSize: getDeviceType() == 'phone' ? 16 : 20,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      onSelect: (value) {
                        setState(() {
                          selectedCountryCode = value;
                        });
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                    child: Row(
                      spacing: 5,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: selectedCountryCode == null ? 15 : 45,
                          child:
                              selectedCountryCode != null
                                  ? Center(
                                    child: Text(
                                      selectedCountryCode!.flagEmoji,
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  )
                                  : cacheImage(
                                    'https://static.vecteezy.com/system/resources/previews/027/222/649/non_2x/myanmar-flag-flag-of-myanmar-myanmar-flag-wave-png.png',
                                    boxFit: BoxFit.fill,
                                  ),
                        ),
                        Text(
                          '+${selectedCountryCode?.phoneCode ?? '95'}',
                          style: TextStyle(color: kWhiteColor),
                        ),
                        Icon(CupertinoIcons.chevron_down, size: 16),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: kMarginMedium),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withValues(alpha: 0.2),
                    ),
                    child: TextField(
                      style: TextStyle(color: kWhiteColor),
                      decoration: InputDecoration(
                        hintText: 'Phone Number',

                        hintStyle: TextStyle(color: kWhiteColor),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            20.vGap,
            //button
            Column(
              spacing: 2,
              children: [
                customButton(
                  onPress: () {
                    PageNavigator(ctx: context).nextPage(page: OTPScreen());
                  },
                  context: context,
                  backgroundColor: kSecondaryColor,
                  title: 'Send OTP',
                  textColor: kWhiteColor,
                ),
                Image.asset(kShadowImage),
              ],
            ),


          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
             //spacer
              Row(
                spacing: kMargin24,
                children: [
                  Expanded(child: Divider(color: kWhiteColor)),
                  Text('Or', style: TextStyle(fontSize: kTextRegular2x)),
                  Expanded(child: Divider(color: kWhiteColor)),
                ],
              ),
            GestureDetector(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kMarginMedium2),
                  color: kWhiteColor,
                ),
                child: Row(
                  spacing: 5,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(Icons.apple, color: kBlackColor, size: 35),
                    ),
                    Text(
                      'Sign in with Apple',
                      style: TextStyle(
                        color: kBlackColor,
                        fontWeight: FontWeight.w700,
                        fontSize: kTextRegular2x,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kMarginMedium2),
                  color: kWhiteColor,
                ),
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset(kGoogleIcon),
                    ),
                    Text(
                      'Sign in with Google',
                      style: TextStyle(
                        color: kBlackColor,
                        fontWeight: FontWeight.w700,
                        fontSize: kTextRegular2x,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            20.vGap,
          ],
        ),
      ),
    );
  }
}
