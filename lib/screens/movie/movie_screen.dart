import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/movie_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/list_items/movie_list_item.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/movie_filter_sheet.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../../extension/page_navigator.dart';
import '../../widgets/empty_view.dart';
import '../home/movie_detail_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
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
          title: Text('Tuu Tu\'s Movies'),
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
                                  data.plan.toUpperCase(),
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
                            borderRadius: BorderRadius.circular(
                              8,
                            ), // your border radius
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
                  bloc.getAllMovie();
                },
                child:
                    bloc.isLoading
                        ? LoadingView()
                        : bloc.movieLists.isNotEmpty
                        ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Stack(
                            children: [
                              GridView.builder(
                                itemCount: bloc.movieLists.length,
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
                                        page: MovieDetailScreen(
                                          movie: bloc.movieLists[index],
                                        ),
                                      );
                                    },
                                    child: movieListItem(
                                      isHomeScreen: true,
                                      movies: bloc.movieLists[index],
                                      type: bloc.movieLists[index].plan,
                                    ),
                                  );
                                },
                              ),

                              bloc.filteredSuggestions.isEmpty
                                  ? SizedBox.shrink()
                                  : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.black38,
                                    ),
                                  ),
                              bloc.filteredSuggestions.isEmpty
                                  ? SizedBox()
                                  : Container(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children:
                                          bloc.filteredSuggestions.map((value) {
                                            return GestureDetector(
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
                            bloc.getAllMovie();
                          },
                        ),
              ),
        ),
      ),
    );
  }
}
