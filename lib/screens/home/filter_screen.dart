import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/search_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/list_items/movie_list_item.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/empty_view.dart';
import 'package:movie_obs/widgets/movie_filter_sheet.dart';
import 'package:movie_obs/widgets/search_filter_sheet.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:provider/provider.dart';

import '../../extension/page_navigator.dart';
import '../home/movie_type_screen.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key, required this.id, required this.title});
  final String id;
  final String title;
  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchBloc(genreId: widget.id),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          surfaceTintColor: kBackgroundColor,
          foregroundColor: kWhiteColor,
          title: Consumer<SearchBloc>(
            builder:
                (context, bloc, child) =>
                    Text('${widget.title} (${bloc.movieSeriesLists.length})'),
          ),
          centerTitle: false,
          actions: [
            Consumer<SearchBloc>(
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
                              filter: (data) {
                                bloc.filter(
                                  data.plan == 'Pay per view'
                                      ? 'PAY_PER_VIEW'
                                      : data.plan.toUpperCase(),
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
        body: Consumer<SearchBloc>(
          builder:
              (context, bloc, child) => Padding(
                padding: const EdgeInsets.only(top: 10),
                child:
                    bloc.isLoading
                        ? LoadingView()
                        : bloc.movieSeriesLists.isNotEmpty
                        ? Stack(
                          children: [
                            bloc.movieSeriesLists.isNotEmpty
                                ? GridView.builder(
                                  itemCount: bloc.movieSeriesLists.length,
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
                                    bottom: 20,
                                  ),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        PageNavigator(ctx: context).nextPage(
                                          page: MovieTypeScreen(
                                            movie: bloc.movieSeriesLists[index],
                                          ),
                                        );
                                      },
                                      child: movieListItem(
                                        isHomeScreen: true,
                                        movies: bloc.movieSeriesLists[index],
                                        type: bloc.movieSeriesLists[index].plan,
                                      ),
                                    );
                                  },
                                )
                                : Center(
                                  child: Text(
                                    'There is no movies and series to show.',
                                  ),
                                ),
                          ],
                        )
                        : EmptyView(
                          reload: () {
                            bloc.getMovieByGenre();
                          },
                          title: 'There is no movie to show.',
                        ),
              ),
        ),
      ),
    );
  }
}
