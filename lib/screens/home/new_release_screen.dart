import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/new_release_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/utils/calculate_time.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/cache_image.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../utils/images.dart';
import '../../widgets/common_dialog.dart';
import '../../widgets/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewReleaseScreen extends StatefulWidget {
  const NewReleaseScreen({super.key});

  @override
  State<NewReleaseScreen> createState() => _NewReleaseScreenState();
}

class _NewReleaseScreenState extends State<NewReleaseScreen> {
  final CarouselSliderController controller = CarouselSliderController();
  final ValueNotifier<int> sliderIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewReleaseBloc(),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          surfaceTintColor: kBackgroundColor,
          title: Text(AppLocalizations.of(context)?.newRelease ?? ''),
        ),
        body: Consumer<NewReleaseBloc>(
          builder:
              (context, bloc, child) =>
                  bloc.isLoading
                      ? LoadingView()
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),

                          /// Slider
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.45,
                            child: ValueListenableBuilder(
                              valueListenable: sliderIndex,
                              builder:
                                  (context, value, child) => CarouselSlider(
                                    items:
                                        bloc.newReleaseMoviesList.map((data) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: kWhiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: cacheImage(
                                                data.posterImageUrl ?? '',
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                    options: CarouselOptions(
                                      autoPlay: false,
                                      viewportFraction:
                                          getDeviceType() == 'phone'
                                              ? 0.8
                                              : 0.5,
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

                          /// Movie Title
                          Text(
                            bloc.newReleaseMoviesList[sliderIndex.value].name ??
                                '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: kTextRegular3x,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          10.vGap,
                          _buildMinuteAndViewCount(bloc),
                          10.vGap,

                          const Text(
                            'Action, Romance, Drama',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kPrimaryColor),
                          ),

                          20.vGap,
                          _buildUnlockAndWishlist(bloc),

                          30.vGap,

                          /// Indicator
                          ValueListenableBuilder(
                            valueListenable: sliderIndex,
                            builder:
                                (context, value, child) =>
                                    AnimatedSmoothIndicator(
                                      effect: const ExpandingDotsEffect(
                                        dotHeight: kMargin5,
                                        dotWidth: kMargin5,
                                        activeDotColor: kSecondaryColor,
                                        dotColor: kWhiteColor,
                                      ),
                                      activeIndex: value,
                                      count: bloc.newReleaseMoviesList.length,
                                    ),
                          ),
                        ],
                      ),
        ),
      ),
    );
  }

  Widget _buildMinuteAndViewCount(NewReleaseBloc bloc) {
    final movie = bloc.newReleaseMoviesList[sliderIndex.value];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: kMargin12 + 4,
      children: [
        Text(
          formatMinutesToHoursAndMinutes(movie.duration ?? 0),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 5,
          height: 5,
          child: CircleAvatar(backgroundColor: kWhiteColor),
        ),
        Row(
          spacing: kMargin5,
          children: [
            const Icon(CupertinoIcons.eye),
            Text(
              movie.viewCount.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUnlockAndWishlist(NewReleaseBloc bloc) {
    final movie = bloc.newReleaseMoviesList[sliderIndex.value];
    final isWishlisted = movie.isWatchlist ?? false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: kMarginMedium2 - 3,
      children: [
        bloc.newReleaseMoviesList[sliderIndex.value].plan == 'PAY_PER_VIEW'
            ? _payPerView(
              bloc.newReleaseMoviesList[sliderIndex.value].payPerViewPrice ?? 0,
              context,
            )
            : Container(
              height: 30,
              padding: const EdgeInsets.symmetric(
                horizontal: kMarginMedium + 4,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: kSecondaryColor.withValues(alpha: 0.2),
              ),
              child: Center(
                child: Row(
                  spacing: kMargin5,
                  children: [
                    Text(
                      bloc.newReleaseMoviesList[sliderIndex.value].plan ?? '',
                      style: TextStyle(color: kPrimaryColor),
                    ),
                  ],
                ),
              ),
            ),

        /// Wishlist toggle
        GestureDetector(
          onTap: () {
            setState(() {
              movie.isWatchlist = !isWishlisted;
              if (movie.type == 'movie') {
                bloc.toggleWatchlist('movie', movie.id ?? '');
              } else {
                bloc.toggleWatchlist('series', movie.id ?? '');
              }
            });
          },
          child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: kMarginMedium),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color:
                  isWishlisted
                      ? kSecondaryColor.withValues(alpha: 0.2)
                      : Colors.transparent,
              border: Border.all(
                color: isWishlisted ? kSecondaryColor : kWhiteColor,
              ),
            ),
            child: Center(
              child: Row(
                spacing: kMargin5,
                children: [
                  Icon(
                    isWishlisted
                        ? CupertinoIcons.bookmark_fill
                        : CupertinoIcons.bookmark,
                    size: 18,
                    color: isWishlisted ? kSecondaryColor : kWhiteColor,
                  ),
                  Text('Wishlist', style: const TextStyle(color: kWhiteColor)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _payPerView(int price, BuildContext context) {
    return GestureDetector(
      onTap:
          () => showCommonDialog(
            context: context,
            dialogWidget: _buildAlert(price),
          ),
      child: Container(
        height: 30,
        padding: EdgeInsets.symmetric(horizontal: kMarginMedium + 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kSecondaryColor.withValues(alpha: 0.2),
        ),
        child: Center(
          child: Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, color: kPrimaryColor, size: 15),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '$price Ks to Unlock',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlert(int price) {
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      backgroundColor: kWhiteColor,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withValues(alpha: 0.4),
                  ),
                  child: Center(
                    child: Icon(
                      CupertinoIcons.clear,
                      color: kBlackColor,
                      size: 10,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 56, width: 56, child: Image.asset(kLockOpenLogo)),
            15.vGap,
            Text(
              'Unlock this movie for only $price Ks!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: kTextRegular2x,
                color: kSecondaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            2.vGap,
            Text(
              'Pay now to start watching instantly.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: kTextRegular13, color: kBlackColor),
            ),
            20.vGap,
            SizedBox(
              width: 140,
              child: customButton(
                height: 35,
                borderRadius: 20,
                onPress: () {},
                context: context,
                backgroundColor: kSecondaryColor,
                title: 'Purchase',
                textColor: kWhiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
