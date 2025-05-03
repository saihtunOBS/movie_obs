import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/home_bloc.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/list_items/movie_list_item.dart';
import 'package:movie_obs/screens/home/free_movie_series_screen.dart';
import 'package:movie_obs/screens/home/notification_screen.dart';
import 'package:movie_obs/screens/home/search_screen.dart';
import 'package:movie_obs/screens/profile/promotion_screen.dart';
import 'package:movie_obs/utils/images.dart';
import 'package:movie_obs/widgets/banner_image_animation.dart';
import 'package:movie_obs/screens/home/movie_type_screen.dart';
import 'package:movie_obs/screens/home/new_release_screen.dart';
import 'package:movie_obs/screens/home/top_trending_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeBloc(context: context),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          title: Row(
            spacing: 10,
            children: [
              Image.asset(kAppIcon, width: 40, height: 40),
              Text(
                'Tuu Tu TV',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: kTextRegular3x,
                ),
              ),
            ],
          ),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          surfaceTintColor: kBackgroundColor,
          foregroundColor: kWhiteColor,
          actions: [
            GestureDetector(
              onTap: () {
                PageNavigator(ctx: context).nextPage(page: PromotionScreen());
              },
              child: CircleAvatar(
                backgroundColor: Colors.black12,
                child: Image.asset(kHomePromotionIcon, width: 35, height: 35),
              ),
            ),
            5.hGap,
            GestureDetector(
              onTap: () {
                PageNavigator(
                  ctx: context,
                ).nextPage(page: NotificationScreen());
              },
              child: CircleAvatar(
                backgroundColor: Colors.black12,
                child: Icon(CupertinoIcons.bell, color: kWhiteColor),
              ),
            ),
            5.hGap,
            GestureDetector(
              onTap: () {
                PageNavigator(ctx: context).nextPage(page: SearchScreen());
              },
              child: CircleAvatar(
                backgroundColor: Colors.black12,
                child: Icon(CupertinoIcons.search, color: kWhiteColor),
              ),
            ),
            10.hGap,
          ],
        ),
        body: Consumer<HomeBloc>(
          builder:
              (context, bloc, child) => CustomScrollView(
                physics: ClampingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: 15)),
                  SliverToBoxAdapter(
                    child: Visibility(
                      visible: bloc.bannerList.isNotEmpty,
                      child: Container(
                        height: getDeviceType() == 'phone' ? 220 : 350,
                        color: Colors.transparent,
                        child: BannerImageAnimation(),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: _buildOptions()),

                  if (bloc.freeMovieLists.isNotEmpty) ...[
                    SliverPersistentHeader(
                      pinned: false,
                      delegate: _SliverHeader(
                        title:
                            AppLocalizations.of(context)?.freeMovieSeries ?? '',
                        onPress: () {
                          PageNavigator(
                            ctx: context,
                          ).nextPage(page: FreeMovieSeriesScreen());
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _buildMovieOptions(bloc.freeMovieLists),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 10)),
                  ],
                  if (bloc.topTrendingMoviesList.isNotEmpty) ...[
                    SliverPersistentHeader(
                      pinned: false,
                      delegate: _SliverHeader(
                        title: 'Top Trending',
                        onPress: () {
                          PageNavigator(
                            ctx: context,
                          ).nextPage(page: TopTrendingScreen());
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _buildMovieOptions(bloc.topTrendingMoviesList),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 10)),
                  ],
                  if (bloc.newReleaseMoviesList.isNotEmpty) ...[
                    SliverPersistentHeader(
                      pinned: false,
                      delegate: _SliverHeader(
                        title: AppLocalizations.of(context)?.newRelease ?? '',
                        onPress: () {
                          PageNavigator(ctx: context).nextPage(
                            page: NewReleaseScreen(
                              movieLists: bloc.newReleaseMoviesList,
                            ),
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _buildMovieOptions(bloc.newReleaseMoviesList),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 10)),
                  ],
                  if (bloc.movieLists.isNotEmpty) ...[
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverHeader(
                        title:
                            AppLocalizations.of(context)?.allMovieSeries ?? '',
                        isAllMovie: true,
                        onPress: () {
                          PageNavigator(ctx: context).nextPage(
                            page: NewReleaseScreen(movieLists: bloc.movieLists),
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _buildAllMovieSeries(bloc.movieLists),
                    ),
                  ],
                  SliverToBoxAdapter(child: SizedBox(height: 20)),
                ],
              ),
        ),
      ),
    );
  }

  Widget _buildOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kMarginMedium2,
        vertical: kMarginMedium2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Column(
              spacing: 10,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Icon(
                      CupertinoIcons.dot_radiowaves_left_right,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)?.live ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: kWhiteColor),
                ),
              ],
            ),
          ),
          SizedBox(
             width: 80,
            child: Column(
              spacing: 10,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Icon(CupertinoIcons.app_badge, color: kPrimaryColor),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)?.program ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: kWhiteColor),
                ),
              ],
            ),
          ),
          SizedBox(
             width: 80,
            child: Column(
              spacing: 10,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Icon(CupertinoIcons.bookmark, color: kPrimaryColor),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)?.watchlist ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: kWhiteColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieOptions(List<MovieVO> movies) {
    return SizedBox(
      height: 180,
      width: double.infinity,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: kMarginMedium2),
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              PageNavigator(
                ctx: context,
              ).nextPage(page: MovieTypeScreen(movie: movies[index]));
            },
            child: SizedBox(
              width: 140,
              child: movieListItem(
                movies: movies[index],
                padding: kMarginMedium,
                type: movies[index].type,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAllMovieSeries(List<MovieVO> movies) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: kMarginMedium2),
      physics: NeverScrollableScrollPhysics(),
      itemCount: movies.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            PageNavigator(
              ctx: context,
            ).nextPage(page: MovieTypeScreen(movie: movies[index]));
          },
          child: movieListItem(
            movies: movies[index],
            isHomeScreen: true,
            type: movies[index].type,
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 220,
      ),
    );
  }
}

class _SliverHeader extends SliverPersistentHeaderDelegate {
  final String title;
  final VoidCallback onPress;
  final bool? isAllMovie;

  _SliverHeader({required this.title, required this.onPress, this.isAllMovie});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: kBackgroundColor,
      padding: const EdgeInsets.symmetric(
        horizontal: kMarginMedium2,
        vertical: 10,
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: kTextRegular3x - 1,
              fontWeight: FontWeight.w800,
            ),
          ),
          IconButton(
            onPressed: onPress,
            icon: Icon(
              isAllMovie == true ? null : CupertinoIcons.arrow_right,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 50;
  @override
  double get minExtent => 50;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
