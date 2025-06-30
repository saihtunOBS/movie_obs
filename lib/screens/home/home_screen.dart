import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_obs/bloc/home_bloc.dart';
import 'package:movie_obs/data/persistence/persistence_data.dart';
import 'package:movie_obs/data/vos/collection_vo.dart';
import 'package:movie_obs/data/vos/movie_vo.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/list_items/movie_list_item.dart';
import 'package:movie_obs/network/responses/movie_detail_response.dart';
import 'package:movie_obs/screens/home/collection_detail_screen.dart';
import 'package:movie_obs/screens/home/free_movie_series_screen.dart';
import 'package:movie_obs/screens/home/notification_screen.dart';
import 'package:movie_obs/screens/home/search_screen.dart';
import 'package:movie_obs/screens/profile/promotion_screen.dart';
import 'package:movie_obs/screens/profile/watch_list_screen.dart';
import 'package:movie_obs/screens/series/season_episode_screen.dart';
import 'package:movie_obs/screens/series/series_detail_screen.dart';
import 'package:movie_obs/utils/images.dart';
import 'package:movie_obs/widgets/banner_image_animation.dart';
import 'package:movie_obs/screens/home/movie_detail_screen.dart';
import 'package:movie_obs/screens/home/new_release_screen.dart';
import 'package:movie_obs/screens/home/top_trending_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/shimmer_loading.dart';
import 'package:provider/provider.dart';

import 'package:movie_obs/l10n/app_localizations.dart';

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
              kMarginMedium.hGap,
              Image.asset(kAppIcon, width: 45, height: 45),
              Image.asset(kAppTextLogo, height: 15),
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
              child: SizedBox(
                height: 35,
                width: 35,
                child: CircleAvatar(
                  backgroundColor: Colors.grey.withValues(alpha: 0.2),
                  child: Icon(
                    CupertinoIcons.bell,
                    color: kWhiteColor,
                    size: 22,
                  ),
                ),
              ),
            ),
            7.hGap,
            GestureDetector(
              onTap: () {
                PageNavigator(ctx: context).nextPage(page: SearchScreen());
              },
              child: SizedBox(
                height: 35,
                width: 35,
                child: CircleAvatar(
                  backgroundColor: Colors.grey.withValues(alpha: 0.2),
                  child: Icon(
                    CupertinoIcons.search,
                    color: kWhiteColor,
                    size: 22,
                  ),
                ),
              ),
            ),
            10.hGap,
          ],
        ),
        body: Consumer<HomeBloc>(
          builder:
              (context, bloc, child) => RefreshIndicator(
                onRefresh: () async {
                  bloc.onRefresh();
                },
                child:
                    bloc.isLoading
                        ? homeShimmerLoading()
                        : CustomScrollView(
                          physics: ClampingScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(child: SizedBox(height: 15)),
                            SliverToBoxAdapter(
                              child: Visibility(
                                visible: bloc.bannerList.isNotEmpty,
                                child: Container(
                                  height:
                                      getDeviceType() == 'phone' ? 220 : 350,
                                  color: Colors.transparent,
                                  child: BannerImageAnimation(),
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(child: _buildOptions()),

                            //lasted movies
                            if (bloc.lastedMoviesLists.isNotEmpty) ...[
                              SliverPersistentHeader(
                                pinned: false,
                                delegate: _SliverHeader(
                                  title:
                                      AppLocalizations.of(
                                        context,
                                      )?.lastedMovies ??
                                      '',
                                  onPress: () {
                                    PageNavigator(
                                      ctx: context,
                                    ).nextPage(page: FreeMovieSeriesScreen());
                                  },
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: _buildMovieOptions(
                                  bloc.lastedMoviesLists,
                                ),
                              ),
                              SliverToBoxAdapter(child: SizedBox(height: 10)),
                            ],

                            ///lasted series
                            if (bloc.lastedSeriesLists.isNotEmpty) ...[
                              SliverPersistentHeader(
                                pinned: false,
                                delegate: _SliverHeader(
                                  title:
                                      AppLocalizations.of(
                                        context,
                                      )?.lastedSeries ??
                                      '',
                                  onPress: () {
                                    PageNavigator(
                                      ctx: context,
                                    ).nextPage(page: FreeMovieSeriesScreen());
                                  },
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: _buildMovieOptions(
                                  bloc.lastedSeriesLists,
                                ),
                              ),
                              SliverToBoxAdapter(child: SizedBox(height: 10)),
                            ],

                            ///top trending
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
                                child: _buildMovieOptions(
                                  bloc.topTrendingMoviesList,
                                ),
                              ),
                              SliverToBoxAdapter(child: SizedBox(height: 10)),
                            ],

                            ///new release
                            if (bloc.newReleaseMoviesList.isNotEmpty) ...[
                              SliverPersistentHeader(
                                pinned: false,
                                delegate: _SliverHeader(
                                  title:
                                      AppLocalizations.of(
                                        context,
                                      )?.newRelease ??
                                      '',
                                  onPress: () {
                                    PageNavigator(
                                      ctx: context,
                                    ).nextPage(page: NewReleaseScreen());
                                  },
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: _buildMovieOptions(
                                  bloc.newReleaseMoviesList,
                                  isNewrelease: true,
                                ),
                              ),
                              SliverToBoxAdapter(child: SizedBox(height: 10)),
                            ],

                            //collection
                            if (bloc.categoryCollectionLists.isNotEmpty) ...[
                              for (var collectionData
                                  in bloc.categoryCollectionLists) ...[
                                SliverPersistentHeader(
                                  pinned: false,
                                  delegate: _SliverHeader(
                                    title: collectionData.name ?? '',
                                    onPress: () {
                                      PageNavigator(ctx: context).nextPage(
                                        page: CollectionDetailScreen(
                                          collectionData: collectionData,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: _buildCollectionMovie(
                                    collectionData.items ?? [],
                                  ),
                                ),
                                SliverToBoxAdapter(child: SizedBox(height: 10)),
                              ],
                            ],
                            if (bloc.movieLists.isNotEmpty) ...[
                              SliverPersistentHeader(
                                pinned: true,
                                delegate: _SliverHeader(
                                  title:
                                      AppLocalizations.of(
                                        context,
                                      )?.allMovieSeries ??
                                      '',
                                  isAllMovie: true,
                                  onPress: () {
                                    PageNavigator(
                                      ctx: context,
                                    ).nextPage(page: NewReleaseScreen());
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
      ),
    );
  }

  Widget _buildOptions() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            PersistenceData.shared.getLocale() != 'en' ? kMarginMedium2 : 0,
        vertical: kMarginMedium2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
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
                  style: TextStyle(
                    fontFamily:
                        PersistenceData.shared.getLocale() == 'en'
                            ? GoogleFonts.prata().fontFamily
                            : GoogleFonts.notoSerifMyanmar().fontFamily,
                    fontSize:
                        PersistenceData.shared.getLocale() != 'en' ? 12 : 14,
                    color: kWhiteColor,
                    fontWeight: FontWeight.w700,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 70,
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
                  style: TextStyle(
                    fontFamily:
                        PersistenceData.shared.getLocale() == 'en'
                            ? GoogleFonts.prata().fontFamily
                            : GoogleFonts.notoSerifMyanmar().fontFamily,
                    fontSize:
                        PersistenceData.shared.getLocale() != 'en' ? 12 : 14,
                    color: kWhiteColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              PageNavigator(ctx: context).nextPage(page: WatchListScreen());
            },
            child: SizedBox(
              width: 70,
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
                        CupertinoIcons.bookmark,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)?.watchlist ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily:
                          PersistenceData.shared.getLocale() == 'en'
                              ? GoogleFonts.prata().fontFamily
                              : GoogleFonts.notoSerifMyanmar().fontFamily,
                      fontSize:
                          PersistenceData.shared.getLocale() != 'en' ? 12 : 14,
                      color: kWhiteColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieOptions(List<MovieVO> movies, {bool? isNewrelease}) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: kMarginMedium2),
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (movies[index].type == 'movie') {
                PageNavigator(
                  ctx: context,
                ).nextPage(page: MovieDetailScreen(movie: movies[index]));
              } else {
                if (movies[index].seasons?.length == 1) {
                  PageNavigator(ctx: context).nextPage(
                    page: SeasonEpisodeScreen(
                      seriesResponse: movies[index].toDetail(),
                      seriesId: movies[index].id,
                      season: movies[index].seasons?.first,
                    ),
                  );
                } else {
                  PageNavigator(
                    ctx: context,
                  ).nextPage(page: SeriesDetailScreen(series: movies[index]));
                }
              }
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 3.35,
              child: movieListItem(
                isHomeScreen: true,
                movies: movies[index],
                padding: kMarginMedium,
                type:
                    isNewrelease == true
                        ? movies[index].type
                        : movies[index].plan,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCollectionMovie(List<CollectionItemVO> movies) {
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
              if (movies[index].referenceModel == 'Movie') {
                PageNavigator(ctx: context).nextPage(
                  page: MovieDetailScreen(movie: movies[index].reference),
                );
              } else {
                if (movies[index].reference?.seasons?.length == 1) {
                  PageNavigator(ctx: context).nextPage(
                    page: SeasonEpisodeScreen(
                      seriesResponse:
                          movies[index].reference?.toDetail() ??
                          MovieDetailResponse(),
                      seriesId: movies[index].reference?.id,
                      season: movies[index].reference?.seasons?.first,
                    ),
                  );
                } else {
                  PageNavigator(ctx: context).nextPage(
                    page: SeriesDetailScreen(series: movies[index].reference),
                  );
                }
              }
            },
            child: SizedBox(
              width: 140,
              child: movieListItem(
                movies: movies[index].reference,
                padding: kMarginMedium,
                type: movies[index].reference?.plan,
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
            if (movies[index].type == 'movie') {
              PageNavigator(
                ctx: context,
              ).nextPage(page: MovieDetailScreen(movie: movies[index]));
            } else {
              if (movies[index].seasons?.length == 1) {
                PageNavigator(ctx: context).nextPage(
                  page: SeasonEpisodeScreen(
                    seriesResponse: movies[index].toDetail(),
                    seriesId: movies[index].id,
                    season: movies[index].seasons?.first,
                  ),
                );
              } else {
                PageNavigator(
                  ctx: context,
                ).nextPage(page: SeriesDetailScreen(series: movies[index]));
              }
            }
          },
          child: movieListItem(movies: movies[index], type: movies[index].type),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 230,
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
            style: TextStyle(
              fontSize: kTextRegular3x - 1,
              fontWeight: FontWeight.w700,
              fontFamily: GoogleFonts.cinzel().fontFamily,
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
