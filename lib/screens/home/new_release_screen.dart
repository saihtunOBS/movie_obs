import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/utils/calculate_time.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/cache_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class NewReleaseScreen extends StatefulWidget {
  const NewReleaseScreen({super.key, required this.movieLists});
  final List<MovieVO> movieLists;

  @override
  State<NewReleaseScreen> createState() => _NewReleaseScreenState();
}

class _NewReleaseScreenState extends State<NewReleaseScreen> {
  final CarouselSliderController controller = CarouselSliderController();
  final ValueNotifier<int> sliderIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        surfaceTintColor: kBackgroundColor,
        title: Text('New Releases'),
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
                        widget.movieLists.map((data) {
                          return Container(
                            decoration: BoxDecoration(
                              color: kWhiteColor,
                              borderRadius: BorderRadiusDirectional.circular(
                                20,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: cacheImage(data.posterImageUrl ?? ''),
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
                        setState(() {});
                      },
                    ),
                  ),
            ),
          ),

          20.vGap,
          // label
          Text(
            widget.movieLists[sliderIndex.value].name ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: kTextRegular3x,
              fontWeight: FontWeight.bold,
            ),
          ),
          10.vGap,
          _buildMinuteAndViewCount(),
          10.vGap,
          Text(
            'Action, Romance, Drama',
            textAlign: TextAlign.center,
            style: TextStyle(color: kThirdColor),
          ),
          20.vGap,
          _buildUnlockAndWishlist(),

          30.vGap,
          //indicator
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
                  count: widget.movieLists.length,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinuteAndViewCount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: kMargin12 + 4,
      children: [
        Text(
          formatMinutesToHoursAndMinutes(
            widget.movieLists[sliderIndex.value].duration ?? 0,
          ),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 5,
          height: 5,
          child: CircleAvatar(backgroundColor: kWhiteColor),
        ),

        Row(
          spacing: kMargin5,
          children: [
            Icon(CupertinoIcons.eye),
            Text(
              widget.movieLists[sliderIndex.value].viewCount.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
            color: kSecondaryColor.withValues(alpha: 0.2),
          ),
          child: Center(
            child: Row(
              spacing: kMargin5,
              children: [
                Icon(CupertinoIcons.lock, color: kWhiteColor, size: 18),
                Text('2000 Ks to unlock', style: TextStyle(color: kThirdColor)),
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
            border: Border.all(color: kWhiteColor),
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
}
