import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/movie_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/list_items/movie_list_item.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/movie_filter_sheet.dart';
import 'package:movie_obs/widgets/shimmer_loading.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../../extension/page_navigator.dart';
import '../../widgets/empty_view.dart';
import '../home/movie_detail_screen.dart';
import 'package:movie_obs/l10n/app_localizations.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
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
      create: (context) => MovieBloc(),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          surfaceTintColor: kBackgroundColor,
          foregroundColor: kWhiteColor,
          title: Padding(
            padding: const EdgeInsets.only(left: kMarginMedium2),
            child: Text('Too To\'s Movies'),
          ),
          centerTitle: false,
          actions: [
            Consumer<MovieBloc>(
              builder:
                  (context, bloc, child) => GestureDetector(
                    onTap: () {
                      if (getDeviceType() == 'phone') {
                        showModalBottomSheet(
                          useRootNavigator: true,
                          context: context,
                          builder: (context) {
                            return movieFilterSheet(
                              () {},
                              filter: (data) {
                                bloc.filterMovies(
                                  data.plan == 'Pay per view'
                                      ? "PAY_PER_VIEW"
                                      : data.plan.toUpperCase(),
                                  data.genreOrContentType,
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
            child: Consumer<MovieBloc>(
              builder:
                  (context, bloc, child) => Padding(
                    padding: EdgeInsets.only(
                      left: kMarginMedium2,
                      right:
                          getDeviceType() == 'phone'
                              ? kMarginMedium2
                              : MediaQuery.sizeOf(context).width / 2,
                    ),
                    child: SizedBox(
                      height: 50,
                      child: SearchBar(
                        controller: _controller,
                        leading: Icon(CupertinoIcons.search),
                        hintText:
                            AppLocalizations.of(context)?.searchMovieTitle,
                        backgroundColor: WidgetStateProperty.all(
                          Colors.grey.withValues(alpha: 0.2),
                        ),
                        hintStyle: WidgetStateProperty.resolveWith<TextStyle>(
                          (_) => TextStyle(color: kWhiteColor),
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
                        onChanged: (value) => bloc.onSearchChanged(value),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ),
                  ),
            ),
          ),
        ),
        body: Consumer<MovieBloc>(
          builder:
              (context, bloc, child) => RefreshIndicator(
                onRefresh: () async {
                  bloc.getMovieByPage();
                },
                child:
                    bloc.isLoading
                        ? shimmerLoading()
                        : bloc.movieLists.isNotEmpty
                        ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Stack(
                            children: [
                              GridView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
                                itemCount: bloc.movieLists.length,
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
                                  bottom: 40,
                                ),
                                controller:
                                    scrollController..addListener(() {
                                      if (scrollController.position.pixels ==
                                          scrollController
                                              .position
                                              .maxScrollExtent) {
                                        if (bloc.movieLists.length >= 10) {
                                          bloc.loadMoreData();
                                        }
                                      }
                                    }),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      PageNavigator(ctx: context).nextPage(
                                        page: MovieDetailScreen(
                                          movie: bloc.movieLists[index],
                                        ),
                                      );
                                    },
                                    child: movieListItem(
                                      movies: bloc.movieLists[index],
                                      type: bloc.movieLists[index].plan,
                                    ),
                                  );
                                },
                              ),

                              //load more loading
                              Positioned(
                                bottom: 5,
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

                              //search view
                              bloc.filteredSuggestions.isEmpty
                                  ? SizedBox.shrink()
                                  : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black38,
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
                                  borderRadius: BorderRadius.circular(
                                    kMargin10,
                                  ),
                                  color: kWhiteColor,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      bloc.filteredSuggestions.map((value) {
                                        return SizedBox(
                                          width: double.infinity,
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              PageNavigator(
                                                ctx: context,
                                              ).nextPage(
                                                page: MovieDetailScreen(
                                                  movie: value,
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: kMarginMedium,
                                                    vertical: kMarginMedium,
                                                  ),
                                              child: SubstringHighlight(
                                                text: value.name ?? '',
                                                term: _controller.text,
                                                textStyleHighlight: TextStyle(
                                                  color: kSecondaryColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ),
                            ],
                          ),
                        )
                        : EmptyView(
                          title: 'There is no movie to show.',
                          reload: () {
                            bloc.getMovieByPage();
                          },
                        ),
              ),
        ),
      ),
    );
  }
}
