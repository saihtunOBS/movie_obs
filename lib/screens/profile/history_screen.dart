import 'package:flutter/material.dart';
import 'package:movie_obs/bloc/history_bloc.dart';
import 'package:movie_obs/extension/extension.dart';
import 'package:movie_obs/list_items/movie_list_item.dart';
import 'package:movie_obs/utils/colors.dart';
import 'package:movie_obs/utils/dimens.dart';
import 'package:provider/provider.dart';

import '../../extension/page_navigator.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/show_loading.dart';
import '../home/movie_detail_screen.dart';
import '../series/series_detail_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
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
                        ? LoadingView()
                        : bloc.historyData?.data?.isNotEmpty ?? true
                        ? Padding(
                          padding: const EdgeInsets.only(),
                          child: GridView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: bloc.historyData?.data?.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      getDeviceType() == 'phone' ? 2 : 3,
                                  mainAxisExtent: 200,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                ),
                            padding: EdgeInsets.symmetric(
                              horizontal: kMarginMedium2,
                              vertical: kMarginMedium2 - 5,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  bloc.historyData?.data?[index].type == 'MOVIE'
                                      ? PageNavigator(ctx: context).nextPage(
                                        page: MovieDetailScreen(
                                          movie:
                                              bloc
                                                  .historyData
                                                  ?.data?[index]
                                                  .reference,
                                        ),
                                      )
                                      : PageNavigator(ctx: context).nextPage(
                                        page: SeriesDetailScreen(
                                          series:
                                              bloc
                                                  .historyData
                                                  ?.data?[index]
                                                  .reference,
                                        ),
                                      );
                                },
                                child: movieListItem(
                                  movies:
                                      bloc.historyData?.data?[index].reference,
                                  type:
                                      bloc.historyData?.data?[index].type
                                          ?.toLowerCase() ??
                                      '',
                                ),
                              );
                            },
                          ),
                        )
                        : EmptyView(
                          title: 'There is no history to show.',
                          reload: () {
                            bloc.getHistory();
                          },
                        ),
              ),
        ),
      ),
    );
  }
}
