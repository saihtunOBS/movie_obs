import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/history_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/list_items/movie_list_item.dart';
import 'package:movie_obs/network/responses/movie_detail_response.dart';
import 'package:movie_obs/screens/series/season_episode_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/shimmer_loading.dart';
import 'package:provider/provider.dart';

import '../../extension/page_navigator.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/show_loading.dart';
import '../home/movie_detail_screen.dart';
import '../series/series_detail_screen.dart';
import 'package:movie_obs/l10n/app_localizations.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
      create: (context) => HistoryBloc(),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          surfaceTintColor: kBackgroundColor,
          title: Text(AppLocalizations.of(context)?.yourHistory ?? ''),
          centerTitle: false,
        ),
        body: Consumer<HistoryBloc>(
          builder:
              (context, bloc, child) => RefreshIndicator(
                onRefresh: () async {
                  bloc.getHistory();
                },
                child:
                    bloc.isLoading
                        ? Padding(
                          padding: EdgeInsets.only(top: kMargin12),
                          child: shimmerLoading(isVertical: true),
                        )
                        : Stack(
                          children: [
                            bloc.historyList.isNotEmpty
                                ? GridView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemCount: bloc.historyList.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            getDeviceType() == 'phone' ? 2 : 3,
                                        mainAxisExtent: 230,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                      ),
                                  padding: EdgeInsets.only(
                                    left: kMarginMedium2,
                                    right: kMarginMedium2,
                                    bottom: 60,
                                    top: kMargin12,
                                  ),
                                  controller:
                                      scrollController..addListener(() {
                                        if (scrollController.position.pixels ==
                                            scrollController
                                                .position
                                                .maxScrollExtent) {
                                          if (bloc.historyList.length >= 10) {
                                            // bloc.loadMoreData();
                                          }
                                        }
                                      }),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        if (bloc.historyList[index].type ==
                                            'MOVIE') {
                                          PageNavigator(ctx: context).nextPage(
                                            page: MovieDetailScreen(
                                              movie:
                                                  bloc
                                                      .historyList[index]
                                                      .reference,
                                            ),
                                          );
                                        } else {
                                          if (bloc
                                                  .historyList[index]
                                                  .reference
                                                  ?.seasons
                                                  ?.length ==
                                              1) {
                                            PageNavigator(
                                              ctx: context,
                                            ).nextPage(
                                              page: SeasonEpisodeScreen(
                                                seriesResponse:
                                                    bloc
                                                        .historyList[index]
                                                        .reference
                                                        ?.toDetail() ??
                                                    MovieDetailResponse(),
                                                seriesId:
                                                    bloc
                                                        .historyList[index]
                                                        .reference
                                                        ?.id,
                                                season:
                                                    bloc
                                                        .historyList[index]
                                                        .reference
                                                        ?.seasons
                                                        ?.first,
                                              ),
                                            );
                                          } else {
                                            PageNavigator(
                                              ctx: context,
                                            ).nextPage(
                                              page: SeriesDetailScreen(
                                                series:
                                                    bloc
                                                        .historyList[index]
                                                        .reference,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: movieListItem(
                                        movies:
                                            bloc.historyList[index].reference,
                                        type:
                                            bloc.historyList[index].type
                                                ?.toLowerCase() ??
                                            '',
                                      ),
                                    );
                                  },
                                )
                                : EmptyView(
                                  title: 'There is no history to show.',
                                  reload: () {
                                    bloc.getHistory();
                                  },
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
    );
  }
}
