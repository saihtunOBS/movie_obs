import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/data/dummy/dummy_data.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/screens/auth/login_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/custom_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final CarouselSliderController controller = CarouselSliderController();
  final ValueNotifier<int> sliderIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          SizedBox(height: 70),
          //slider
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: sliderIndex,
              builder:
                  (context, value, child) => CarouselSlider(
                    items:
                        imageArray.map((data) {
                          return Container(
                            decoration: BoxDecoration(
                              color: kWhiteColor,
                              borderRadius: BorderRadiusDirectional.circular(
                                20,
                              ),
                            ),
                          );
                        }).toList(),
                    options: CarouselOptions(
                      autoPlay: false,
                      viewportFraction: getDeviceType() == 'phone' ? 0.8 : 0.5,
                      enlargeCenterPage: true,
                      disableCenter: true,
                      onPageChanged: (index, reason) {
                        sliderIndex.value = index;
                      },
                    ),
                  ),
            ),
          ),

          20.vGap,
          //indicator
          ValueListenableBuilder(
            valueListenable: sliderIndex,
            builder:
                (context, value, child) => AnimatedSmoothIndicator(
                  effect: ExpandingDotsEffect(
                    dotHeight: kMarginMedium,
                    dotWidth: kMarginMedium,
                    activeDotColor: kBlackColor,
                    dotColor: kWhiteColor,
                  ),
                  activeIndex: value,
                  count: imageArray.length,
                ),
          ),

          20.vGap,
          // label
          Text(
            'Watch Anytime, Anywhere',
            style: TextStyle(
              fontSize: kTextRegular3x,
              fontWeight: FontWeight.bold,
            ),
          ),
          10.vGap,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
            child: Text(
              'Enjoy movies on your phone, tablet, or smart TV whenever you want.',
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(
            height:
                getDeviceType() == 'phone'
                    ? 80
                    : MediaQuery.of(context).size.width * 0.3,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 140,
        margin: EdgeInsets.symmetric(
          horizontal:
              getDeviceType() == 'phone'
                  ? kMarginMedium2
                  : MediaQuery.of(context).size.width * 0.15,
          vertical: kMarginMedium2,
        ),
        width: double.infinity,
        child: Column(
          spacing: kMarginMedium2 - 3,
          children: [
            customButton(
              onPress: () {
                PageNavigator(ctx: context).nextPageOnly(page: LoginScreen());
              },
              context: context,
              title: 'Login',
              backgroundColor: kBlackColor,
              textColor: kWhiteColor,
            ),
            customButton(
              onPress: () {},
              context: context,
              title: 'Try as Guest',
              textColor: kBlackColor,
              borderColor: kBlackColor,
              backgroundColor: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
