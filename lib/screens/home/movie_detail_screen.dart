import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/movie_detail_bloc.dart';
import 'package:movie_obs/data/dummy/dummy_data.dart';
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
import 'package:provider/provider.dart';

import '../../list_items/recommended_movie_list_item.dart';
import '../../widgets/expandable_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key, this.movie});
  final MovieVO? movie;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MovieDetailBloc(movie?.id),
      child: Consumer<MovieDetailBloc>(
        builder:
            (context, bloc, child) => Scaffold(
              backgroundColor: kBackgroundColor,
              body: CustomScrollView(
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
                            child: cacheImage(imageArray.last),
                          ),
                        ),
                        Positioned(
                          bottom: -17,
                          child: Container(
                            height: 35,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: kWhiteColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: _buildWatchTrailerView(context),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 55,
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
            ),
      ),
    );
  }

  Widget _buildWatchTrailerView(BuildContext context) {
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
              movie?.name ?? '',
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
          _buildTypeAndWatchList(),
          1.vGap,
          _buildWatchNowButton(context, movie?.id ?? '', movie?.videoUrl ?? ''),
          _buildCastView(bloc),
          _buildDescription(bloc, context),
          5.vGap,
          _buildRecommendedView(bloc),
        ],
      ),
    );
  }

  Widget _buildRecommendedView(MovieDetailBloc bloc) {
    return 
    // bloc.recommendedList?.isEmpty ?? true
    //     ? SizedBox.shrink()
    //     :
         Column(
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
                itemCount: imageArray.length,
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
          // bloc.moviesResponse?.actors?.isEmpty ?? true
          //     ? SizedBox.shrink()
          //     : 
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageArray.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        PageNavigator(ctx: context).nextPage(
                          page: ActorViewScreen(
                            id:
                                bloc.moviesResponse?.actors?[index].cast?.id ??
                                '',
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: castListItem(
                          actor: bloc.moviesResponse?.actors?[index],
                        ),
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
          text: 'testing testingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtestingtesting',
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
        context.pushTransparentRoute(
          VideoPlayerScreen(url: 'https://moviedatatesting.s3.ap-southeast-1.amazonaws.com/Movie2/master.m3u8', isFirstTime: true, videoId: videoId),
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

  Widget _buildTypeAndWatchList() {
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
                //Icon(CupertinoIcons.lock, color: kWhiteColor, size: 18),
                Text('Free', style: TextStyle(color: kPrimaryColor)),
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
                Text('Watchlist', style: TextStyle()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
