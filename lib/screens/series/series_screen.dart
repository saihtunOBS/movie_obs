import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/series_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/extension/page_navigator.dart';
import 'package:movie_obs/list_items/movie_list_item.dart';
import 'package:movie_obs/screens/series/series_detail_screen.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:movie_obs/widgets/empty_view.dart';
import 'package:movie_obs/widgets/series_filter_sheet.dart';
import 'package:movie_obs/widgets/show_loading.dart';
import 'package:provider/provider.dart';
import 'package:substring_highlight/substring_highlight.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SeriesScreen extends StatefulWidget {
  const SeriesScreen({super.key});

  @override
  State<SeriesScreen> createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SeriesBloc(),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          surfaceTintColor: kBackgroundColor,
          foregroundColor: kWhiteColor,
          title: Padding(
            padding: const EdgeInsets.only(left: kMarginMedium2),
            child: Text('Tuu Tu\'s Series'),
          ),
          centerTitle: false,
          actions: [
            Consumer<SeriesBloc>(
              builder:
                  (context, bloc, child) => GestureDetector(
                    onTap: () {
                      if (getDeviceType() == 'phone') {
                        showModalBottomSheet(
                          useRootNavigator: true,
                          context: context,
                          builder: (context) {
                            return seriesFilterSheet(
                              () {},
                              filter: (data) {
                                bloc.filterSeries(
                                  data.plan.toUpperCase(),
                                  data.genreOrContentType.toUpperCase(),
                                );
                                return data;
                              },
                            );
                          },
                        );
                      } else {
                        showSeriesRightSideSheet(context);
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
              child: Consumer<SeriesBloc>(
                builder:
                    (context, bloc, child) => SizedBox(
                      height: 50,
                      child: SearchBar(
                        controller: _controller,
                        leading: Icon(CupertinoIcons.search),
                        hintText:
                            AppLocalizations.of(context)?.searchSeriesTitle,
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
        body: Consumer<SeriesBloc>(
          builder:
              (context, bloc, child) => RefreshIndicator(
                onRefresh: () async {
                  bloc.getAllSeries();
                },
                child:
                    bloc.isLoading
                        ? LoadingView()
                        : bloc.seriesLists.isNotEmpty
                        ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Stack(
                            children: [
                              GridView.builder(
                                itemCount: bloc.seriesLists.length,
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
                                        page: SeriesDetailScreen(
                                          series: bloc.seriesLists[index],
                                        ),
                                      );
                                    },
                                    child: movieListItem(
                                      isHomeScreen: true,
                                      movies: bloc.seriesLists[index],
                                      type: bloc.seriesLists[index].plan,
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
                                            return Padding(
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
                                            );
                                          }).toList(),
                                    ),
                                  ),
                            ],
                          ),
                        )
                        : EmptyView(
                          reload: () {
                            bloc.getAllSeries();
                          },
                          title: 'There is no series to show.',
                        ),
              ),
        ),
      ),
    );
  }
}
