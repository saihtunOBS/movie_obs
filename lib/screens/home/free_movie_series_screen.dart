import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/home_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/list_items/movie_list_item.dart';
import 'package:movie_obs/screens/series/season_episode_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/empty_view.dart';
import 'package:movie_obs/widgets/free_movie_series_filter.dart';
import 'package:movie_obs/widgets/movie_filter_sheet.dart';
import 'package:movie_obs/widgets/shimmer_loading.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:provider/provider.dart';

import '../../extension/page_navigator.dart';
import '../series/series_detail_screen.dart';
import 'movie_detail_screen.dart';
import 'package:movie_obs/l10n/app_localizations.dart';

class FreeMovieSeriesScreen extends StatefulWidget {
  const FreeMovieSeriesScreen({super.key});
  @override
  State<FreeMovieSeriesScreen> createState() => _FreeMovieSeriesScreenState();
}

class _FreeMovieSeriesScreenState extends State<FreeMovieSeriesScreen> {
  final scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeBloc(),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          surfaceTintColor: kBackgroundColor,
          foregroundColor: kWhiteColor,
          title: Text(AppLocalizations.of(context)?.freeMovieSeries ?? ''),
          centerTitle: false,
          actions: [
            Consumer<HomeBloc>(
              builder:
                  (context, bloc, child) => GestureDetector(
                    onTap: () {
                      if (getDeviceType() == 'phone') {
                        showModalBottomSheet(
                          useRootNavigator: true,
                          context: context,
                          builder: (context) {
                            return freeMovieSeriesFilterSheet(
                              () {},
                              filter: (data) {
                                bloc.filter(
                                  data.plan == 'Pay per view'
                                      ? 'PAY_PER_VIEW'
                                      : data.plan.toUpperCase(),
                                  data.newGenre ?? '',
                                  data.genreOrContentType == ''
                                      ? 'BOTH'
                                      : data.genreOrContentType.toUpperCase(),
                                );
                                return data;
                              },
                            );
                          },
                        );
                      } else {
                        showMovieRightSideSheet(context);
                      }
                    },
                    child: Container(
                      width: 42,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        CupertinoIcons.slider_horizontal_3,
                        color: kPrimaryColor,
                        size: 19,
                      ),
                    ),
                  ),
            ),
            kMarginMedium2.hGap,
          ],
        ),
        body: Consumer<HomeBloc>(
          builder:
              (context, bloc, child) => RefreshIndicator(
                onRefresh: () async {
                  bloc.getLastedMovies();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child:
                      bloc.isLoading
                          ? shimmerLoading(isVertical: true)
                          : Stack(
                            children: [
                              bloc.lastedMoviesLists.isNotEmpty
                                  ? GridView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount: bloc.lastedMoviesLists.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              getDeviceType() == 'phone'
                                                  ? 2
                                                  : 3,
                                          mainAxisExtent: 230,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                        ),
                                    padding: EdgeInsets.only(
                                      left: kMarginMedium2,
                                      right: kMarginMedium2,
                                      bottom: 60,
                                    ),
                                    controller:
                                        scrollController..addListener(() {
                                          if (scrollController
                                                  .position
                                                  .pixels ==
                                              scrollController
                                                  .position
                                                  .maxScrollExtent) {
                                            if (bloc.lastedMoviesLists.length >=
                                                10) {
                                              bloc.loadMoreFreeMovieAndSeries();
                                            }
                                          }
                                        }),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (bloc
                                                  .lastedMoviesLists[index]
                                                  .type ==
                                              'movie') {
                                            PageNavigator(
                                              ctx: context,
                                            ).nextPage(
                                              page: MovieDetailScreen(
                                                movie:
                                                    bloc.lastedMoviesLists[index],
                                              ),
                                            );
                                          } else {
                                            if (bloc
                                                    .lastedMoviesLists[index]
                                                    .seasons
                                                    ?.length ==
                                                1) {
                                              PageNavigator(
                                                ctx: context,
                                              ).nextPage(
                                                page: SeasonEpisodeScreen(
                                                  seriesResponse:
                                                      bloc.lastedMoviesLists[index]
                                                          .toDetail(),
                                                  seriesId:
                                                      bloc
                                                          .lastedMoviesLists[index]
                                                          .id,
                                                  season:
                                                      bloc
                                                          .lastedMoviesLists[index]
                                                          .seasons
                                                          ?.first,
                                                ),
                                              );
                                            } else {
                                              PageNavigator(
                                                ctx: context,
                                              ).nextPage(
                                                page: SeriesDetailScreen(
                                                  series:
                                                      bloc.lastedMoviesLists[index],
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        child: movieListItem(
                                          movies: bloc.lastedMoviesLists[index],
                                          type:
                                              bloc
                                                  .lastedMoviesLists[index]
                                                  .type,
                                        ),
                                      );
                                    },
                                  )
                                  : EmptyView(
                                    reload: () {
                                      bloc.getLastedMovies();
                                    },
                                    title: 'There is no free movies & series',
                                  ),
                              //load more loading
                              Positioned(
                                bottom: 30,
                                left: 0,
                                right: 0,
                                child:
                                    bloc.isLoadMore
                                        ? Center(
                                          child: SizedBox(
                                            width: 25,
                                            height: 25,
                                            child: LoadingView(),
                                          ),
                                        )
                                        : SizedBox.shrink(),
                              ),
                            ],
                          ),
                ),
              ),
        ),
      ),
    );
  }
}
