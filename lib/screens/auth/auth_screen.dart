import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/banner_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/l10n/app_localizations.dart';
import 'package:movie_obs/screens/auth/login_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/utils/images.dart';
import 'package:movie_obs/widgets/cache_image.dart';
import 'package:movie_obs/widgets/custom_button.dart';
import 'package:provider/provider.dart';
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
    return ChangeNotifierProvider(
      create: (context) => BannerBloc(),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Consumer<BannerBloc>(
          builder:
              (context, bloc, child) => Column(
                children: [
                  SizedBox(height: 70),
                  //slider
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: sliderIndex,
                      builder:
                          (context, value, child) => CarouselSlider(
                            items:
                                bloc.bannerList.map((data) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadiusDirectional.circular(20),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: cacheImage(data.image ?? ''),
                                    ),
                                  );
                                }).toList(),
                            options: CarouselOptions(
                              autoPlay: false,
                              viewportFraction:
                                  getDeviceType() == 'phone' ? 0.8 : 0.5,
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
                  if (bloc.bannerList.isNotEmpty)
                    ValueListenableBuilder(
                      valueListenable: sliderIndex,
                      builder:
                          (context, value, child) => AnimatedSmoothIndicator(
                            effect: ExpandingDotsEffect(
                              dotHeight: kMargin5,
                              dotWidth: kMargin5,
                              activeDotColor: kSecondaryColor,
                              dotColor: kWhiteColor,
                            ),
                            activeIndex: value,
                            count: bloc.bannerList.length,
                          ),
                    ),

                  20.vGap,
                  // label
                  Text(
                    'Welcome to Too To\'Tv',
                    style: TextStyle(
                      fontSize: kTextRegular3x,
                      fontWeight: FontWeight.bold,
                      color: kWhiteColor,
                    ),
                  ),
                  10.vGap,
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: kMarginMedium2,
                    ),
                    child: Text(
                      AppLocalizations.of(context)?.discoverLabel ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(height: 1.8, color: kWhiteColor),
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
            spacing: 3,
            children: [
              customButton(
                onPress: () {
                  PageNavigator(ctx: context).nextPageOnly(page: LoginScreen());
                },
                context: context,
                title: AppLocalizations.of(context)?.login,
                backgroundColor: kSecondaryColor,
                textColor: kWhiteColor,
              ),
              Image.asset(kShadowImage),
            ],
          ),
        ),
      ),
    );
  }
}
