import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/data/dummy/dummy_data.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TopTrendingScreen extends StatefulWidget {
  const TopTrendingScreen({super.key});

  @override
  State<TopTrendingScreen> createState() => _TopTrendingScreenState();
}

class _TopTrendingScreenState extends State<TopTrendingScreen> {
  final CarouselSliderController controller = CarouselSliderController();
  final ValueNotifier<int> sliderIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        surfaceTintColor: kBackgroundColor,
        title: Text('Top Trending'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          //slider
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.45,
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
          // label
          Text(
            'Movie Title',
            style: TextStyle(
              fontSize: kTextRegular3x,
              fontWeight: FontWeight.bold,
            ),
          ),
          10.vGap,
          _buildMinuteAndViewCount(),
          10.vGap,
          Text('Action, Romance, Drama', textAlign: TextAlign.center),
          20.vGap,
          _buildUnlockAndWishlist(),

          30.vGap,
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
        ],
      ),
    );
  }
}

Widget _buildMinuteAndViewCount() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    spacing: kMargin12 + 4,
    children: [
      Text('3 hr 30 mins', style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(
        width: 5,
        height: 5,
        child: CircleAvatar(backgroundColor: kBlackColor),
      ),

      Row(
        spacing: kMargin5,
        children: [
          Icon(CupertinoIcons.eye),
          Text('35', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    ],
  );
}

Widget _buildUnlockAndWishlist() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    spacing: kMarginMedium2 - 3,
    children: [
      Container(
        height: 30,
        padding: EdgeInsets.symmetric(horizontal: kMarginMedium + 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kBlackColor,
        ),
        child: Center(
          child: Row(
            spacing: kMargin5,
            children: [
              Icon(CupertinoIcons.lock, color: kWhiteColor, size: 18),
              Text('2000 Ks to unlock', style: TextStyle(color: kWhiteColor)),
            ],
          ),
        ),
      ),
      Container(
        height: 30,
        padding: EdgeInsets.symmetric(horizontal: kMarginMedium),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent,
          border: Border.all(color: kBlackColor),
        ),
        child: Center(
          child: Row(
            spacing: kMargin5,
            children: [
              Icon(CupertinoIcons.bookmark, size: 18),
              Text('Wishlist', style: TextStyle()),
            ],
          ),
        ),
      ),
    ],
  );
}
