import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/watchlist_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/list_items/movie_list_item.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/movie_filter_sheet.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../../extension/page_navigator.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/search_filter_sheet.dart';
import '../../widgets/show_loading.dart';
import '../home/movie_detail_screen.dart';
import '../series/series_detail_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WatchListScreen extends StatefulWidget {
  const WatchListScreen({super.key});

  @override
  State<WatchListScreen> createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
  final TextEditingController _controller = TextEditingController();

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
      create: (context) => WatchlistBloc(),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          surfaceTintColor: kBackgroundColor,
          title: Text(AppLocalizations.of(context)?.watchlist ?? ''),
          centerTitle: false,
          actions: [
            Consumer<WatchlistBloc>(
              builder:
                  (context, bloc, child) => GestureDetector(
                    onTap: () {
                      if (getDeviceType() == 'phone') {
                        showModalBottomSheet(
                          useRootNavigator: true,
                          context: context,
                          builder: (context) {
                            return searchFilterSheet(
                              () {},
                              isWatchList: true,
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
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 55),
            child: Padding(
              padding: EdgeInsets.only(
                left: kMarginMedium2,
                right:
                    getDeviceType() == 'phone'
                        ? kMarginMedium2
                        : MediaQuery.sizeOf(context).width / 2,
              ),
              child: Consumer<WatchlistBloc>(
                builder:
                    (context, bloc, child) => SizedBox(
                      height: 50,
                      child: SearchBar(
                        controller: _controller,
                        leading: Icon(CupertinoIcons.search),
                        hintText:
                            AppLocalizations.of(context)?.searchByMovieSeries ??
                            '',
                        backgroundColor: WidgetStateProperty.all(
                          Colors.grey.withValues(alpha: 0.2),
                        ),
                        trailing: [
                          Visibility(
                            visible: _controller.text.isNotEmpty,
                            child: GestureDetector(
                              onTap: () {
                                _controller.clear();
                                bloc.clearFilter();
                              },
                              child: Icon(
                                CupertinoIcons.clear_circled,
                                color: kWhiteColor,
                              ),
                            ),
                          ),
                        ],
                        hintStyle: WidgetStateProperty.resolveWith<TextStyle>(
                          (_) => TextStyle(color: kWhiteColor),
                        ),
                        onChanged: (value) => bloc.onSearchChanged(value),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              24,
                            ), // your border radius
                          ),
                        ),
                      ),
                    ),
              ),
            ),
          ),
        ),
        body: Consumer<WatchlistBloc>(
          builder:
              (context, bloc, child) => RefreshIndicator(
                onRefresh: () async {
                  bloc.getWatchList();
                },
                child:
                    bloc.isLoading
                        ? LoadingView()
                        : bloc.watchLists.isNotEmpty
                        ? Stack(
                          children: [
                            GridView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: bloc.watchLists.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        getDeviceType() == 'phone' ? 2 : 3,
                                    mainAxisExtent: 200,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                  ),
                              padding: EdgeInsets.only(
                                left: kMarginMedium2,
                                right: kMarginMedium2,
                                bottom: 60,
                                top: kMarginMedium + 2,
                              ),
                              controller:
                                  scrollController..addListener(() {
                                    if (scrollController.position.pixels ==
                                        scrollController
                                            .position
                                            .maxScrollExtent) {
                                      if (bloc.watchLists.length >= 10) {
                                        bloc.loadMoreData();
                                      }
                                    }
                                  }),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    bloc.watchLists[index].type == 'MOVIE'
                                        ? PageNavigator(ctx: context).nextPage(
                                          page: MovieDetailScreen(
                                            movie:
                                                bloc
                                                    .watchLists[index]
                                                    .reference,
                                          ),
                                        )
                                        : PageNavigator(ctx: context).nextPage(
                                          page: SeriesDetailScreen(
                                            series:
                                                bloc
                                                    .watchLists[index]
                                                    .reference,
                                          ),
                                        );
                                  },
                                  child: movieListItem(
                                    movies: bloc.watchLists[index].reference,
                                    type:
                                        bloc.watchLists[index].type
                                            ?.toLowerCase() ??
                                        '',
                                  ),
                                );
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
                            bloc.filteredSuggestions.isEmpty
                                ? SizedBox.shrink()
                                : Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.black12,
                                  ),
                                ),
                            Container(
                              height:
                                  bloc.filteredSuggestions.isEmpty ? 0 : null,
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(
                                horizontal: kMarginMedium2,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: kMarginMedium,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(kMargin10),
                                color: kWhiteColor,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    bloc.filteredSuggestions.map((value) {
                                      return GestureDetector(
                                        onTap: () {
                                          value.type == 'MOVIE'
                                              ? PageNavigator(
                                                ctx: context,
                                              ).nextPage(
                                                page: MovieDetailScreen(
                                                  movie: value.reference,
                                                ),
                                              )
                                              : PageNavigator(
                                                ctx: context,
                                              ).nextPage(
                                                page: SeriesDetailScreen(
                                                  series: value.reference,
                                                ),
                                              );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: kMarginMedium,
                                            vertical: kMarginMedium,
                                          ),
                                          child: SubstringHighlight(
                                            text: value.reference?.name ?? '',
                                            term: _controller.text,
                                            textStyleHighlight: TextStyle(
                                              color: kSecondaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ],
                        )
                        : EmptyView(
                          title: 'There is no movie to show.',
                          reload: () {
                            bloc.getWatchList();
                          },
                        ),
              ),
        ),
      ),
    );
  }
}
