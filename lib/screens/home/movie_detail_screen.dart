import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/movie_detail_bloc.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/list_items/cast_list_item.dart';
import 'package:movie_obs/screens/home/actor_view_screen.dart';
import 'package:movie_obs/screens/video_player.dart/video_player_screen.dart';
import 'package:movie_obs/utils/calculate_time.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/utils/images.dart';
import 'package:movie_obs/widgets/cache_image.dart';
import 'package:movie_obs/widgets/common_dialog.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:provider/provider.dart';

import '../../list_items/recommended_movie_list_item.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/expandable_text.dart';
import 'package:movie_obs/l10n/app_localizations.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key, this.movie});
  final MovieVO? movie;

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MovieDetailBloc(widget.movie?.id, context),
      child: Consumer<MovieDetailBloc>(
        builder:
            (context, bloc, child) => Scaffold(
              backgroundColor: kBackgroundColor,
              body: Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        expandedHeight: getDeviceType() == 'phone' ? 250 : 380,
                        automaticallyImplyLeading: false,
                        foregroundColor: Colors.white,
                        backgroundColor: kBackgroundColor,
                        pinned: true,
                        stretch: true,
                        floating: true,
                        flexibleSpace: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: double.infinity,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(35),
                                  bottomRight: Radius.circular(35),
                                ),
                                child: cacheImage(
                                  widget.movie?.posterImageUrl ?? '',
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -17,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  PageNavigator(ctx: context).nextPage(
                                    page: VideoPlayerScreen(
                                      isFirstTime: true,
                                      type: 'trailer',
                                      url: widget.movie?.trailerUrl,
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 35,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: kWhiteColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: _buildWatchTrailerView(
                                    context,
                                    widget.movie?.trailerUrl ?? '',
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 20,
                              top: 40,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    color: kWhiteColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      CupertinoIcons.arrow_left,
                                      size: 20,
                                      color: kBlackColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //body
                      SliverToBoxAdapter(child: _buildBody(context, bloc)),
                    ],
                  ),
                  //loading
                  bloc.isLoading ? LoadingView() : SizedBox.shrink(),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildWatchTrailerView(BuildContext context, String trailerUrl) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              CupertinoIcons.play_circle_fill,
              size: 26,
              color: kBlackColor,
            ),
            const SizedBox(width: 5),
            Text(
              AppLocalizations.of(context)?.watchTrailer ?? '',
              style: TextStyle(
                fontSize: kTextRegular2x - 3,
                color: kBlackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, MovieDetailBloc bloc) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: kMarginMedium2,
        vertical: kMarginMedium2 + 15,
      ),
      child: Column(
        spacing: getDeviceType() == 'phone' ? 8 : 15,
        children: [
          Center(
            child: Text(
              widget.movie?.name ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: kTextRegular18 + 2),
            ),
          ),
          _buildMinuteAndViewCount(bloc),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                bloc.moviesResponse?.genres
                        ?.map((genre) => genre.name ?? '')
                        .join(', ') ??
                    '',
                style: TextStyle(
                  fontSize: kTextSmall,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          _buildTypeAndWatchList(bloc, context),
          1.vGap,
          _buildWatchNowButton(
            context,
            widget.movie?.id ?? '',
            widget.movie?.videoUrl ?? '',
          ),
          _buildCastView(bloc),
          _buildDescription(bloc, context),
          5.vGap,
          _buildRecommendedView(bloc),
        ],
      ),
    );
  }

  Widget _buildRecommendedView(MovieDetailBloc bloc) {
    return bloc.recommendedList?.isEmpty ?? true
        ? SizedBox.shrink()
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommended',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: kTextRegular18,
              ),
            ),
            7.vGap,
            SizedBox(
              height: 170,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: bloc.recommendedList?.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      PageNavigator(ctx: context).nextPage(
                        page: MovieDetailScreen(
                          movie: bloc.recommendedList?[index],
                        ),
                      );
                    },
                    child: recommendedMovieListItem(
                      bloc.recommendedList?[index] ?? MovieVO(),
                    ),
                  );
                },
              ),
            ),
          ],
        );
  }

  Widget _buildCastView(MovieDetailBloc bloc) {
    return SizedBox(
      height: 100,
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bloc.castLists.isEmpty
              ? SizedBox.shrink()
              : Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: bloc.castLists.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        PageNavigator(ctx: context).nextPage(
                          page: ActorViewScreen(
                            id: bloc.castLists[index].cast?.id ?? '',
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: castListItem(actor: bloc.castLists[index]),
                      ),
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildDescription(MovieDetailBloc bloc, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.of(context)?.director ?? ''} ${bloc.moviesResponse?.director ?? ''}',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        5.vGap,
        Divider(thickness: 0.5),
        5.vGap,
        Text(
          '${AppLocalizations.of(context)?.scriptWriter ?? ''} ${bloc.moviesResponse?.scriptWriter ?? ''}',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        20.vGap,
        ExpandableText(
          text: bloc.moviesResponse?.description ?? '',
          style: TextStyle(fontSize: 14),
        ),
        10.vGap,
        Text('Tags', style: TextStyle(fontWeight: FontWeight.w700)),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: bloc.moviesResponse?.tags?.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Chip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  label: Text(
                    '#${bloc.moviesResponse?.tags?[index]}',
                    style: TextStyle(color: kWhiteColor),
                  ),
                  backgroundColor: kBlackColor,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  //https://moviedatatesting.s3.ap-southeast-1.amazonaws.com/Movie2/master.m3u8
  Widget _buildWatchNowButton(
    BuildContext context,
    String videoId,
    String url,
  ) {
    return GestureDetector(
      onTap: () {
        PageNavigator(ctx: context).nextPage(
          page: VideoPlayerScreen(
            url: widget.movie?.videoUrl ?? '',
            isFirstTime: true,
            videoId: videoId,
            type: 'MOVIE',
          ),
        );
      },
      child: Column(
        spacing: 2,
        children: [
          Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: kSecondaryColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Icon(CupertinoIcons.video_camera, color: kWhiteColor, size: 27),
                Text(
                  AppLocalizations.of(context)?.watchNow ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kWhiteColor,
                  ),
                ),
              ],
            ),
          ),
          Image.asset(kShadowImage),
        ],
      ),
    );
  }

  Widget _buildMinuteAndViewCount(MovieDetailBloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: kMargin12 + 4,
      children: [
        Text(
          formatMinutesToHoursAndMinutes(bloc.moviesResponse?.duration ?? 0),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        SizedBox(
          width: 5,
          height: 5,
          child: CircleAvatar(backgroundColor: Colors.grey),
        ),

        Row(
          spacing: kMargin5,
          children: [
            Icon(CupertinoIcons.eye, size: 20, color: Colors.grey),
            Text(
              bloc.moviesResponse?.viewCount.toString() ?? '',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeAndWatchList(MovieDetailBloc bloc, BuildContext context) {
    bool isWishlisted = bloc.moviesResponse?.isWatchlist ?? false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: kMarginMedium2 - 3,
      children: [
        bloc.moviesResponse?.plan == 'PAY_PER_VIEW'
            ? _payPerView(bloc.moviesResponse?.payPerViewPrice ?? 0, context)
            : Container(
              height: 30,
              padding: EdgeInsets.symmetric(horizontal: kMarginMedium + 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: kSecondaryColor.withValues(alpha: 0.2),
              ),
              child: Center(
                child: Text(
                  bloc.moviesResponse?.plan ?? '',
                  style: TextStyle(color: kPrimaryColor),
                ),
              ),
            ),
        GestureDetector(
          onTap: () {
            bloc.toggleWatchlist();
          },
          child: Container(
            height: 30,
            padding: EdgeInsets.symmetric(horizontal: kMarginMedium),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent,
              border: Border.all(
                color: isWishlisted ? kSecondaryColor : kWhiteColor,
              ),
            ),
            child: Center(
              child: Row(
                spacing: kMargin5,
                children: [
                  Icon(
                    CupertinoIcons.bookmark_fill,
                    size: 18,
                    color: isWishlisted ? kSecondaryColor : kWhiteColor,
                  ),
                  Text('Watchlist', style: TextStyle(color: kWhiteColor)),
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
