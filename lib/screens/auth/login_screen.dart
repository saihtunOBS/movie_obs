import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_obs/bloc/auth_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/auth/otp_screen.dart';
import 'package:movie_obs/screens/bottom_nav/bottom_nav_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/utils/images.dart';
import 'package:movie_obs/utils/validator.dart';
import 'package:movie_obs/widgets/cache_image.dart';
import 'package:movie_obs/widgets/custom_button.dart';
import 'package:movie_obs/widgets/custom_textfield.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:movie_obs/widgets/toast_service.dart';
import 'package:provider/provider.dart';

import 'package:movie_obs/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Country? selectedCountryCode;
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthBloc(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal:
                  getDeviceType() == 'phone'
                      ? kMarginMedium2
                      : MediaQuery.of(context).size.width * 0.15,
            ),
            child: Consumer<AuthBloc>(
              builder:
                  (context, bloc, child) => Stack(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: kMarginMedium,
                          children: [
                            Text(
                              'LOGIN',
                              style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                letterSpacing: 10.0,
                                fontSize: kTextRegular32,
                                fontWeight: FontWeight.bold,
                                color: kPrimaryColor,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)?.enterPhoneNumber ??
                                  '',
                              style: TextStyle(fontSize: kTextRegular2x),
                            ),
                            20.vGap,
                            Row(
                              spacing: kMarginMedium,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Localizations.override(
                                  context: context,
                                  locale: Locale('en'),
                                  child: GestureDetector(
                                    onTap: () {
                                      showCountryPicker(
                                        context: context,
                                        useSafeArea: true,
                                        searchAutofocus: true,
                                        useRootNavigator: true,
                                        moveAlongWithKeyboard: false,
                                        countryListTheme: CountryListThemeData(
                                          bottomSheetHeight:
                                              MediaQuery.of(
                                                context,
                                              ).size.height /
                                              1.5,
                                          inputDecoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: kWhiteColor,
                                              ),
                                            ),
                                            labelText: 'Search Country',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                color: Colors.white,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                color: Colors.white,
                                                width: 1,
                                              ),
                                            ),
                                          ),

                                          textStyle: TextStyle(
                                            fontSize:
                                                getDeviceType() == 'phone'
                                                    ? 16
                                                    : 20,
                                            color: Colors.white,
                                          ),
                                          backgroundColor: Colors.black,
                                          searchTextStyle: TextStyle(
                                            color: kWhiteColor,
                                            fontSize:
                                                getDeviceType() == 'phone'
                                                    ? 16
                                                    : 20,
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
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        color: Colors.grey.withValues(
                                          alpha: 0.2,
                                        ),
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                            255,
                                            126,
                                            125,
                                            125,
                                          ),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        spacing: 5,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height:
                                                selectedCountryCode == null
                                                    ? 15
                                                    : 45,
                                            child:
                                                selectedCountryCode != null
                                                    ? Center(
                                                      child: Text(
                                                        selectedCountryCode!
                                                            .flagEmoji,
                                                        style: TextStyle(
                                                          fontSize: 25,
                                                        ),
                                                      ),
                                                    )
                                                    : cacheImage(
                                                      'https://static.vecteezy.com/system/resources/previews/027/222/649/non_2x/myanmar-flag-flag-of-myanmar-myanmar-flag-wave-png.png',
                                                      boxFit: BoxFit.fill,
                                                    ),
                                          ),
                                          Text(
                                            '+${selectedCountryCode?.phoneCode ?? '95'}',
                                            style: TextStyle(
                                              color: kWhiteColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Icon(
                                            CupertinoIcons.chevron_down,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: CustomTextfield(
                                    controller: _phoneController,
                                    validator: phoneValidator,
                                    hint: '09xxxxxxxxxx',
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                              ],
                            ),
                            5.vGap,
                            //button
                            Column(
                              spacing: 2,
                              children: [
                                customButton(
                                  onPress: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      bloc
                                          .getAuthUser()
                                          .then((_) {
                                            tab.value = true;
                                            PageNavigator(
                                              ctx: context,
                                            ).nextPageOnly(
                                              page: BottomNavScreen(),
                                            );
                                          })
                                          .catchError((_) {
                                            bloc
                                                .userLogin(
                                                  '${selectedCountryCode?.phoneCode ?? '95'}${_phoneController.text.trim()}',
                                                )
                                                .then((response) {
                                                  PageNavigator(
                                                    ctx: context,
                                                  ).nextPage(
                                                    page: OTPScreen(
                                                      phone:
                                                          '${selectedCountryCode?.phoneCode ?? '95'}${_phoneController.text.trim()}',
                                                      requestId:
                                                          '${response.requestId}',
                                                    ),
                                                  );
                                                })
                                                .catchError((error) {
                                                  ToastService.warningToast(
                                                    error.toString(),
                                                  );
                                                });
                                          });
                                    }
                                  },
                                  context: context,
                                  backgroundColor: kSecondaryColor,
                                  title: AppLocalizations.of(context)?.sendOtp,
                                  textColor: kWhiteColor,
                                ),
                                Image.asset(kShadowImage),
                              ],
                            ),
                          ],
                        ),
                      ),

                      //show lading
                      bloc.isLoading ? LoadingView() : SizedBox.shrink(),
                    ],
                  ),
            ),
          ),
        ),
        bottomNavigationBar: Consumer<AuthBloc>(
          builder:
              (context, bloc, child) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5,
                  children: [
                    //spacer
                    Row(
                      spacing: kMargin24,
                      children: [
                        Expanded(
                          child: Divider(color: kWhiteColor, thickness: 0.5),
                        ),
                        Text('Or', style: TextStyle(fontSize: kTextRegular2x)),
                        Expanded(
                          child: Divider(color: kWhiteColor, thickness: 0.5),
                        ),
                      ],
                    ),
                    5.vGap,
                    GestureDetector(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: kWhiteColor,
                        ),
                        child: Row(
                          spacing: 5,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: Icon(
                                Icons.apple,
                                color: kBlackColor,
                                size: 35,
                              ),
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
                    3.vGap,
                    GestureDetector(
                      onTap: () {
                        bloc.loginGoogle();
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
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
                    5.vGap,
                    privacyPolicyText(),
                    30.vGap,
                  ],
                ),
              ),
        ),
      ),
    );
  }

  Widget privacyPolicyText() {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text('By logging in, you agree to our '),
        InkWell(
          onTap: () async {},
          child: Text('Terms of Use', style: TextStyle(color: Colors.blue)),
        ),
        Text(' and '),
        InkWell(
          onTap: () async {},
          child: Text('Privacy Policy.', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}
